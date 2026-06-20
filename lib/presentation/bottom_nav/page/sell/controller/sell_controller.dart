import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../widget/app_alert.dart';
import '../../../../../utils/static_strings/static_strings.dart';
import '../../../../../utils/assets_image/app_images.dart';

class SellController extends GetxController {
  final RxBool isActiveTab = true.obs;

  // Track alternate clicks to show different warnings (for demonstration)
  int _warningToggle = 0;

  // Dummy products
  final RxList<Map<String, dynamic>> activeProducts = <Map<String, dynamic>>[
    {
      'name': 'Kids Cotton Hoodie...',
      'image': AppImages.kidAccessor,
      'price': '18.00',
      'oldPrice': '21.99',
      'rating': '4.9/5.0',
      'material': 'Cotton Pull-On',
      'discount': '10%',
    },
    {
      'name': 'Kids Cotton Hoodie...',
      'image': AppImages.kidCottonShoStand,
      'price': '18.00',
      'oldPrice': '21.99',
      'rating': '4.9/5.0',
      'material': 'Cotton Pull-On',
      'discount': '10%',
    },
    {
      'name': 'Kids Cotton Hoodie...',
      'image': AppImages.kidsCottonSho,
      'price': '18.00',
      'oldPrice': '21.99',
      'rating': '4.9/5.0',
      'material': 'Cotton Pull-On',
      'discount': '10%',
    },
    {
      'name': 'Kids Cotton Hoodie...',
      'image': AppImages.kidCottonShoStand,
      'price': '18.00',
      'oldPrice': '21.99',
      'rating': '4.9/5.0',
      'material': 'Cotton Pull-On',
      'discount': '10%',
    },
  ].obs;

  final RxList<Map<String, dynamic>> inactiveProducts =
      <Map<String, dynamic>>[].obs; // Empty by default

  void toggleTab(bool isActive) {
    isActiveTab.value = isActive;
  }

  void onAddProductTap() {
    // Alternate between showing Delivery Information Missing and Stripe Account Required
    if (_warningToggle % 2 == 0) {
      AppAlerts.warning(
        title: AppStrings.deliveryInfoMissingTitle.tr,
        message: AppStrings.deliveryInfoMissingSubtitle.tr,
        confirmLabel: 'Confirm',
        cancelLabel: 'Cancel',
        onConfirm: () {
          // Typically navigate to Delivery settings
        },
      );
    } else {
      AppAlerts.warning(
        title: AppStrings.stripeAccountRequiredTitle.tr,
        message: AppStrings.stripeAccountRequiredSubtitle.tr,
        confirmLabel: 'Confirm',
        cancelLabel: 'Cancel',
        onConfirm: () {
          // Typically navigate to Stripe settings
        },
      );
    }
    _warningToggle++;
  }
}
