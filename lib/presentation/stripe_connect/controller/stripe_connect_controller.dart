import 'package:get/get.dart';
import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/service/api_service.dart';
import 'package:bestkits/service/api_url.dart';
import 'package:bestkits/widget/open_url.dart';
import 'package:bestkits/widget/show_snackbar.dart';

enum StripeConnectionState { loading, initial, onboarding, connected, failed }

class StripeConnectController extends GetxController {
  final _apiClient = ApiClient();

  final connectionState = StripeConnectionState.loading.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkStripeStatus();
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
        final data = (body is Map && body['data'] is Map)
            ? body['data'] as Map
            : (body is Map ? body : <String, dynamic>{});

        connectionState.value = _resolveState(data);
      } else if (response.statusCode == 401) {
        errorMessage.value = 'Session expired. Please log in again.';
        connectionState.value = StripeConnectionState.failed;
      } else {
        // Status endpoint failure — fall back to initial so user can try
        connectionState.value = StripeConnectionState.initial;
      }
    } catch (e) {
      // Network or parse error — show initial so user isn't stuck on loading
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
        body: {
          "returnUrl": "bestkits://stripe/callback",
          "refreshUrl": "bestkits://stripe/refresh",
        },
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        final stripeUrl = _extractUrl(body);

        if (stripeUrl != null && stripeUrl.isNotEmpty) {
          // Mark as onboarding so the UI updates while user is in browser
          connectionState.value = StripeConnectionState.onboarding;
          await openExternalUrl(stripeUrl);
          // User returned from browser — re-check status automatically
          await checkStripeStatus();
        } else {
          _setFailed('Could not retrieve the Stripe onboarding link.');
        }
      } else {
        _setFailed(
            _extractErrorMessage(response.body, response.statusCode ?? 500));
      }
    } catch (e) {
      _setFailed('A network error occurred. Please try again.');
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
