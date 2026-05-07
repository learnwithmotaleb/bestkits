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
                      controller.tabs[index],
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
        const Text(
          'Description:-',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Text(
          'Comfortable and lightweight side sneakers designed for everyday use. Made with breathable materials and a flexible sole to support active movement. Clean finish with a modern look, easy to match with any outfit.\n\nBrand new, unused condition.\nFrom a clean, smoke-free environment.\nComes with original packaging.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Details:-',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        _buildDetailRow('Online since:', '2024-04-20'),
        _buildDetailRow('Category:', 'Kids'),
        _buildDetailRow('Sub-category:', 'Sneakers'),
        _buildDetailRow('Condition:', 'New'),
        _buildDetailRow('Material:', 'Textile & Rubber'),
        _buildDetailRow('Color:', 'Black'),
        _buildDetailRow('Size:', 'EU 28'),
        _buildDetailRow('Location:', 'Bulgaria'),
        _buildDetailRow('Seller:', 'Sofia Kids Closet'),
        _buildDetailRow('Reference:', '87456231'),
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
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View More',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10),
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
                          child: const Text(
                            '★ Professional Seller',
                            style: TextStyle(color: Color(0xFF03A9F4), fontSize: 8, fontWeight: FontWeight.w700),
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
                'Message Seller',
                style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Seller Overview:',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 12),
        // Stats
        _buildSellerStat(Icons.star_border, 'Total Rating ( 128 Reviews )', '4.9/5.0'),
        _buildSellerStat(Icons.shopping_bag_outlined, 'Items Sold', '1680 Sold', highlight: true),
        _buildSellerStat(Icons.category_outlined, 'Total Items', '56 Products', highlight: true),
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
