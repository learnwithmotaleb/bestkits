import 'package:bestkits/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_button.dart';
import '../controller/currency_preference_controller.dart';

class CurrencyPreferenceScreen extends StatefulWidget {
  const CurrencyPreferenceScreen({super.key});

  @override
  State<CurrencyPreferenceScreen> createState() => _CurrencyPreferenceScreenState();
}

class _CurrencyPreferenceScreenState extends State<CurrencyPreferenceScreen> {
  final CurrencyPreferenceController controller = Get.put(CurrencyPreferenceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: CommonAppBar(
        title: AppStrings.currencyPreference.tr,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.w(20),
            vertical: Dimensions.h(20),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: controller.currencies.length,
                  separatorBuilder: (context, index) => SizedBox(height: Dimensions.h(16)),
                  itemBuilder: (context, index) {
                    final currency = controller.currencies[index];
                    return Obx(() {
                      final isSelected = controller.selectedCurrency.value == currency['name'];
                      return GestureDetector(
                        onTap: () => controller.selectCurrency(currency['name']!),
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
                                  currency['symbol']!,
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimensions.fs(14),
                                  ),
                                ),
                              ),
                              SizedBox(width: Dimensions.w(12)),
                              Text(
                                currency['name']!,
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
                  },
                ),
              ),
              Obx(() => AppButton(
                label: AppStrings.switchCurrency.tr,
                onPressed: (controller.isChanged && !controller.isLoading.value) ? controller.switchCurrency : null,
                isLoading: controller.isLoading.value,
                backgroundColor: const Color(0xFF1A1A1A),
                textColor: AppColors.primaryColor,
                borderRadius: Dimensions.r(8),
                height: Dimensions.h(50),
              )),
              SizedBox(height: Dimensions.h(20)),
            ],
          ),
        );
      }),

    );
  }
}
