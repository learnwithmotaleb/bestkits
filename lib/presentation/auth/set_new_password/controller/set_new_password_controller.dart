import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/route_path.dart';

class SetNewPasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void updatePassword() {
    // Implement update password logic here
    if (newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      Get.snackbar("Error", "Fields cannot be empty");
      return;
    }
    
    if (newPasswordController.text == confirmPasswordController.text) {
      Get.snackbar("Success", "Password updated successfully");
      
      // Navigate to account block as requested
      Get.offAllNamed(RoutePath.accountBlock);
    } else {
      Get.snackbar("Error", "Passwords do not match");
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}