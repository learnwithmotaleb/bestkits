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
        margin: EdgeInsets.only(bottom: Dimensions.h(10)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.r(14)),
          border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(16),
                vertical: Dimensions.h(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.question,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.fs(13),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.w(8)),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_right,
                    size: Dimensions.rs(18),
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
                  vertical: Dimensions.h(12),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F7EF),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Dimensions.r(14)),
                    bottomRight: Radius.circular(Dimensions.r(14)),
                  ),
                ),
                child: Text(
                  item.answer!,
                  style: AppTextStyles.body.copyWith(
                    fontSize: Dimensions.fs(12),
                    color: AppColors.darkGreyColor.withOpacity(0.75),
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