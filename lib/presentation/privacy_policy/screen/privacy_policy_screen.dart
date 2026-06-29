import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:bestkits/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../controller/privacy_policy_controller.dart';
import '../widget/privacy_policy_widget.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrivacyPolicyController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: AppStrings.privacyPolicy.tr,
      ),
      body: PrivacyPolicyWidget(htmlContent: controller.policyText),
    );
  }
}
