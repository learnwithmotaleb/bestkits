import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../utils/static_strings/static_strings.dart';
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
                    AppStrings.checkout.tr,
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
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: AppColors.greyColor,
                          ),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: [
                            Text(
                              AppStrings.orderSummary.tr,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, fontStyle: FontStyle.italic),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.primaryColor, width: 1),
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
                        ),
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
                                    TextSpan(text: AppStrings.iAgreeToThe.tr),
                                    TextSpan(
                                      text: AppStrings.termsCondition.tr,
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    TextSpan(text: AppStrings.andText.tr),
                                    TextSpan(
                                      text: AppStrings.privacyPolicy.tr,
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    TextSpan(text: AppStrings.ofBestKid.tr),
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
                          label: AppStrings.proceedToPay.tr,
                          onPressed: controller.termsAgreed.value
                              ? () {
                                  Get.snackbar(
                                    AppStrings.orderPlaced.tr,
                                    AppStrings.orderPlacedSuccess.tr,
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
                          leadingIcon: Icon(Icons.sell, color: AppColors.primaryColor, size: 18),
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
