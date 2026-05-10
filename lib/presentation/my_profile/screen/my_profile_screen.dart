import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/responsive_layout/dimensions.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../widget/app_button.dart';
import '../../../widget/app_text_field.dart';
import '../controller/my_profile_controller.dart';

class MyProfileScreen extends GetView<MyProfileController> {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure the controller is initialized
    Get.put(MyProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Light background matching design
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.navBarColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.blackColor, size: 20),
              onPressed: () => Get.back(),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        title: Text(
          "My Profile",
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: AppColors.darkGreyColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: Dimensions.pSym(h: 20, v: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Dimensions.h(20)),
            // Avatar Container
            Container(
              width: Dimensions.rs(100),
              height: Dimensions.rs(100),
              decoration: BoxDecoration(
                color: AppColors.navBarColor,
                borderRadius: BorderRadius.circular(Dimensions.r(24)),
                border: Border.all(
                  color: AppColors.greyColor.withOpacity(0.5)
                )
              ),
              alignment: Alignment.center,
              child: Text(
                "R",
                style: AppTextStyles.h1.copyWith(
                  fontSize: Dimensions.fs(40),
                  fontStyle: FontStyle.italic,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: Dimensions.h(40)),
            
            // Text Fields
            AppTextField(
              controller: controller.nameController,
              label: "Name",
              hint: "Enter your name",
              readOnly: true,
            ),
            SizedBox(height: Dimensions.h(16)),
            
            AppTextField(
              controller: controller.emailController,
              label: "Email",
              hint: "Enter your email",
              keyboardType: TextInputType.emailAddress,
              readOnly: true,
            ),
            SizedBox(height: Dimensions.h(16)),
            
            AppTextField(
              controller: controller.phoneController,
              label: "Contact Phone",
              hint: "Enter your phone number",
              keyboardType: TextInputType.phone,
              readOnly: true,
            ),
            
            SizedBox(height: Dimensions.h(32)),
            
            // Update Profile Button
            AppButton(
              label: "Update Profile",
              backgroundColor: AppColors.secondaryColor, // Black background
              textColor: AppColors.primaryColor, // Yellow text
              borderSideColor: Colors.transparent,
              leadingIcon: Icon(Icons.edit_outlined, color: AppColors.primaryColor, size: Dimensions.rs(20)),
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
