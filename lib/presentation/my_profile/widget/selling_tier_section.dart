import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../utils/static_strings/static_strings.dart';

class SellingTierSection extends StatelessWidget {
  final String tier;

  const SellingTierSection({
    super.key,
    this.tier = 'Basic Seller',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: Dimensions.pSym(h: 14, v: 14),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(12)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.mySellingTier.tr,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor.withOpacity(0.8),
              fontSize: Dimensions.fs(14),
            ),
          ),
          SizedBox(height: Dimensions.h(10)),
          _TierChip(label: tier),
        ],
      ),
    );
  }
}

class _TierChip extends StatelessWidget {
  final String label;

  const _TierChip({required this.label});

  Color get _chipColor {
    switch (label.toLowerCase()) {
      case 'professional seller':
        return const Color(0xFF1E88E5); // blue
      case 'premium seller':
        return const Color(0xFF8E24AA); // purple
      default:
        return AppColors.darkGreyColor; // grey for Basic
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _chipColor;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.w(12),
        vertical: Dimensions.h(5),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Dimensions.r(20)),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Dimensions.rs(7),
            height: Dimensions.rs(7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          SizedBox(width: Dimensions.w(6)),
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontSize: Dimensions.fs(12),
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
