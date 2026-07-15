import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';
import '../../../../widget/app_button.dart';
import '../controller/product_details_controller.dart';
import 'package:bestkits/data/model/product_model.dart';

class ProductActionSection extends StatelessWidget {
  final ProductDetailsController controller;
  final ProductModel product;

  const ProductActionSection({
    super.key,
    required this.controller,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final variants = product.variants;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Variant Selection
        if (variants.isNotEmpty) ...[
          Text(
            '${AppStrings.variant.tr} -',
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
              itemCount: variants.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return Obx(() {
                  final variant = variants[index];
                  final isSelected =
                      controller.selectedVariant.value == variant.variantName;
                  return GestureDetector(
                    onTap: () =>
                        controller.selectVariant(variant.variantName),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 15),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            variant.variantName,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.grey[500],
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
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
          const SizedBox(height: 20),
        ],

        // Quantity Selection
        Text(
          '${AppStrings.quantity.tr} -',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 150,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: controller.decrementQuantity,
                icon: Icon(Icons.remove,
                    color: AppColors.primaryColor, size: 18),
              ),
              Expanded(
                child: Container(
                  height: double.infinity,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Obx(() => Text(
                        '${controller.quantity.value}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      )),
                ),
              ),
              IconButton(
                onPressed: controller.incrementQuantity,
                icon: Icon(Icons.add,
                    color: AppColors.primaryColor, size: 18),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),

        // Buttons Row
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: AppStrings.addToCart.tr,
                onPressed: () {
                  Get.snackbar(
                    'Success',
                    'Product added to cart successfully',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                backgroundColor: const Color(0xFF1A1A1A),
                textColor: AppColors.primaryColor,
                leadingIcon: Icon(Icons.shopping_bag_outlined,
                    color: AppColors.primaryColor, size: 18),
                borderRadius: 12,
                height: 50,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: AppButton(
                label: AppStrings.orderNow.tr,
                onPressed: () {
                  Get.toNamed(RoutePath.checkOut);
                },
                backgroundColor: AppColors.primaryColor,
                textColor: Colors.black,
                leadingIcon:
                    const Icon(Icons.bolt, color: Colors.black, size: 18),
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
