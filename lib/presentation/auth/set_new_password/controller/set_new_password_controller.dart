import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/route_path.dart';
import '../../../../service/api_service.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/tost_message/show_snackbar.dart';

class SetNewPasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final ApiClient _apiClient = ApiClient();

  var isLoading = false.obs;

  // Retrieve requestId passed from OTP verification success
  String? get requestId =>
      (Get.arguments is Map) ? Get.arguments['requestId'] : null;

  Future<void> updatePassword() async {
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      AppSnackBar.fail("Fields cannot be empty");
      return;
    }

    if (newPassword.length < 6) {
      AppSnackBar.fail("Password must be at least 6 characters long");
      return;
    }

    if (newPassword != confirmPassword) {
      AppSnackBar.fail("Passwords do not match");
      return;
    }

    if (requestId == null || requestId!.isEmpty) {
      AppSnackBar.fail(
          "Verification session expired. Please request OTP again.");
      return;
    }

    try {
      isLoading.value = true;

      final Map<String, dynamic> body = {
        "requestId": requestId,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };

      final response = await _apiClient.post(
        url: ApiUrl.resetPassword,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.body;
        bool isSuccess = responseData['success'] ?? false;

        if (isSuccess) {
          AppSnackBar.success("Password updated successfully!");

          // Navigate back to Sign In
          Get.offAllNamed(RoutePath.login);
        } else {
          AppSnackBar.fail(
              responseData['message'] ?? "Failed to update password");
        }
      } else {
        final errorMsg = response.body?['message'] ??
            response.statusText ??
            "Failed to update password";
        AppSnackBar.fail(errorMsg);
      }
    } catch (e) {
      AppSnackBar.fail("An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
