import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';

class OnboardPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnboardPage({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.w(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title
          Text(
            title,
            style: AppTextStyles.title.copyWith(
              fontSize: Dimensions.fs(32, tablet: 40, desktop: 48),
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              height: 1.2,
            ),
          ),

          Dimensions.gapH(16),

          // Subtitle
          Text(
            subtitle,
            style: AppTextStyles.body.copyWith(
              fontSize: Dimensions.fs(16, tablet: 18, desktop: 20),
              fontStyle: FontStyle.italic,
              color: AppColors.greyColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}