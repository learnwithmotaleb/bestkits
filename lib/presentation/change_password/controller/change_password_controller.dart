import 'package:bestkits/core/routes/route_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_alert.dart';
import '../../../helper/tost_message/show_snackbar.dart';
import '../../../service/api_service.dart';
import '../../../service/api_url.dart';

class ChangePasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ApiClient _apiClient = ApiClient();
  final isLoading = false.obs;

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void saveChanges() {
    final currentPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty) {
      AppSnackBar.fail("Please enter your current password");
      return;
    }
    if (newPassword.isEmpty) {
      AppSnackBar.fail("Please enter a new password");
      return;
    }
    if (newPassword.length < 6) {
      AppSnackBar.fail("New password must be at least 6 characters");
      return;
    }
    if (newPassword != confirmPassword) {
      AppSnackBar.fail("New password and confirm password do not match");
      return;
    }

    AppAlerts.warning(
      title: AppStrings.changePasswordAlertTitle.tr,
      message: AppStrings.changePasswordAlertSubtitle.tr,
      confirmLabel: AppStrings.confirm.tr,
      cancelLabel: AppStrings.cancel.tr,
      onConfirm: () {
        _performPasswordChange();
      },
    );
  }

  Future<void> _performPasswordChange() async {
    try {
      isLoading.value = true;

      final response = await _apiClient.patch(
        url: ApiUrl.changePassword,
        isToken: true,
        body: {
          "currentPassword": oldPasswordController.text.trim(),
          "newpassword": newPasswordController.text.trim(),
          "confirmPassword": confirmPasswordController.text.trim(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.body;
        if (responseData['success'] == true) {
          AppSnackBar.success("Password changed successfully!");
          Get.offAndToNamed(RoutePath.bottomNav);
        } else {
          AppSnackBar.fail(responseData['message'] ?? "Failed to change password");
        }
      } else {
        AppSnackBar.fail(
          response.body?['message'] ?? response.statusText ?? "Failed to change password",
        );
      }
    } catch (e) {
      AppSnackBar.fail("An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

