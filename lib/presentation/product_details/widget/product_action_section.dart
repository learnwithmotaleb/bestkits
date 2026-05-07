import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';
import '../../../../widget/app_button.dart';
import '../controller/product_details_controller.dart';

class ProductActionSection extends StatelessWidget {
  final ProductDetailsController controller;

  const ProductActionSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Size Selection
        Text(
          'Size / Variant -',
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
                        color: isSelected ? AppColors.primaryColor : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      size,
                      style: TextStyle(
                        color: isSelected ? AppColors.primaryColor : Colors.grey[500],
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

        // Quantity Selection
        Text(
          'Quantity -',
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
                icon: Icon(Icons.remove, color: AppColors.primaryColor, size: 18),
              ),
              Expanded(
                child: Container(
                  height: double.infinity,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Obx(() => Text(
                        '${controller.quantity.value}',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      )),
                ),
              ),
              IconButton(
                onPressed: controller.incrementQuantity,
                icon: Icon(Icons.add, color: AppColors.primaryColor, size: 18),
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
                label: 'Add to Cart',
                onPressed: () {},
                backgroundColor: const Color(0xFF1A1A1A),
                textColor: AppColors.primaryColor,
                leadingIcon: Icon(Icons.shopping_bag_outlined, color: AppColors.primaryColor, size: 18),
                borderRadius: 12,
                height: 50,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: AppButton(
                label: 'Order Now',
                onPressed: () {},
                backgroundColor: AppColors.primaryColor,
                textColor: Colors.black,
                leadingIcon: const Icon(Icons.bolt, color: Colors.black, size: 18),
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
