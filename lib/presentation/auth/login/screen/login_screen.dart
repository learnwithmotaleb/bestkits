import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/core/responsive_layout/dimensions.dart';
import 'package:bestkits/utils/app_colors/app_colors.dart';
import 'package:bestkits/utils/app_text_style/app_text_style.dart';
import 'package:bestkits/widget/app_button.dart';
import 'package:bestkits/widget/app_text_field.dart';
import '../controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Dimensions.pSym(h: 24, v: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.h(60)),
              
              // Title
              Text(
                "Welcome Back",
                style: AppTextStyles.title.copyWith(
                  fontSize: Dimensions.fs(32, tablet: 36, desktop: 40),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: Dimensions.h(8)),
              
              // Subtitle
              Text(
                "Log in to continue using BestKid.",
                style: AppTextStyles.body.copyWith(
                  color: AppColors.greyColor,
                ),
              ),
              
              SizedBox(height: Dimensions.h(40)),
              
              // Email Field
              AppTextField(
                controller: controller.emailController,
                label: "Email Address",
                hint: "Enter your email address",
                keyboardType: TextInputType.emailAddress,
              ),
              
              SizedBox(height: Dimensions.h(24)),
              
              // Password Field
              AppTextField(
                controller: controller.passwordController,
                label: "Password",
                hint: "••••••••",
                obscure: true,
              ),
              
              SizedBox(height: Dimensions.h(16)),
              
              // Remember Me & Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Obx(() => SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: controller.toggleRememberMe,
                          activeColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      )),
                      SizedBox(width: Dimensions.w(8)),
                      Text(
                        "Remember me",
                        style: AppTextStyles.body.copyWith(
                          fontSize: Dimensions.fs(14),
                          color: AppColors.darkGreyColor,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Navigate to forgot password
                    },
                    child: Text(
                      "Forgot password?",
                      style: AppTextStyles.body.copyWith(
                        fontSize: Dimensions.fs(14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: Dimensions.h(32)),
              
              // Login Button
              AppButton(
                label: "Log In",
                onPressed: controller.login,
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
                    Get.toNamed(RoutePath.signup);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "No account yet? ",
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.greyColor,
                      ),
                      children: [
                        TextSpan(
                          text: "Create an account !",
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
            ],
          ),
        ),
      ),
    );
  }
}
