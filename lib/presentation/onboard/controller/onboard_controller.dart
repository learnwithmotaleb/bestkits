import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/static_strings/static_strings.dart';

class OnboardController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/image/onboard1.jpg',
      'title': AppStrings.onboardingTitle1.tr,
      'subtitle': AppStrings.onboardingSubtitle1.tr,
    },
    {
      'image': 'assets/image/onboard2.jpg',
      'title': AppStrings.onboardingTitle2.tr,
      'subtitle': AppStrings.onboardingSubtitle2.tr,
    },
  ];

  bool get isLastPage => currentPage.value == pages.length - 1;

  void onPageChanged(int index) => currentPage.value = index;

  void nextPage() {
    if (isLastPage) {
      Get.offNamed(RoutePath.forgotPassword);
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() => Get.offNamed(RoutePath.forgotPassword);

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}