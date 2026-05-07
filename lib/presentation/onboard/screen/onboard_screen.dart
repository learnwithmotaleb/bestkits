import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_button.dart';
import '../controller/onboard_controller.dart';
import '../widget/onboard_page.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        return Stack(
          children: [
            // ── PageView ────────────────────────────────────────
            PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: controller.pages.length,
              itemBuilder: (context, index) {
                final page = controller.pages[index];
                return OnboardPage(
                  image: page['image']!,
                  title: page['title']!,
                  subtitle: page['subtitle']!,
                );
              },
            ),

            // ── Bottom Navigation ───────────────────────────────
            Positioned(
              bottom: Dimensions.h(48),
              left: Dimensions.w(20),
              right: Dimensions.w(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip Button
                  Expanded(
                    child: AppButton(
                      label: AppStrings.skip.tr,
                      onPressed: controller.skip,
                      backgroundColor: const Color(0xFFFEF7E5),
                      textColor: const Color(0xFFFFB000),
                      borderSideColor: const Color(0xFFFEF7E5),
                      borderRadius: Dimensions.r(25),
                      height: Dimensions.h(45),
                    ),
                  ),
                  Dimensions.gapW(15),
                  // Next Button
                  Expanded(
                    child: AppButton(
                      label: controller.isLastPage ? AppStrings.getStarted.tr : AppStrings.next.tr,
                      onPressed: controller.nextPage,
                      backgroundColor: AppColors.blackColor,
                      textColor: const Color(0xFFFFB000),
                      borderSideColor: AppColors.blackColor,
                      borderRadius: Dimensions.r(25),
                      height: Dimensions.h(45),
                      trailingIcon: Icon(
                        Icons.arrow_forward,
                        color: const Color(0xFFFFB000),
                        size: Dimensions.w(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}


