import 'package:bestkits/widget/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../service/api_service.dart';
import '../../../service/api_url.dart';
import '../../../helper/tost_message/show_snackbar.dart';
import '../../../widget/open_url.dart';
import '../../cart/controller/cart_controller.dart';
import '../model/OrderSummaryModel.dart';
import '../model/TbiCalculationModel.dart';

/// Selected payment plan on the checkout screen.
enum PaymentPlanType { full, installment }

/// Installment option returned by the calculations GET API.
class InstallmentPlanOption {
  final int months;
  final double monthlyAmount;
  final double totalAmount;
  final double aprPercent;
  final String currency;

  const InstallmentPlanOption({
    required this.months,
    required this.monthlyAmount,
    required this.totalAmount,
    required this.aprPercent,
    this.currency = 'EUR',
  });
}

class CheckoutController extends GetxController {
  final CartController cartController = Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController());
  final ApiClient _apiClient = ApiClient();

  // Order Summary State
  final Rx<OrderSummaryModel?> orderSummary = Rx<OrderSummaryModel?>(null);
  final RxBool isLoading = false.obs;

  // Selected address index
  final RxInt selectedAddressIndex = 0.obs;

  // Terms agreed
  final RxBool termsAgreed = false.obs;

  // API Loading States
  final RxBool isApplyingCoupon = false.obs;
  final RxBool isSubmittingOrder = false.obs;

  // Coupon state
  final couponController = TextEditingController();
  final RxBool isCouponApplied = false.obs;

  // Local price overrides (updated by apply coupon)
  final RxDouble apiSubtotal = 0.0.obs;
  final RxDouble apiShippingFee = 0.0.obs;
  final RxDouble apiDiscount = 0.0.obs;
  final RxDouble apiTotal = 0.0.obs;
  final RxString couponError = ''.obs;
  final RxString couponSuccess = ''.obs;

  bool isBuyNow = false;
  Map<String, dynamic>? buyNowArgs;

  // ── Payment Plan (Pay in Full / Installment Plan) — design only ────────
  // NOTE: Only the UI is being wired up here. "Pay in Full" keeps using the
  // existing Stripe checkout flow (placeOrder) unchanged.
  final Rx<PaymentPlanType> paymentPlanType = PaymentPlanType.full.obs;
  final RxInt selectedInstallmentIndex = 0.obs;

  // Installment plan options, populated live from GET ApiUrl.tbiCalculations.
  final RxList<InstallmentPlanOption> installmentPlanOptions =
      <InstallmentPlanOption>[].obs;
  final RxBool isLoadingInstallmentPlans = false.obs;

  void selectPaymentPlanType(PaymentPlanType type) {
    paymentPlanType.value = type;
    // Fetch the installment schemes the first time this tab is opened.
    if (type == PaymentPlanType.installment &&
        !isLoadingInstallmentPlans.value) {
      fetchInstallmentPlans();
    }
  }

  void selectInstallmentOption(int index) =>
      selectedInstallmentIndex.value = index;

  /// GET ApiUrl.tbiCalculations — TBI Fusion Pay installment schemes for the
  /// current checkout selection (Buy Now product, or the selected cart
  /// sellers/items), scoped to the selected address and any applied coupon.
  Future<void> fetchInstallmentPlans() async {
    if (isLoadingInstallmentPlans.value) return;
    isLoadingInstallmentPlans.value = true;
    installmentPlanOptions.clear();
    try {
      final Map<String, dynamic> queryParams = {};

      final addresses = orderSummary.value?.data?.addresses ?? [];
      final address = addresses.isNotEmpty &&
              selectedAddressIndex.value < addresses.length
          ? addresses[selectedAddressIndex.value]
          : null;
      if (address?.id != null) {
        queryParams['addressId'] = address!.id!.toInt().toString();
      }
      if (address?.country != null && address!.country!.isNotEmpty) {
        queryParams['country'] = address.country!;
      }

      if (isBuyNow) {
        final productId = buyNowArgs?['productId'];
        if (productId != null) {
          queryParams['productId'] = productId.toString();
        }
      } else {
        final sellerIds = (orderSummary.value?.data?.selectedSellerIds ?? [])
            .map((e) => e.toString())
            .toList();
        final cartItemIds =
            (orderSummary.value?.data?.selectedCartItemIds ?? [])
                .map((e) => e.toString())
                .toList();
        if (sellerIds.isNotEmpty) queryParams['sellerIds'] = sellerIds;
        if (cartItemIds.isNotEmpty) queryParams['cartItemIds'] = cartItemIds;
      }

      final categoryIds = (orderSummary.value?.data?.sellerGroups ?? [])
          .expand((group) => group.items ?? <Items>[])
          .map((item) => item.product?.categoryId?.toInt())
          .whereType<int>()
          .toSet();
      final categoryId = buyNowArgs?['categoryId'] ??
          (categoryIds.length == 1 ? categoryIds.single : null);
      if (categoryId != null) {
        queryParams['categoryId'] = categoryId.toString();
      }

      if (isCouponApplied.value && couponController.text.isNotEmpty) {
        queryParams['couponCode'] = couponController.text.trim().toUpperCase();
      }

      // Always send the current order total as the amount to finance —
      // alongside the product/cart identifiers above — so the schemes match
      // exactly what the customer will pay regardless of how the backend
      // resolves the cart on its side.
      if (total > 0) {
        queryParams['amount'] = total.toString();
      }

      final uri = Uri.parse(ApiUrl.tbiCalculations)
          .replace(queryParameters: queryParams);
      final response = await _apiClient.get(url: uri.toString(), isToken: true);

      if (response.statusCode == 200 &&
          response.body is Map &&
          response.body['success'] == true) {
        final model = TbiCalculationModel.fromJson(response.body);
        final schemes = model.data?.schemes ?? [];
        installmentPlanOptions.assignAll(schemes.map((s) =>
            InstallmentPlanOption(
              months: s.raw?.period ?? s.period ?? 0,
              monthlyAmount: s.installment ?? 0.0,
              totalAmount: s.totalDue ?? 0.0,
              aprPercent: s.raw?.apr ?? s.apr ?? 0.0,
              currency: s.raw?.currency ?? model.data?.currency ?? 'EUR',
            )));
        selectedInstallmentIndex.value = 0;
      } else {
        final raw = response.body?['message'] ??
            response.statusText ??
            "Failed to load installment plans.";
        final msg = raw is List ? raw.join(', ') : raw.toString();
        AppSnackBar.fail(msg);
      }
    } catch (e) {
      AppSnackBar.fail('Something went wrong while loading installment plans.');
    } finally {
      isLoadingInstallmentPlans.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  void handleArguments(dynamic args) {
    if (args != null && args['isBuyNow'] == true) {
      isBuyNow = true;
      buyNowArgs = args;
    } else {
      isBuyNow = false;
      buyNowArgs = null;
    }
  }

  Future<void> fetchCheckoutSummary() async {
    isLoading.value = true;
    try {
      late final Response response;
      if (isBuyNow) {
        final Map<String, dynamic> buyNowBody = {
          "productId": buyNowArgs?['productId'] ?? 0,
          "addressId": buyNowArgs?['addressId'] ?? 0,
          "shippingAddress": buyNowArgs?['shippingAddress'] ?? "",
          "city": buyNowArgs?['city'] ?? "",
          "postalCode": buyNowArgs?['postalCode'] ?? "",
          "country": buyNowArgs?['country'] ?? "",
        };

        if (couponController.text.isNotEmpty) {
          buyNowBody["couponCode"] = couponController.text;
        }

        response = await _apiClient.post(
          url: ApiUrl.orderBuyNowSummary,
          body: buyNowBody,
          isToken: true,
        );
      } else {
        response = await _apiClient.get(
          url: ApiUrl.orderCheckoutSummary,
          isToken: true,
        );
      }

      if (response.statusCode == 200) {
        final body = response.body;
        if (body['success'] == true) {
          orderSummary.value = OrderSummaryModel.fromJson(body);

          // Match selected address index
          final addresses = orderSummary.value?.data?.addresses ?? [];
          final selectedId = orderSummary.value?.data?.selectedAddress?.id;
          if (selectedId != null && addresses.isNotEmpty) {
            final index = addresses.indexWhere((a) => a.id == selectedId);
            if (index != -1) {
              selectedAddressIndex.value = index;
            }
          }
        } else {
          final msg =
              body['message']?.toString() ?? "Failed to load checkout summary.";
          AppSnackBar.fail(msg);
          Get.back();
        }
      } else {
        final raw = response.body?['message'] ??
            response.statusText ??
            "Failed to load checkout summary.";
        final msg = raw is List ? raw.join(', ') : raw.toString();
        AppSnackBar.fail(msg);
        Get.back();
      }
    } catch (e) {
      AppSnackBar.fail("Error fetching summary: $e");
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  void selectAddress(int index) => selectedAddressIndex.value = index;

  void toggleTerms(bool? value) => termsAgreed.value = value ?? false;

  Future<void> applyCoupon() async {
    final code = couponController.text.trim().toUpperCase();
    if (code.isEmpty) {
      couponError.value = 'Please enter a coupon code.';
      couponSuccess.value = '';
      isCouponApplied.value = false;
      return;
    }

    isApplyingCoupon.value = true;
    couponError.value = '';
    couponSuccess.value = '';

    try {
      // Build the address info from the currently selected address
      final addresses = orderSummary.value?.data?.addresses ?? [];
      final address =
          addresses.isNotEmpty ? addresses[selectedAddressIndex.value] : null;
      final addressId = address?.id?.toInt() ?? 0;
      final country = address?.country ?? '';

      final Map<String, dynamic> body = {
        "couponCode": code,
        "addressId": addressId,
        "country": country,
      };

      if (isBuyNow) {
        // Direct "Buy Now" flow — send productId only (no sellerIds / cartItemIds)
        body["productId"] = buyNowArgs?['productId'] ?? 0;
      } else {
        // Cart flow — send sellerIds + cartItemIds (no productId)
        final sellerIds = (orderSummary.value?.data?.selectedSellerIds ?? [])
            .map((e) => e.toInt())
            .toList();
        final cartItemIds =
            (orderSummary.value?.data?.selectedCartItemIds ?? [])
                .map((e) => e.toInt())
                .toList();
        body["sellerIds"] = sellerIds;
        body["cartItemIds"] = cartItemIds;
      }

      final response = await _apiClient.post(
        url: ApiUrl.applyCouponCode,
        body: body,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final bodyData = response.body;
        if (bodyData != null && bodyData['success'] == true) {
          isCouponApplied.value = true;
          couponSuccess.value =
              bodyData['data']?['message'] ?? 'Discount applied to your order.';
          final priceDetails = bodyData['data']?['price_details'];
          if (priceDetails != null) {
            apiSubtotal.value = (priceDetails['subtotal'] as num).toDouble();
            apiShippingFee.value =
                (priceDetails['shipping_fee'] as num).toDouble();
            apiDiscount.value = (priceDetails['discount'] as num).toDouble();
            apiTotal.value = (priceDetails['total'] as num).toDouble();
          }
        } else {
          isCouponApplied.value = false;
          couponError.value =
              bodyData?['message'] ?? 'Invalid coupon code. Please try again.';
        }
      } else {
        isCouponApplied.value = false;
        final raw = response.body?['message'] ??
            response.statusText ??
            "Invalid coupon code.";
        couponError.value = raw is List ? raw.join(', ') : raw.toString();
      }
    } catch (e) {
      isCouponApplied.value = false;
      couponError.value = 'Something went wrong. Please try again.';
    } finally {
      isApplyingCoupon.value = false;
    }
  }

  void removeCoupon() {
    isCouponApplied.value = false;
    couponError.value = '';
    couponSuccess.value = '';
    couponController.clear();
  }

  Future<void> placeOrder() async {
    if (!termsAgreed.value) {
      AppSnackBar.fail("Please accept terms and conditions");
      return;
    }

    final addresses = orderSummary.value?.data?.addresses ?? [];
    if (addresses.isEmpty) {
      AppSnackBar.fail("Please select a delivery address");
      return;
    }

    isSubmittingOrder.value = true;
    try {
      final address = addresses[selectedAddressIndex.value];
      final sellerIds = (orderSummary.value?.data?.selectedSellerIds ?? [])
          .map((e) => e.toInt())
          .toList();
      final cartItemIds = (orderSummary.value?.data?.selectedCartItemIds ?? [])
          .map((e) => e.toInt())
          .toList();

      final body = <String, dynamic>{
        "successUrl": "https://app.bestkid.com/checkout/success",
        "cancelUrl": "https://app.bestkid.com/checkout/cancel",
        "addressId": address.id,
        "shippingAddress": address.address ?? '',
        "city": address.city ?? '',
        "postalCode": address.postalCode ?? '',
        "country": address.country ?? '',
        "couponCode":
            (isCouponApplied.value && couponController.text.isNotEmpty)
                ? couponController.text.trim().toUpperCase()
                : "",
        "acceptedTerms": termsAgreed.value,
      };

      if (isBuyNow) {
        body["productId"] = buyNowArgs?['productId'] ?? null;
      }

      final response = await _apiClient.post(
        url: ApiUrl.stripeCheckOutSession,
        body: body,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final bodyData = response.body;
        if (bodyData != null && bodyData['success'] == true) {
          final data = bodyData['data'];
          final String? checkoutUrl =
              data is Map ? data['url'] : (data is String ? data : null);

          if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
            // Open Stripe-hosted checkout page
            await openExternalUrl(checkoutUrl);
          } else {
            AppSnackBar.fail('Could not retrieve the checkout link.',
                title: 'Error');
          }
        } else {
          final msg = bodyData?['message'];
          final msgStr = msg is List
              ? msg.join('\n')
              : msg?.toString() ?? 'Checkout failed';
          AppSnackBar.fail(msgStr, title: 'Error');
        }
      } else {
        final raw = response.body?['message'] ??
            response.statusText ??
            "Checkout failed";
        final msg = raw is List ? raw.join(', ') : raw.toString();
        AppSnackBar.fail(msg, title: 'Error');
      }
    } catch (e) {
      AppSnackBar.fail('Something went wrong. Please try again.',
          title: 'Error');
    } finally {
      isSubmittingOrder.value = false;
    }
  }

  /// POST ApiUrl.tbiCheckoutSession — creates a TBI Credit application for
  /// the current cart selection using the chosen installment plan, then
  /// opens the returned application URL (mirrors placeOrder's Stripe flow).
  Future<void> placeInstallmentOrder() async {
    if (isSubmittingOrder.value) return;
    if (isLoadingInstallmentPlans.value) {
      AppSnackBar.fail("Please wait for installment plans to load");
      return;
    }

    if (!termsAgreed.value) {
      AppSnackBar.fail("Please accept terms and conditions");
      return;
    }

    final addresses = orderSummary.value?.data?.addresses ?? [];
    if (addresses.isEmpty ||
        selectedAddressIndex.value < 0 ||
        selectedAddressIndex.value >= addresses.length) {
      AppSnackBar.fail("Please select a delivery address");
      return;
    }

    if (installmentPlanOptions.isEmpty ||
        selectedInstallmentIndex.value < 0 ||
        selectedInstallmentIndex.value >= installmentPlanOptions.length) {
      AppSnackBar.fail("Please select an installment plan");
      return;
    }

    if (installmentPlanOptions[selectedInstallmentIndex.value].months <= 0) {
      AppSnackBar.fail("Please select a valid installment plan");
      return;
    }

    isSubmittingOrder.value = true;
    try {
      final address = addresses[selectedAddressIndex.value];
      final sellerIds = (orderSummary.value?.data?.selectedSellerIds ?? [])
          .map((e) => e.toInt())
          .toList();
      final cartItemIds = (orderSummary.value?.data?.selectedCartItemIds ?? [])
          .map((e) => e.toInt())
          .toList();
      final selectedPlan =
          installmentPlanOptions[selectedInstallmentIndex.value];

      if (cartItemIds.isEmpty && sellerIds.isEmpty) {
        AppSnackBar.fail("Please select cart items for installment checkout");
        return;
      }

      final body = <String, dynamic>{
        "successUrl": "https://www.bestkid.eu/payment/success",
        "failUrl": "https://www.bestkid.eu/payment/failed",
        // TBI accepts one selection method; prefer the exact selected items.
        if (cartItemIds.isNotEmpty)
          "cartItemIds": cartItemIds
        else
          "sellerIds": sellerIds,
        "addressId": address.id,
        "shippingAddress": address.address ?? '',
        "city": address.city ?? '',
        "postalCode": address.postalCode ?? '',
        "country": (address.country ?? '').trim().toLowerCase() == 'bulgaria'
            ? 'BG'
            : (address.country ?? '').trim(),
        "couponCode": isCouponApplied.value ? couponController.text.trim() : "",
        "period": selectedPlan.months,
        "bnpl": true,
        "acceptedTerms": termsAgreed.value,
      };

      final response = await _apiClient.post(
        url: ApiUrl.tbiCheckoutSession,
        body: body,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final bodyData = response.body;
        if (bodyData != null && bodyData['success'] == true) {
          final data = bodyData['data'];
          // NOTE: The Swagger example for this endpoint only shows a
          // generic placeholder ({"id":..., "createdAt":...}), not the real
          // "TBI application URL" field name — try the common spellings
          // defensively until the backend confirms the exact key.
          final String? applicationUrl = data is Map
              ? (data['url'] ??
                      data['applicationUrl'] ??
                      data['redirectUrl'] ??
                      data['checkoutUrl'] ??
                      data['link'])
                  ?.toString()
              : (data is String ? data : null);

          if (applicationUrl != null && applicationUrl.isNotEmpty) {
            // Open TBI-hosted application page
            await openExternalUrl(applicationUrl);
          } else {
            AppSnackBar.fail('Could not retrieve the TBI application link.',
                title: 'Error');
          }
        } else {
          final msg = bodyData?['message'];
          final msgStr = msg is List
              ? msg.join('\n')
              : msg?.toString() ?? 'Installment checkout failed';
          AppSnackBar.fail(msgStr, title: 'Error');
        }
      } else {
        final raw = response.body?['message'] ??
            response.statusText ??
            "Installment checkout failed";
        final msg = raw is List ? raw.join(', ') : raw.toString();
        AppSnackBar.fail(msg, title: 'Error');
      }
    } catch (e) {
      AppSnackBar.fail('Something went wrong. Please try again.',
          title: 'Error');
    } finally {
      isSubmittingOrder.value = false;
    }
  }

  double get subtotal {
    if (isCouponApplied.value) return apiSubtotal.value;
    return (orderSummary.value?.data?.priceDetails?.subtotal as num?)
            ?.toDouble() ??
        0.0;
  }

  double get shippingTotal {
    if (isCouponApplied.value) return apiShippingFee.value;
    return (orderSummary.value?.data?.priceDetails?.shippingFee as num?)
            ?.toDouble() ??
        0.0;
  }

  double get discountAmount {
    if (isCouponApplied.value) return apiDiscount.value;
    return (orderSummary.value?.data?.priceDetails?.discount as num?)
            ?.toDouble() ??
        0.0;
  }

  double get total {
    if (isCouponApplied.value) return apiTotal.value;
    return (orderSummary.value?.data?.priceDetails?.total as num?)
            ?.toDouble() ??
        0.0;
  }

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }
}
