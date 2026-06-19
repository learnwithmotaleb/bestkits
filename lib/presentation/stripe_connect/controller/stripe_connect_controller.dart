import 'package:get/get.dart';
import 'package:bestkits/core/routes/route_path.dart';

enum StripeConnectionState { initial, connected, failed }

class StripeConnectController extends GetxController {
  var connectionState = StripeConnectionState.initial.obs;

  void connectStripeAccount() {
    // Simulate connection process
    connectionState.value = StripeConnectionState.connected;
    // connectionState.value = StripeConnectionState.failed; // To test failure
  }

  void saveAndContinue() {
    if (connectionState.value == StripeConnectionState.connected) {
      Get.offAllNamed(RoutePath.onboard); // Navigate to main app
    }
  }

  void skipForNow() {
    Get.offAllNamed(RoutePath.onboard); // Navigate to main app
  }
}
