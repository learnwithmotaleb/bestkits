import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../widget/app_button.dart';
import '../controller/cart_controller.dart';
import 'cart_item_card.dart';

class SellerCartGroup extends StatelessWidget {
  final String seller;
  final CartController controller;

  const SellerCartGroup({
    super.key,
    required this.seller,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.itemsBySeller(seller);
      if (items.isEmpty) return const SizedBox();

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seller Header
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    seller,
                    style: AppTextStyles.h4.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.arrow_forward_ios, size: 10, color: Colors.grey[400]),
                  Icon(Icons.arrow_forward_ios, size: 10, color: Colors.grey[400]),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),

            // Items
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF0F0F0)),
              itemBuilder: (context, index) {
                return CartItemCard(item: items[index], controller: controller);
              },
            ),
          ],
        ),
      );
    });
  }
}
