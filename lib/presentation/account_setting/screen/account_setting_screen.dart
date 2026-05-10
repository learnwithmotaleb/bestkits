import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../controller/account_setting_controller.dart';
import '../widget/account_setting_tile.dart';

class AccountSettingScreen extends GetView<AccountSettingController> {
  const AccountSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AccountSettingController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.navBarColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.blackColor, size: 20),
              onPressed: () => Get.back(),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        title: Text(
          "Account Settings",
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: AppColors.darkGreyColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: Dimensions.pSym(h: 20, v: 24),
        child: Column(
          children: [
            AccountSettingTile(
              title: "My Addresses",
              icon: Icons.location_on_outlined,
              onTap: () {
                // Navigate to My Addresses
              },
            ),
            AccountSettingTile(
              title: "Language Preference",
              icon: Icons.g_translate_outlined,
              onTap: () {
                // Navigate to Language Preference
              },
            ),
            AccountSettingTile(
              title: "Currency Preference",
              icon: Icons.euro_symbol_outlined,
              onTap: () {
                // Navigate to Currency Preference
              },
            ),
            AccountSettingTile(
              title: "Change Password",
              icon: Icons.lock_outline,
              onTap: () {
                // Navigate to Change Password
              },
            ),
            SizedBox(height: Dimensions.h(8)),
            AccountSettingTile(
              title: "Delete account",
              icon: Icons.person_remove_outlined,
              isDestructive: true,
              onTap: () {
                controller.confirmDeleteAccount();
              },
            ),
          ],
        ),
      ),
    );
  }
}
