import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/utils/app_const/app_const.dart';
import 'package:get/get.dart';
import '../../../../helper/local_db/local_db.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() {
    Future.delayed(
      Duration(seconds: AppConstants.splashDelaySeconds),
      () async {
        FlutterNativeSplash.remove();

        final token = SharePrefsHelper.getToken();
        if (token != null && token.isNotEmpty) {
          Get.offAllNamed(RoutePath.bottomNav);
        } else {
          Get.offAllNamed(RoutePath.login);
        }
      },
    );
  }
}
