
// ─────────────────────────────────────────────
// widget/legal_company_info_widget.dart
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../../core/responsive_layout/dimensions.dart';

class LegalCompanyInfoWidget extends StatelessWidget {
  final List<Map<String, String>> fields;

  const LegalCompanyInfoWidget({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.w(18),
        vertical: Dimensions.h(20),
      ),
      itemCount: fields.length,
      separatorBuilder: (_, __) => SizedBox(height: Dimensions.h(12)),
      itemBuilder: (context, index) {
        final field = fields[index];
        return _InfoCard(
          label: field['label']!,
          value: field['value']!,
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.w(16),
        vertical: Dimensions.h(14),
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(16)),
        border: Border.all(
          color: AppColors.blackColor.withOpacity(0.08),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyText.copyWith(
              fontSize: Dimensions.fs(12),
              color: AppColors.greyColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Dimensions.h(6)),
          Text(
            value,
            style: AppTextStyles.h4.copyWith(
              fontSize: Dimensions.fs(15),
              fontStyle: FontStyle.italic,
              color: AppColors.blackColor.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}