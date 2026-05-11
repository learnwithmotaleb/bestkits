import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:get/get.dart';
import '../../../../../widget/app_alert.dart';

class ProfileController extends GetxController {

  void logout() {
    AppAlerts.warning(
      title: AppStrings.logoutTitle.tr,
      message: AppStrings.logoutConfirmSubtitle.tr,
      confirmLabel: AppStrings.logoutButton.tr,
      cancelLabel: AppStrings.cancel.tr,
      onConfirm: () {
        // Implement actual logout logic here
        _performLogout();
      },
    );
  }

  void _performLogout() async {
    // Navigate to login or clear session
    Get.offAllNamed('/LoginScreen'); // Or appropriate route
  }


}