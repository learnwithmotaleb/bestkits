import 'package:flutter/material.dart';
import '../../core/responsive_layout/dimensions.dart';
import '../app_colors/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String nunito = "Nunito";

  // 🔹 TITLE (Hero Headers)
  static TextStyle title = TextStyle(
    fontFamily: nunito,
    fontSize: Dimensions.fs(24, tablet: 26, desktop: 28),
    fontWeight: FontWeight.w700,
    color: AppColors.blackColor,
  );

  // 🔹 SECTION TITLE
  static TextStyle sectionTitle = TextStyle(
    fontFamily: nunito,
    fontSize: Dimensions.fs(18, tablet: 20, desktop: 22),
    fontWeight: FontWeight.w700,
    color: AppColors.blackColor,
  );

  // 🔹 BODY / SUBTITLE
  static TextStyle body = TextStyle(
    fontFamily: nunito,
    fontSize: Dimensions.fs(14, tablet: 16, desktop: 18),
    fontWeight: FontWeight.w400,
    color: AppColors.darkGreyColor,
  );

  // 🔹 HINT / LABEL
  static TextStyle hint = TextStyle(
    fontFamily: nunito,
    fontSize: Dimensions.fs(14, tablet: 15, desktop: 16),
    fontWeight: FontWeight.w400,
    color: AppColors.hintTextColor,
  );

  // 🔹 BUTTON
  static TextStyle button = TextStyle(
    fontFamily: nunito,
    fontSize: Dimensions.fs(16, tablet: 18, desktop: 20),
    fontWeight: FontWeight.w600,
    color: AppColors.whiteColor,
  );
}