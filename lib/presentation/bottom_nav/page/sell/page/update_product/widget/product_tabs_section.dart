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
    final category = (product['category'] is Map
            ? product['category']['name']
            : product['category'])
        ?.toString() ??
        '';
    final subCategory = (product['subCategory'] is Map
            ? product['subCategory']['name']
            : product['sub_category'])
        ?.toString() ??
        '';
    final condition = product['condition']?.toString() ?? '';
    final createdAtRaw = product['createdAt']?.toString() ?? '';
    final onlineSince =
        createdAtRaw.length >= 10 ? createdAtRaw.substring(0, 10) : createdAtRaw;

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

    final rawStatus =
        (product['status'] ?? 'INACTIVE').toString().toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppStrings.description.tr}:-',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Text(
          description.isNotEmpty
              ? description
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
        if (onlineSince.isNotEmpty)
          _buildDetailRow('${AppStrings.onlineSince.tr}:', onlineSince),
        if (category.isNotEmpty)
          _buildDetailRow('${AppStrings.category.tr}:', category),
        if (subCategory.isNotEmpty)
          _buildDetailRow('${AppStrings.subCategory.tr}:', subCategory),
        if (condition.isNotEmpty)
          _buildDetailRow('${AppStrings.condition.tr}:', condition),
        if (location.isNotEmpty)
          _buildDetailRow('${AppStrings.location.tr}:', location),
        if (sellerName.isNotEmpty)
          _buildDetailRow('${AppStrings.sellerLabel.tr}:', sellerName),
        const SizedBox(height: 24),

        // ── Status-specific banners + bottom action buttons ──────────────────
        _buildStatusActions(rawStatus),
      ],
    );
  }

  // ─── Status Actions ──────────────────────────────────────────────────────────
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
        // Info banner
        _InfoBanner(
          icon: Icons.info_outline_rounded,
          color: const Color(0xFFFFB000),
          bgColor: const Color(0xFFFFF8E1),
          message:
              'Your product is currently under review by our team. You will be notified once the review is complete.',
        ),
        const SizedBox(height: 16),
        // Cancel Submission
        AppButton(
          label: 'Cancel Submission',
          onPressed: () => controller.deleteProduct(),
          backgroundColor: const Color(0xFFFFEBEE),
          textColor: AppColors.redColor,
          leadingIcon: Icon(Icons.cancel_outlined,
              color: AppColors.redColor, size: 18),
          borderRadius: 12,
          height: 50,
          borderSideColor: AppColors.redColor,
        ),
      ],
    );
  }

  // ── LIVE ─────────────────────────────────────────────────────────────────────
  Widget _buildLiveActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mark As Inactive
        AppButton(
          label: AppStrings.markAsInactiveBtn.tr,
          onPressed: () => controller.markAsInactive(),
          backgroundColor: const Color(0xFF1B1B1B),
          textColor: AppColors.primaryColor,
          leadingIcon: Icon(Icons.block_outlined,
              color: AppColors.primaryColor, size: 18),
          borderRadius: 12,
          height: 50,
        ),
        const SizedBox(height: 12),
        // Delete Product
        AppButton(
          label: AppStrings.deleteProductBtn.tr,
          onPressed: () => controller.deleteProduct(),
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
        // Timer / warning banner
        _TimerBanner(
          color: const Color(0xFFFF6B35),
          bgColor: const Color(0xFFFFF3E0),
        ),
        const SizedBox(height: 16),
        // Resubmit For Verification
        AppButton(
          label: 'Resubmit For Verification',
          onPressed: () {
            // Navigate to verification flow (integration off — placeholder)
          },
          backgroundColor: const Color(0xFF1B1B1B),
          textColor: AppColors.primaryColor,
          leadingIcon: Icon(Icons.refresh_rounded,
              color: AppColors.primaryColor, size: 18),
          borderRadius: 12,
          height: 50,
        ),
        const SizedBox(height: 12),
        // Delete Product
        AppButton(
          label: AppStrings.deleteProductBtn.tr,
          onPressed: () => controller.deleteProduct(),
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

  // ── REJECTED ──────────────────────────────────────────────────────────────────
  Widget _buildRejectedActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timer / warning banner
        _TimerBanner(
          color: AppColors.redColor,
          bgColor: const Color(0xFFFFEBEE),
        ),
        const SizedBox(height: 16),
        // Resubmit For Verification
        AppButton(
          label: 'Resubmit For Verification',
          onPressed: () {
            // Integration off — placeholder
          },
          backgroundColor: const Color(0xFF1B1B1B),
          textColor: AppColors.primaryColor,
          leadingIcon: Icon(Icons.refresh_rounded,
              color: AppColors.primaryColor, size: 18),
          borderRadius: 12,
          height: 50,
        ),
        const SizedBox(height: 12),
        // Delete Product
        AppButton(
          label: AppStrings.deleteProductBtn.tr,
          onPressed: () => controller.deleteProduct(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoBanner(
          icon: Icons.check_circle_outline_rounded,
          color: const Color(0xFF6366F1),
          bgColor: const Color(0xFFEDE9FE),
          message:
              'This product has been sold. View order details for more information.',
        ),
      ],
    );
  }

  // ── INACTIVE ─────────────────────────────────────────────────────────────────
  Widget _buildInactiveActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mark As Active
        AppButton(
          label: 'Mark As Active',
          onPressed: () => controller.markAsInactive(), // toggle logic inside
          backgroundColor: const Color(0xFFE8F5E9),
          textColor: const Color(0xFF22C55E),
          leadingIcon: const Icon(Icons.visibility_outlined,
              color: Color(0xFF22C55E), size: 18),
          borderRadius: 12,
          height: 50,
          borderSideColor: const Color(0xFF22C55E),
        ),
        const SizedBox(height: 12),
        // Delete Product
        AppButton(
          label: AppStrings.deleteProductBtn.tr,
          onPressed: () => controller.deleteProduct(),
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
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic),
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
                child: Center(
                    child: Text('No reviews yet.',
                        style: TextStyle(color: Colors.grey))),
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
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 10),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

// ─── Info Banner ──────────────────────────────────────────────────────────────
class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String message;

  const _InfoBanner({
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

// ─── Timer Banner ──────────────────────────────────────────────────────────────
class _TimerBanner extends StatelessWidget {
  final Color color;
  final Color bgColor;

  const _TimerBanner({
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    // Dummy countdown — real data comes from backend
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
                  'Time Remaining: 03d 14h 35m',
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your Product Requires Attention. Please Update And Resubmit It For Verification. The Time Remaining Is Shown Before The Countdown Ends. (You Listing Will Be Automatically Removed)',
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
