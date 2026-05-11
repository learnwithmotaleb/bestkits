import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onTapViewAll;

  const SectionTitle({
    super.key,
    required this.title,
    this.onTapViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              fontSize: Dimensions.fs(16),
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
          GestureDetector(
            onTap: onTapViewAll,
            child: Text(
              AppStrings.viewAll.tr,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: Dimensions.fs(12),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
