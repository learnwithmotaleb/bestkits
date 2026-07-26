import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_button.dart';
import '../../../widget/custom_appbar.dart';
import '../../bottom_nav/page/cart/controller/cart_controller.dart';
import '../controller/checkout_controller.dart';
import '../widget/checkout_address_section.dart';
import '../widget/checkout_coupon_section.dart';
import '../widget/checkout_order_items.dart';
import '../widget/checkout_price_details.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late final CheckoutController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<CheckoutController>()) {
      controller = Get.find<CheckoutController>();
    } else {
      controller = Get.put(CheckoutController());
    }
    // Handle Buy Now arguments and fetch data
    controller.handleArguments(Get.arguments);
    controller.fetchCheckoutSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(
        title: AppStrings.checkout.tr,
      ),
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              // ── Scrollable Body ─────────────────────────────────────
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.w(16),
                          vertical: Dimensions.h(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Order Summary header row
                          Obx(() {
                            // Calculate total unique items (rows) to match Cart logic
                            int uniqueItemsCount = 0;
                            final groups = controller
                                .orderSummary.value?.data?.sellerGroups;
                            if (groups != null) {
                              for (var group in groups) {
                                uniqueItemsCount += (group.items?.length ?? 0);
                              }
                            }

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.greyColor,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    AppStrings.orderSummary.tr,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: AppColors.primaryColor,
                                          width: 1),
                                    ),
                                    child: Text(
                                      '$uniqueItemsCount'.padLeft(2, '0'),
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
                          // Delivery Address
                          // Terms & Conditions
                          Obx(() => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAFAFA),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.1)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Checkbox(
                                        value: controller.termsAgreed.value,
                                        onChanged: controller.toggleTerms,
                                        activeColor: const Color(0xFF1A1A1A),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        side: BorderSide(
                                            color: Colors.grey.shade400,
                                            width: 1),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.black,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600,
                                            height: 1.4,
                                          ),
                                          children: [
                                            const TextSpan(
                                                text: 'I Agree To The '),
                                            TextSpan(
                                              text: 'Terms & Conditions',
                                              style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const TextSpan(text: ' And '),
                                            TextSpan(
                                              text: 'Privacy Policy',
                                              style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const TextSpan(
                                                text: ' Of BestKid.'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 14),

                          // Price Details
                          CheckoutPriceDetails(controller: controller),
                          const SizedBox(height: 14),

                          // Apply Coupon Section
                          CheckoutCouponSection(controller: controller),
                          const SizedBox(height: 20),

                          // Proceed To Pay button
                          Obx(() => AppButton(
                                label: AppStrings.proceedToPay.tr,
                                isLoading: controller.isSubmittingOrder.value,
                                onPressed: controller.termsAgreed.value
                                    ? () {
                                        controller.placeOrder();
                                      }
                                    : null,
                                backgroundColor: const Color(0xFF1A1A1A),
                                textColor: AppColors.primaryColor,
                                borderSideColor: const Color(0xFF1A1A1A),
                                leadingIcon: Icon(Icons.sell,
                                    color: AppColors.primaryColor, size: 18),
                                borderRadius: 12,
                                height: 52,
                              )),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return Container(
                          color: const Color(0xFFF8F8F8),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
