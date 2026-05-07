import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/assets_image/app_images.dart';

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

  // Tab selection
  final selectedTabIndex = 0.obs;
  final List<String> tabs = ['Description', 'Reviews (05)', 'Seller'];

  // Dummy Reviews
  final List<Map<String, dynamic>> reviews = [
    {
      'name': 'Maximilian Becker',
      'initials': 'MB',
      'rating': '4.9/5.0',
      'date': '22 Feb 2024',
      'content': 'Very comfortable and lightweight sneakers. My son has been wearing them almost every day and they still look great. The fit is perfect and easy to put on. Definitely a good purchase.',
    },
    {
      'name': 'Noah Hoffmann',
      'initials': 'NH',
      'rating': '4.8/5.0',
      'date': '02 Feb 2024',
      'content': 'Good quality overall and the design looks really nice. The material feels durable and suitable for daily use. Delivery was smooth and packaging was proper. Happy with the purchase.',
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