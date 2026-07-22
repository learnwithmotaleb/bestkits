import 'package:get/get.dart';
import '../page/home/screen/home_screen.dart';
import '../page/search/screen/search_screen.dart';
import '../../favorite/screen/favourite_screen.dart';
import '../page/order/screen/order_screen.dart';
import '../page/profile/screen/profile_screen.dart';
import '../page/sell/screen/sell_screen.dart';
import '../page/home/controller/home_controller.dart';

class BottomNavController extends GetxController {
  final currentIndex = 0.obs;

  final pages = [
    const HomeScreen(),
    const SearchScreen(),
    const SellScreen(),
    const FavouriteScreen(),
    // const OrderScreen(),
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
    }
  }
}
