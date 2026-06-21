import 'package:flutter/material.dart';

import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';

class EaringCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const EaringCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.w(16), vertical: Dimensions.h(16)),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(12)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: Dimensions.w(48),
            height: Dimensions.w(48),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor.withOpacity(0.1),
            ),
            child: ClipOval(
              child: Image.asset(
                data['image'],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.person, color: AppColors.primaryColor),
              ),
            ),
          ),
          SizedBox(width: Dimensions.w(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'],
                  style: AppTextStyles.body.copyWith(
                    fontSize: Dimensions.fs(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: Dimensions.h(4)),
                Text(
                  data['date'],
                  style: AppTextStyles.body.copyWith(
                    fontSize: Dimensions.fs(12),
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '€${data['amount']}',
            style: AppTextStyles.body.copyWith(
              fontSize: Dimensions.fs(16),
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
