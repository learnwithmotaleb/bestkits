import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/static_strings/static_strings.dart';
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
      AppAlerts.error(message: "${AppStrings.failedToPickImage.tr}: $e");
    }
  }

  void showConfirmationDialog() {
    AppAlerts.warning(
      title: AppStrings.saveProfileAlertTitle.tr,
      message: AppStrings.saveProfileAlertSubtitle.tr,
      confirmLabel: AppStrings.confirm.tr,
      cancelLabel: AppStrings.cancel.tr,
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