import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_alert.dart';

class ChangePasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void saveChanges() {
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

  void _performPasswordChange() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    AppAlerts.success(message: AppStrings.passwordChangedSuccess.tr);
    Get.back();
  }
}