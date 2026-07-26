import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../controller/cart_controller.dart';
import '../model/CartModel.dart';

class CartItemCard extends StatelessWidget {
  final Items item;
  final CartController controller;

  const CartItemCard({super.key, required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    final imageUrl = ApiUrl.buildImageUrl(
        item.product?.imageUrls != null && item.product!.imageUrls!.isNotEmpty
            ? item.product!.imageUrls!.first
            : null);

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: AppColors.primaryColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: imageUrl.isNotEmpty
                      ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image))
                      : const Icon(Icons.image_not_supported),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Remove Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.product?.name ?? 'Unknown Product',
                            maxLines: 2,
                            style: AppTextStyles.h4.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Remove Button
                        GestureDetector(
                          onTap: () {
                            if (item.id != null) {
                              controller.removeItem(item.id.toString());
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.delete_outline, color: Colors.red, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  AppStrings.remove.tr,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Size / Variant Row
          Row(
            children: [
              Text(
                '${AppStrings.sizeVariant.tr} :- ',
                style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.primaryColor.withOpacity(0.4)),
                ),
                child: Text(
                  item.variant?.variantName ?? 'N/A',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Quantity Row
          Row(
            children: [
              Text(
                '${AppStrings.quantityLabel.tr} :- ',
                style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
              ),
              Container(
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        if (item.id != null && (item.quantity ?? 1) > 1) {
                          controller.updateQty(item.id.toString(), (item.quantity ?? 1).toInt() - 1);
                        }
                      },
                      child: Container(
                        width: 30,
                        alignment: Alignment.center,
                        child: Icon(Icons.remove, color: AppColors.primaryColor, size: 14),
                      ),
                    ),
                    Container(
                      width: 28,
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Text(
                        '${item.quantity ?? 1}',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (item.id != null) {
                          controller.updateQty(item.id.toString(), (item.quantity ?? 1).toInt() + 1);
                        }
                      },
                      child: Container(
                        width: 30,
                        alignment: Alignment.center,
                        child: Icon(Icons.add, color: AppColors.primaryColor, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Price Row
          Row(
            children: [
              Text(
                '€${item.price ?? 0}',
                style: AppTextStyles.h3.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
