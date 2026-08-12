import 'package:bestkits/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/core/responsive_layout/dimensions.dart';
import 'package:bestkits/service/api_url.dart';
import '../controller/shop_details_controller.dart';

class ShopImageSection extends StatelessWidget {
  final ShopDetailsController controller;

  const ShopImageSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final product = controller.productDetails.value;
      final rawImages = product?.imageUrls ?? [];
      // Build full URLs using the shared helper so relative paths like
      // "/uploads/shoes.jpg" are resolved against the active domain.
      final images =
          rawImages.map((p) => ApiUrl.buildImageUrl(p)).toList();
      final selectedIndex = controller.selectedImageIndex.value;

      return Column(
        children: [
          // Main Image
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: images.isNotEmpty
                    ? Image.network(
                        images[selectedIndex.clamp(0, images.length - 1)],
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 60,
                        ),
                      )
                    : const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 60,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Thumbnails
          if (images.length > 1)
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () => controller.selectImage(index),
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.grey.withOpacity(0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.network(
                          images[index],
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported, size: 20),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      );
    });
  }
}
