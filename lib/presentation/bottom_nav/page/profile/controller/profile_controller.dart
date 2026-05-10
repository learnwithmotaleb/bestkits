import 'package:get/get.dart';
import '../../../../../widget/app_alert.dart';

class ProfileController extends GetxController {

  void logout() {
    AppAlerts.warning(
      title: 'Log Out !',
      message: 'Are you sure you want to log out of your account?',
      confirmLabel: 'Log Out',
      onConfirm: () {
        // Implement actual logout logic here
      },
    );
  }

}