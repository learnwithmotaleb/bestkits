import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/presentation/customer_order/screen/customer_order_screen.dart';
import 'package:bestkits/presentation/delivery_options/screen/delivery_options_screen.dart';
import 'package:bestkits/presentation/return_order/screen/return_order_screen.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:bestkits/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_icons/app_icons.dart';
import '../../../../earnings/screen/earning_screen.dart';
import '../../order/screen/order_screen.dart';
import '../controller/profile_controller.dart';
import '../widget/profile_menu_item.dart';
import '../../../../my_return/screen/my_return_screen.dart';
import '../../../../message/screen/message_screen.dart';
import '../../../../../service/api_url.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: AppStrings.profile.tr,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.w(24), vertical: Dimensions.h(20)),
        child: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height: Dimensions.h(30)),
            ProfileMenuItem(
              icon: AppIcons.profile,
              label: AppStrings.myProfile.tr,
              onTap: () {
                Get.toNamed(RoutePath.myProfile);
              },
            ),
            ProfileMenuItem(
              icon: AppIcons.message,
              label: AppStrings.messages.tr,
              onTap: () => Get.to(() => const MessageScreen()),
            ),
            ProfileMenuItem(
              icon: AppIcons.setting,
              label: AppStrings.accountSetting.tr,
              onTap: () {
                Get.toNamed(RoutePath.accountSetting);
              },
            ),
            SizedBox(height: Dimensions.h(10)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.buying.tr,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: Dimensions.h(10)),
            ProfileMenuItem(
              icon: AppIcons.order_icon,
              label: AppStrings.myOrders.tr,
              onTap: () => Get.to(() => const OrderScreen()),
            ),
            ProfileMenuItem(
              icon: AppIcons.my_return,
              label: AppStrings.myReturns.tr,
              onTap: () => Get.to(() => const MyReturnScreen()),
            ),
            SizedBox(height: Dimensions.h(10)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.selling.tr,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: Dimensions.h(16)),
            ProfileMenuItem(
              icon: AppIcons.order_icon,
              label: AppStrings.customerOrder.tr,
              onTap: () => Get.to(() => const CustomerOrderScreen()),
            ),
            ProfileMenuItem(
              icon: AppIcons.my_return,
              label: AppStrings.returnOrder.tr,
              onTap: () => Get.to(() => const ReturnOrderScreen()),
            ),
            ProfileMenuItem(
              icon: AppIcons.earningIcon,
              label: AppStrings.earning.tr,
              onTap: () => Get.to(() => const EarningScreen()),
            ),
            ProfileMenuItem(
              icon: AppIcons.deliveryOption,
              label: AppStrings.deliveryOption.tr,
              onTap: () => Get.to(() => const DeliveryOptionsScreen()),
            ),
            SizedBox(height: Dimensions.h(16)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.more.tr,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  color: Colors.grey[400],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: Dimensions.h(16)),
            ProfileMenuItem(
              icon: AppIcons.terms_condition,
              label: AppStrings.termsCondition.tr,
              onTap: () {
                Get.toNamed(RoutePath.termsCondition);
              },
            ),
            ProfileMenuItem(
              icon: AppIcons.privacy_policy,
              label: AppStrings.privacyPolicy.tr,
              onTap: () {
                Get.toNamed(RoutePath.privacyPolicy);
              },
            ),
            ProfileMenuItem(
              icon: AppIcons.legal,
              label: AppStrings.legalCompanyInfo.tr,
              onTap: () {
                Get.toNamed(RoutePath.legalCompanyInfo);
              },
            ),
            ProfileMenuItem(
              icon: AppIcons.help_support,
              label: AppStrings.helpSupport.tr,
              onTap: () {
                Get.toNamed(RoutePath.helpSupport);
              },
            ),
            SizedBox(height: Dimensions.h(10)),
            ProfileMenuItem(
              icon: Icons.logout,
              label: AppStrings.logout.tr,
              isDestructive: true,
              onTap: () => controller.logout(),
            ),
            SizedBox(height: Dimensions.h(40)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Obx(() {
      final user = controller.userData.value;
      final name = user?.profile.fullName ?? AppStrings.dummyUserName.tr;
      final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';
      final avatarUrl = user?.profile.avatarUrl;

      return Column(
        children: [
          Container(
            width: Dimensions.w(100),
            height: Dimensions.h(100),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(Dimensions.r(24)),
              border: Border.all(
                  color: AppColors.greyColor.withOpacity(0.5), width: 1),
              image: avatarUrl != null && avatarUrl.trim().isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(ApiUrl.buildImageUrl(avatarUrl)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: avatarUrl != null && avatarUrl.trim().isNotEmpty
                ? null
                : Text(
                    firstLetter,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      color: AppColors.primaryColor,
                    ),
                  ),
          ),
          SizedBox(height: Dimensions.h(16)),
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              color: AppColors.blackColor,
            ),
          ),
        ],
      );
    });
  }
}
