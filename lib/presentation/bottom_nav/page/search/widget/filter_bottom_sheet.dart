import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../widget/bottom_sheet_textfield.dart';
import '../../../../../widget/app_button.dart';
import '../controller/search_controller.dart';

class FilterBottomSheet extends StatelessWidget {
  final AppSearchController controller;

  const FilterBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter',
                    style: AppTextStyles.h2.copyWith(fontSize: 22),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, size: 24, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Refine products by category, size, brand, price, and more.',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
              const SizedBox(height: 20),


              BottomSheetTextField(
                controller: controller.categoryController,
                label: 'Select Category',
                items: controller.categories,
                hint: 'Select Category',
              ),
              const SizedBox(height: 18),


              BottomSheetTextField(
                controller: controller.subcategoryController,
                label: 'Select Subcategory',
                items: controller.subcategories,
                hint: 'Select Subcategory',
              ),
              const SizedBox(height: 18),


              BottomSheetTextField(
                controller: controller.sortByController,
                label: 'Sort By',
                items: controller.sortByOptions,
                hint: 'Sort By',
              ),
              const SizedBox(height: 18),

              // Price Range
              Text('Price Range', style: AppTextStyles.h4.copyWith(fontSize: 14)),
              const SizedBox(height: 12),
              Obx(() => Row(
                children: [
                  // Min price
                  Container(
                    width: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    ),
                    child: Text(
                      controller.priceRangeMin.value.toInt().toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Spacer(),
                  const Text('»', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const Spacer(),
                  // Max price
                  Container(
                    width: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    ),
                    child: Text(
                      controller.priceRangeMax.value.toInt().toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 8),
              Obx(() => SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.primaryColor,
                  inactiveTrackColor: AppColors.navBarColor,
                  thumbColor: AppColors.primaryColor,
                  overlayColor: AppColors.primaryColor.withOpacity(0.1),
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                ),
                child: RangeSlider(
                  values: RangeValues(
                    controller.priceRangeMin.value,
                    controller.priceRangeMax.value,
                  ),
                  min: 0,
                  max: 500,
                  onChanged: (values) {
                    controller.priceRangeMin.value = values.start;
                    controller.priceRangeMax.value = values.end;
                  },
                ),
              )),
              const SizedBox(height: 18),

              // Sort By Rating
              Text('Sort By', style: AppTextStyles.h4.copyWith(fontSize: 14)),
              const SizedBox(height: 10),
              Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.ratingOptions.map((rating) {
                  final isSelected = controller.selectedRating.value == rating;
                  return GestureDetector(
                    onTap: () => controller.selectedRating.value = rating,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.navBarColor : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        rating,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppColors.primaryColor : Colors.black87,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
              const SizedBox(height: 28),

              // Buttons
              Row(
                children: [
                  // Reset Filter
                  Expanded(
                    child: AppButton(
                      label: 'Reset Filter',
                      onPressed: () {
                        controller.resetFilter();
                        Get.back();
                      },
                      backgroundColor: Colors.white,
                      textColor: AppColors.redColor,
                      borderSideColor: AppColors.redColor,
                      borderRadius: 12,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Apply Filter
                  Expanded(
                    child: AppButton(
                      label: 'Apply Filter',
                      onPressed: () => controller.applyFilter(),
                      backgroundColor: AppColors.blackColor,
                      textColor: AppColors.primaryColor,
                      borderSideColor: AppColors.blackColor,
                      borderRadius: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
