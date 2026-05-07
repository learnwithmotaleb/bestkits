import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../controller/bottom_nav_controller.dart';

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomNavController());

    return Scaffold(
      body: Obx(() => controller.pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(() => Container(
            height: Dimensions.h(85),
            decoration: const BoxDecoration(
              color: AppColors.navBarColor,
              border: Border(
                top: BorderSide(color: AppColors.navBarBorderColor, width: 1.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home_filled, AppStrings.home.tr, controller),
                _buildNavItem(1, Icons.search_outlined, Icons.search, AppStrings.browse.tr, controller),
                _buildNavItem(2, Icons.shopping_bag_outlined, Icons.shopping_bag, AppStrings.cart.tr, controller),
                _buildNavItem(3, Icons.inventory_2_outlined, Icons.inventory_2, AppStrings.orders.tr, controller),
                _buildNavItem(4, Icons.person_outline, Icons.person, AppStrings.profile.tr, controller),
              ],
            ),
          )),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label, BottomNavController controller) {
    final isSelected = controller.currentIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changeIndex(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: Dimensions.screenWidth / 5,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? Colors.transparent : AppColors.blackColor,
                  size: Dimensions.icon(28),
                ),
                SizedBox(height: Dimensions.h(4)),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? AppColors.primaryColor : AppColors.blackColor,
                    fontSize: Dimensions.fs(12),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: -Dimensions.h(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: Dimensions.w(60),
                      height: Dimensions.w(60),
                      decoration: BoxDecoration(
                        color: AppColors.blackColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        activeIcon,
                        color: AppColors.primaryColor,
                        size: Dimensions.icon(30),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}