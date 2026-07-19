import 'package:get/get.dart';
import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/service/api_service.dart';
import 'package:bestkits/service/api_url.dart';
import 'package:bestkits/widget/open_url.dart';
import 'package:bestkits/widget/show_snackbar.dart';
import 'package:bestkits/helper/local_db/local_db.dart';

enum StripeConnectionState { loading, initial, onboarding, connected, failed }

class StripeConnectController extends GetxController {
  final _apiClient = ApiClient();

  final connectionState = StripeConnectionState.loading.obs;
  final errorMessage = ''.obs;
  final cardNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkStripeStatus();
    loadCardNumber();
  }

  void loadCardNumber() {
    cardNumber.value =
        SharePrefsHelper.getStripeCardNumber() ?? '4242 4242 4242 4242';
  }

  Future<void> saveCardNumber(String number) async {
    cardNumber.value = number;
    await SharePrefsHelper.saveStripeCardNumber(number);
  }

  // ─── Status Check ─────────────────────────────────────────────────────────

  /// Calls GET /stripe/status and maps the response to a connection state.
  Future<void> checkStripeStatus() async {
    connectionState.value = StripeConnectionState.loading;
    errorMessage.value = '';

    try {
      final response = await _apiClient.get(
        url: ApiUrl.stripeStatus,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;

        // Handle body-level error even if HTTP 200
        if (body is Map && body['success'] == false) {
          connectionState.value = StripeConnectionState.initial;
          return;
        }

        final data = (body is Map && body['data'] is Map)
            ? body['data'] as Map
            : (body is Map ? body : <String, dynamic>{});

        connectionState.value = _resolveState(data);
      } else if (response.statusCode == 401) {
        errorMessage.value = 'Session expired. Please log in again.';
        connectionState.value = StripeConnectionState.failed;
      } else {
        connectionState.value = StripeConnectionState.initial;
      }
    } catch (e) {
      connectionState.value = StripeConnectionState.initial;
    }
  }

  /// Maps the status data map to a [StripeConnectionState].
  StripeConnectionState _resolveState(Map data) {
    final chargesEnabled = data['charges_enabled'] == true;
    final payoutsEnabled = data['payouts_enabled'] == true;
    final detailsSubmitted = data['details_submitted'] == true;
    final isOnboarded =
        data['isOnboarded'] == true || data['is_onboarded'] == true;

    if (chargesEnabled && payoutsEnabled)
      return StripeConnectionState.connected;
    if (chargesEnabled || isOnboarded) return StripeConnectionState.connected;
    if (detailsSubmitted) return StripeConnectionState.onboarding;
    return StripeConnectionState.initial;
  }

  // ─── Onboarding ───────────────────────────────────────────────────────────

  /// Calls POST /stripe/onboard, receives the Stripe-hosted URL, opens it.
  Future<void> connectStripeAccount() async {
    connectionState.value = StripeConnectionState.loading;
    errorMessage.value = '';

    try {
      final response = await _apiClient.post(
        url: ApiUrl.stripeOnboard,
        body: {}, // returnUrl & refreshUrl are optional — omitting them
        isToken: true,
      );

      final body = response.body;
      final httpCode = response.statusCode ?? 500;

      // ── Success path ──────────────────────────────────────────
      if (httpCode == 200 || httpCode == 201) {
        // Handle body-level failure (success:false with HTTP 200)
        if (body is Map && body['success'] == false) {
          final msg = _extractErrorMessage(body, httpCode);
          _setFailed(msg);
          return;
        }

        final stripeUrl = _extractUrl(body);
        if (stripeUrl != null && stripeUrl.isNotEmpty) {
          // Open Stripe-hosted onboarding in our in-app WebView
          connectionState.value = StripeConnectionState.onboarding;

          // Wait for the user to return from the webview
          await Get.toNamed(RoutePath.stripeWebview, arguments: stripeUrl);

          // Re-check status when they return
          await checkStripeStatus();
        } else {
          _setFailed('Could not retrieve the Stripe onboarding link.');
        }
      }

      // ── Server error (4xx / 5xx) ──────────────────────────────
      else {
        final msg = _extractErrorMessage(body, httpCode);
        _setFailed('[$httpCode] $msg');
      }
    } catch (e) {
      _setFailed('A network error occurred. Please try again. ($e)');
    }
  }

  // ─── App Resume ───────────────────────────────────────────────────────────

  /// Called by the screen when the app resumes from background.
  /// Automatically re-checks status after returning from the Stripe browser.
  Future<void> onAppResumed() async {
    if (connectionState.value == StripeConnectionState.onboarding) {
      await checkStripeStatus();
    }
  }

  // ─── Checkout Session ─────────────────────────────────────────────────────

  /// Calls POST /stripe/checkout-session to create a checkout session and opens it.
  Future<void> createCheckoutSession({required String productId}) async {
    try {
      final response = await _apiClient.post(
        url: ApiUrl.stripeCheckOutSession,
        body: {
          'product_id': productId,
        },
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        final checkoutUrl = _extractUrl(body);

        if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
          await openExternalUrl(checkoutUrl);
        } else {
          ShowAppSnackBar.fail('Could not retrieve the checkout link.',
              title: 'Error');
        }
      } else {
        ShowAppSnackBar.fail(
            _extractErrorMessage(response.body, response.statusCode ?? 500),
            title: 'Error');
      }
    } catch (e) {
      ShowAppSnackBar.fail('A network error occurred. Please try again.',
          title: 'Error');
    }
  }

  // ─── Navigation ───────────────────────────────────────────────────────────

  void saveAndContinue() {
    if (connectionState.value == StripeConnectionState.connected) {
      Get.offAllNamed(RoutePath.bottomNav);
    }
  }

  void skipForNow() {
    Get.offAllNamed(RoutePath.bottomNav);
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  void _setFailed(String message) {
    errorMessage.value = message;
    connectionState.value = StripeConnectionState.failed;
    ShowAppSnackBar.fail(message, title: 'Stripe Error');
  }

  String? _extractUrl(dynamic body) {
    if (body is! Map) return null;
    return body['data']?['url']?.toString() ??
        body['data']?['onboardingUrl']?.toString() ??
        body['url']?.toString();
  }

  String _extractErrorMessage(dynamic body, int statusCode) {
    if (body is Map && body.containsKey('message')) {
      final msg = body['message'];
      return msg is List ? msg.join('\n') : msg.toString();
    }
    return 'Request failed (HTTP $statusCode). Please try again.';
  }
}
