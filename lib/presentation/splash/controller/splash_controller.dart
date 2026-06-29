import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/utils/app_const/app_const.dart';
import 'package:get/get.dart';
class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() {
    Future.delayed(
      Duration(seconds: AppConstants.splashDelaySeconds),
      () {
        FlutterNativeSplash.remove();
        Get.offAllNamed(RoutePath.login);
      },
    );
  }
}