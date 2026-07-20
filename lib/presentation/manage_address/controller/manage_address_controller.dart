import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_alert.dart';
import '../../../helper/tost_message/show_snackbar.dart';
import '../../../service/api_service.dart';
import '../../../service/api_url.dart';
import '../../my_address/model/MyAddressModel.dart';

class ManageAddressController extends GetxController {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final isLoading = false.obs;
  final ApiClient _apiClient = ApiClient();

  bool isUpdate = false;
  Data? addressData;

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments["address"] != null) {
      isUpdate = true;
      addressData = Get.arguments["address"];
      nameController.text = addressData?.addressName ?? '';
      addressController.text = addressData?.address ?? '';
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
      title: isUpdate
          ? AppStrings.updateAddressAlertTitle.tr
          : AppStrings.saveAddressAlertTitle.tr,
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

    Map<String, dynamic> body = {
      "address_name": nameController.text.trim(),
      "address": addressController.text.trim(),
      "city": addressData?.city ?? "Plovdiv", // Default or keep existing
      "postal_code": addressData?.postalCode ?? "4000",
      "country": addressData?.country ?? "Bulgaria",
      "is_default": addressData?.isDefault ?? false,
    };

    ApiResult response;

    if (isUpdate && addressData != null) {
      response = await _apiClient.patch(
        url: ApiUrl.updateAccountAddress(addressData!.id.toString()),
        body: body,
        isToken: true,
      );
    } else {
      response = await _apiClient.post(
        url: ApiUrl.createAccountAddress,
        body: body,
        isToken: true,
      );
    }

    isLoading.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.back(result: true);
      AppSnackBar.success(
          isUpdate
              ? AppStrings.addressUpdatedSuccess.tr
              : AppStrings.addressSavedSuccess.tr);
    } else {
      AppSnackBar.fail("Request failed");
    }
  }
}
