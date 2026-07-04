import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_alert.dart';
import '../../../helper/tost_message/show_snackbar.dart';
import '../../../service/api_service.dart';
import '../../../service/api_url.dart';
import '../../../helper/local_db/local_db.dart';
import '../../bottom_nav/page/profile/model/user_model.dart';
import '../../bottom_nav/page/profile/controller/profile_controller.dart';

class UpdateProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Rx<File?> selectedImage = Rx<File?>(null);
  RxnString existingImageUrl = RxnString(null);
  final ImagePicker _picker = ImagePicker();
  final ApiClient _apiClient = ApiClient();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  void _loadInitialData() {
    final userDataJson = SharePrefsHelper.getUserData();
    if (userDataJson != null && userDataJson.isNotEmpty) {
      try {
        final Map<String, dynamic> data = jsonDecode(userDataJson);
        final user = UserData.fromJson(data);
        nameController.text = user.profile.fullName;
        phoneController.text = user.profile.phone ?? '';
        existingImageUrl.value = user.profile.avatarUrl;
      } catch (e) {
        print("Error loading initial data: $e");
      }
    }
  }

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
        updateProfile();
      },
    );
  }

  Future<void> updateProfile() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty) {
      AppSnackBar.fail("Name cannot be empty");
      return;
    }

    try {
      isLoading.value = true;

      final Map<String, String> fields = {
        "full_name": name,
        "phone": phone,
      };

      final List<MultipartFileData> files = [];
      if (selectedImage.value != null) {
        files.add(
            MultipartFileData(key: 'file', path: selectedImage.value!.path));
      }

      final response = await _apiClient.multipart(
        url: ApiUrl.updateProfile,
        method: "PATCH",
        isToken: true,
        fields: fields,
        files: files,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.body;
        if (responseData['success'] == true) {
          AppSnackBar.success("Profile updated successfully!");

          // Re-fetch user profile to update cached data and UI globally
          if (Get.isRegistered<ProfileController>()) {
            await Get.find<ProfileController>().fetchUserProfile();
          }

          Get.back(); // Go back to the previous screen
        } else {
          AppSnackBar.fail(responseData['message'] ?? "Update failed");
        }
      } else {
        AppSnackBar.fail(response.body?['message'] ??
            response.statusText ??
            "Update failed");
      }
    } catch (e) {
      AppSnackBar.fail("An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
