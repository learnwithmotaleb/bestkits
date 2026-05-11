import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  final List<FaqItem> faqs = const [
    FaqItem(
      question: '— How does BestKid ensure product safety and quality?',
      answer:
      'All listings go through clear seller guidelines and community-based trust signals such as ratings and reviews. Sellers are encouraged to provide accurate descriptions and real product images, helping buyers make informed and confident decisions.',
    ),
    FaqItem(question: '— How does the payment system work?'),
    FaqItem(question: '— Can I return or refund a product if I am not satisfied?'),
    FaqItem(question: '— How does BestKid ensure product safety and quality?'),
    FaqItem(question: '— What fees or commission does BestKid charge?'),
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
