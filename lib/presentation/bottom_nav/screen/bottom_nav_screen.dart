import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_icons/app_icons.dart';
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
                _buildNavItem(0, AppIcons.home, AppIcons.home,
                    AppStrings.home.tr, controller),
                _buildNavItem(1, AppIcons.search_icon, AppIcons.search_icon,
                    AppStrings.search.tr, controller),
                _buildNavItem(2,  AppIcons.favouriteIcon, AppIcons.favouriteIcon,
                    AppStrings.favorite.tr, controller),
                _buildNavItem(3, AppIcons.order_icon, AppIcons.order_icon,
                    AppStrings.orders.tr, controller),
                _buildNavItem(4, AppIcons.profile, AppIcons.profile,
                    AppStrings.profile.tr, controller),
              ],
            ),
          )),
    );
  }

  Widget _buildNavItem(int index, dynamic icon, dynamic activeIcon,
      String label, BottomNavController controller) {
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
                _buildIcon(
                  isSelected ? activeIcon : icon,
                  isSelected ? Colors.transparent : AppColors.blackColor,
                  Dimensions.icon(28),
                ),
                SizedBox(height: Dimensions.h(4)),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.blackColor,
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
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: _buildIcon(
                          activeIcon,
                          AppColors.primaryColor,
                          Dimensions.icon(10),
                        ),
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

  Widget _buildIcon(dynamic icon, Color color, double size) {
    if (icon is IconData) {
      return Icon(icon, color: color, size: size);
    } else if (icon is String) {
      return SvgPicture.asset(
        icon,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        width: size,
        height: size,
      );
    }
    return const SizedBox.shrink();
  }
}
