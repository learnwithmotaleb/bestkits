import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../controller/order_controller.dart';

class OrderListView extends StatelessWidget {
  final OrderController controller;

  const OrderListView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF1A1A1A),
            strokeWidth: 2.5,
          ),
        );
      }

      final orders = controller.currentTabOrders;
      if (orders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox, size: 60, color: Colors.grey[300]),
              const SizedBox(height: 10),
              Text(
                '${AppStrings.noOrderFound.tr} (${controller.tabs[controller.selectedTab.value].tr})',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic),
              )
            ],
          ),
        );
      }

      return ListView.builder(
        padding:
            EdgeInsets.symmetric(horizontal: Dimensions.w(16), vertical: 10),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '- ${AppStrings.orderIdLabel.tr}: ${order.displayId ?? ""}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            fontStyle: FontStyle.italic),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: order.status == 'DELIVERED'
                            ? Colors.green.withOpacity(0.1)
                            : (order.status == 'CANCELLED'
                                ? Colors.red.withOpacity(0.1)
                                : Colors.blue.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '• ${order.statusLabel ?? ""}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: order.status == 'DELIVERED'
                              ? Colors.green
                              : (order.status == 'CANCELLED'
                                  ? Colors.red
                                  : Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  order.createdAt ?? "",
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[400],
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => controller.viewOrderDetails(order),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppStrings.viewDetails.tr,
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
