import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../controller/order_controller.dart';
import '../widget/order_list_view.dart';
import '../widget/order_details_view.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());

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
              child: Obx(() {
                final isDetailsView = controller.selectedOrder.value != null;
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (isDetailsView) {
                          controller.backToList();
                        } else {
                          // Usually Get.back() if pushed, but here maybe just stays or nothing.
                        }
                      },
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
                      AppStrings.myOrders.tr,
                      style: AppTextStyles.h3.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 38),
                  ],
                );
              }),
            ),

            // ── Tabs ────────────────────────────────────────────────
            Obx(() {
              if (controller.selectedOrder.value != null) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.w(16)),
                child: Row(
                  children: List.generate(
                    controller.tabs.length,
                    (index) => Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeTab(index),
                        child: Container(
                          height: 40,
                          margin: EdgeInsets.only(right: index < controller.tabs.length - 1 ? 8 : 0),
                          decoration: BoxDecoration(
                            color: controller.selectedTab.value == index ? const Color(0xFF1A1A1A) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: controller.selectedTab.value == index ? const Color(0xFF1A1A1A) : Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            controller.tabs[index].tr,
                            style: TextStyle(
                              color: controller.selectedTab.value == index ? AppColors.primaryColor : Colors.grey,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            
            Obx(() => controller.selectedOrder.value == null ? const SizedBox(height: 16) : const SizedBox(height: 4)),

            // ── Body ────────────────────────────────────────────────
            Expanded(
              child: Obx(() {
                if (controller.selectedOrder.value != null) {
                  return OrderDetailsView(
                    order: controller.selectedOrder.value!,
                    controller: controller,
                  );
                }
                return OrderListView(controller: controller);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
