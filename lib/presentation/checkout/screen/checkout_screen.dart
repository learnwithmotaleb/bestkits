import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../widget/app_button.dart';
import '../../bottom_nav/page/cart/controller/cart_controller.dart';
import '../controller/checkout_controller.dart';
import '../widget/checkout_address_section.dart';
import '../widget/checkout_order_items.dart';
import '../widget/checkout_price_details.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(20),
                vertical: Dimensions.h(14),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.navBarColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, size: 18, color: Colors.black54),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Checkout',
                    style: AppTextStyles.h3.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 38),
                ],
              ),
            ),

            // ── Scrollable Body ─────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.w(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Summary header row
                    Obx(() {
                      final count = controller.cartController.totalItemCount;
                      return Row(
                        children: [
                          const Text(
                            'Order Summary',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.navBarColor,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.primaryColor.withOpacity(0.4)),
                            ),
                            child: Text(
                              '$count'.padLeft(2, '0'),
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 14),

                    // Order Items + Delivery Selection per seller
                    CheckoutOrderItems(controller: controller),
                    const SizedBox(height: 8),

                    // Delivery Address
                    CheckoutAddressSection(controller: controller),
                    const SizedBox(height: 14),

                    // Terms & Conditions
                    Obx(() => Row(
                          children: [
                            Checkbox(
                              value: controller.termsAgreed.value,
                              onChanged: controller.toggleTerms,
                              activeColor: const Color(0xFF1A1A1A),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  children: [
                                    const TextSpan(text: 'I Agree To The '),
                                    TextSpan(
                                      text: 'Terms & Conditions',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    const TextSpan(text: ' And '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    const TextSpan(text: ' Of BestKid.'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: 14),

                    // Price Details
                    CheckoutPriceDetails(controller: controller),
                    const SizedBox(height: 20),

                    // Proceed To Pay button
                    Obx(() => AppButton(
                          label: 'Proceed To Pay',
                          onPressed: controller.termsAgreed.value
                              ? () {
                                  Get.snackbar(
                                    'Order Placed!',
                                    'Your order has been placed successfully.',
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: const Color(0xFF1A1A1A),
                                    colorText: AppColors.primaryColor,
                                    borderRadius: 12,
                                    margin: const EdgeInsets.all(16),
                                    icon: Icon(Icons.check_circle, color: AppColors.primaryColor),
                                  );
                                }
                              : null,
                          backgroundColor: const Color(0xFF1A1A1A),
                          textColor: AppColors.primaryColor,
                          borderSideColor: const Color(0xFF1A1A1A),
                          leadingIcon: Icon(Icons.bolt, color: AppColors.primaryColor, size: 18),
                          borderRadius: 12,
                          height: 52,
                        )),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
