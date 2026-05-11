
// ─────────────────────────────────────────────
// screen/legal_company_screen.dart
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
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
        backgroundColor: const Color(0xFFF5F3EC),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFEEEBE2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black54,
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          'Legal & Company Info',
          style: TextStyle(
            color: Colors.black,
            fontSize: Dimensions.fs(18),
            fontWeight: FontWeight.w800,
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

