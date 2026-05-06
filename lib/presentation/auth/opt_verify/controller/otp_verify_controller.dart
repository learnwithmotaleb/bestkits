import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        // Get.offAllNamed(RoutePath.home); // Navigate after success
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