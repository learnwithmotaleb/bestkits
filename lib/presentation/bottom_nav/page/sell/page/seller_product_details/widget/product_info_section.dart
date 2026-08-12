import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../utils/app_text_style/app_text_style.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/seller_product_details/model/seller_product_details.dart'
    as sellModel;

// ─── Status Helpers ────────────────────────────────────────────────────────────

Color statusAccentColor(String status) {
  switch (status.toUpperCase()) {
    case 'UNDER_REVIEW':
      return AppColors.statusUnderReview;
    case 'ACTIVE':
    case 'LIVE':
      return AppColors.statusLive;
    case 'ACTION_REQUIRED':
      return AppColors.statusActionRequired;
    case 'REJECTED':
      return AppColors.statusRejected;
    case 'SOLD':
      return AppColors.statusSold;
    case 'INACTIVE':
      return AppColors.statusInactive;
    default:
      return AppColors.statusInactive;
  }
}

Color statusBgColor(String status) {
  switch (status.toUpperCase()) {
    case 'UNDER_REVIEW':
      return AppColors.statusUnderReviewBg;
    case 'ACTIVE':
    case 'LIVE':
      return AppColors.statusLiveBg;
    case 'ACTION_REQUIRED':
      return AppColors.statusActionRequiredBg;
    case 'REJECTED':
      return AppColors.statusRejectedBg;
    case 'SOLD':
      return AppColors.statusSoldBg;
    case 'INACTIVE':
      return AppColors.statusInactiveBg;
    default:
      return AppColors.statusInactiveBg;
  }
}

String statusLabel(String status) {
  switch (status.toUpperCase()) {
    case 'UNDER_REVIEW':
      return 'Under Review';
    case 'ACTIVE':
    case 'LIVE':
      return 'Live';
    case 'ACTION_REQUIRED':
      return 'Action Required';
    case 'REJECTED':
      return 'Rejected';
    case 'SOLD':
      return 'Sold';
    case 'INACTIVE':
      return 'Inactive';
    default:
      return status;
  }
}

// ─── Product Info Section ──────────────────────────────────────────────────────

class ProductInfoSection extends StatelessWidget {
  final sellModel.Data product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.discountedPrice != null &&
        product.discountPercentage != null &&
        product.discountPercentage! > 0;

    final rawStatus = (product.status ?? '').toUpperCase();
    final accentColor = statusAccentColor(rawStatus);
    final bgColor = statusBgColor(rawStatus);
    final label = statusLabel(rawStatus);

    final categoryName = product.category?.name ?? '';
    final subCategoryName = product.subCategory?.name ?? '';
    final condition = product.condition ?? '';

    final effectivePrice =
        ((product.effectivePrice ?? 0).toDouble() / 100).toStringAsFixed(2);
    final originalPrice =
        ((product.originalPrice ?? 0).toDouble() / 100).toStringAsFixed(2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Row 1: Category / Subcategory (with divider between them) ──────────
        Row(
          children: [
            if (categoryName.isNotEmpty) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.primaryColor.withValues(alpha: 0.5)),
                ),
                child: Text(
                  categoryName,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (subCategoryName.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '/',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ],
            if (subCategoryName.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[100],
                ),
                child: Text(
                  subCategoryName,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        // ── Row 2: Product Name ────────────────────────────────────────────────
        Text(
          product.name ?? '',
          style: AppTextStyles.h3.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 5),

        // ── Row 3: Status Badge ────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: accentColor.withValues(alpha: 0.4), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // ── Row 4: Condition label + chip ──────────────────────────────────────
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Condition - ',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: condition.toUpperCase() == 'NEW'
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: condition.toUpperCase() == 'NEW'
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFFF6B35),
                  width: 1,
                ),
              ),
              child: Text(
                condition.isNotEmpty ? condition : 'N/A',
                style: TextStyle(
                  color: condition.toUpperCase() == 'NEW'
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFFF6B35),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // ── Row 5: Price Row ───────────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '\$$effectivePrice',
              style: AppTextStyles.h2.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (hasDiscount) ...[
              const SizedBox(width: 8),
              Text(
                '\$$originalPrice',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[400],
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.primaryColor.withValues(alpha: 0.5)),
                ),
                child: Text(
                  '${product.discountPercentage!.toInt()}% ${AppStrings.off.tr}',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: Color(0xFFF5F5F5)),
      ],
    );
  }
}
