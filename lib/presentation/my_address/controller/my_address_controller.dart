import 'package:get/get.dart';
import '../../../core/routes/route_path.dart';
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
      title: 'Delete Address !',
      message: 'Are you sure you want to delete this address?',
      confirmLabel: 'Confirm',
      cancelLabel: 'Cancel',
      onConfirm: () {
        addresses.removeAt(index);
        AppAlerts.success(message: 'Address deleted successfully');
      },
    );
  }
}