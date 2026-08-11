import 'package:get/get.dart';
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
