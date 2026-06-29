import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:bestkits/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_icons/app_icons.dart';
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
      appBar: CommonAppBar(
        title: AppStrings.accountSetting.tr,
      ),
      body: SingleChildScrollView(
        padding: Dimensions.pSym(h: 20, v: 24),
        child: Column(
          children: [
            AccountSettingTile(
              title: AppStrings.myAddresses.tr,
              icon: AppIcons.my_addreess,
              onTap: () {
                Get.toNamed(RoutePath.myAddress);
              },
            ),
            AccountSettingTile(
              title: AppStrings.languagePreference.tr,
              icon: AppIcons.language_preference,
              onTap: () {
                Get.toNamed(RoutePath.languagePreference);
              },
            ),
            AccountSettingTile(
              title: AppStrings.currencyPreference.tr,
              icon: AppIcons.currency_preference,
              onTap: () {
                Get.toNamed(RoutePath.currencyPreference);
              },
            ),
            AccountSettingTile(
              title: AppStrings.changePassword.tr,
              icon: AppIcons.change_password,
              onTap: () {
                Get.toNamed(RoutePath.changePassword);
              },
            ),
            SizedBox(height: Dimensions.h(8)),
            AccountSettingTile(
              title: AppStrings.deleteAccount.tr,
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
