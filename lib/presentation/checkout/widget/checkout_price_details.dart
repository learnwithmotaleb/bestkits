import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/static_strings/static_strings.dart';

import '../controller/checkout_controller.dart';

class CheckoutPriceDetails extends StatelessWidget {
  final CheckoutController controller;

  const CheckoutPriceDetails({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '- ${AppStrings.priceDetails.tr}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFF0F0F0)),
              const SizedBox(height: 12),

              // Per-item breakdown
              ...controller.cartController.cartItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  item.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'x${item.quantity.value}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '€${(double.parse(item.price) * item.quantity.value).toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )),

              const Divider(height: 1, color: Color(0xFFF0F0F0)),
              const SizedBox(height: 12),

              // Subtotal
              _row(AppStrings.subtotal.tr, null, '€${controller.subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _row(AppStrings.shippingFee.tr, 'x${controller.cartController.sellers.length}', '€${controller.shippingTotal.toStringAsFixed(2)}'),
              if (controller.isCouponApplied.value) ...[
                const SizedBox(height: 8),
                _row(
                  'Discount',
                  '${controller.discountPercentage.value.toInt()}%',
                  '-€${controller.discountAmount.toStringAsFixed(2)}',
                  isDiscount: true,
                ),
              ],
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFF0F0F0)),
              const SizedBox(height: 12),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppStrings.total.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  Text(
                    '€${controller.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _row(String label, String? suffix, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (suffix != null) ...[
              const SizedBox(width: 4),
              Text(
                suffix,
                style: TextStyle(
                  fontSize: 11,
                  color: isDiscount ? const Color(0xFF2E7D32) : AppColors.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ]
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: isDiscount ? const Color(0xFF2E7D32) : Colors.black,
          ),
        ),
      ],
    );
  }
}
