import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import '../../../../core/routes/route_path.dart';
import '../../../../service/api_service.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/tost_message/show_snackbar.dart';
import '../../../../helper/local_db/local_db.dart';
import '../../../../core/enums/app_role.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiClient _apiClient = ApiClient();

  var isPasswordVisible = false.obs;
  var rememberMe = false.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      AppSnackBar.fail("Please enter a valid email address");
      return;
    }

    if (password.isEmpty) {
      AppSnackBar.fail("Please enter your password");
      return;
    }

    try {
      isLoading.value = true;

      final Map<String, dynamic> body = {
        "email": email,
        "password": password,
      };

      final response = await _apiClient.post(
        url: ApiUrl.login,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.body;
        bool isSuccess = responseData['success'] ?? false;

        if (isSuccess) {
          final tokenString = responseData['data'] as String?;

          if (tokenString != null && tokenString.isNotEmpty) {
            try {
              // Decode JWT payload
              final parts = tokenString.split('.');
              if (parts.length == 3) {
                final payload = parts[1];
                // Pad base64 string if needed
                final normalized = base64Url.normalize(payload);
                final resp = utf8.decode(base64Url.decode(normalized));
                final user = json.decode(resp);

                final userId = user['id']?.toString() ?? "";
                final roleString = user['role']?.toString() ?? "USER";

                // Save Session Details
                await SharePrefsHelper.saveToken(tokenString);

                if (userId.isNotEmpty) {
                  await SharePrefsHelper.saveUserId(userId);
                }

                // Parse Role and Save
                AppRole userRole = AppRole.CUSTOMER;
                if (roleString == "DRIVER") {
                  userRole = AppRole.DRIVER;
                } else if (roleString == "USER") {
                  userRole = AppRole.CUSTOMER;
                }
                await SharePrefsHelper.saveRole(userRole);
              }
            } catch (e) {
              print("JWT Parsing Error: $e");
            }
          }

          AppSnackBar.success("Logged in successfully!");

          // Navigate to home screen
          Get.offAllNamed(RoutePath.bottomNav);
        } else {
          AppSnackBar.fail(responseData['message'] ?? "Login failed");
        }
      } else {
        final errorMsg =
            response.body?['message'] ?? response.statusText ?? "Login failed";
        AppSnackBar.fail(errorMsg);
      }
    } catch (e) {
      AppSnackBar.fail("An error occurred during login: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
