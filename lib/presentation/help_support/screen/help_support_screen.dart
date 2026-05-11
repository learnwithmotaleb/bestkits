import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';
import '../../../widget/app_button.dart';
import '../../../widget/app_text_field.dart';
import '../../../widget/custom_appbar.dart';
import '../controller/help_support_controller.dart';
import '../widget/faq_item_widget.dart';

import '../../../utils/static_strings/static_strings.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HelpSupportController>();

    return Scaffold(
      backgroundColor:AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: AppStrings.helpSupport.tr,
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.w(18),
            vertical: Dimensions.h(16),
          ),
          children: [
            // ── FAQ Section Header
            Text(
              "— ${AppStrings.frequentlyAskedQuestions.tr}",
              style: AppTextStyles.h4.copyWith(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w800,
                color: AppColors.blackColor.withOpacity(0.8),
              ),
            ),
            SizedBox(height: Dimensions.h(18)),

            // ── FAQ Items
            Obx(() => Column(
              children: List.generate(controller.faqs.length, (i) {
                return FaqItemWidget(
                  index: i,
                  item: controller.faqs[i],
                  isExpanded: controller.expandedIndex.value == i,
                  onTap: () => controller.toggleFaq(i),
                );
              }),
            )),

            SizedBox(height: Dimensions.h(28)),

            // ── Contact Us Section
            ContactUsSection(controller: controller),

            SizedBox(height: Dimensions.h(32)),
          ],
        ),
      ),
    );
  }
}

class ContactUsSection extends StatelessWidget {
  final HelpSupportController controller;

  const ContactUsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Header
        Text(
          "— ${AppStrings.contactSupport.tr}",
          style: AppTextStyles.h4.copyWith(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w800,
            color: AppColors.blackColor.withOpacity(0.8),
          ),
        ),
        SizedBox(height: Dimensions.h(20)),

        // ── Reason For Contact
        AppTextField(
          controller: controller.reasonController,
          label: AppStrings.reasonForContact.tr,
          hint: AppStrings.reasonForContactHint.tr,
          validator: (v) => (v == null || v.isEmpty) ? AppStrings.pleaseEnterReason.tr : null,
        ),

        SizedBox(height: Dimensions.h(18)),

        // ── Description (multiline)
        AppTextField(
          controller: controller.descriptionController,
          label: AppStrings.description.tr,
          hint: AppStrings.descriptionHint.tr,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          validator: (v) => (v == null || v.isEmpty) ? AppStrings.pleaseEnterDescription.tr : null,
        ),

        SizedBox(height: Dimensions.h(32)),

        // ── Send Message Button
        AppButton(
          label: AppStrings.sendMessage.tr,
          onPressed: controller.sendMessage,
          backgroundColor: AppColors.blackColor,
          textColor: AppColors.primaryColor,
          borderSideColor: AppColors.blackColor,
          height: Dimensions.h(54),
          borderRadius: Dimensions.r(16),
        ),
      ],
    );
  }
}
