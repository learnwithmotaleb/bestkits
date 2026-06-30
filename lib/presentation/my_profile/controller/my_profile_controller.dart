import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/local_db/local_db.dart';
import '../../bottom_nav/page/profile/model/user_model.dart';

class MyProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Selling tier — could be driven by API; hardcoded for now
  final RxString sellingTier = 'Basic Seller'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    final userDataJson = SharePrefsHelper.getUserData();
    if (userDataJson != null && userDataJson.isNotEmpty) {
      try {
        final Map<String, dynamic> data = jsonDecode(userDataJson);
        final user = UserData.fromJson(data);

        nameController.text = user.profile.fullName;
        emailController.text = user.email;
        phoneController.text = user.profile.phone ?? '';

        sellingTier.value =
            user.role == 'USER' ? 'Basic Seller' : 'Premium Seller';
      } catch (e) {
        print("Error parsing cached user data: $e");
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
