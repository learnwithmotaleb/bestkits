import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/utils/app_colors/app_colors.dart';
import 'package:bestkits/widget/app_button.dart';
import '../controller/shop_details_controller.dart';
import '../model/shop_details_model.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/service/api_url.dart';

class ShopTabsSection extends StatelessWidget {
  final ShopDetailsController controller;
  final ShopDetailsData product;

  const ShopTabsSection({
    super.key,
    required this.controller,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Tab Bar ──────────────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(controller.tabs.length, (index) {
            return Expanded(
              child: Obx(() {
                final isSelected = controller.selectedTabIndex.value == index;
                String tabLabel = controller.tabs[index].tr;

                return GestureDetector(
                  onTap: () => controller.selectTab(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primaryColor.withOpacity(0.2),
                                Colors.grey.withOpacity(0.1),
                              ],
                            )
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tabLabel,
                      style: TextStyle(
                        color:
                            isSelected ? AppColors.primaryColor : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 14,
                        fontStyle:
                            isSelected ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ),
        const SizedBox(height: 5),

        // ── Tab Content ──────────────────────────────────────────────────────
        Obx(() {
          switch (controller.selectedTabIndex.value) {
            case 0:
              return _buildDescription();
            case 1:
              return _buildSeller(context);
            default:
              return const SizedBox();
          }
        }),
        const SizedBox(height: 20),
      ],
    );
  }

  // ─── Description Tab ────────────────────────────────────────────────────────
  Widget _buildDescription() {
    final seller = product.user;
    final sellerName = seller?.profile?.fullName ?? '';
    final country = seller?.profile?.country ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF9F6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description:-',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                (product.description?.isNotEmpty ?? false)
                    ? product.description!
                    : AppStrings.dummyDescription.tr,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Details:-',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 10),
              _buildDetailRow('${AppStrings.onlineSince.tr}:',
                  _formatDate(product.createdAt ?? '')),
              _buildDetailRow(
                  '${AppStrings.category.tr}:', product.category?.name ?? ''),
              _buildDetailRow('${AppStrings.subCategory.tr}:',
                  product.subCategory?.name ?? ''),
              _buildDetailRow(
                  '${AppStrings.condition.tr}:', product.condition ?? ''),
              if (country.isNotEmpty)
                _buildDetailRow('${AppStrings.location.tr}:', country),
              if (sellerName.isNotEmpty)
                _buildDetailRow('${AppStrings.sellerLabel.tr}:', sellerName),
              _buildDetailRow(
                  '${AppStrings.reference.tr}:', product.id?.toString() ?? ''),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Detail Row ──────────────────────────────────────────────────────────────
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

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }

  // ─── Seller Tab ──────────────────────────────────────────────────────────────
  Widget _buildSeller(BuildContext context) {
    final seller = product.user;
    final profile = seller?.profile;
    final sellerName = (profile?.fullName?.isNotEmpty ?? false)
        ? profile!.fullName!
        : 'Seller';
    final country = profile?.country ?? '';
    final email = seller?.email ?? '';
    final avatarUrl = ApiUrl.buildImageUrl(profile?.avatarUrl);

    // Seller overview from API
    final overview = product.sellerOverview;
    final itemsSold = overview?.itemsSold ?? 0;
    final activeProducts = overview?.activeProducts ?? 0;
    final avgRating = overview?.averageRating ?? 0;
    final totalReviews = overview?.totalReviews ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
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
                        errorBuilder: (_, __, ___) =>
                            _buildAvatarFallback(sellerName),
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
                  if (email.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.email_outlined,
                              size: 12, color: AppColors.primaryColor),
                          const SizedBox(width: 4),
                          Text(
                            email,
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  if (country.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 12, color: AppColors.primaryColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              country,
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppButton(
          label: 'Message Seller',
          onPressed: () {
            Get.toNamed(RoutePath.message);
          },
          backgroundColor: const Color(0xFF1A1A1A),
          textColor: AppColors.primaryColor,
          leadingIcon: Icon(Icons.chat_bubble_outline,
              color: AppColors.primaryColor, size: 16),
          height: 45,
          borderRadius: 12,
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '${AppStrings.sellerOverview.tr}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      fontStyle: FontStyle.italic),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFF5F5F5)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSellerStat(
                      Icons.insights_outlined,
                      'Items Sold',
                      '$itemsSold Sold',
                      highlight: true,
                    ),
                    _buildSellerStat(
                      Icons.inventory_2_outlined,
                      AppStrings.totalItems.tr,
                      '$activeProducts Products',
                      highlight: true,
                    ),
                    _buildSellerReviewStat(
                      Icons.star_border,
                      '${AppStrings.totalRating.tr} [ $totalReviews ${AppStrings.reviews.tr} ]',
                      avgRating.toString(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarFallback(String name) {
    final initials = name.isNotEmpty
        ? name
            .trim()
            .split(' ')
            .map((w) => w.isNotEmpty ? w[0] : '')
            .take(2)
            .join()
            .toUpperCase()
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
      margin: const EdgeInsets.only(bottom: 15),
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
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
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

  Widget _buildSellerReviewStat(IconData icon, String label, String value) {
    return Container(
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
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star,
                        color: AppColors.primaryColor, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '/5.0',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(RoutePath.viewAllReview,
                  arguments: product.id?.toString());
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.remove_red_eye_outlined,
                  color: Colors.blue, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
