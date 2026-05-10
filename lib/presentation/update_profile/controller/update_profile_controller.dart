import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widget/app_alert.dart';

class UpdateProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController(text: 'Roberts Junior');
  final TextEditingController phoneController = TextEditingController(text: '+1 (212) 555-0148');

  Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      AppAlerts.error(message: "Failed to pick image: $e");
    }
  }

  void showConfirmationDialog() {
    AppAlerts.warning(
      title: "Save Profile Changes !",
      message: "Are you sure you want to update your profile information? Your changes will be applied immediately.",
      confirmLabel: "Confirm",
      cancelLabel: "Cancel",
      onConfirm: () {
        // Handle profile update
      },
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}