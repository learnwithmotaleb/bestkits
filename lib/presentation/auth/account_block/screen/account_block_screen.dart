import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';
import '../../../../utils/static_strings/static_strings.dart';
import '../../../../widget/app_button.dart';

import '../controller/account_block_controller.dart';

class AccountBlockScreen extends StatelessWidget {
  const AccountBlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AccountBlockController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Slightly off-white background as in design
      body: Center(
        child: Container(
          margin: Dimensions.pAll(20),
          padding: Dimensions.pSym(h: 24, v: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.r(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Restricted Icon
              Container(
                padding: Dimensions.pAll(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5E5), // Soft red/pink background
                  borderRadius: BorderRadius.circular(Dimensions.r(12)),
                ),
                child: Icon(
                  Icons.person_off_outlined,
                  color: AppColors.redColor,
                  size: Dimensions.icon(32),
                ),
              ),
              Dimensions.gapH(24),
              
              // Title
              Text(
                AppStrings.accountBlocked.tr,
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: Dimensions.fs(20),
                  color: AppColors.darkGreyColor,
                ),
              ),
              Dimensions.gapH(12),
              
              // Subtitle with highlighted email
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.greyColor,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: "${AppStrings.accountBlockedSubtitle.tr} "),
                    TextSpan(
                      text: AppStrings.supportEmail.tr,
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: "."),
                  ],
                ),
              ),
              Dimensions.gapH(32),
              
              // Action Button
              AppButton(
                label: AppStrings.goBackLogin.tr,
                onPressed: controller.goBackLogin,
                backgroundColor: AppColors.blackColor,
                textColor: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
