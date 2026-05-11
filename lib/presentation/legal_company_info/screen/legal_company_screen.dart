
// ─────────────────────────────────────────────
// screen/legal_company_screen.dart
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../controller/legal_company_controller.dart';
import '../widget/legal_company_info_widget.dart';

class LegalCompanyScreen extends StatelessWidget {
  const LegalCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LegalCompanyController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: Dimensions.w(64),
        leading: Padding(
          padding: EdgeInsets.only(left: Dimensions.w(16), top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFEEEBE2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.blackColor.withOpacity(0.54),
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          AppStrings.legalCompanyInfo.tr,
          style: AppTextStyles.h3.copyWith(
            fontStyle: FontStyle.italic,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: LegalCompanyInfoWidget(fields: controller.companyFields),
    );
  }
}

