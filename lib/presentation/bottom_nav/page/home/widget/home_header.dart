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
            child: Container(
              padding: EdgeInsets.all(Dimensions.w(8)),
              decoration: BoxDecoration(
                color: AppColors.navBarColor,
                shape: BoxShape.circle,
              ),
              child: AppSvg(
                path: AppIcons.cart,
                color: AppColors.primaryColor,
                size: Dimensions.icon(24),
              ),
            ),
          ),
          Dimensions.gapW(10),
          // Notification Bell
          GestureDetector(
            onTap: () {
              Get.toNamed(RoutePath.notification);
            },
            child: Container(
              padding: EdgeInsets.all(Dimensions.w(8)),
              decoration: BoxDecoration(
                color: AppColors.navBarColor,
                shape: BoxShape.circle,
              ),
              child: AppSvg(
                path: AppIcons.notification,
                color: AppColors.primaryColor,
                size: Dimensions.icon(24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
