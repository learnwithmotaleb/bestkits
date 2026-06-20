import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../widget/app_button.dart';
import '../controller/update_product_controller.dart';
import '../screen/order_details_screen.dart';

class ProductActionSection extends StatelessWidget {
  final UpdateProductController controller;

  const ProductActionSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Size Selection
        Text(
          '${AppStrings.sizeVariant.tr} -',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 35,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.sizes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return Obx(() {
                final size = controller.sizes[index];
                final isSelected = controller.selectedSize.value == size;
                return GestureDetector(
                  onTap: () => controller.selectSize(size),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      size,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.grey[500],
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
        const SizedBox(height: 25),

        // Buttons Row
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Update Product',
                onPressed: () {
                  controller.updateProduct();
                },
                backgroundColor: const Color(0xFF1A1A1A),
                textColor: AppColors.primaryColor,
                leadingIcon: Icon(Icons.edit_outlined,
                    color: AppColors.primaryColor, size: 18),
                borderRadius: 12,
                height: 50,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: AppButton(
                label: "View Order's",
                onPressed: () {
                  Get.to(() => const OrderDetailsScreen());
                },
                backgroundColor: AppColors.primaryColor,
                textColor: Colors.black,
                leadingIcon: const Icon(Icons.assignment_outlined,
                    color: Colors.black, size: 18),
                borderRadius: 12,
                height: 50,
                borderSideColor: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(color: Color(0xFFF5F5F5)),
      ],
    );
  }
}
