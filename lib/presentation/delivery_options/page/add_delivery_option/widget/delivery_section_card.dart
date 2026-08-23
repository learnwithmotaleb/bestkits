import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../utils/static_strings/static_strings.dart';
import '../../../../../widget/app_text_field.dart';

/// A reusable card section for Domestic or International delivery form fields.
class DeliverySectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final TextEditingController partnerCtrl;
  final TextEditingController costCtrl;
  final TextEditingController minDaysCtrl;
  final TextEditingController maxDaysCtrl;
  final String? Function(String?)? partnerValidator;
  final String? Function(String?)? costValidator;
  final String? Function(String?)? minDaysValidator;
  final String? Function(String?)? maxDaysValidator;

  const DeliverySectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.partnerCtrl,
    required this.costCtrl,
    required this.minDaysCtrl,
    required this.maxDaysCtrl,
    this.partnerValidator,
    this.costValidator,
    this.minDaysValidator,
    this.maxDaysValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(16)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.w(16),
              vertical: Dimensions.h(14),
            ),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.r(16)),
                topRight: Radius.circular(Dimensions.r(16)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(Dimensions.w(8)),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(Dimensions.r(8)),
                  ),
                  child: Icon(icon, color: iconColor, size: Dimensions.rs(18)),
                ),
                SizedBox(width: Dimensions.w(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: Dimensions.fs(14),
                          fontStyle: FontStyle.italic,
                          color: AppColors.blackColor,
                        ),
                      ),
                      SizedBox(height: Dimensions.h(2)),
                      Text(
                        subtitle,
                        style: AppTextStyles.body.copyWith(
                          fontSize: Dimensions.fs(11),
                          color: AppColors.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Fields ──────────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(Dimensions.w(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery Partner
                _FieldLabel(label: AppStrings.deliveryPartner.tr),
                SizedBox(height: Dimensions.h(8)),
                AppTextField(
                  controller: partnerCtrl,
                  hint: AppStrings.deliveryPartnerHint.tr,
                  hintTextStyle:
                      TextStyle(fontSize: 12, color: Colors.grey[400]),
                  validator: partnerValidator,
                  prefixIcon: Icon(
                    Icons.local_shipping_outlined,
                    size: 18,
                    color: AppColors.greyColor.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: Dimensions.h(16)),

                // Delivery Cost
                _FieldLabel(label: AppStrings.deliveryCostEuro.tr),
                SizedBox(height: Dimensions.h(8)),
                AppTextField(
                  controller: costCtrl,
                  hint: AppStrings.deliveryCostHint.tr,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  hintTextStyle:
                      TextStyle(fontSize: 12, color: Colors.grey[400]),
                  validator: costValidator,
                ),
                SizedBox(height: Dimensions.h(16)),

                // Estimated Delivery Days
                _FieldLabel(label: AppStrings.estimatedDeliveryDays.tr),
                SizedBox(height: Dimensions.h(8)),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: minDaysCtrl,
                        hint: AppStrings.minDaysHint.tr,
                        keyboardType: TextInputType.number,
                        hintTextStyle:
                            TextStyle(fontSize: 12, color: Colors.grey[400]),
                        validator: minDaysValidator,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimensions.w(10)),
                      child: Text(
                        '—',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.greyColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: AppTextField(
                        controller: maxDaysCtrl,
                        hint: AppStrings.maxDaysHint.tr,
                        keyboardType: TextInputType.number,
                        hintTextStyle:
                            TextStyle(fontSize: 12, color: Colors.grey[400]),
                        validator: maxDaysValidator,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.body.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: Dimensions.fs(13),
        fontStyle: FontStyle.italic,
        color: AppColors.darkGreyColor,
      ),
    );
  }
}
