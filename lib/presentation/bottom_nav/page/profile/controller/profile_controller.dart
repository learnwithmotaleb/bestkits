import 'package:get/get.dart';
import '../../../../../widget/app_alert.dart';

class ProfileController extends GetxController {

  void logout() {
    AppAlerts.warning(
      title: 'Log out !',
      message: 'Are you sure you want to log out?',
      confirmLabel: 'Log Out',
      cancelLabel: 'Cancel',
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