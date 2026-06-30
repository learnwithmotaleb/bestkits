import 'package:bestkits/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';
import '../../../../utils/static_strings/static_strings.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/app_text_field.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CommonAppBar(
        title: "",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Dimensions.gapH(20),
            // Title
            Text(
              AppStrings.forgotPassword.tr,
              style: AppTextStyles.title.copyWith(
                fontSize: Dimensions.fs(32, tablet: 36, desktop: 40),
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
              ),
            ),
            Dimensions.gapH(16),
            // Subtitle
            Text(
              AppStrings.forgotPasswordSubtitle.tr,
              style: AppTextStyles.body.copyWith(
                color: AppColors.greyColor,
                height: 1.5,
              ),
            ),
            Dimensions.gapH(40),
            // Email Field
            AppTextField(
              controller: controller.emailController,
              label: AppStrings.emailAddress.tr,
              hint: AppStrings.emailPlaceholder.tr,
              keyboardType: TextInputType.emailAddress,
            ),
            Dimensions.gapH(40),
            // Send Button
            Obx(() => AppButton(
                  label: AppStrings.sendVerificationCode.tr,
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.sendVerificationCode(),
                  isLoading: controller.isLoading.value,
                  backgroundColor: AppColors.blackColor,
                  textColor: const Color(0xFFFFB000), // Gold/Yellow as in design
                  borderRadius: Dimensions.r(12),
                  height: Dimensions.h(56),
                  borderSideColor: Colors.transparent,
                )),
          ],
        ),
      ),
    );
  }
}
