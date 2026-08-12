import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../widget/app_button.dart';
import '../controller/seller_product_details_controller.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/seller_product_details/model/seller_product_details.dart' as sellModel;
import 'package:bestkits/service/api_url.dart';

class ProductTabsSection extends StatelessWidget {
  final SellerProductDetailsController controller;
  final sellModel.Data product;

  const ProductTabsSection({
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
                if (index == 1) {
                  tabLabel += ' (${product.totalReviews ?? 0})';
                }

                return GestureDetector(
                  onTap: () => controller.selectTab(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal:10, vertical: 10),
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
                    alignment: Alignment.centerLeft,
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
              return _buildReviews();
            case 2:
              return _buildSeller(context);
            default:
              return const SizedBox();
          }
        }),
        SizedBox(height: 40,)
      ],
    );
  }

  // ─── Description Tab ────────────────────────────────────────────────────────
  Widget _buildDescription() {
    final rawStatus = (product.status ?? '').toUpperCase();
    final desc = product.description ?? '';

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
                desc.isNotEmpty
                    ? desc
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
              _buildDetailRow(
                  '${AppStrings.subCategory.tr}:', product.subCategory?.name ?? ''),
              _buildDetailRow('${AppStrings.condition.tr}:', product.condition ?? ''),
              if (product.seller?.profile?.country != null)
                _buildDetailRow('${AppStrings.location.tr}:',
                    product.seller!.profile!.country!),
              _buildDetailRow(
                  '${AppStrings.sellerLabel.tr}:', product.seller?.profile?.fullName ?? ''),
              _buildDetailRow(
                  '${AppStrings.reference.tr}:', product.id.toString()),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ── Status-specific banners + bottom action buttons ──────────────────
        _buildStatusActions(rawStatus),
      ],
    );
  }

  // ─── Status-specific bottom actions ─────────────────────────────────────────
  Widget _buildStatusActions(String status) {
    switch (status) {
      case 'UNDER_REVIEW':
        return _buildUnderReviewActions();
      case 'ACTIVE':
      case 'LIVE':
        return _buildLiveActions();
      case 'ACTION_REQUIRED':
        return _buildActionRequiredActions();
      case 'REJECTED':
        return _buildRejectedActions();
      case 'SOLD':
        return _buildSoldActions();
      case 'INACTIVE':
        return _buildInactiveActions();
      default:
        return _buildLiveActions();
    }
  }

  // ── UNDER REVIEW ─────────────────────────────────────────────────────────────
  Widget _buildUnderReviewActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatusInfoBanner(
          icon: Icons.info_outline_rounded,
          color: const Color(0xFFFFB000),
          bgColor: const Color(0xFFFFF8E1),
          message:
              'Your product is currently under review by our team. You will be notified once the review is complete.',
        ),
        const SizedBox(height: 16),
        AppButton(
          label: 'Cancel Submission',
          onPressed: () {
            Get.dialog(
              Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.redColor, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.priority_high,
                            color: AppColors.redColor,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Cancel Product Submission !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Are you sure you want to cancel this product submission? The product will be removed from the verification queue.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.3)),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                                Get.back(); // Go back to sell screen
                              },
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1A1A),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          backgroundColor: const Color(0xFF1A1A1A),
          textColor: AppColors.primaryColor,
          leadingIcon: Icon(Icons.cancel_outlined,
              color: AppColors.primaryColor, size: 18),
          borderRadius: 12,
          height: 50,
        ),
      ],
    );
  }

  // ── LIVE ─────────────────────────────────────────────────────────────────────
  Widget _buildLiveActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppButton(
          label: 'Mark As Inactive',
          onPressed: controller.markAsInactive,
          backgroundColor: const Color(0xFF1B1B1B),
          textColor: AppColors.primaryColor,
          leadingIcon: Icon(Icons.block_outlined,
              color: AppColors.primaryColor, size: 18),
          borderRadius: 12,
          height: 50,
        ),
        const SizedBox(height: 12),
        AppButton(
          label: 'Delete Product',
          onPressed: controller.deleteProduct,
          backgroundColor: const Color(0xFFFFEBEE),
          textColor: AppColors.redColor,
          leadingIcon: Icon(Icons.delete_outline_rounded,
              color: AppColors.redColor, size: 18),
          borderRadius: 12,
          height: 50,
          borderSideColor: AppColors.redColor,
        ),
      ],
    );
  }

  // ── ACTION REQUIRED ──────────────────────────────────────────────────────────
  Widget _buildActionRequiredActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatusTimerBanner(
          color: const Color(0xFFFF6B35),
          bgColor: const Color(0xFFFFF3E0),
        ),
      ],
    );
  }

  // ── REJECTED ──────────────────────────────────────────────────────────────────
  Widget _buildRejectedActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatusTimerBanner(
          color: AppColors.redColor,
          bgColor: const Color(0xFFFFEBEE),
        ),
        const SizedBox(height: 16),
        AppButton(
          label: 'Delete Product',
          onPressed: controller.deleteProduct,
          backgroundColor: const Color(0xFFFFEBEE),
          textColor: AppColors.redColor,
          leadingIcon: Icon(Icons.delete_outline_rounded,
              color: AppColors.redColor, size: 18),
          borderRadius: 12,
          height: 50,
          borderSideColor: AppColors.redColor,
        ),
      ],
    );
  }

  // ── SOLD ─────────────────────────────────────────────────────────────────────
  Widget _buildSoldActions() {
    return const SizedBox.shrink();
  }

  // ── INACTIVE ─────────────────────────────────────────────────────────────────
  Widget _buildInactiveActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppButton(
          label: 'Mark As Live',
          onPressed: controller.markAsInactive,
          backgroundColor: const Color(0xFF1B1B1B),
          textColor: AppColors.primaryColor,
          leadingIcon: Icon(Icons.remove_red_eye_sharp,
              color: AppColors.primaryColor, size: 18),
          borderRadius: 12,
          height: 50,
        ),
        const SizedBox(height: 12),
        AppButton(
          label: 'Delete Product',
          onPressed: controller.deleteProduct,
          backgroundColor: const Color(0xFFFFEBEE),
          textColor: AppColors.redColor,
          leadingIcon: Icon(Icons.delete_outline_rounded,
              color: AppColors.redColor, size: 18),
          borderRadius: 12,
          height: 50,
          borderSideColor: AppColors.redColor,
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
    if (isoDate.isEmpty) return '—';
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }

  // ─── Reviews Tab ─────────────────────────────────────────────────────────────
  Widget _buildReviews() {
    if ((product.totalReviews ?? 0) == 0) {
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          '${product.totalReviews ?? 0} review(s) — details coming soon',
          style: TextStyle(color: Colors.grey[500], fontSize: 13),
        ),
      ),
    );
  }

  // ─── Seller Tab ──────────────────────────────────────────────────────────────
  Widget _buildSeller(BuildContext context) {
    final seller = product.seller;
    final profile = seller?.profile;
    final sellerName =
        (profile?.fullName?.isNotEmpty ?? false) ? profile!.fullName! : 'Seller';
    final country = profile?.country ?? '';
    final avatarUrl = ApiUrl.buildImageUrl(profile?.avatarUrl);

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
        const SizedBox(height: 20),
        Text(
          '${AppStrings.sellerOverview.tr}:',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 12),
        _buildSellerStat(
          Icons.star_border,
          '${AppStrings.totalRating.tr} ( ${product.totalReviews ?? 0} ${AppStrings.reviews.tr} )',
          (product.averageRating ?? 0.0).toString(),
        ),
        _buildSellerStat(
          Icons.category_outlined,
          AppStrings.totalItems.tr,
          '${product.category?.name ?? ''} • ${product.subCategory?.name ?? ''}',
          highlight: true,
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
                    style: TextStyle(color: Colors.grey[500], fontSize: 11)),
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

// ─── Status Info Banner ───────────────────────────────────────────────────────
class _StatusInfoBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String message;

  const _StatusInfoBanner({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontSize: 12,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Status Timer Banner ──────────────────────────────────────────────────────
class _StatusTimerBanner extends StatelessWidget {
  final Color color;
  final Color bgColor;

  const _StatusTimerBanner({
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.timer_outlined, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time Remaining: 02d 14h 35m',
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your Product Requires Attention. Please tackle and Resubmit It For Verification. Within The Next 3 Days. If No Action is Taken Today, The Countdown Ends. This Listing Will Be Automatically Removed.',
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
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
