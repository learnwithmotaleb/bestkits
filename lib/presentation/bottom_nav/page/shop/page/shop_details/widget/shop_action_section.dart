import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/utils/app_colors/app_colors.dart';
import 'package:bestkits/widget/app_button.dart';
import '../controller/shop_details_controller.dart';
import 'package:bestkits/data/model/product_model.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';

class ShopActionSection extends StatelessWidget {
  final ShopDetailsController controller;
  final ProductModel product;

  const ShopActionSection({
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
        // ── Variant Selection ─────────────────────────────────────────────────
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
                    onTap: () => controller.selectVariant(variant.variantName),
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
                        variant.variantName,
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
          const SizedBox(height: 20),
        ],

        // ── Actions ───────────────────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: Obx(() {
                return AppButton(
                  label: 'Add to Cart',
                  isLoading: controller.isAddingToCart.value,
                  onPressed: controller.addToCart,
                  backgroundColor: const Color(0xFF1A1A1A),
                  textColor: AppColors.primaryColor,
                  leadingIcon: Icon(Icons.shopping_bag_outlined,
                      color: AppColors.primaryColor, size: 18),
                  borderRadius: 12,
                  height: 50,
                );
              }),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Obx(() {
                return AppButton(
                  label: 'Order Now',
                  isLoading: controller.isOrderingNow.value,
                  onPressed: controller.orderNow,
                  backgroundColor: AppColors.primaryColor,
                  textColor: Colors.black,
                  leadingIcon:
                      const Icon(Icons.bolt, color: Colors.black, size: 20),
                  borderRadius: 12,
                  height: 50,
                  borderSideColor: AppColors.primaryColor,
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: Color(0xFFF5F5F5)),
      ],
    );
  }
}
