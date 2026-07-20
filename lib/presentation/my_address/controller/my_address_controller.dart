import 'dart:convert';
import 'package:get/get.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_alert.dart';
import '../../../service/api_service.dart';
import '../../../service/api_url.dart';
import '../model/MyAddressModel.dart';

class MyAddressController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final RxBool isLoading = false.obs;
  final RxList<Data> addresses = <Data>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAddresses();
  }

  Future<void> getAddresses() async {
    isLoading.value = true;
    final response = await _apiClient.get(
      url: ApiUrl.getAccountAddress,
      isToken: true,
    );
    isLoading.value = false;

    if (response.statusCode == 200) {
      final model = MyAddressModel.fromJson(response.body);
      if (model.success == true && model.data != null) {
        addresses.value = model.data!;
      }
    } else {
      AppAlerts.error(message: "Failed to load addresses");
    }
  }

  void goToAddAddress() {
    Get.toNamed(RoutePath.manageAddress)?.then((value) {
      if (value == true) {
        getAddresses();
      }
    });
  }

  void goToEditAddress(Data address) {
    Get.toNamed(RoutePath.manageAddress, arguments: {"address": address})?.then((value) {
      if (value == true) {
        getAddresses();
      }
    });
  }

  void deleteAddress(int index) {
    final address = addresses[index];
    AppAlerts.warning(
      title: AppStrings.deleteAddressAlertTitle.tr,
      message: AppStrings.deleteAddressAlertSubtitle.tr,
      confirmLabel: AppStrings.confirm.tr,
      cancelLabel: AppStrings.cancel.tr,
      onConfirm: () async {
        if (address.id != null) {
          isLoading.value = true;
          final response = await _apiClient.delete(
            url: ApiUrl.deleteAccountAddress(address.id.toString()),
            isToken: true,
          );
          isLoading.value = false;

          if (response.statusCode == 200) {
            addresses.removeAt(index);
            AppAlerts.success(message: AppStrings.addressDeletedSuccess.tr);
          } else {
             AppAlerts.error(message: "Failed to delete address");
          }
        }
      },
    );
  }
}
