import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../bottom_nav/page/cart/controller/cart_controller.dart';

class DeliveryOption {
  final String type;
  final String label;
  final String badge;
  final String partner;
  final String time;
  final String price;

  const DeliveryOption({
    required this.type,
    required this.label,
    required this.badge,
    required this.partner,
    required this.time,
    required this.price,
  });
}

class AddressModel {
  final String name;
  final String phone;
  final String address;
  final String tag;

  const AddressModel({
    required this.name,
    required this.phone,
    required this.address,
    required this.tag,
  });
}

class CheckoutController extends GetxController {
  final CartController cartController = Get.find<CartController>();

  // Selected delivery per seller
  final RxMap<String, String> selectedDelivery = <String, String>{}.obs;

  // Selected address index
  final RxInt selectedAddressIndex = 0.obs;

  // Terms agreed
  final RxBool termsAgreed = false.obs;

  // Coupon state
  final couponController = TextEditingController();
  final RxBool isCouponApplied = false.obs;
  final RxDouble discountPercentage = 0.0.obs;
  final RxString couponError = ''.obs;
  final RxString couponSuccess = ''.obs;

  // Delivery options per seller
  final Map<String, List<DeliveryOption>> deliveryOptions = {
    'Mayoral Reseller': [
      const DeliveryOption(
        type: 'domestic',
        label: AppStrings.domesticDelivery,
        badge: AppStrings.insideCountry,
        partner: 'Bulgarian Post',
        time: '2-4',
        price: '4.99',
      ),
    ],
    'Tochici Clothing': [
      const DeliveryOption(
        type: 'international',
        label: AppStrings.internationalDelivery,
        badge: AppStrings.outsideCountry,
        partner: 'DHL Express',
        time: '5-10',
        price: '12.99',
      ),
    ],
  };

  // Addresses
  final List<AddressModel> addresses = [
    const AddressModel(
      name: 'Roberts Junior',
      phone: '+359 77 123 4567',
      address: '25 "Ivan Vazov" Street, Plovdiv 4000, Bulgaria',
      tag: AppStrings.homeTag,
    ),
    const AddressModel(
      name: 'Roberts Junior',
      phone: '+359 77 123 4567',
      address: '25 "Ivan Vazov" Street, Plovdiv 4000, Bulgaria',
      tag: AppStrings.office,
    ),
    const AddressModel(
      name: 'Roberts Junior',
      phone: '+359 77 123 4567',
      address: '25 "Ivan Vazov" Street, Plovdiv 4000, Bulgaria',
      tag: AppStrings.selected,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Default select first delivery for each seller
    for (final seller in cartController.sellers) {
      if (deliveryOptions.containsKey(seller)) {
        selectedDelivery[seller] = deliveryOptions[seller]!.first.type;
      }
    }
  }

  void selectDelivery(String seller, String type) {
    selectedDelivery[seller] = type;
  }

  void selectAddress(int index) => selectedAddressIndex.value = index;

  void toggleTerms(bool? value) => termsAgreed.value = value ?? false;

  void applyCoupon() {
    final code = couponController.text.trim().toUpperCase();
    if (code.isEmpty) {
      couponError.value = 'Please enter a coupon code.';
      couponSuccess.value = '';
      isCouponApplied.value = false;
      discountPercentage.value = 0.0;
      return;
    }

    // Accepting common variations of the coupon code
    if (code == 'BESTKITS10' || code == 'WELCOME10' || code == '10PERCENT' || code == 'COUPON10' || code == 'MOTALEB') {
      isCouponApplied.value = true;
      discountPercentage.value = 10.0;
      couponError.value = '';
      couponSuccess.value = '10% discount applied to your order.';
    } else {
      isCouponApplied.value = false;
      discountPercentage.value = 0.0;
      couponSuccess.value = '';
      couponError.value = 'Invalid coupon code. Please try again.';
    }
  }

  void removeCoupon() {
    isCouponApplied.value = false;
    discountPercentage.value = 0.0;
    couponError.value = '';
    couponSuccess.value = '';
    couponController.clear();
  }

  double get shippingTotal {
    double total = 0;
    for (final seller in cartController.sellers) {
      final selected = selectedDelivery[seller];
      final options = deliveryOptions[seller] ?? [];
      final option = options.where((o) => o.type == selected).firstOrNull;
      if (option != null) total += double.parse(option.price);
    }
    return total;
  }

  double get discountAmount => isCouponApplied.value ? (subtotal * (discountPercentage.value / 100.0)) : 0.0;
  double get subtotal => cartController.subtotal;
  double get total => subtotal - discountAmount + shippingTotal;

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }
}