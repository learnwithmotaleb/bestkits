import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/responsive_layout/dimensions.dart';
import '../../../core/responsive_layout/responsive_layout.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_icons/app_icons.dart';
import '../../../widget/custom_svg_icon.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);

    _scaleAnim = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut),
    );

    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

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
      child: FadeTransition(
        opacity: _fadeAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: CustomSvgIcon(
            icon: AppIcons.splash,
            size: Dimensions.rs(logoWidth),
            // We don't apply a color filter here to preserve the SVG's original design 
            // unless specified, but for "bestkid" logo it should be as is.
          ),
        ),
      ),
    );
  }
}
