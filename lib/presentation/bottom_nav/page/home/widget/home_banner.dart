import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../utils/assets_image/app_images.dart';
import 'package:get/get.dart';
import '../../../../product_details/screen/product_details_screen.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => const ProductDetailsScreen()),
      child: Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
      height: Dimensions.h(160),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.r(15)),
        gradient: LinearGradient(
          colors: [
            AppColors.navBarColor.withOpacity(0.8),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(Dimensions.w(15)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.w(8), vertical: Dimensions.h(4)),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(Dimensions.r(20)),
                    ),
                    child: Text(
                      AppStrings.limitedTimeOffer.tr,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: Dimensions.fs(10),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Dimensions.gapH(8),
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.h2.copyWith(fontSize: Dimensions.fs(20), color: Colors.black),
                      children: [
                        TextSpan(text: AppStrings.upTo.tr),
                        TextSpan(
                          text: AppStrings.discount40.tr,
                          style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    AppStrings.springSale.tr,
                    style: AppTextStyles.h4.copyWith(fontSize: Dimensions.fs(14)),
                  ),
                  Dimensions.gapH(5),
                  SizedBox(
                    width: Dimensions.w(150),
                    child: Text(
                      AppStrings.bannerSubtitle.tr,
                      style: TextStyle(fontSize: Dimensions.fs(8), color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: Image.asset(
              AppImages.kidsCollections,
              width: Dimensions.w(150),
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    )
    );
  }
}
