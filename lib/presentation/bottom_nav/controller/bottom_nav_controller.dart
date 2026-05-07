import 'package:get/get.dart';
import '../page/home/screen/home_screen.dart';
import '../page/search/screen/search_screen.dart';
import '../page/cart/screen/cart_screen.dart';
import '../page/order/screen/order_screen.dart';
import '../page/profile/screen/profile_screen.dart';

class BottomNavController extends GetxController {
  final currentIndex = 0.obs;

  final pages = [
    const HomeScreen(),
    const SearchScreen(),
    const CartScreen(),
    const OrderScreen(),
    const ProfileScreen(),
  ];

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}