import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/route_path.dart';

class OtpVerifyController extends GetxController {
  final otpController = TextEditingController();
  var isLoading = false.obs;

  void emailVerifyProcess() {
    if (otpController.text.length == 6) {
      isLoading.value = true;
      // TODO: Implement actual verification logic
      print("Verifying OTP: ${otpController.text}");

      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;

        // Retrieve navigation source from arguments
        final String? flowType = Get.arguments;

        if (flowType == "forgot_password") {
          // If coming from forgot password, go to set new password
          Get.toNamed(RoutePath.setNewPassword);
        } else if (flowType == "signup") {
          // If coming from signup, go to onboard
          Get.offAllNamed(RoutePath.onboard);
        } else {
          // Default fallback
          Get.offAllNamed(RoutePath.onboard);
        }
      });
    } else {
      Get.snackbar("Error", "Please enter a 6-digit code");
    }
  }

  void resendOtpProcess() {
    print("Resending OTP...");
    // TODO: Implement resend logic
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
