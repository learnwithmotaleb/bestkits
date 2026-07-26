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
                if (index == 1) {
                  final count = controller.product['total_reviews'] ?? 0;
                  tabLabel += ' ($count)';
                }
                
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
              return _buildDescription(controller.product);
            case 1:
              return _buildReviews();
            default:
              return const SizedBox();
          }
        }),
      ],
    );
  }

  Widget _buildDescription(Map<String, dynamic> product) {
    final description = product['description']?.toString() ?? '';

    // Category / subCategory
    final category = (product['category'] is Map
            ? product['category']['name']
            : product['category'])
        ?.toString() ?? '';
    final subCategory = (product['subCategory'] is Map
            ? product['subCategory']['name']
            : product['sub_category'])
        ?.toString() ?? '';

    // Condition
    final condition = product['condition']?.toString() ?? '';

    // Created at (online since)
    final createdAtRaw = product['createdAt']?.toString() ?? '';
    final onlineSince = createdAtRaw.length >= 10 ? createdAtRaw.substring(0, 10) : createdAtRaw;

    // Seller info from nested user object
    String sellerName = '';
    String location = '';
    final user = product['user'];
    if (user is Map) {
      final profile = user['profile'];
      if (profile is Map) {
        sellerName = profile['full_name']?.toString() ?? '';
        location = profile['country']?.toString() ?? '';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppStrings.description.tr}:-',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Text(
          description.isNotEmpty ? description : AppStrings.dummyDescription.tr,
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
        if (onlineSince.isNotEmpty) _buildDetailRow('${AppStrings.onlineSince.tr}:', onlineSince),
        if (category.isNotEmpty) _buildDetailRow('${AppStrings.category.tr}:', category),
        if (subCategory.isNotEmpty) _buildDetailRow('${AppStrings.subCategory.tr}:', subCategory),
        if (condition.isNotEmpty) _buildDetailRow('${AppStrings.condition.tr}:', condition),
        if (location.isNotEmpty) _buildDetailRow('${AppStrings.location.tr}:', location),
        if (sellerName.isNotEmpty) _buildDetailRow('${AppStrings.sellerLabel.tr}:', sellerName),
        const SizedBox(height: 30),

        // Mark As Inactive Button
        AppButton(
          label: AppStrings.markAsInactiveBtn.tr,
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

        // Delete Product Button
        AppButton(
          label: AppStrings.deleteProductBtn.tr,
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
    return Obx(() => Column(
      children: [
        if (controller.reviewsList.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: Text('No reviews yet.', style: TextStyle(color: Colors.grey))),
          )
        else
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
    ));
  }
}
