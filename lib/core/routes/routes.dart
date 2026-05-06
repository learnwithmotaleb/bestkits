

import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/presentation/auth/login/controller/login_controller.dart';
import 'package:bestkits/presentation/auth/login/screen/login_screen.dart';
import 'package:bestkits/presentation/auth/opt_verify/controller/otp_verify_controller.dart';
import 'package:bestkits/presentation/auth/opt_verify/screen/otp_verify_screen.dart';
import 'package:bestkits/presentation/auth/signup/controller/signup_controller.dart';
import 'package:bestkits/presentation/auth/signup/screen/signup_screen.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:bestkits/presentation/onboard/screen/onboard_screen.dart';
import 'package:bestkits/presentation/onboard/controller/onboard_controller.dart';
import 'package:bestkits/presentation/auth/forgot_password/screen/forgot_password_screen.dart';
import 'package:bestkits/presentation/auth/forgot_password/controller/forgot_password_controller.dart';

import '../../presentation/splash/controller/splash_controller.dart';
import '../../presentation/splash/screen/splash_screen.dart';

class AppRouter {
  static final List<GetPage<dynamic>> pages = [

    GetPage(
      name: RoutePath.splash,
      page: () => const SplashScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(
      name: RoutePath.onboard,
      page: () => const OnboardScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(OnboardController());
      }),
    ),

    GetPage(
      name: RoutePath.login,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(LoginController());
      }),
    ),


    GetPage(
      name: RoutePath.signup,
      page: () => const SignupScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(SignupController());
      }),
    ),



    GetPage(
      name: RoutePath.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(ForgotPasswordController());
      }),
    ),

    GetPage(
      name: RoutePath.otpScreen,
      page: () => const OtpVerifyScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(OtpVerifyController());
      }),
    ),







  ];
}
