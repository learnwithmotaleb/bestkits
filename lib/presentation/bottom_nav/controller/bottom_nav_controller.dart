import 'package:get/get.dart';
import '../../../core/routes/route_path.dart';
import '../../../helper/local_db/local_db.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_alert.dart';
import '../page/home/screen/home_screen.dart';
import '../../favorite/screen/favourite_screen.dart';
import '../page/profile/screen/profile_screen.dart';
import '../page/sell/screen/sell_screen.dart';
import '../page/home/controller/home_controller.dart';
import '../page/shop/controller/shop_controller.dart';
import '../page/shop/screen/shop_screen.dart';

class BottomNavController extends GetxController {
  final currentIndex = 0.obs;

  final pages = [
    const HomeScreen(),
    const ShopScreen(),
    const SellScreen(),
    const FavouriteScreen(),
    const ProfileScreen(),
  ];

  void changeIndex(int index) {
    // Sell, Favourite & Profile tabs require login → ask guest to log in or sign up
    if (index == 2 || index == 3 || index == 4) {
      final token = SharePrefsHelper.getToken();
      if (token == null || token.isEmpty) {
        AppAlerts.confirm(
          title: AppStrings.logIn.tr,
          message: AppStrings.loginSubtitle.tr,
          confirmLabel: AppStrings.logIn.tr,
          cancelLabel: AppStrings.createAccount.tr,
          onConfirm: () => Get.toNamed(RoutePath.login),
          onCancel: () => Get.toNamed(RoutePath.signup),
        );
        return;
      }
    }

    currentIndex.value = index;

    // Refresh Home Data when navigating back to the Home Tab
    if (index == 0) {
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        homeController.fetchHomeData();
        homeController.fetchRecentlyViewed();
      }
    } else if (index == 1) {
      if (Get.isRegistered<ShopController>()) {
        final shopController = Get.find<ShopController>();
        shopController.fetchProducts(isRefresh: true);
      }
    }
  }
}
