import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';

class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.5)),
          ),
          child: Text(
            'kids sneakers',
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
          'Kids Cotton Hoodie – Soft Fit',
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
            const Text(
              '4.9/5.0',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 4),
            Text(
              '[ 128 Reviews ]',
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
            const Spacer(),
            // Active Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  CircleAvatar(radius: 2, backgroundColor: Color(0xFF4CAF50)),
                  SizedBox(width: 4),
                  Text(
                    'Active',
                    style: TextStyle(color: Color(0xFF4CAF50), fontSize: 10, fontWeight: FontWeight.w600),
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
              '€180.00',
              style: AppTextStyles.h2.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '21.99',
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
                border: Border.all(color: AppColors.primaryColor.withOpacity(0.5)),
              ),
              child: Text(
                '10% off',
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
  }
}
