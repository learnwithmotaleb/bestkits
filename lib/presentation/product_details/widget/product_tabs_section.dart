import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';
import '../controller/product_details_controller.dart';
import 'package:bestkits/data/model/product_model.dart';

class ProductTabsSection extends StatelessWidget {
  final ProductDetailsController controller;
  final ProductModel product;

  const ProductTabsSection({
    super.key,
    required this.controller,
    required this.product,
  });

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
                  tabLabel += ' (${product.totalReviews})';
                }

                return GestureDetector(
                  onTap: () => controller.selectTab(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.grey.withOpacity(0.1),
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
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.black,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 14,
                        fontStyle: isSelected
                            ? FontStyle.italic
                            : FontStyle.normal,
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
          product.description.isNotEmpty
              ? product.description
              : AppStrings.dummyDescription.tr,
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
        _buildDetailRow(
          '${AppStrings.onlineSince.tr}:',
          _formatDate(product.createdAt),
        ),
        _buildDetailRow(
          '${AppStrings.category.tr}:',
          product.categoryName,
        ),
        _buildDetailRow(
          '${AppStrings.subCategory.tr}:',
          product.subCategoryName,
        ),
        _buildDetailRow(
          '${AppStrings.condition.tr}:',
          product.condition,
        ),
        if (product.user?.profile?.country != null)
          _buildDetailRow(
            '${AppStrings.location.tr}:',
            product.user!.profile!.country!,
          ),
        _buildDetailRow(
          '${AppStrings.sellerLabel.tr}:',
          product.sellerName,
        ),
        _buildDetailRow(
          '${AppStrings.reference.tr}:',
          product.id.toString(),
        ),
      ],
    );
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    } catch (_) {
      return isoDate;
    }
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
          Flexible(
            child: Text(
              value.isNotEmpty ? value : '—',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    if (product.totalReviews == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.rate_review_outlined,
                  size: 48, color: Colors.grey[300]),
              const SizedBox(height: 12),
              Text(
                'No reviews yet',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // When API includes reviews, map them here. For now show a placeholder count.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          '${product.totalReviews} review(s) — details coming soon',
          style: TextStyle(color: Colors.grey[500], fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildSeller(BuildContext context) {
    final seller = product.user;
    final profile = seller?.profile;
    final sellerName =
        (profile?.fullName.isNotEmpty ?? false) ? profile!.fullName : 'Seller';
    final country = profile?.country ?? '';
    final avatarUrl = product.sellerAvatarUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Seller Profile
        Row(
          children: [
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: avatarUrl.isNotEmpty
                    ? Image.network(
                        avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildAvatarFallback(sellerName),
                      )
                    : _buildAvatarFallback(sellerName),
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
                        Text(
                          sellerName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE1F5FE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '★ ${AppStrings.professionalSeller.tr}',
                            style: const TextStyle(
                                color: Color(0xFF03A9F4),
                                fontSize: 8,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (country.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            country,
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        // Message Button
        GestureDetector(
          onTap: () {
            Get.toNamed(RoutePath.message);
          },
          child: Container(
            width: double.infinity,
            height: 45,
            decoration: BoxDecoration(
              color: AppColors.blackColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.message_outlined,
                    color: AppColors.primaryColor, size: 18),
                const SizedBox(width: 10),
                Text(
                  AppStrings.messageSeller.tr,
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '${AppStrings.sellerOverview.tr}:',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 12),
        // Stats
        _buildSellerStat(
          Icons.star_border,
          '${AppStrings.totalRating.tr} ( ${product.totalReviews} ${AppStrings.reviews.tr} )',
          product.ratingDisplay,
        ),
        _buildSellerStat(
          Icons.category_outlined,
          AppStrings.totalItems.tr,
          '${product.categoryName} • ${product.subCategoryName}',
          highlight: true,
        ),
      ],
    );
  }

  Widget _buildAvatarFallback(String name) {
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase()
        : '?';
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
            color: Color(0xFF2196F3),
            fontSize: 14,
            fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildSellerStat(IconData icon, String label, String value,
      {bool highlight = false}) {
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        TextStyle(color: Colors.grey[500], fontSize: 11)),
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
          ),
        ],
      ),
    );
  }
}
