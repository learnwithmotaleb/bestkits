import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../utils/app_text_style/app_text_style.dart';
import 'package:bestkits/presentation/currency_preference/widget/currency_helper.dart';
import '../controller/update_product_controller.dart';

// ─── Status helpers ────────────────────────────────────────────────────────────

Color statusAccentColor(String status) {
  switch (status.toUpperCase()) {
    case 'UNDER_REVIEW':
      return const Color(0xFFFFB000); // Amber
    case 'ACTIVE':
    case 'LIVE':
      return const Color(0xFF22C55E); // Green
    case 'ACTION_REQUIRED':
      return const Color(0xFFFF6B35); // Orange
    case 'REJECTED':
      return const Color(0xFFB3261E); // Red
    case 'SOLD':
      return const Color(0xFF6366F1); // Indigo
    case 'INACTIVE':
      return const Color(0xFF9E9E9E); // Grey
    default:
      return const Color(0xFF9E9E9E);
  }
}

Color statusBgColor(String status) {
  switch (status.toUpperCase()) {
    case 'UNDER_REVIEW':
      return const Color(0xFFFFF8E1);
    case 'ACTIVE':
    case 'LIVE':
      return const Color(0xFFE8F5E9);
    case 'ACTION_REQUIRED':
      return const Color(0xFFFFF3E0);
    case 'REJECTED':
      return const Color(0xFFFFEBEE);
    case 'SOLD':
      return const Color(0xFFEDE9FE);
    case 'INACTIVE':
      return const Color(0xFFF5F5F5);
    default:
      return const Color(0xFFF5F5F5);
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
  final UpdateProductController controller;

  const ProductInfoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final product = controller.product;
      final name = product['name'] ?? '';
      final price = (product['effective_price'] ??
              product['discounted_price'] ??
              product['original_price'] ??
              product['price'] ??
              '')
          .toString();
      final oldPrice =
          (product['original_price'] ?? product['oldPrice'] ?? '').toString();
      final discount = product['discount_percentage'] != null
          ? '${product['discount_percentage']}%'
          : (product['discount'] ?? '').toString();
      final rating = product['average_rating']?.toString() ??
          product['rating']?.toString() ??
          '4.9/5.0';
      final material = (product['category'] is Map
              ? product['category']['name']
              : product['category']) ??
          product['material'] ??
          '';

      final rawStatus =
          (product['status'] ?? 'INACTIVE').toString().toUpperCase();
      final accentColor = statusAccentColor(rawStatus);
      final bgColor = statusBgColor(rawStatus);
      final label = statusLabel(rawStatus);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Tag + Status Badge row
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.5)),
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
              const SizedBox(width: 8),
              // 6-state status badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: accentColor.withOpacity(0.4), width: 1),
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
            ],
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
          // Rating row
          Row(
            children: [
              Icon(Icons.star, color: AppColors.primaryColor, size: 16),
              const SizedBox(width: 4),
              Text(
                rating,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 4),
              Text(
                '[ 128 ${AppStrings.reviews.tr} ]',
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Product Condition
          Row(
            children: [
              Text(
                'Product Condition',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Condition chip
          Builder(builder: (_) {
            final condition =
                product['condition']?.toString().toUpperCase() ?? '';
            final isNew = condition == 'NEW' || condition == 'new';
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: isNew
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isNew ? 'New' : 'Used',
                style: TextStyle(
                  color: isNew
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFFF6B35),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }),
          const SizedBox(height: 15),
          // Price Row
          Row(
            children: [
              Text(
                CurrencyHelper.formatPrice(price),
                style: AppTextStyles.h4.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              if (oldPrice.isNotEmpty && oldPrice != '0' && oldPrice != '0.0' && oldPrice != price) ...[
                const SizedBox(width: 8),
                Text(
                  CurrencyHelper.formatPrice(oldPrice),
                  style:  TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
              const SizedBox(width: 12),
              // Discount Badge
              if (discount.isNotEmpty && discount != '0%')
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.5)),
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
