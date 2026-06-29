import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../widget/app_button.dart';
import '../../../../../../presentation/checkout/screen/checkout_screen.dart';
import '../controller/cart_controller.dart';

class CartOrderSummary extends StatelessWidget {
  final CartController controller;

  const CartOrderSummary({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                '- ${AppStrings.orderSummary.tr}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFF0F0F0)),
              const SizedBox(height: 12),

              // Item lines
              ...controller.cartItems.map((item) => Padding(
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
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'x${item.quantity.value}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '€${(double.parse(item.price) * item.quantity.value).toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  )),

              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFF0F0F0)),
              const SizedBox(height: 12),

              // Subtotal
              _summaryRow(AppStrings.subtotal.tr, '€${controller.subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: 8),

              // Shipping
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('${AppStrings.shippingFee.tr} ', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      Text(
                        'x${controller.totalItemCount}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '€${controller.shippingFee.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFF0F0F0)),
              const SizedBox(height: 12),

              // Total
              _summaryRow(AppStrings.total.tr, '€${controller.total.toStringAsFixed(2)}', bold: true),
              const SizedBox(height: 20),

              // Proceed to Checkout
              AppButton(
                label: AppStrings.proceedToCheckout.tr,
                onPressed: () => Get.to(() => const CheckoutScreen()),
                backgroundColor: const Color(0xFF1A1A1A),
                textColor: AppColors.primaryColor,
                borderSideColor: const Color(0xFF1A1A1A),
                leadingIcon: Icon(Icons.shopping_bag_outlined, color: AppColors.primaryColor, size: 18),
                borderRadius: 12,
                height: 52,
              ),
              const SizedBox(height: 12),

              // Continue Shopping
              AppButton(
                label: AppStrings.continueShopping.tr,
                onPressed: () => Get.back(),
                backgroundColor: AppColors.navBarColor,
                textColor: AppColors.primaryColor,
                borderSideColor: AppColors.navBarColor,
                borderRadius: 12,
                height: 50,
              ),
            ],
          ),
        ));
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: bold ? Colors.black : Colors.grey,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 16 : 13,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
