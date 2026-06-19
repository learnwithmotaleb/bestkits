import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/core/responsive_layout/dimensions.dart';
import 'package:bestkits/utils/app_colors/app_colors.dart';
import 'package:bestkits/utils/app_text_style/app_text_style.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:bestkits/widget/app_button.dart';
import '../controller/stripe_connect_controller.dart';

class StripeConnectScreen extends StatelessWidget {
  const StripeConnectScreen({super.key});

  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.h(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(Dimensions.w(12)),
            decoration: BoxDecoration(
              color: AppColors.blackColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor,
              size: Dimensions.w(24),
            ),
          ),
          SizedBox(width: Dimensions.w(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: Dimensions.h(4)),
                Text(
                  subtitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.greyColor,
                    fontSize: Dimensions.fs(13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StripeConnectController>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Dimensions.pSym(h: 24, v: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.h(40)),
              
              // Top Icon
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.w(16), vertical: Dimensions.w(10) ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "S",
                  style: TextStyle(
                    fontSize: Dimensions.fs(32),
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.h(24)),

              // Title
              Text(
                AppStrings.connectPaymentsStripe.tr,
                style: AppTextStyles.title.copyWith(
                  fontSize: Dimensions.fs(28, tablet: 32, desktop: 36),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: Dimensions.h(8)),

              // Subtitle
              Text(
                AppStrings.connectStripeSubtitle.tr,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.greyColor,
                ),
              ),
              SizedBox(height: Dimensions.h(32)),

              // Items
              _buildListTile(
                Icons.security_outlined,
                AppStrings.securePayments.tr,
                AppStrings.securePaymentsSubtitle.tr,
              ),
              _buildListTile(
                Icons.account_balance_outlined,
                AppStrings.directBankPayouts.tr,
                AppStrings.directBankPayoutsSubtitle.tr,
              ),
              _buildListTile(
                Icons.offline_bolt_outlined,
                AppStrings.fastSetup.tr,
                AppStrings.fastSetupSubtitle.tr,
              ),

              SizedBox(height: Dimensions.h(16)),

              // Info Box
              Container(
                padding: EdgeInsets.all(Dimensions.w(16)),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.shade300,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.green.shade400,
                      size: Dimensions.w(20),
                    ),
                    SizedBox(width: Dimensions.w(12)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.aboutBestKidPayments.tr,
                            style: AppTextStyles.h4.copyWith(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: Dimensions.fs(14),
                            ),
                          ),
                          SizedBox(height: Dimensions.h(4)),
                          Text(
                            AppStrings.aboutBestKidPaymentsSubtitle.tr,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.greyColor,
                              fontSize: Dimensions.fs(13),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.h(32)),

              // Action Buttons
              Obx(() {
                if (controller.connectionState.value == StripeConnectionState.connected) {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: Dimensions.h(56),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade400),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.green, size: Dimensions.w(20)),
                            SizedBox(width: Dimensions.w(8)),
                            Text(
                              AppStrings.stripeConnected.tr,
                              style: AppTextStyles.button.copyWith(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Dimensions.h(16)),
                      AppButton(
                        label: AppStrings.saveAndContinue.tr,
                        onPressed: controller.saveAndContinue,
                        backgroundColor: AppColors.blackColor,
                        textColor: AppColors.primaryColor,
                        borderSideColor: AppColors.blackColor,
                        borderRadius: Dimensions.r(12),
                        height: Dimensions.h(56),
                      ),
                    ],
                  );
                } else if (controller.connectionState.value == StripeConnectionState.failed) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: controller.connectStripeAccount,
                        child: Container(
                          width: double.infinity,
                          height: Dimensions.h(56),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade400),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, color: Colors.red, size: Dimensions.w(20)),
                              SizedBox(width: Dimensions.w(8)),
                              Text(
                                AppStrings.stripeConnectionFailed.tr,
                                style: AppTextStyles.button.copyWith(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.h(16)),
                      AppButton(
                        label: AppStrings.saveAndContinue.tr,
                        onPressed: () {}, // Disabled
                        backgroundColor: AppColors.blackColor,
                        textColor: AppColors.primaryColor,
                        borderSideColor: AppColors.blackColor,
                        borderRadius: Dimensions.r(12),
                        height: Dimensions.h(56),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      AppButton(
                        label: AppStrings.connectStripeAccount.tr,
                        onPressed: controller.connectStripeAccount,
                        backgroundColor: AppColors.blackColor,
                        textColor: AppColors.primaryColor,
                        borderSideColor: AppColors.blackColor,
                        borderRadius: Dimensions.r(12),
                        height: Dimensions.h(56),
                        trailingIcon: Icon(Icons.link, color: AppColors.primaryColor, size: Dimensions.w(18)),
                      ),
                      SizedBox(height: Dimensions.h(16)),
                      Container(
                        width: double.infinity,
                        height: Dimensions.h(56),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          AppStrings.saveAndContinue.tr,
                          style: AppTextStyles.button.copyWith(color: AppColors.whiteColor),
                        ),
                      ),
                      SizedBox(height: Dimensions.h(16)),
                      GestureDetector(
                        onTap: controller.skipForNow,
                        child: Container(
                          width: double.infinity,
                          height: Dimensions.h(56),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF7E5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.skipForNow.tr,
                            style: AppTextStyles.button.copyWith(color: AppColors.blackColor),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
              SizedBox(height: Dimensions.h(24)),
            ],
          ),
        ),
      ),
    );
  }
}
