import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../widget/app_button.dart';
import '../controller/update_product_controller.dart';
import 'review_card.dart';

class ProductTabsSection extends StatelessWidget {
  final UpdateProductController controller;

  const ProductTabsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(controller.tabs.length, (index) {
            return Expanded(
              child: Obx(() {
                final isSelected = controller.selectedTabIndex.value == index;
                String tabLabel = controller.tabs[index].tr;
                if (index == 1) tabLabel += " (05)";
                
                return GestureDetector(
                  onTap: () => controller.selectTab(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? AppColors.primaryColor : Colors.grey.withOpacity(0.1),
                          width: 2,
                        ),
                      ),
                      gradient: isSelected
                          ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primaryColor.withOpacity(0.1),
                                Colors.white,
                              ],
                            )
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tabLabel,
                      style: TextStyle(
                        color: isSelected ? AppColors.primaryColor : Colors.black,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 14,
                        fontStyle: isSelected ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ),
        const SizedBox(height: 20),

        // Tab Content
        Obx(() {
          switch (controller.selectedTabIndex.value) {
            case 0:
              return _buildDescription();
            case 1:
              return _buildReviews();
            default:
              return const SizedBox();
          }
        }),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppStrings.description.tr}:-',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Text(
          AppStrings.dummyDescription.tr,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '${AppStrings.detailsLabel.tr}:-',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        _buildDetailRow('${AppStrings.onlineSince.tr}:', '2026-04-20'),
        _buildDetailRow('${AppStrings.category.tr}:', 'Kids'),
        _buildDetailRow('${AppStrings.subCategory.tr}:', 'Sneakers'),
        _buildDetailRow('${AppStrings.condition.tr}:', 'New'),
        _buildDetailRow('${AppStrings.material.tr}:', 'Textile & Rubber'),
        _buildDetailRow('${AppStrings.color.tr}:', 'Black'),
        _buildDetailRow('${AppStrings.size.tr}:', 'EU 28'),
        _buildDetailRow('${AppStrings.location.tr}:', 'Bulgaria'),
        _buildDetailRow('${AppStrings.sellerLabel.tr}:', 'Sofia Kids Closet'),
        _buildDetailRow('${AppStrings.reference.tr}:', '87458231'),
        const SizedBox(height: 30),

        // Mark As Inactive Button (Image 1)
        AppButton(
          label: 'Mark As Inactive',
          onPressed: () {
            controller.markAsInactive();
          },
          backgroundColor: const Color(0xFF1B1B1B),
          textColor: AppColors.primaryColor,
          leadingIcon: Icon(Icons.block_outlined, color: AppColors.primaryColor, size: 18),
          borderRadius: 12,
          height: 50,
        ),
        const SizedBox(height: 12),
        
        // Delete Product Button (Image 1)
        AppButton(
          label: 'Delete Product',
          onPressed: () {
            controller.deleteProduct();
          },
          backgroundColor: const Color(0xFFFFEBEE),
          textColor: AppColors.redColor,
          leadingIcon: Icon(Icons.delete_outline_rounded, color: AppColors.redColor, size: 18),
          borderRadius: 12,
          height: 50,
          borderSideColor: AppColors.redColor,
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    return Column(
      children: [
        ...controller.reviewsList.map((review) => ReviewCard(review: review)),
        const SizedBox(height: 10),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.viewMore.tr,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
