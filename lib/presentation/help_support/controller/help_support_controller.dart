import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../../service/api_service.dart';
import '../../../../service/api_url.dart';
import '../../../../widget/show_snackbar.dart';
import '../model/FAQModel.dart';

class FaqItem {
  final String question;
  final String? answer;

  const FaqItem({required this.question, this.answer});
}

class HelpSupportController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final reasonController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxInt expandedIndex = (-1).obs;
  final RxList<FaqItem> faqs = <FaqItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isFaqLoading = false.obs;

  final ApiClient _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    _loadStaticFaqs();
    fetchFaqs();
  }

  void _loadStaticFaqs() {
    faqs.assignAll([
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
    ]);
  }

  void toggleFaq(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }

  Future<void> fetchFaqs() async {
    isFaqLoading.value = true;
    try {
      final response = await _apiClient.get(
        url: ApiUrl.fag,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final faqModel = FaqModel.fromJson(response.body);
        if (faqModel.success == true && faqModel.data != null) {
          final items = faqModel.data!
              .map((e) => FaqItem(
                    question: e.question ?? '',
                    answer: e.answer ?? '',
                  ))
              .toList();
          faqs.assignAll(items);
        }
      }
    } catch (e) {
      print("Error fetching FAQs: $e");
    } finally {
      isFaqLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    if (formKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      try {
        final body = {
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneController.text.trim(),
          "subject": reasonController.text.trim(),
          "message": descriptionController.text.trim(),
        };

        final response = await _apiClient.post(
          url: ApiUrl.helpAndSupport,
          body: body,
          isToken: false,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ShowAppSnackBar.success("Message sent successfully!");
          nameController.clear();
          emailController.clear();
          phoneController.clear();
          reasonController.clear();
          descriptionController.clear();
        } else {
          String errMsg = "Failed to send message";
          if (response.body is Map && response.body['message'] != null) {
            errMsg = response.body['message'].toString();
          }
          ShowAppSnackBar.error(errMsg);
        }
      } catch (e) {
        print("Error sending message: $e");
        ShowAppSnackBar.error("An error occurred while sending message.");
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    reasonController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
