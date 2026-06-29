import 'package:bestkits/core/routes/route_path.dart';
import 'package:get/get.dart';

class AccountBlockController extends GetxController {
  void goBackLogin() {
    // Navigate back to login screen
    Get.offAllNamed(RoutePath.login); // Assuming you have routes
    // Get.back();
  }
}