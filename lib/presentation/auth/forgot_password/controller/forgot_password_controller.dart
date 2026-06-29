import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/route_path.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  void sendVerificationCode() {
    // Logic to send code
    Get.toNamed(RoutePath.otpScreen, arguments: "forgot_password"); // Assuming this route exists
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
