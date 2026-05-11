import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/static_strings/static_strings.dart';

import '../controller/checkout_controller.dart';

class CheckoutOrderItems extends StatelessWidget {
  final CheckoutController controller;

  const CheckoutOrderItems({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final cart = controller.cartController;

    return Column(
      children: controller.cartController.sellers.map((seller) {
        final items = cart.itemsBySeller(seller);
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seller row
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '- $seller',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic),
                    ),
                    Text(
                      '${AppStrings.totalAmount.tr} : €${items.fold(0.0, (s, i) => s + double.parse(i.price) * i.quantity.value).toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 11, color: AppColors.blackColor),
                    ),
                  ],
                ),
              ),
              const Divider(height: 2, thickness: 0.2,),

              // Products
              ...items.map((item) => Obx(() => Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyColor.withOpacity(0.5), width: 1),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.primaryColor, width: 1)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Image.asset(item.image, fit: BoxFit.contain),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${AppStrings.quantity.tr} :- ${item.quantity.value} • ${AppStrings.size.tr} / ${AppStrings.variant.tr} :- ${item.selectedSize.value}',
                                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '€${(double.parse(item.price) * item.quantity.value).toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              ))),

              // Delivery selection
              if (controller.deliveryOptions.containsKey(seller)) ...[
                Obx(() => Column(
                      children: controller.deliveryOptions[seller]!.map((option) {
                        final isSelected = controller.selectedDelivery[seller] == option.type;
                        return GestureDetector(
                          onTap: () => controller.selectDelivery(seller, option.type),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.navBarColor : const Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? AppColors.primaryColor : Colors.grey,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              option.label,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 13,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              option.badge,
                                              style: TextStyle(fontSize: 9, color: Colors.grey[400]),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(fontSize: 10, color: Colors.grey[400], fontStyle: FontStyle.italic),
                                            children: [
                                              TextSpan(text: '${AppStrings.deliveryPartner.tr} - '),
                                              TextSpan(
                                                text: option.partner,
                                                style: TextStyle(color: Colors.grey[700]),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(fontSize: 10, color: Colors.grey[400], fontStyle: FontStyle.italic),
                                            children: [
                                              TextSpan(text: '${AppStrings.estimatedTime.tr} - '),
                                              TextSpan(
                                                text: option.time,
                                                style: TextStyle(color: Colors.grey[700]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '€${option.price}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                          ),
                        );
                      }).toList(),
                    )),
                const SizedBox(height: 10),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
