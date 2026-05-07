import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/responsive_layout/dimensions.dart';
import '../../../core/responsive_layout/responsive_layout.dart';
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
      body: ResponsiveLayout(
        mobile: _buildContent(context, logoWidth: 200),
        tablet: _buildContent(context, logoWidth: 300),
        desktop: _buildContent(context, logoWidth: 400),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {required double logoWidth}) {
    return Center(
      child: CustomSvgIcon(
        icon: AppIcons.splash,
        size: Dimensions.rs(logoWidth),
      ),
    );
  }
}
