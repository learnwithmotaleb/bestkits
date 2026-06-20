import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../utils/app_text_style/app_text_style.dart';
import '../controller/update_product_controller.dart';
import '../../../controller/sell_controller.dart';

class ProductInfoSection extends StatelessWidget {
  final UpdateProductController controller;

  const ProductInfoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final product = controller.product;
      final name = product['name'] ?? '';
      final price = product['price'] ?? '';
      final oldPrice = product['oldPrice'] ?? '';
      final discount = product['discount'] ?? '';
      final rating = product['rating'] ?? '4.9/5.0';
      final material = product['material'] ?? '';
      
      // Dynamic active/inactive state check
      bool isActive = true;
      try {
        final sellController = Get.find<SellController>();
        if (sellController.inactiveProducts.any((p) => p['name'] == name)) {
          isActive = false;
        }
      } catch (e) {}

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryColor.withOpacity(0.5)),
            ),
            child: Text(
              material.toString().tr,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Product Name
          Text(
            name.toString().tr,
            style: AppTextStyles.h3.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          // Rating and Status
          Row(
            children: [
              Icon(Icons.star, color: AppColors.primaryColor, size: 16),
              const SizedBox(width: 4),
              Text(
                rating,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 4),
              Text(
                '[ 128 ${AppStrings.reviews.tr} ]',
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
              const Spacer(),
              // Status Badge (Active / Inactive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 2, 
                      backgroundColor: isActive ? const Color(0xFF4CAF50) : Colors.grey
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isActive ? AppStrings.active.tr : "Inactive",
                      style: TextStyle(
                        color: isActive ? const Color(0xFF4CAF50) : Colors.grey[600], 
                        fontSize: 10, 
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Price Row
          Row(
            children: [
              Text(
                '€$price',
                style: AppTextStyles.h2.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                oldPrice,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 12),
              // Discount Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryColor.withOpacity(0.5)),
                ),
                child: Text(
                  discount,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFFF5F5F5)),
        ],
      );
    });
  }
}
