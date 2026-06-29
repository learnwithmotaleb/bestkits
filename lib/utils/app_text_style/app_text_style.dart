import 'package:flutter/material.dart';
import '../../core/responsive_layout/dimensions.dart';
import '../app_colors/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String nunito = "Nunito";

  // 🔹 Headers
  static TextStyle h1 = TextStyle(
    fontFamily: nunito,
    fontSize: Dimensions.fs(28),
    fontWeight: FontWeight.w800,
    color: AppColors.blackColor,
  );

  static TextStyle h2 = TextStyle(
    fontFamily: nunito,
    fontSize: Dimensions.fs(24),
    fontWeight: FontWeight.w700,
    color: AppColors.blackColor,
  );

  static TextStyle h3 = TextStyle(
    fontFamily: nunito,
    fontSize: Dimensions.fs(18),
    fontWeight: FontWeight.w700,
    color: AppColors.blackColor,
  );

  static TextStyle h4 = TextStyle(
    fontFamily: nunito,
    fontSize: Dimensions.fs(16),
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
  );

  // 🔹 Aliases for existing styles
  static TextStyle get title => h2;
  static TextStyle get sectionTitle => h3;

  // 🔹 Body / Subtitle
  static TextStyle bodyText = TextStyle(
    fontFamily: nunito,
    fontSize: Dimensions.fs(14),
    fontWeight: FontWeight.w400,
    color: AppColors.darkGreyColor,
  );

  static TextStyle get body => bodyText;

  // 🔹 Hint / Label
  static TextStyle hint = TextStyle(
    fontFamily: nunito,
    fontSize: Dimensions.fs(14),
    fontWeight: FontWeight.w400,
    color: AppColors.hintTextColor,
  );

  // 🔹 Button
  static TextStyle button = TextStyle(
    fontFamily: nunito,
    fontSize: Dimensions.fs(16),
    fontWeight: FontWeight.w600,
    color: AppColors.whiteColor,
  );

  static TextStyle appBarTitle = h3.copyWith(
    fontStyle: FontStyle.italic,
  );
}