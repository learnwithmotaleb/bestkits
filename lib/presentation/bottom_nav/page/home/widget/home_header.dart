import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../core/widgets/app_svg.dart';
import '../../../../../utils/app_icons/app_icons.dart';
import '../controller/home_controller.dart';
import '../../../../../service/api_url.dart';
import '../../../../notification/controller/notification_controller.dart';
import '../../../page/cart/controller/cart_controller.dart';

class HomeHeader extends GetView<HomeController> {
  const HomeHeader({super.key});

  Widget _buildDummyName(String name) {
    return Text(
      name.isNotEmpty
          ? name[0].toUpperCase()
          : AppStrings.dummyUserName.tr[0].toUpperCase(),
      style: AppTextStyles.h1.copyWith(
        fontSize: Dimensions.fs(20),
        fontStyle: FontStyle.italic,
        color: AppColors.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure NotificationController is initialized here so we can show the badge
    final notifCtrl = Get.put(NotificationController());
    // Ensure CartController is initialized for the cart badge
    final cartCtrl = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
      child: Row(
        children: [
          // Profile Avatar
          Obx(() {
            final user = controller.userData.value;
            final avatarUrl = user?.profile.avatarUrl;
            final hasImage = avatarUrl != null && avatarUrl.isNotEmpty;
            final name = user?.profile.fullName ?? 'Roberts Junior';

            return Container(
              width: Dimensions.w(45),
              height: Dimensions.h(45),
              decoration: BoxDecoration(
                color: hasImage ? Colors.transparent : AppColors.navBarColor,
                borderRadius: BorderRadius.circular(Dimensions.r(10)),
              ),
              alignment: Alignment.center,
              child: hasImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.r(10)),
                      child: Image.network(
                        ApiUrl.buildImageUrl(avatarUrl),
                        width: Dimensions.w(45),
                        height: Dimensions.h(45),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDummyName(name),
                      ),
                    )
                  : _buildDummyName(name),
            );
          }),
          Dimensions.gapW(12),
          // User Info
          Expanded(
            child: Obx(() {
              final user = controller.userData.value;
              final name = user?.profile.fullName ?? 'Roberts Junior';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppStrings.hello.tr} $name',
                    style: AppTextStyles.h3.copyWith(
                      fontSize: Dimensions.fs(18),
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    AppStrings.welcomeToBestKid.tr,
                    style: AppTextStyles.bodyText.copyWith(
                      fontSize: Dimensions.fs(12),
                      color: Colors.grey,
                    ),
                  ),
                ],
              );
            }),
          ),
          // Cart Icon
          GestureDetector(
            onTap: () {
              Get.toNamed(RoutePath.cart);
            },
            child: Obx(() {
              final count = cartCtrl.cartItemCount.value;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.all(Dimensions.w(8)),
                    decoration: const BoxDecoration(
                      color: AppColors.navBarColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.primaryColor,
                      size: Dimensions.icon(24),
                    ),
                  ),
                  if (count > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          count > 99 ? '99+' : count.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
          Dimensions.gapW(10),
          // Notification Bell
          GestureDetector(
            onTap: () {
              Get.toNamed(RoutePath.notification);
            },
            child: Obx(() {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.all(Dimensions.w(8)),
                    decoration: const BoxDecoration(
                      color: AppColors.navBarColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: AppColors.primaryColor,
                      size: Dimensions.icon(24),
                    ),
                  ),
                  if (notifCtrl.unreadCount.value > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          notifCtrl.unreadCount.value > 99
                              ? '99+'
                              : notifCtrl.unreadCount.value.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
