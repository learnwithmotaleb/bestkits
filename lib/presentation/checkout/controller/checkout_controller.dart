import 'package:bestkits/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../service/api_service.dart';
import '../../../service/api_url.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/show_snackbar.dart';
import '../../../widget/open_url.dart';
import '../../cart/controller/cart_controller.dart';
import '../model/OrderSummaryModel.dart';

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
          ShowAppSnackBar.fail(msg);
          Get.back();
        }
      } else {
        final raw = response.body?['message'] ??
            response.statusText ??
            "Failed to load checkout summary.";
        final msg = raw is List ? raw.join(', ') : raw.toString();
        ShowAppSnackBar.fail(msg);
        Get.back();
      }
    } catch (e) {
      ShowAppSnackBar.fail("Error fetching summary: $e");
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
      final response = await _apiClient.post(
        url: ApiUrl.applyCouponCode,
        body: {"couponCode": code},
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
      ShowAppSnackBar.fail("Please accept terms and conditions");
      return;
    }

    final addresses = orderSummary.value?.data?.addresses ?? [];
    if (addresses.isEmpty) {
      ShowAppSnackBar.fail("Please select a delivery address");
      return;
    }

    isSubmittingOrder.value = true;
    try {
      final address = addresses[selectedAddressIndex.value];
      final sellerIds =
          orderSummary.value?.data?.selectedSellerIds?.cast<int>() ?? [];

      final body = {
        "successUrl": "https://app.bestkid.com/checkout/success",
        "cancelUrl": "https://app.bestkid.com/checkout/cancel",
        "addressId": address.id,
        if (isCouponApplied.value && couponController.text.isNotEmpty)
          "couponCode": couponController.text.trim().toUpperCase(),
        "acceptedTerms": termsAgreed.value,
      };

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
            await openExternalUrl(checkoutUrl);
          } else {
            Get.snackbar(
              AppStrings.orderPlaced.tr,
              AppStrings.orderPlacedSuccess.tr,
              snackPosition: SnackPosition.TOP,
              backgroundColor: const Color(0xFF1A1A1A),
              colorText: AppColors.primaryColor,
              borderRadius: 12,
              margin: const EdgeInsets.all(16),
              icon: Icon(Icons.check_circle, color: AppColors.primaryColor),
            );
          }

          cartController
              .emptyCart(); // Clear the local cart after successful checkout
          Get.offAllNamed(
              '/home'); // Or whatever the appropriate back/success navigation is
        } else {
          Get.snackbar(
            'Error',
            bodyData?['message'] ?? 'Checkout failed',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        final raw = response.body?['message'] ??
            response.statusText ??
            "Checkout failed";
        final msg = raw is List ? raw.join(', ') : raw.toString();
        Get.snackbar(
          'Error',
          msg,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
