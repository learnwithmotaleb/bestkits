import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../utils/static_strings/static_strings.dart';
import '../../../../../widget/app_alert.dart';
import '../../../../../widget/app_button.dart';
import '../../../../../widget/custom_appbar.dart';
import '../controller/add_delivery_option_controller.dart';
import '../widget/delivery_section_card.dart';

class AddDeliveryOptionScreen extends StatefulWidget {
  const AddDeliveryOptionScreen({super.key});

  @override
  State<AddDeliveryOptionScreen> createState() =>
      _AddDeliveryOptionScreenState();
}

class _AddDeliveryOptionScreenState extends State<AddDeliveryOptionScreen> {
  late final AddDeliveryOptionController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.isRegistered<AddDeliveryOptionController>()
        ? Get.find<AddDeliveryOptionController>()
        : Get.put(AddDeliveryOptionController());
  }

  void _onSave() {
    if (!_ctrl.formKey.currentState!.validate()) return;

    AppAlerts.warning(
      title: AppStrings.saveDeliveryOptionAlertTitle.tr,
      message: AppStrings.saveDeliveryOptionAlertSubtitle.tr,
      confirmLabel: AppStrings.confirm.tr,
      cancelLabel: AppStrings.cancel.tr,
      onConfirm: () => _ctrl.saveDeliveryOptions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: CommonAppBar(title: AppStrings.addDeliveryOption.tr),
      body: Form(
        key: _ctrl.formKey,
        child: Column(
          children: [
            // ── Scrollable content ──────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(16),
                  vertical: Dimensions.h(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Info banner ───────────────────────────
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.w(14),
                        vertical: Dimensions.h(12),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(Dimensions.r(10)),
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.primaryColor,
                            size: Dimensions.rs(18),
                          ),
                          SizedBox(width: Dimensions.w(10)),
                          Expanded(
                            child: Text(
                              AppStrings.addDeliveryOptionInfoBanner.tr,
                              style: AppTextStyles.body.copyWith(
                                fontSize: Dimensions.fs(12),
                                color: AppColors.darkGreyColor,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.h(20)),

                    // ── Domestic Section ──────────────────────
                    _SectionTitle(
                      label: AppStrings.domesticDelivery.tr,
                      badge: AppStrings.insideCountry.tr,
                    ),
                    SizedBox(height: Dimensions.h(10)),
                    DeliverySectionCard(
                      title: AppStrings.domesticDelivery.tr,
                      subtitle: AppStrings.insideCountry.tr,
                      icon: Icons.home_outlined,
                      iconColor: AppColors.primaryColor,
                      partnerCtrl: _ctrl.domesticPartnerCtrl,
                      costCtrl: _ctrl.domesticCostCtrl,
                      minDaysCtrl: _ctrl.domesticMinDaysCtrl,
                      maxDaysCtrl: _ctrl.domesticMaxDaysCtrl,
                      partnerValidator: (v) =>
                          _ctrl.validateRequired(v, AppStrings.deliveryPartner.tr),
                      costValidator: _ctrl.validateCost,
                      minDaysValidator: (v) =>
                          _ctrl.validateDays(v, 'Min days'),
                      maxDaysValidator: (v) => _ctrl.validateMaxDays(
                        v,
                        _ctrl.domesticMinDaysCtrl.text,
                        'Max days',
                      ),
                    ),
                    SizedBox(height: Dimensions.h(24)),

                    // ── International Section ─────────────────
                    _SectionTitle(
                      label: AppStrings.internationalDelivery.tr,
                      badge: AppStrings.outsideCountry.tr,
                    ),
                    SizedBox(height: Dimensions.h(10)),
                    DeliverySectionCard(
                      title: AppStrings.internationalDelivery.tr,
                      subtitle: AppStrings.outsideCountry.tr,
                      icon: Icons.public_outlined,
                      iconColor: const Color(0xFF6366F1),
                      partnerCtrl: _ctrl.internationalPartnerCtrl,
                      costCtrl: _ctrl.internationalCostCtrl,
                      minDaysCtrl: _ctrl.internationalMinDaysCtrl,
                      maxDaysCtrl: _ctrl.internationalMaxDaysCtrl,
                      partnerValidator: (v) =>
                          _ctrl.validateRequired(v, AppStrings.deliveryPartner.tr),
                      costValidator: _ctrl.validateCost,
                      minDaysValidator: (v) =>
                          _ctrl.validateDays(v, 'Min days'),
                      maxDaysValidator: (v) => _ctrl.validateMaxDays(
                        v,
                        _ctrl.internationalMinDaysCtrl.text,
                        'Max days',
                      ),
                    ),
                    SizedBox(height: Dimensions.h(32)),
                  ],
                ),
              ),
            ),

            // ── Save Button ─────────────────────────────────
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(16),
                vertical: Dimensions.h(16),
              ),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border(
                  top: BorderSide(
                    color: AppColors.greyColor.withOpacity(0.12),
                  ),
                ),
              ),
              child: Obx(
                () => AppButton(
                  label: AppStrings.saveChanges.tr,
                  isLoading: _ctrl.isLoading.value,
                  onPressed: _ctrl.isLoading.value ? null : _onSave,
                  backgroundColor: const Color(0xFF1A1A1A),
                  textColor: AppColors.primaryColor,
                  borderSideColor: const Color(0xFF1A1A1A),
                  borderRadius: 12,
                  height: 52,
                  leadingIcon: _ctrl.isLoading.value
                      ? null
                      : Icon(
                          Icons.save_outlined,
                          color: AppColors.primaryColor,
                          size: 18,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper Widgets ─────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String label;
  final String badge;

  const _SectionTitle({required this.label, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: Dimensions.fs(14),
            fontStyle: FontStyle.italic,
            color: AppColors.blackColor,
          ),
        ),
        SizedBox(width: Dimensions.w(8)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.w(8),
            vertical: Dimensions.h(2),
          ),
          decoration: BoxDecoration(
            color: AppColors.greyColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(Dimensions.r(4)),
            border: Border.all(
              color: AppColors.greyColor.withOpacity(0.2),
            ),
          ),
          child: Text(
            badge,
            style: AppTextStyles.body.copyWith(
              fontSize: Dimensions.fs(10),
              color: AppColors.greyColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
