import 'package:bestkits/widget/custom_appbar.dart';
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
      appBar: CommonAppBar(
        title: AppStrings.legalCompanyInfo.tr,
      ),
      body: LegalCompanyInfoWidget(fields: controller.companyFields),
    );
  }
}

