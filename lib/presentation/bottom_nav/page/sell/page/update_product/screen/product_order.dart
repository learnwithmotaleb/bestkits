import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../../../utils/static_strings/static_strings.dart';
import '../../../../../../../widget/custom_appbar.dart';
import 'order_details_screen.dart';

class ProductOrder extends StatefulWidget {
  const ProductOrder({super.key});

  @override
  State<ProductOrder> createState() => _ProductOrderState();
}

class _ProductOrderState extends State<ProductOrder> {
  // Dummy order list
  final List<Map<String, dynamic>> orders = [
    {
      'orderId': 'KDF143625879',
      'date': '27 Aug 2020 - 06:20 AM',
      'status': 'Order Placed',
    },
    {
      'orderId': 'DDF143625869',
      'date': '27 Aug 2020 - 06:20 AM',
      'status': 'Order Placed',
    },
    {
      'orderId': 'ABF143625812',
      'date': '25 Aug 2020 - 10:45 AM',
      'status': 'Confirmed',
    },
    {
      'orderId': 'XYZ143625744',
      'date': '20 Aug 2020 - 08:15 AM',
      'status': 'Delivered',
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'Confirmed':
      case 'Delivered':
        return const Color(0xFF4CAF50);
      case 'Canceled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: CommonAppBar(
        title: AppStrings.productOrdersTitle.tr,
        backgroundColor: const Color(0xFFF4F4F4),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.w(20),
          vertical: Dimensions.h(15),
        ),
        itemCount: orders.length,
        separatorBuilder: (_, __) => Dimensions.gapH(12),
        itemBuilder: (context, index) {
          final order = orders[index];
          final statusColor = _statusColor(order['status']);

          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(Dimensions.w(15)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.r(15)),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order ID & status row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppStrings.orderIdLabelWithDash.tr}${order['orderId']}',
                            style: TextStyle(
                              fontSize: Dimensions.fs(13),
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          Dimensions.gapH(4),
                          Text(
                            order['date'],
                            style: TextStyle(
                              fontSize: Dimensions.fs(10),
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.w(8),
                        vertical: Dimensions.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Dimensions.r(20)),
                      ),
                      child: Text(
                        '• ${order['status'].toString().tr}',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: Dimensions.fs(9),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Dimensions.gapH(14),

                // View Details Button
                GestureDetector(
                  onTap: () {
                    Get.to(() => const OrderDetailsScreen(),
                        arguments: order);
                  },
                  child: Container(
                    height: Dimensions.h(44),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1B1B),
                      borderRadius: BorderRadius.circular(Dimensions.r(10)),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.viewDetailsBtn.tr,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: Dimensions.fs(13),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Dimensions.gapW(6),
                        Icon(
                          Icons.double_arrow_rounded,
                          color: AppColors.primaryColor,
                          size: Dimensions.icon(16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
