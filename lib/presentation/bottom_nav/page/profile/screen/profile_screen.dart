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
        title: const Text(
          "Profile",
          style: TextStyle(
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
              label: 'My Profile',
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.chat_bubble_outline,
              label: 'Messages',
              onTap: () => Get.to(() => const MessageScreen()),
            ),
            ProfileMenuItem(
              icon: Icons.assignment_return_outlined,
              label: 'My Returns',
              onTap: () => Get.to(() => const MyReturnScreen()),
            ),
            ProfileMenuItem(
              icon: Icons.settings_outlined,
              label: 'Account Setting',
              onTap: () {},
            ),
            SizedBox(height: Dimensions.h(10)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'More',
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
              label: 'Terms & Condition',
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.privacy_tip_outlined,
              label: 'Privacy policy',
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.business_outlined,
              label: 'Legal & Company Info',
              onTap: () {},
            ),
            SizedBox(height: Dimensions.h(10)),
            ProfileMenuItem(
              icon: Icons.logout,
              label: 'Log Out',
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
          ),
          alignment: Alignment.center,
          child: const Text(
            'R',
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
        const Text(
          "Roberts Junior",
          style: TextStyle(
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
