import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/core/responsive_layout/dimensions.dart';
import 'package:bestkits/utils/app_colors/app_colors.dart';
import 'package:bestkits/utils/app_text_style/app_text_style.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:bestkits/widget/app_button.dart';
import '../controller/otp_verify_controller.dart';
import '../widget/timer_widget.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    
    // Update main controller
    final controller = Get.find<OtpVerifyController>();
    String code = _controllers.map((c) => c.text).join();
    controller.otpController.text = code;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OtpVerifyController>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Dimensions.pSym(h: 24, v: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.h(60)),
              
              Text(
                AppStrings.verifyYourOtp.tr,
                style: AppTextStyles.title.copyWith(
                  fontSize: Dimensions.fs(32, tablet: 36, desktop: 40),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: Dimensions.h(8)),
              
              Text(
                AppStrings.otpSubtitle.tr,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.greyColor,
                ),
              ),
              
              SizedBox(height: Dimensions.h(40)),
              
              Text(
                AppStrings.verificationCode.tr,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor.withOpacity(0.8),
                  fontSize: Dimensions.fs(14),
                ),
              ),
              SizedBox(height: Dimensions.h(12)),
              
              // Custom OTP Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _buildOtpBox(index)),
              ),
              
              SizedBox(height: Dimensions.h(16)),
              
              TimerWidget(
                onResendCode: controller.resendOtpProcess,
              ),
              
              SizedBox(height: Dimensions.h(32)),
              
              Obx(() => AppButton(
                label: AppStrings.verifyCode.tr,
                onPressed: controller.emailVerifyProcess,
                isLoading: controller.isLoading.value,
                backgroundColor: AppColors.secondaryColor,
                textColor: AppColors.primaryColor,
                borderSideColor: AppColors.secondaryColor,
                borderRadius: Dimensions.r(12),
                height: Dimensions.h(56),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: Dimensions.w(46),
      height: Dimensions.h(56),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        onChanged: (v) => _onChanged(v, index),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppTextStyles.body.copyWith(
          fontSize: Dimensions.fs(18),
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: AppColors.whiteColor,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.r(12)),
            borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.r(12)),
            borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.r(12)),
            borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
          ),
        ),
      ),
    );
  }
}
