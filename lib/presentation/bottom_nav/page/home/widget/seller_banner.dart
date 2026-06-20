import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../widget/app_button.dart';
import '../../../controller/bottom_nav_controller.dart';

class SellerBanner extends StatelessWidget {
  const SellerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(Dimensions.w(20)),
      padding: EdgeInsets.all(Dimensions.w(20)),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(Dimensions.r(20)),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.sellerBannerTitle.tr,
            textAlign: TextAlign.center,
            style: AppTextStyles.h3.copyWith(
              fontSize: Dimensions.fs(16),
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
          Dimensions.gapH(10),
          Text(
            AppStrings.sellerBannerSubtitle.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Dimensions.fs(10),
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          Dimensions.gapH(20),
          AppButton(
            label: AppStrings.startSellingNow.tr,
            onPressed: () {
              try {
                final bottomNavController = Get.find<BottomNavController>();
                bottomNavController.changeIndex(2); // Switch to Sell tab
              } catch (e) {
                // Fail-safe
              }
            },
            backgroundColor: AppColors.blackColor,
            textColor: AppColors.primaryColor,
            borderSideColor: AppColors.blackColor,
            leadingIcon: Icon(
              Icons.storefront_outlined,
              size: Dimensions.icon(20),
              color: AppColors.primaryColor,
            ),
            borderRadius: Dimensions.r(10),
            height: Dimensions.h(50),
          ),
        ],
      ),
    );
  }
}
