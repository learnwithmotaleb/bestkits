import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_icons/app_icons.dart';
import '../../../widget/custom_svg_icon.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>(); // ensure controller is alive
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: CustomSvgIcon(
          icon: AppIcons.splash,
          size: Dimensions.w(150),
        ),
      ),
    );
  }
}
