import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_button.dart';
import '../../../widget/app_text_field.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ChangePasswordController controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: Dimensions.w(70),
        leading: Padding(
          padding: EdgeInsets.only(left: Dimensions.w(20)),
          child: Center(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                height: Dimensions.h(40),
                width: Dimensions.h(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withOpacity(0.1),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.blackColor.withOpacity(0.7),
                  size: Dimensions.rs(20),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          AppStrings.changePassword.tr,
          style: AppTextStyles.h2.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: Dimensions.fs(18),
            color: AppColors.blackColor.withOpacity(0.8),
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.w(20),
          vertical: Dimensions.h(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: controller.oldPasswordController,
              label: AppStrings.oldPassword.tr,
              hint: AppStrings.passwordPlaceholder.tr,
              obscure: true,
              radius: Dimensions.r(8),
            ),
            SizedBox(height: Dimensions.h(20)),
            AppTextField(
              controller: controller.newPasswordController,
              label: AppStrings.newPassword.tr,
              hint: AppStrings.passwordPlaceholder.tr,
              obscure: true,
              radius: Dimensions.r(8),
            ),
            SizedBox(height: Dimensions.h(20)),
            AppTextField(
              controller: controller.confirmPasswordController,
              label: AppStrings.confirmPassword.tr,
              hint: AppStrings.passwordPlaceholder.tr,
              obscure: true,
              radius: Dimensions.r(8),
            ),
            SizedBox(height: Dimensions.h(30)),
            Obx(() => AppButton(
              label: AppStrings.saveTheChanges.tr,
              onPressed: controller.isLoading.value ? null : () => controller.saveChanges(),
              isLoading: controller.isLoading.value,
              backgroundColor: const Color(0xFF1A1A1A),
              textColor: AppColors.primaryColor,
              borderRadius: Dimensions.r(8),
              borderSideColor: Colors.transparent,
              height: Dimensions.h(50),
            )),
          ],
        ),
      ),
    );
  }
}
