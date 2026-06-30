import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/route_path.dart';
import '../../../../service/api_service.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/tost_message/show_snackbar.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final ApiClient _apiClient = ApiClient();

  var isLoading = false.obs;

  Future<void> sendVerificationCode() async {
    final email = emailController.text.trim();
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      AppSnackBar.fail("Please enter a valid email address");
      return;
    }

    try {
      isLoading.value = true;
      final response = await _apiClient.post(
        url: ApiUrl.forgotPassword,
        body: {"email": email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.body;
        bool isSuccess = responseData['success'] ?? false;

        if (isSuccess) {
          AppSnackBar.success("Verification code sent successfully!");

          // Debug: print full response to identify correct key
          print("Forgot Password Response Data: ${responseData['data']}");

          // Try multiple possible keys from the API response
          final data = responseData['data'];
          final emailVerificationId = data?['email_verification_id']
              ?? data?['requestId']
              ?? data?['request_id']
              ?? data?['id'];

          print("Extracted email_verification_id: $emailVerificationId");

          // Navigate to OTP Screen and pass arguments
          Get.toNamed(
            RoutePath.otpScreen,
            arguments: {
              "source": "forgot_password",
              "email": email,
              "email_verification_id": emailVerificationId,
            },
          );
        } else {
          AppSnackBar.fail(responseData['message'] ?? "Failed to send code");
        }
      } else {
        final errorMsg = response.body?['message'] ??
            response.statusText ??
            "Failed to send code";
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
    emailController.dispose();
    super.onClose();
  }
}
