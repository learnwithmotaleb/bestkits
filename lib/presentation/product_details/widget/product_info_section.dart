import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';
import 'package:bestkits/data/model/product_model.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductModel product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.discountedPrice != null &&
        product.discountPercentage != null &&
        product.discountPercentage! > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Tag
        if (product.categoryName.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.primaryColor.withOpacity(0.5)),
            ),
            child: Text(
              product.categoryName,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        const SizedBox(height: 10),
        // Product Name
        Text(
          product.name,
          style: AppTextStyles.h3.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        // Rating and Status
        Row(
          children: [
            Icon(Icons.star, color: AppColors.primaryColor, size: 16),
            const SizedBox(width: 4),
            Text(
              product.ratingDisplay,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 4),
            Text(
              '[ ${product.totalReviews} ${AppStrings.reviews.tr} ]',
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
            const Spacer(),
            // Active / Condition Badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: product.condition == 'NEW'
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 2,
                    backgroundColor: product.condition == 'NEW'
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFFF9800),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    product.condition,
                    style: TextStyle(
                      color: product.condition == 'NEW'
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFFF9800),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        // Price Row
        Row(
          children: [
            Text(
              product.formattedPrice,
              style: AppTextStyles.h2.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (hasDiscount) ...[
              const SizedBox(width: 8),
              Text(
                product.formattedOriginalPrice,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 12),
              // Discount Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.5)),
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
