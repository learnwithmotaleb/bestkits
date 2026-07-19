import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/core/responsive_layout/dimensions.dart';
import 'package:bestkits/utils/app_colors/app_colors.dart';
import 'package:bestkits/utils/app_text_style/app_text_style.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:bestkits/widget/custom_appbar.dart';
import 'package:bestkits/widget/app_bottom_sheet.dart';
import 'package:bestkits/widget/app_text_field.dart';
import 'package:bestkits/widget/app_button.dart';
import '../controller/stripe_connect_controller.dart';

class StripeConnectProfileScreen extends StatefulWidget {
  const StripeConnectProfileScreen({super.key});

  @override
  State<StripeConnectProfileScreen> createState() =>
      _StripeConnectProfileScreenState();
}

class _StripeConnectProfileScreenState
    extends State<StripeConnectProfileScreen> with WidgetsBindingObserver {
  late final StripeConnectController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(StripeConnectController());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.onAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.connectionState.value;

      // ── Loading ────────────────────────────────────────────────────────
      if (state == StripeConnectionState.loading) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: const CommonAppBar(
            title: 'Stripe Connect',
            showBack: true,
          ),
          body: Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        );
      }

      // ── Connected → show profile card ──────────────────────────────────
      if (state == StripeConnectionState.connected) {
        return _buildProfileScreen(context);
      }

      // ── Not connected (initial / onboarding / failed) → show onboard UI
      return _buildOnboardScreen(context, state);
    });
  }

  // ──────────────────────────────────────────────────────────────────────────
  // PROFILE SCREEN (connected state)
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildProfileScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CommonAppBar(
        title: 'Connected Account',
        showBack: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.w(20), vertical: Dimensions.h(20)),
        child: Column(
          children: [
            // ── Connected status badge ──────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(16), vertical: Dimensions.h(10)),
              margin: EdgeInsets.only(bottom: Dimensions.h(16)),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(Dimensions.r(12)),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      color: Colors.green.shade600, size: Dimensions.icon(18)),
                  SizedBox(width: Dimensions.w(8)),
                  Text(
                    'Account Connected',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: Dimensions.fs(14),
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),

            // ── Card tile ───────────────────────────────────────────────
            Container(
              padding: EdgeInsets.all(Dimensions.w(16)),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(Dimensions.r(16)),
                border:
                    Border.all(color: AppColors.greyColor.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greyColor.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Stripe icon
                  Container(
                    height: Dimensions.w(48),
                    width: Dimensions.w(48),
                    decoration: BoxDecoration(
                      color: AppColors.blackColor,
                      borderRadius: BorderRadius.circular(Dimensions.r(12)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.account_balance,
                        color: AppColors.primaryColor,
                        size: Dimensions.icon(24),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.w(16)),

                  // Name + card number
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'stripe',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: Dimensions.fs(18),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF5433FF),
                          ),
                        ),
                        SizedBox(height: Dimensions.h(4)),
                        Row(
                          children: [
                            Icon(
                              Icons.insert_drive_file_outlined,
                              size: Dimensions.icon(14),
                              color: AppColors.greyColor,
                            ),
                            SizedBox(width: Dimensions.w(4)),
                            Obx(() => Text(
                                  controller.cardNumber.value,
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: Dimensions.fs(12),
                                    color: AppColors.greyColor,
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Edit button
                  GestureDetector(
                    onTap: () => _showEditBottomSheet(context),
                    child: Container(
                      height: Dimensions.w(36),
                      width: Dimensions.w(36),
                      decoration: const BoxDecoration(
                        color: AppColors.blackColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.edit,
                          color: AppColors.primaryColor,
                          size: Dimensions.icon(16),
                        ),
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

  // ──────────────────────────────────────────────────────────────────────────
  // ONBOARD SCREEN (initial / onboarding / failed states)
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildOnboardScreen(
      BuildContext context, StripeConnectionState state) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CommonAppBar(
        title: 'Connect Stripe',
        showBack: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Dimensions.pSym(h: 24, v: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.h(20)),

              // Stripe "S" logo
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.w(16),
                    vertical: Dimensions.w(10)),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'S',
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
                style:
                    AppTextStyles.body.copyWith(color: AppColors.greyColor),
              ),
              SizedBox(height: Dimensions.h(32)),

              // Feature list
              _buildFeatureTile(Icons.security_outlined,
                  AppStrings.securePayments.tr,
                  AppStrings.securePaymentsSubtitle.tr),
              _buildFeatureTile(Icons.account_balance_outlined,
                  AppStrings.directBankPayouts.tr,
                  AppStrings.directBankPayoutsSubtitle.tr),
              _buildFeatureTile(Icons.offline_bolt_outlined,
                  AppStrings.fastSetup.tr,
                  AppStrings.fastSetupSubtitle.tr),

              SizedBox(height: Dimensions.h(16)),

              // Info box
              Container(
                padding: EdgeInsets.all(Dimensions.w(16)),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.green.shade300, width: 1.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.green.shade400,
                        size: Dimensions.w(20)),
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

              // ── Error banner (failed state) ──────────────────────────
              if (state == StripeConnectionState.failed &&
                  controller.errorMessage.value.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Dimensions.w(12)),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Text(
                    controller.errorMessage.value,
                    style: AppTextStyles.body.copyWith(
                      color: Colors.red.shade700,
                      fontSize: Dimensions.fs(13),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: Dimensions.h(16)),
              ],

              // ── Onboarding in-progress banner ────────────────────────
              if (state == StripeConnectionState.onboarding) ...[
                Container(
                  width: double.infinity,
                  height: Dimensions.h(56),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade400),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pending_actions,
                          color: Colors.orange,
                          size: Dimensions.w(20)),
                      SizedBox(width: Dimensions.w(8)),
                      Text(
                        'Onboarding Started',
                        style: AppTextStyles.button
                            .copyWith(color: Colors.orange),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.h(16)),
              ],

              // ── Primary CTA ──────────────────────────────────────────
              AppButton(
                label: state == StripeConnectionState.onboarding
                    ? 'Continue Onboarding'
                    : AppStrings.connectStripeAccount.tr,
                onPressed: controller.connectStripeAccount,
                backgroundColor: AppColors.blackColor,
                textColor: AppColors.primaryColor,
                borderSideColor: AppColors.blackColor,
                borderRadius: Dimensions.r(12),
                height: Dimensions.h(56),
                trailingIcon: Icon(
                    state == StripeConnectionState.onboarding
                        ? Icons.arrow_forward
                        : Icons.link,
                    color: AppColors.primaryColor,
                    size: Dimensions.w(18)),
              ),
              SizedBox(height: Dimensions.h(16)),

              // ── Refresh status ───────────────────────────────────────
              AppButton(
                label: 'Refresh Status',
                onPressed: controller.checkStripeStatus,
                backgroundColor: AppColors.whiteColor,
                textColor: AppColors.blackColor,
                borderSideColor: AppColors.blackColor,
                borderRadius: Dimensions.r(12),
                height: Dimensions.h(56),
                trailingIcon: Icon(Icons.refresh,
                    color: AppColors.blackColor, size: Dimensions.w(18)),
              ),
              SizedBox(height: Dimensions.h(16)),

              // ── Skip ─────────────────────────────────────────────────
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
                    style: AppTextStyles.button
                        .copyWith(color: AppColors.blackColor),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.h(24)),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // HELPERS
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildFeatureTile(IconData icon, String title, String subtitle) {
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
            child: Icon(icon, color: AppColors.primaryColor,
                size: Dimensions.w(24)),
          ),
          SizedBox(width: Dimensions.w(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyles.h4.copyWith(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic)),
                SizedBox(height: Dimensions.h(4)),
                Text(subtitle,
                    style: AppTextStyles.body.copyWith(
                        color: AppColors.greyColor,
                        fontSize: Dimensions.fs(13))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditBottomSheet(BuildContext context) {
    final TextEditingController cardController =
        TextEditingController(text: controller.cardNumber.value);

    AppBottomSheet(
      child: Padding(
        padding: EdgeInsets.only(
          left: Dimensions.w(20),
          right: Dimensions.w(20),
          bottom:
              MediaQuery.of(context).viewInsets.bottom + Dimensions.h(20),
          top: Dimensions.h(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: Dimensions.w(40),
                height: Dimensions.h(4),
                decoration: BoxDecoration(
                  color: AppColors.greyColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(Dimensions.r(2)),
                ),
              ),
            ),
            SizedBox(height: Dimensions.h(20)),
            Text(
              'Edit Card Number',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: Dimensions.fs(18),
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: Dimensions.h(20)),
            AppTextField(
              controller: cardController,
              label: 'Card Number',
              hint: 'Enter card number',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: Dimensions.h(30)),
            AppButton(
              label: 'Save',
              onPressed: () {
                if (cardController.text.isNotEmpty) {
                  controller.saveCardNumber(cardController.text);
                  Get.back();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
