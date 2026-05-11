import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';
import '../controller/product_details_controller.dart';
import 'review_card.dart';

class ProductTabsSection extends StatelessWidget {
  final ProductDetailsController controller;

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
            case 2:
              return _buildSeller(context);
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
        _buildDetailRow('${AppStrings.onlineSince.tr}:', '2024-04-20'),
        _buildDetailRow('${AppStrings.category.tr}:', 'Kids'),
        _buildDetailRow('${AppStrings.subCategory.tr}:', 'Sneakers'),
        _buildDetailRow('${AppStrings.condition.tr}:', 'New'),
        _buildDetailRow('${AppStrings.material.tr}:', 'Textile & Rubber'),
        _buildDetailRow('${AppStrings.color.tr}:', 'Black'),
        _buildDetailRow('${AppStrings.size.tr}:', 'EU 28'),
        _buildDetailRow('${AppStrings.location.tr}:', 'Bulgaria'),
        _buildDetailRow('${AppStrings.sellerLabel.tr}:', 'Sofia Kids Closet'),
        _buildDetailRow('${AppStrings.reference.tr}:', '87456231'),
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
        ...controller.reviews.map((review) => ReviewCard(review: review)),
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

  Widget _buildSeller(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Seller Profile
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text('mayoral', style: TextStyle(color: Color(0xFF2196F3), fontSize: 10, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Text(
                          'Mayoral Clothing Reseller',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE1F5FE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '★ ${AppStrings.professionalSeller.tr}',
                            style: const TextStyle(color: Color(0xFF03A9F4), fontSize: 8, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.mail_outline, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Support@mayoral.com', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Ivan Vazov, Plovdiv 4000, Bulgaria', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        // Message Button
        Container(
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.message_outlined, color: AppColors.primaryColor, size: 18),
              const SizedBox(width: 10),
              Text(
                AppStrings.messageSeller.tr,
                style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '${AppStrings.sellerOverview.tr}:',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 12),
        // Stats
        _buildSellerStat(Icons.star_border, '${AppStrings.totalRating.tr} ( 128 ${AppStrings.reviews.tr} )', '4.9/5.0'),
        _buildSellerStat(Icons.shopping_bag_outlined, AppStrings.itemsSold.tr, '1680 ${AppStrings.sold.tr}', highlight: true),
        _buildSellerStat(Icons.category_outlined, AppStrings.totalItems.tr, '56 ${AppStrings.products.tr}', highlight: true),
      ],
    );
  }

  Widget _buildSellerStat(IconData icon, String label, String value, {bool highlight = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: highlight ? AppColors.primaryColor : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
