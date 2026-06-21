import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfileController extends GetxController {
  final TextEditingController nameController =
      TextEditingController(text: 'Roberts Junior');
  final TextEditingController emailController =
      TextEditingController(text: 'robert@canaletto.com');
  final TextEditingController phoneController =
      TextEditingController(text: '+1 (212) 555-0148');

  // Selling tier — could be driven by API; hardcoded for now
  final RxString sellingTier = 'Basic Seller'.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}