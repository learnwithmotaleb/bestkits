import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';
import '../../../widget/app_button.dart';
import '../../../widget/app_text_field.dart';
import '../controller/help_support_controller.dart';
import '../widget/faq_item_widget.dart';


class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HelpSupportController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EC),
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
              child: const Icon(Icons.arrow_back, color: Colors.black54, size: 20),
            ),
          ),
        ),
        title: Text(
          'Help & Support',
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: Dimensions.fs(18),
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.w(18),
            vertical: Dimensions.h(8),
          ),
          children: [
            // ── FAQ Section Header
            Text(
              '— Frequently Asked Questions',
              style: AppTextStyles.h3.copyWith(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: Dimensions.h(14)),

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

            SizedBox(height: Dimensions.h(24)),

            // ── Contact Us Section
            ContactUsSection(controller: controller),

            SizedBox(height: Dimensions.h(24)),
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
          '— Contact Us',
          style: AppTextStyles.h3.copyWith(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: Dimensions.h(16)),

        // ── Reason For Contact
        AppTextField(
          controller: controller.reasonController,
          label: 'Reason For Contact',
          hint: 'Enter the Reason for Contact',
          validator: (v) => (v == null || v.isEmpty) ? 'Please enter a reason' : null,
        ),

        SizedBox(height: Dimensions.h(16)),

        // ── Description (multiline)
        AppTextField(
          controller: controller.descriptionController,
          label: 'Description',
          hint: 'Please describe your issue or question in detail',
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          validator: (v) => (v == null || v.isEmpty) ? 'Please enter a description' : null,
        ),

        SizedBox(height: Dimensions.h(24)),

        // ── Send Message Button
        AppButton(
          label: 'Send message',
          onPressed: controller.sendMessage,
          backgroundColor: AppColors.blackColor,
          textColor: AppColors.primaryColor,
          borderSideColor: AppColors.blackColor,
          height: Dimensions.h(52),
          borderRadius: Dimensions.r(14),
        ),
      ],
    );
  }
}