import 'package:get/get.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_alert.dart';

class MyAddressController extends GetxController {
  final addresses = [
    {
      "name": "Home",
      "address": "25 \"Ivan Vazov\" Street, Plovdiv 4000, Bulgaria",
    },
    {
      "name": "Home",
      "address": "25 \"Ivan Vazov\" Street, Plovdiv 4000, Bulgaria",
    },
    {
      "name": "Home",
      "address": "25 \"Ivan Vazov\" Street, Plovdiv 4000, Bulgaria",
    }
  ].obs;

  void goToAddAddress() {
    Get.toNamed(RoutePath.manageAddress);
  }

  void goToEditAddress(Map<String, dynamic> address) {
    Get.toNamed(RoutePath.manageAddress, arguments: {"address": address});
  }

  void deleteAddress(int index) {
    AppAlerts.warning(
      title: AppStrings.deleteAddressAlertTitle.tr,
      message: AppStrings.deleteAddressAlertSubtitle.tr,
      confirmLabel: AppStrings.confirm.tr,
      cancelLabel: AppStrings.cancel.tr,
      onConfirm: () {
        addresses.removeAt(index);
        AppAlerts.success(message: AppStrings.addressDeletedSuccess.tr);
      },
    );
  }
}