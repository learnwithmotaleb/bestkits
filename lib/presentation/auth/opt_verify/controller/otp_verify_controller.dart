import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../service/api_service.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/tost_message/show_snackbar.dart';
import '../../../../core/routes/route_path.dart';

class OtpVerifyController extends GetxController {
  final otpController = TextEditingController();
  final ApiClient _apiClient = ApiClient();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Debug: log received arguments
    print("OtpVerifyController onInit - Arguments: ${Get.arguments}");
    print("OtpVerifyController onInit - flowType: $flowType");
    print("OtpVerifyController onInit - email: $email");
    print("OtpVerifyController onInit - requestId: $requestId");
  }

  // Retrieve verification info passed from previous screens
  String? get flowType => (Get.arguments is Map)
      ? Get.arguments['source']
      : (Get.arguments is String ? Get.arguments : null);
  String? get email => (Get.arguments is Map) ? Get.arguments['email'] : null;
  String? get requestId {
    if (Get.arguments is! Map) return null;
    final args = Get.arguments as Map;
    return args['email_verification_id'] ??
        args['requestId'] ??
        args['request_id'];
  }

  Future<void> emailVerifyProcess() async {
    final otpText = otpController.text.trim();
    if (otpText.length != 6) {
      AppSnackBar.fail("Please enter a 6-digit code");
      return;
    }

    if (requestId == null || requestId!.isEmpty) {
      AppSnackBar.fail("Verification session missing. Please try again.");
      return;
    }

    try {
      isLoading.value = true;

      // 1. Prepare Request Payload
      final Map<String, dynamic> body = {
        "requestId": requestId ?? "",
        "otp": otpText,
      };

      // 2. Call API (Determine endpoint based on flow)
      final url = (flowType == "forgot_password")
          ? ApiUrl.verifyResetOtp
          : ApiUrl.verifyEmail;

      final response = await _apiClient.post(
        url: url,
        body: body,
      );

      // 3. Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.body;
        bool isSuccess = responseData['success'] ?? false;

        if (isSuccess) {
          AppSnackBar.success(
              responseData['message'] ?? "Email verification successful!");

          otpController.clear();

          if (flowType == "forgot_password") {
            // Check verifyResetOtp response structure to extract email_verification_id
            final nextRequestId = (responseData['data'] is Map)
                ? (responseData['data']['email_verification_id'] ??
                    responseData['data']['requestId'] ??
                    requestId)
                : (responseData['email_verification_id'] ??
                    responseData['requestId'] ??
                    requestId);

            print(
                "OTP Verification Successful. Passing requestId to SetNewPassword: $nextRequestId");

            Get.toNamed(
              RoutePath.setNewPassword,
              arguments: {
                "requestId": nextRequestId,
              },
            );
          } else {
            Get.offAllNamed(RoutePath.stripeConnect);
          }
        } else {
          final errorMsg = responseData['message'] ?? "Verification failed";
          AppSnackBar.fail(errorMsg);
        }
      } else {
        final errorMsg = response.body?['message'] ??
            response.statusText ??
            "Verification failed";
        AppSnackBar.fail(errorMsg);
      }
    } catch (e) {
      AppSnackBar.fail("An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void resendOtpProcess() async {
    if (email == null || email!.isEmpty) {
      AppSnackBar.fail("Email address is missing");
      return;
    }

    try {
      // Endpoint to resend activation OTP code
      final response = await _apiClient.post(
        url: ApiUrl.resendOtp,
        body: {"email": email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.body;
        bool isSuccess = responseData['success'] ?? false;
        if (isSuccess) {
          AppSnackBar.success("OTP has been resent successfully!");

          // If the verification id changed, we need to update it
          final newRequestId = responseData['data']?['email_verification_id'];
          if (newRequestId != null && Get.arguments is Map) {
            Get.arguments['email_verification_id'] = newRequestId;
          }
        } else {
          AppSnackBar.fail(responseData['message'] ?? "Resending code failed");
        }
      } else {
        final errorMsg = response.body?['message'] ??
            response.statusText ??
            "Resending code failed";
        AppSnackBar.fail(errorMsg);
      }
    } catch (e) {
      AppSnackBar.fail("Failed to resend OTP: $e");
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
