import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../../../widget/app_alert.dart';
import '../../../../../../../utils/static_strings/static_strings.dart';
import '../../../../../../../utils/assets_image/app_images.dart';
import '../../../controller/sell_controller.dart';

class UpdateProductController extends GetxController {
  late final RxMap<String, dynamic> product;

  // Image selection
  final selectedImageIndex = 0.obs;
  final RxList<String> productImages = <String>[].obs;

  // Size selection
  final selectedSize = 'S'.obs;
  final List<String> sizes = ['S', 'M', 'L', 'XL', '2XL', '3XL'];

  // Quantity selection
  final quantity = 1.obs;

  // Tab selection
  final selectedTabIndex = 0.obs;
  final List<String> tabs = [AppStrings.description, AppStrings.reviews];

  // Dummy Reviews (matching screenshot)
  final List<Map<String, dynamic>> reviewsList = [
    {
      'name': 'Maximilian Becker',
      'initials': 'MB',
      'rating': '4.9/5.0',
      'date': '12 Feb 2026',
      'content': 'Very comfortable and lightweight sneakers. My son has been wearing them almost every day, and they still look great. The fit is perfect and easy to put on. Definitely a good purchase.',
    },
    {
      'name': 'Noah Hoffmann',
      'initials': 'NH',
      'rating': '4.9/5.0',
      'date': '03 Feb 2026',
      'content': 'Good quality overall and the design looks really nice. The material feels durable and suitable for daily use. Delivery was smooth and packaging was proper. Happy with the purchase.',
    },
    {
      'name': 'Clara Vogel',
      'initials': 'CV',
      'rating': '4.9/5.0',
      'date': '28 Jan 2026',
      'content': 'Exactly as described. The sneakers look clean and well-made, and the size fits perfectly. My child finds them very comfortable for school and outdoor play. Would recommend.',
    },
    {
      'name': 'Alex Müller',
      'initials': 'AM',
      'rating': '4.9/5.0',
      'date': '19 Jan 2026',
      'content': 'Comfortable and stylish sneakers. The sole has good grip and the build quality feels solid. Slightly snug at first, but after a few uses it fits better. Overall a good value product.',
    },
    {
      'name': 'Jonas Weber',
      'initials': 'JW',
      'rating': '4.9/5.0',
      'date': '28 Jan 2026',
      'content': 'Very comfortable and lightweight sneakers. My son has been wearing them almost every day, and they still look great. The fit is perfect and easy to put on. Definitely a good purchase.',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      product = RxMap<String, dynamic>(args);
    } else {
      product = RxMap<String, dynamic>({
        'name': AppStrings.dummyProductName,
        'image': AppImages.kidsCottonSho,
        'price': '180.00',
        'oldPrice': '21.99',
        'rating': '4.9/5.0',
        'material': AppStrings.dummyMaterial,
        'discount': '20%',
      });
    }

    // Populate images based on product image
    productImages.clear();
    final mainImg = product['image'] ?? AppImages.kidsCottonSho;
    productImages.addAll([
      mainImg,
      mainImg,
      mainImg,
      mainImg,
      mainImg,
    ]);
  }

  void incrementQuantity() => quantity.value++;
  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void selectImage(int index) => selectedImageIndex.value = index;
  void selectSize(String size) => selectedSize.value = size;
  void selectTab(int index) => selectedTabIndex.value = index;

  void markAsInactive() {
    AppAlerts.warning(
      title: "Mark As Inactive !",
      message: "Are you sure you want to mark this product as inactive? It will not be visible to customers on the platform.",
      confirmLabel: "Confirm",
      cancelLabel: "Cancel",
      onConfirm: () {
        try {
          final sellController = Get.find<SellController>();
          final prod = Map<String, dynamic>.from(product);
          
          sellController.activeProducts.removeWhere((p) => p['name'] == prod['name']);
          if (!sellController.inactiveProducts.any((p) => p['name'] == prod['name'])) {
            sellController.inactiveProducts.add(prod);
          }
          sellController.isActiveTab.value = false;
          
          Get.back(); // go back
          AppAlerts.success(message: "Product marked as inactive successfully");
        } catch (e) {
          Get.back();
        }
      },
    );
  }

  void deleteProduct() {
    AppAlerts.delete(
      title: "Delete Product !",
      message: "Are you sure you want to delete this product? This action cannot be undone.",
      onDelete: () {
        try {
          final sellController = Get.find<SellController>();
          final prod = Map<String, dynamic>.from(product);
          
          sellController.activeProducts.removeWhere((p) => p['name'] == prod['name']);
          sellController.inactiveProducts.removeWhere((p) => p['name'] == prod['name']);
          
          Get.back(); // go back
          AppAlerts.success(message: "Product deleted successfully");
        } catch (e) {
          Get.back();
        }
      },
    );
  }

  void updateProduct() {
    AppAlerts.success(message: "Product updated successfully");
  }
}