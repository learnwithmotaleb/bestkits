import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../service/api_service.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/tost_message/show_snackbar.dart';
import '../../../../core/routes/route_path.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ApiClient _apiClient = ApiClient();

  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var agreeToTerms = false.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();
  void toggleAgreeToTerms(bool? value) => agreeToTerms.value = value ?? false;

  Future<void> signUp() async {
    // 1. Validation checks
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty) {
      AppSnackBar.fail("Please enter your full name");
      return;
    }
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      AppSnackBar.fail("Please enter a valid email address");
      return;
    }
    if (phone.isEmpty) {
      AppSnackBar.fail("Please enter your phone number");
      return;
    }
    if (password.isEmpty || password.length < 6) {
      AppSnackBar.fail("Password must be at least 6 characters long");
      return;
    }
    if (password != confirmPassword) {
      AppSnackBar.fail("Passwords do not match");
      return;
    }
    if (!agreeToTerms.value) {
      AppSnackBar.fail("You must agree to the Terms of Service & Privacy Policy");
      return;
    }

    try {
      isLoading.value = true;

      // 2. Prepare payload
      final Map<String, dynamic> body = {
        "fullName": name,
        "email": email,
        "phone": phone,
        "password": password,
        "confirmPassword": confirmPassword,
      };

      // 3. Make the API Call
      final response = await _apiClient.post(
        url: ApiUrl.register,
        body: body,
      );

      // 4. Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        bool isSuccess = data['success'] ?? false;
        
        if (isSuccess) {
          final emailVerificationId = data['data']?['email_verification_id'];
          AppSnackBar.success("Registration successful! Please verify your email.");

          // Navigate to OTP screen and pass verification id and email
          Get.toNamed(
            RoutePath.otpScreen,
            arguments: {
              "source": "signup",
              "email": email,
              "email_verification_id": emailVerificationId,
            },
          );
        } else {
          final errorMsg = data['message'] ?? "Registration failed";
          AppSnackBar.fail(errorMsg);
        }
      } else {
        final errorMsg = response.body?['message'] ?? response.statusText ?? "Registration failed";
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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}