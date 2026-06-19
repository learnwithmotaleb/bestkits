

import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/presentation/account_setting/screen/account_setting_screen.dart';
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
import 'package:bestkits/presentation/change_password/controller/change_password_controller.dart';
import 'package:bestkits/presentation/change_password/screen/change_password_screen.dart';
import 'package:bestkits/presentation/currency_preference/controller/currency_preference_controller.dart';
import 'package:bestkits/presentation/currency_preference/screen/currency_preference_screen.dart';
import 'package:bestkits/presentation/favorite/controller/favourite_controller.dart';
import 'package:bestkits/presentation/favorite/screen/favourite_screen.dart';
import 'package:bestkits/presentation/bottom_nav/page/cart/screen/cart_screen.dart';
import 'package:bestkits/presentation/help_support/controller/help_support_controller.dart';
import 'package:bestkits/presentation/help_support/screen/help_support_screen.dart';
import 'package:bestkits/presentation/language_preference/controller/language_preference_controller.dart';
import 'package:bestkits/presentation/language_preference/screen/language_preference_screen.dart';
import 'package:bestkits/presentation/legal_company_info/controller/legal_company_controller.dart';
import 'package:bestkits/presentation/legal_company_info/screen/legal_company_screen.dart';
import 'package:bestkits/presentation/manage_address/controller/manage_address_controller.dart';
import 'package:bestkits/presentation/manage_address/screen/manage_address_screen.dart';
import 'package:bestkits/presentation/message/controller/message_controller.dart';
import 'package:bestkits/presentation/message/page/chat/chat_controller/chat_controller.dart';
import 'package:bestkits/presentation/message/page/chat/chat_screen/chat_screen.dart';
import 'package:bestkits/presentation/message/screen/message_screen.dart';
import 'package:bestkits/presentation/my_address/controller/my_address_controller.dart';
import 'package:bestkits/presentation/my_address/screen/my_address_screen.dart';
import 'package:bestkits/presentation/my_profile/controller/my_profile_controller.dart';
import 'package:bestkits/presentation/my_profile/screen/my_profile_screen.dart';
import 'package:bestkits/presentation/my_return/controller/my_return_controller.dart';
import 'package:bestkits/presentation/my_return/screen/my_return_screen.dart';
import 'package:bestkits/presentation/notification/controller/notification_controller.dart';
import 'package:bestkits/presentation/notification/screen/notification_screen.dart';
import 'package:bestkits/presentation/privacy_policy/controller/privacy_policy_controller.dart';
import 'package:bestkits/presentation/privacy_policy/screen/privacy_policy_screen.dart';
import 'package:bestkits/presentation/product_details/controller/product_details_controller.dart';
import 'package:bestkits/presentation/product_details/screen/product_details_screen.dart';
import 'package:bestkits/presentation/terms_condition/controller/terms_condition_controller.dart';
import 'package:bestkits/presentation/terms_condition/screen/terms_condition_screen.dart';
import 'package:bestkits/presentation/update_profile/controller/update_profile_controller.dart';
import 'package:bestkits/presentation/update_profile/screen/update_profile_screen.dart';
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

import '../../presentation/account_setting/controller/account_setting_controller.dart';
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
        Get.put(FavouriteController(), permanent: true);
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


    GetPage(
      name: RoutePath.myProfile,
      page: () => const MyProfileScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(MyProfileController());
      }),
    ),


    GetPage(
      name: RoutePath.updateProfile,
      page: () => const UpdateProfileScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(UpdateProfileController());
      }),
    ),


    GetPage(
      name: RoutePath.accountSetting,
      page: () => const AccountSettingScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(AccountSettingController());
      }),
    ),


    GetPage(
      name: RoutePath.changePassword,
      page: () => const ChangePasswordScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(ChangePasswordController());
      }),
    ),

    GetPage(
      name: RoutePath.myAddress,
      page: () => const MyAddressScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(MyAddressController());
      }),
    ),



  GetPage(
      name: RoutePath.manageAddress,
      page: () => const ManageAddressScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(ManageAddressController());
      }),
    ),



  GetPage(
      name: RoutePath.currencyPreference,
      page: () => const CurrencyPreferenceScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(CurrencyPreferenceController());
      }),
    ),


  GetPage(
      name: RoutePath.languagePreference,
      page: () => const LanguagePreferenceScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(LanguagePreferenceController());
      }),
    ),



  GetPage(
      name: RoutePath.termsCondition,
      page: () => const TermsConditionScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(TermsConditionController());
      }),
    ),



  GetPage(
      name: RoutePath.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(PrivacyPolicyController());
      }),
    ),



  GetPage(
      name: RoutePath.notification,
      page: () => const NotificationScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(NotificationController());
      }),
    ),




  GetPage(
      name: RoutePath.legalCompanyInfo,
      page: () => const LegalCompanyScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(LegalCompanyController());
      }),
    ),





  GetPage(
      name: RoutePath.helpSupport,
      page: () => const HelpSupportScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(HelpSupportController());
      }),
    ),

  GetPage(
      name: RoutePath.favorite,
      page: () => const FavouriteScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(FavouriteController());
      }),
    ),

    GetPage(
      name: RoutePath.cart,
      page: () => const CartScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
