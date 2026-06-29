import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:bestkits/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../controller/cart_controller.dart';
import '../widget/cart_order_summary.dart';
import '../widget/seller_cart_group.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: CommonAppBar(
        title: AppStrings.cartTitle.tr,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // My Cart count + Empty Cart row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
            child: Obx(() => Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.greyColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          AppStrings.myCart.tr,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.navBarColor,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppColors.primaryColor.withOpacity(0.4)),
                          ),
                          child: Text(
                            '${controller.totalItemCount}'.padLeft(2, '0'),
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () =>
                              _showEmptyCartDialog(context, controller),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.shopping_bag_outlined,
                                    color: Colors.red, size: 14),
                                const SizedBox(width: 5),
                                Text(
                                  AppStrings.emptyCart.tr,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          const SizedBox(height: 16),

          // Scrollable content
          Expanded(
            child: Obx(() {
              if (controller.cartItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined,
                          size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.cartEmptyMessage.tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.w(16)),
                child: Column(
                  children: [
                    // Seller groups
                    ...controller.sellers.map(
                      (seller) => SellerCartGroup(
                        seller: seller,
                        controller: controller,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Order Summary
                    CartOrderSummary(controller: controller),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showEmptyCartDialog(BuildContext context, CartController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppStrings.emptyCartConfirmTitle.tr,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        content: Text(AppStrings.emptyCartConfirmSubtitle.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppStrings.cancel.tr,
                style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              controller.emptyCart();
              Get.back();
            },
            child: Text(AppStrings.yesEmpty.tr,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
