import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/static_strings/static_strings.dart';
import '../../../../widget/custom_appbar.dart';
import '../controller/terms_condition_controller.dart';
import '../widget/legal_content_widget.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TermsConditionController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: AppStrings.termsCondition.tr,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return LegalContentWidget(htmlContent: controller.termsText);
      }),
    );
  }
}
