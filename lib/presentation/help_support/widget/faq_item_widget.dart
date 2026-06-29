import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../controller/help_support_controller.dart';

class FaqItemWidget extends StatelessWidget {
  final int index;
  final FaqItem item;
  final bool isExpanded;
  final VoidCallback onTap;

  const FaqItemWidget({
    super.key,
    required this.index,
    required this.item,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.h(12)),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(Dimensions.r(16)),
          border: Border.all(color: AppColors.blackColor.withOpacity(0.06), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(16),
                vertical: Dimensions.h(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.question,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.blackColor.withOpacity(0.9),
                        fontWeight: FontWeight.w700,
                        fontSize: Dimensions.fs(13.5),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.w(8)),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_right,
                    size: Dimensions.rs(20),
                    color: AppColors.greyColor,
                  ),
                ],
              ),
            ),
            if (isExpanded && item.answer != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(16),
                  vertical: Dimensions.h(16),
                ),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Dimensions.r(16)),
                    bottomRight: Radius.circular(Dimensions.r(16)),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: AppColors.blackColor.withOpacity(0.04),
                      width: 0.8,
                    ),
                  ),
                ),
                child: Text(
                  item.answer!,
                  style: AppTextStyles.body.copyWith(
                    fontSize: Dimensions.fs(12.5),
                    color: AppColors.darkGreyColor.withOpacity(0.85),
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}