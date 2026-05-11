import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../controller/profile_controller.dart';
import '../widget/profile_menu_item.dart';
import '../../../../my_return/screen/my_return_screen.dart';
import '../../../../message/screen/message_screen.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,

              ),
              child: const Icon(Icons.arrow_back, color: AppColors.blackColor, size: 20),
            ),
          ),
        ),
        title: Text(
          AppStrings.profile.tr,
          style: const TextStyle(
            color: AppColors.blackColor,
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.w(24), vertical: Dimensions.h(20)),
        child: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height: Dimensions.h(30)),
            ProfileMenuItem(
              icon: Icons.person_outline,
              label: AppStrings.myProfile.tr,
              onTap: () {
                Get.toNamed(RoutePath.myProfile);
              },
            ),
            ProfileMenuItem(
              icon: Icons.chat_bubble_outline,
              label: AppStrings.messages.tr,
              onTap: () => Get.to(() => const MessageScreen()),
            ),
            ProfileMenuItem(
              icon: Icons.assignment_return_outlined,
              label: AppStrings.myReturns.tr,
              onTap: () => Get.to(() => const MyReturnScreen()),
            ),
            ProfileMenuItem(
              icon: Icons.settings_outlined,
              label: AppStrings.accountSetting.tr,
              onTap: () {
                Get.toNamed(RoutePath.accountSetting);
              },
            ),

            SizedBox(height: Dimensions.h(10)),
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
              icon: Icons.gavel_outlined,
              label: AppStrings.termsCondition.tr,
              onTap: () {
                Get.toNamed(RoutePath.termsCondition);
              },
            ),
            ProfileMenuItem(
              icon: Icons.privacy_tip_outlined,
              label: AppStrings.privacyPolicy.tr,
              onTap: () {
                Get.toNamed(RoutePath.privacyPolicy);
              },
            ),
            ProfileMenuItem(
              icon: Icons.business_outlined,
              label: AppStrings.legalCompanyInfo.tr,
              onTap: () {
                Get.toNamed(RoutePath.legalCompanyInfo);
              },
            ),
            ProfileMenuItem(
              icon: Icons.help_outlined,
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
    return Column(
      children: [
        Container(
          width: Dimensions.w(100),
          height: Dimensions.h(100),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(Dimensions.r(24)),
              border: Border.all(color: AppColors.greyColor.withOpacity(0.5), width: 1)
          ),
          alignment: Alignment.center,
          child: Text(
            AppStrings.dummyUserName.tr[0].toUpperCase(),
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
          AppStrings.dummyUserName.tr,
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
  }
}
