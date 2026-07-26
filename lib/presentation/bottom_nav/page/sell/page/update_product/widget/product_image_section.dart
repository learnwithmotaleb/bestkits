import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../service/api_url.dart';

import '../controller/update_product_controller.dart';

class ProductImageSection extends StatelessWidget {
  final UpdateProductController controller;

  const ProductImageSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
                  child: Builder(builder: (context) {
                    final imgPath = controller.productImages[controller.selectedImageIndex.value];
                    return imgPath.startsWith('assets/')
                        ? Image.asset(imgPath, fit: BoxFit.contain)
                        : Image.network(
                            ApiUrl.buildImageUrl(imgPath),
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                          );
                  }),
                ),
              ),
            ),
        const SizedBox(height: 15),
        // Thumbnails
        SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.productImages.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return Obx(() {
                final isSelected = controller.selectedImageIndex.value == index;
                return GestureDetector(
                  onTap: () => controller.selectImage(index),
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryColor : Colors.grey.withOpacity(0.2),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Builder(builder: (context) {
                        final imgPath = controller.productImages[index];
                        return imgPath.startsWith('assets/')
                            ? Image.asset(imgPath, fit: BoxFit.contain)
                            : Image.network(
                                ApiUrl.buildImageUrl(imgPath),
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                              );
                      }),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }
}
