import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/static_strings/static_strings.dart';

class FaqItem {
  final String question;
  final String? answer;

  const FaqItem({required this.question, this.answer});
}

class HelpSupportController extends GetxController {
  final reasonController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxInt expandedIndex = (-1).obs;

  final List<FaqItem> faqs = [
    FaqItem(
      question: AppStrings.faqQuestion1.tr,
      answer: AppStrings.faqAnswer1.tr,
    ),
    FaqItem(
      question: AppStrings.faqQuestion2.tr,
      answer: AppStrings.faqAnswerDefault.tr,
    ),
    FaqItem(
      question: AppStrings.faqQuestion3.tr,
      answer: AppStrings.faqAnswerDefault.tr,
    ),
    FaqItem(
      question: AppStrings.faqQuestion4.tr,
      answer: AppStrings.faqAnswerDefault.tr,
    ),
    FaqItem(
      question: AppStrings.faqQuestion5.tr,
      answer: AppStrings.faqAnswerDefault.tr,
    ),
  ];

  void toggleFaq(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }

  void sendMessage() {
    if (formKey.currentState?.validate() ?? false) {
      // TODO: handle send
    }
  }

  @override
  void onClose() {
    reasonController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
