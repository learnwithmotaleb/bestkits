import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:bestkits/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/responsive_layout/dimensions.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../widget/app_button.dart';
import '../../../widget/app_text_field.dart';
import '../controller/my_profile_controller.dart';
import '../widget/selling_tier_section.dart';

class MyProfileScreen extends GetView<MyProfileController> {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MyProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: CommonAppBar(
        title: AppStrings.myProfile.tr,
      ),
      body: SingleChildScrollView(
        padding: Dimensions.pSym(h: 20, v: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Dimensions.h(20)),

            // ── Avatar ──────────────────────────────────────────
            Container(
              width: Dimensions.rs(100),
              height: Dimensions.rs(100),
              decoration: BoxDecoration(
                color: AppColors.navBarColor,
                borderRadius: BorderRadius.circular(Dimensions.r(24)),
                border: Border.all(
                  color: AppColors.greyColor.withOpacity(0.5),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                controller.nameController.text.isNotEmpty
                    ? controller.nameController.text[0].toUpperCase()
                    : AppStrings.dummyUserName.tr[0].toUpperCase(),
                style: AppTextStyles.h1.copyWith(
                  fontSize: Dimensions.fs(40),
                  fontStyle: FontStyle.italic,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: Dimensions.h(40)),

            // ── Name ─────────────────────────────────────────────
            AppTextField(
              controller: controller.nameController,
              label: AppStrings.fullName.tr,
              hint: AppStrings.enterFullName.tr,
              readOnly: true,
            ),
            SizedBox(height: Dimensions.h(16)),

            // ── Email ─────────────────────────────────────────────
            AppTextField(
              controller: controller.emailController,
              label: AppStrings.emailAddress.tr,
              hint: AppStrings.emailPlaceholder.tr,
              keyboardType: TextInputType.emailAddress,
              readOnly: true,
            ),
            SizedBox(height: Dimensions.h(16)),

            // ── Phone ─────────────────────────────────────────────
            AppTextField(
              controller: controller.phoneController,
              label: AppStrings.phoneNumber.tr,
              hint: AppStrings.enterPhoneNumber.tr,
              keyboardType: TextInputType.phone,
              readOnly: true,
            ),
            SizedBox(height: Dimensions.h(16)),

            // ── Selling Tier ──────────────────────────────────────
            Obx(() => SellingTierSection(tier: controller.sellingTier.value)),
            SizedBox(height: Dimensions.h(32)),

            // ── Update Profile Button ─────────────────────────────
            AppButton(
              label: AppStrings.updateProfile.tr,
              backgroundColor: AppColors.secondaryColor,
              textColor: AppColors.primaryColor,
              borderSideColor: Colors.transparent,
              leadingIcon: Icon(
                Icons.edit_outlined,
                color: AppColors.primaryColor,
                size: Dimensions.rs(20),
              ),
              onPressed: () {
                Get.toNamed(RoutePath.updateProfile);
              },
            ),
          ],
        ),
      ),
    );
  }
}
