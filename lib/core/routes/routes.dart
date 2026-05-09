

import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/presentation/auth/account_block/controller/account_block_controller.dart';
import 'package:bestkits/presentation/auth/account_block/screen/account_block_screen.dart';
import 'package:bestkits/presentation/auth/login/controller/login_controller.dart';
import 'package:bestkits/presentation/auth/login/screen/login_screen.dart';
import 'package:bestkits/presentation/auth/opt_verify/controller/otp_verify_controller.dart';
import 'package:bestkits/presentation/auth/opt_verify/screen/otp_verify_screen.dart';
import 'package:bestkits/presentation/auth/set_new_password/controller/set_new_password_controller.dart';
import 'package:bestkits/presentation/auth/set_new_password/screen/set_new_password_screen.dart';
import 'package:bestkits/presentation/auth/signup/controller/signup_controller.dart';
import 'package:bestkits/presentation/auth/signup/screen/signup_screen.dart';
import 'package:bestkits/presentation/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:bestkits/presentation/bottom_nav/page/home/pages/categories/controller/categories_controller.dart';
import 'package:bestkits/presentation/bottom_nav/page/home/pages/categories/screen/categories_screen.dart';
import 'package:bestkits/presentation/bottom_nav/screen/bottom_nav_screen.dart';
import 'package:bestkits/presentation/message/controller/message_controller.dart';
import 'package:bestkits/presentation/message/page/chat/chat_controller/chat_controller.dart';
import 'package:bestkits/presentation/message/page/chat/chat_screen/chat_screen.dart';
import 'package:bestkits/presentation/message/screen/message_screen.dart';
import 'package:bestkits/presentation/my_return/controller/my_return_controller.dart';
import 'package:bestkits/presentation/my_return/screen/my_return_screen.dart';
import 'package:bestkits/presentation/product_details/controller/product_details_controller.dart';
import 'package:bestkits/presentation/product_details/screen/product_details_screen.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
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

    GetPage(
      name: RoutePath.setNewPassword,
      page: () => const SetNewPasswordScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(SetNewPasswordController());
      }),
    ),

    GetPage(
      name: RoutePath.accountBlock,
      page: () => const AccountBlockScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(AccountBlockController());
      }),
    ),


    GetPage(
      name: RoutePath.bottomNav,
      page: () => const BottomNavScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(BottomNavController());
      }),
    ),




    GetPage(
      name: RoutePath.categoriesScreen,
      page: () => const CategoriesScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(CategoriesController());
      }),
    ),



    GetPage(
      name: RoutePath.productDetail,
      page: () => const ProductDetailsScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(ProductDetailsController());
      }),
    ),



    GetPage(
      name: RoutePath.myReturn,
      page: () => const MyReturnScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(MyReturnController());
      }),
    ),





    GetPage(
      name: RoutePath.message,
      page: () => const MessageScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(MessageController());
      }),
    ),



    GetPage(
      name: RoutePath.chat,
      page: () => ChatScreen(chatSummary: Get.arguments), // Grab the summary from Get.arguments
      transition: Transition.rightToLeft,
      // You don't actually need the binding here because ChatScreen already initializes
      // the ChatController dynamically with a unique tag in its initState!
    ),






  ];
}
