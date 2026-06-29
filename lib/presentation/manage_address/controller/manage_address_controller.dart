import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_alert.dart';

class ManageAddressController extends GetxController {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final isLoading = false.obs;

  bool isUpdate = false;

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments["address"] != null) {
      isUpdate = true;
      nameController.text = Get.arguments["address"]["name"];
      addressController.text = Get.arguments["address"]["address"];
    }
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    super.onClose();
  }

  void saveChanges() {
    AppAlerts.warning(
      title: isUpdate ? AppStrings.updateAddressAlertTitle.tr : AppStrings.saveAddressAlertTitle.tr,
      message: isUpdate 
          ? AppStrings.updateAddressAlertSubtitle.tr 
          : AppStrings.saveAddressAlertSubtitle.tr,
      confirmLabel: AppStrings.confirm.tr,
      cancelLabel: AppStrings.cancel.tr,
      onConfirm: () {
        _performSave();
      },
    );
  }

  void _performSave() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    AppAlerts.success(message: isUpdate ? AppStrings.addressUpdatedSuccess.tr : AppStrings.addressSavedSuccess.tr);
    Get.back();
  }
}