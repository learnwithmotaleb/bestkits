import 'package:bestkits/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_button.dart';
import '../controller/language_preference_controller.dart';

class LanguagePreferenceScreen extends StatefulWidget {
  const LanguagePreferenceScreen({super.key});

  @override
  State<LanguagePreferenceScreen> createState() => _LanguagePreferenceScreenState();
}

class _LanguagePreferenceScreenState extends State<LanguagePreferenceScreen> {
  final LanguagePreferenceController controller = Get.put(LanguagePreferenceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: CommonAppBar(
        title: AppStrings.languagePreference.tr,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.w(20),
          vertical: Dimensions.h(20),
        ),
        child: Column(
          children: [
            _buildLanguageItem(
              code: "EN",
              name: AppStrings.english.tr,
              langKey: "en",
            ),
            SizedBox(height: Dimensions.h(16)),
            _buildLanguageItem(
              code: "BG",
              name: AppStrings.bulgarian.tr,
              langKey: "bg",
            ),
            const Spacer(),
            Obx(() => AppButton(
              label: AppStrings.switchLanguage.tr,
              onPressed: (controller.isChanged && !controller.isLoading.value) ? controller.switchLanguage : null,
              isLoading: controller.isLoading.value,
              backgroundColor: const Color(0xFF1A1A1A),
              textColor: AppColors.primaryColor,
              borderRadius: Dimensions.r(8),
              height: Dimensions.h(50),
            )),
            SizedBox(height: Dimensions.h(20)),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem({required String code, required String name, required String langKey}) {
    return Obx(() {
      final isSelected = controller.selectedLanguage.value == langKey;
      return GestureDetector(
        onTap: () => controller.selectLanguage(langKey),
        child: Container(
          padding: EdgeInsets.all(Dimensions.r(12)),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(Dimensions.r(10)),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : AppColors.greyColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: Dimensions.h(32),
                width: Dimensions.h(32),
                decoration: BoxDecoration(
                  color: AppColors.blackColor,
                  borderRadius: BorderRadius.circular(Dimensions.r(6)),
                ),
                alignment: Alignment.center,
                child: Text(
                  code,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.fs(12),
                  ),
                ),
              ),
              SizedBox(width: Dimensions.w(12)),
              Text(
                name,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: Dimensions.fs(14),
                  color: AppColors.blackColor,
                ),
              ),
              const Spacer(),
              if (isSelected)
                Icon(
                  Icons.wb_sunny_rounded,
                  color: AppColors.primaryColor,
                  size: Dimensions.rs(18),
                )
              else
                Container(
                  height: Dimensions.h(18),
                  width: Dimensions.h(18),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.greyColor.withOpacity(0.5)),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

