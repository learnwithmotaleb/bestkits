import 'package:get/get.dart';

import '../../../widget/app_alert.dart';

class AccountSettingController extends GetxController {
  
  void confirmDeleteAccount() {
    AppAlerts.delete(
      title: "Delete Account",
      message: "Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.",
      onDelete: () {
        // Handle account deletion logic here
        AppAlerts.success(message: "Account deleted successfully");
      },
    );
  }
}