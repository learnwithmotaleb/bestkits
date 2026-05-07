import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/core/responsive_layout/dimensions.dart';
import 'package:bestkits/utils/app_colors/app_colors.dart';
import 'package:bestkits/utils/app_text_style/app_text_style.dart';
import 'package:bestkits/widget/app_button.dart';
import 'package:bestkits/widget/app_text_field.dart';
import 'package:bestkits/core/routes/route_path.dart';
import '../controller/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Dimensions.pSym(h: 24, v: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.h(40)),
              
              // Title
              Text(
                "Create Your Account",
                style: AppTextStyles.title.copyWith(
                  fontSize: Dimensions.fs(32, tablet: 36, desktop: 40),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: Dimensions.h(8)),
              
              // Subtitle
              Text(
                "Sign up to start using BestKid.",
                style: AppTextStyles.body.copyWith(
                  color: AppColors.greyColor,
                ),
              ),
              
              SizedBox(height: Dimensions.h(32)),
              
              // Full Name
              AppTextField(
                controller: controller.nameController,
                label: "Full Name",
                hint: "Enter your full name",
                keyboardType: TextInputType.name,
              ),
              
              SizedBox(height: Dimensions.h(20)),
              
              // Email Address
              AppTextField(
                controller: controller.emailController,
                label: "Email Address",
                hint: "Enter your email address",
                keyboardType: TextInputType.emailAddress,
              ),
              
              SizedBox(height: Dimensions.h(20)),
              
              // Phone Number
              AppTextField(
                controller: controller.phoneController,
                label: "Phone Number",
                hint: "Enter your phone number",
                keyboardType: TextInputType.phone,
              ),
              
              SizedBox(height: Dimensions.h(20)),
              
              // Password
              AppTextField(
                controller: controller.passwordController,
                label: "Password",
                hint: "••••••••",
                obscure: true,
              ),
              
              SizedBox(height: Dimensions.h(20)),
              
              // Confirm Password
              AppTextField(
                controller: controller.confirmPasswordController,
                label: "Confirm Password",
                hint: "••••••••",
                obscure: true,
              ),
              
              SizedBox(height: Dimensions.h(16)),
              
              // Terms & Conditions
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() => SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: controller.agreeToTerms.value,
                      onChanged: controller.toggleAgreeToTerms,
                      activeColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  )),
                  SizedBox(width: Dimensions.w(8)),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "I agree to the ",
                        style: AppTextStyles.body.copyWith(
                          fontSize: Dimensions.fs(13),
                          color: AppColors.greyColor,
                        ),
                        children: [
                          TextSpan(
                            text: "Terms of Service",
                            style: AppTextStyles.body.copyWith(
                              fontSize: Dimensions.fs(13),
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: AppTextStyles.body.copyWith(
                              fontSize: Dimensions.fs(13),
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: Dimensions.h(32)),
              
              // Sign Up Button (Labelled "Log In" as per Figma)
              AppButton(
                label: "Log In",
                onPressed: () {
                  Get.toNamed(RoutePath.otpScreen, arguments: "signup");
                },
                backgroundColor: AppColors.secondaryColor,
                textColor: AppColors.primaryColor,
                borderSideColor: AppColors.secondaryColor,
                borderRadius: Dimensions.r(12),
                height: Dimensions.h(56),
              ),
              
              SizedBox(height: Dimensions.h(24)),
              
              // Footer
              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.greyColor,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign In !",
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.h(20)),
            ],
          ),
        ),
      ),
    );
  }
}
