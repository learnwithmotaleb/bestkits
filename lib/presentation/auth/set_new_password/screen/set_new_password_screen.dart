import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';
import '../../../../utils/static_strings/static_strings.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/app_text_field.dart';

import '../controller/set_new_password_controller.dart';

class SetNewPasswordScreen extends StatelessWidget {
  const SetNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SetNewPasswordController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: Dimensions.pSym(h: 20, v: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Dimensions.gapH(40),
            Text(
              AppStrings.setNewPassword.tr,
              style: AppTextStyles.title.copyWith(
                fontSize: Dimensions.fs(28),
              ),
            ),
            Dimensions.gapH(12),
            Text(
              AppStrings.setNewPasswordSubtitle.tr,
              style: AppTextStyles.body.copyWith(
                color: AppColors.darkGreyColor.withOpacity(0.7),
              ),
            ),
            Dimensions.gapH(40),
            
            // New Password
            Text(
              AppStrings.newPassword.tr,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ),
            Dimensions.gapH(8),
            AppTextField(
              controller: controller.newPasswordController,
              hint: AppStrings.passwordPlaceholder.tr,
              obscure: true, // AppTextField handles toggle automatically
            ),
            
            Dimensions.gapH(20),
            
            // Confirm New Password
            Text(
              AppStrings.confirmPassword.tr,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ),
            Dimensions.gapH(8),
            AppTextField(
              controller: controller.confirmPasswordController,
              hint: AppStrings.passwordPlaceholder.tr, // Matching the design placeholder
              obscure: true, // AppTextField handles toggle automatically
            ),
            
            Dimensions.gapH(40),
            
            AppButton(
              label: AppStrings.updatePassword.tr,
              onPressed: controller.updatePassword,
              backgroundColor: AppColors.blackColor,
              textColor: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
