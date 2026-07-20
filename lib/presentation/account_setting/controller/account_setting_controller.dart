import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive_layout/dimensions.dart';
import '../../../core/routes/route_path.dart';
import '../../../helper/local_db/local_db.dart';
import '../../../helper/tost_message/show_snackbar.dart';
import '../../../service/api_service.dart';
import '../../../service/api_url.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_alert.dart';
import '../../../widget/app_text_field.dart';

class AccountSettingController extends GetxController {
  final passwordController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }

  void confirmDeleteAccount() {
    AppAlerts.warning(
      title: AppStrings.deleteYourAccount.tr,
      message: AppStrings.deleteAccountSubtitle.tr,
      confirmLabel: AppStrings.confirm.tr,
      cancelLabel: AppStrings.cancel.tr,
      onConfirm: () {
        _showPasswordConfirmation();
      },
    );
  }

  void _showPasswordConfirmation() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.r(20)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.w(24),
            vertical: Dimensions.h(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "- ${AppStrings.confirmAccountDeletion.tr}",
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  fontSize: Dimensions.fs(16),
                  color: AppColors.blackColor,
                ),
              ),
              SizedBox(height: Dimensions.h(20)),
              AppTextField(
                controller: passwordController,
                label: AppStrings.oldPassword.tr,
                hint: AppStrings.passwordPlaceholder.tr,
                obscure: true,
                radius: Dimensions.r(8),
              ),
              SizedBox(height: Dimensions.h(16)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: Dimensions.h(2)),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.redColor, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(Icons.priority_high,
                        color: AppColors.redColor, size: 8),
                  ),
                  SizedBox(width: Dimensions.w(8)),
                  Expanded(
                    child: Text(
                      AppStrings.deleteSecurityNote.tr,
                      style: AppTextStyles.body.copyWith(
                        fontSize: Dimensions.fs(10),
                        color: AppColors.greyColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.h(24)),
              Obx(() => Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: isLoading.value ? null : () => Get.back(),
                          child: Container(
                            height: Dimensions.h(44),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.r(8)),
                              border: Border.all(
                                  color: AppColors.greyColor.withOpacity(0.3)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              AppStrings.cancel.tr,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: Dimensions.fs(14),
                                fontWeight: FontWeight.w700,
                                color: AppColors.greyColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Dimensions.w(12)),
                      Expanded(
                        child: GestureDetector(
                          onTap: isLoading.value
                              ? null
                              : () {
                                  _handleFinalDelete();
                                },
                          child: Container(
                            height: Dimensions.h(44),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF15151),
                              borderRadius:
                                  BorderRadius.circular(Dimensions.r(8)),
                            ),
                            alignment: Alignment.center,
                            child: isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    AppStrings.confirmAndDelete.tr,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: Dimensions.fs(13),
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFinalDelete() async {
    final password = passwordController.text.trim();
    if (password.isEmpty) {
      AppSnackBar.fail("Please enter your password");
      return;
    }

    isLoading.value = true;
    final response = await _apiClient.delete(
      url: ApiUrl.deleteAccount,
      body: {"password": password},
      isToken: true,
    );
    isLoading.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.back(); // Close password dialog
      await SharePrefsHelper.clearAll();
      Get.offAllNamed(RoutePath.login);
      AppSnackBar.success(AppStrings.accountDeletedSuccess.tr);
    } else {
      String errorMsg = "Failed to delete account";
      if (response.body is Map && response.body['message'] != null) {
        errorMsg = response.body['message'].toString();
      }
      AppSnackBar.fail(errorMsg);
    }
  }
}
