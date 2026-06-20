import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/assets_image/app_images.dart';
import '../../../../utils/static_strings/static_strings.dart';

class ProductDetailsController extends GetxController {
  // Image selection
  final selectedImageIndex = 0.obs;
  final List<String> productImages = [
    AppImages.kidsCottonSho, // Using shoe image as per design
    AppImages.kidsCottonSho,
    AppImages.kidsCottonSho,
    AppImages.kidsCottonSho,
    AppImages.kidsCottonSho,
  ];

  // Size selection
  final selectedSize = 'S'.obs;
  final List<String> sizes = ['S', 'M', 'L', 'XL', '2XL', '3XL'];

  // Quantity selection
  final quantity = 1.obs;

  // Dummy product for favorite toggle
  final Map<String, dynamic> product = {
    'name': AppStrings.dummyProductName,
    'image': AppImages.kidsCottonSho,
    'price': '18.00',
    'oldPrice': '21.99',
    'rating': '4.9/5.0',
    'material': AppStrings.dummyMaterial,
    'discount': '20%',
  };

  // Tab selection
  final selectedTabIndex = 0.obs;
  final List<String> tabs = [AppStrings.description, AppStrings.reviews, AppStrings.sellerLabel];

  // Dummy Reviews
  final List<Map<String, dynamic>> reviews = [
    {
      'name': 'Maximilian Becker',
      'initials': 'MB',
      'rating': '4.9/5.0',
      'date': '22 Feb 2024',
      'content': AppStrings.dummyReview1,
    },
    {
      'name': 'Noah Hoffmann',
      'initials': 'NH',
      'rating': '4.8/5.0',
      'date': '02 Feb 2024',
      'content': AppStrings.dummyReview2,
    },
  ];

  void incrementQuantity() => quantity.value++;
  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void selectImage(int index) => selectedImageIndex.value = index;
  void selectSize(String size) => selectedSize.value = size;
  void selectTab(int index) => selectedTabIndex.value = index;
}