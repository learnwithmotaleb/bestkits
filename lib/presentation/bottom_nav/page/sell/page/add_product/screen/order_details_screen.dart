import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../../../utils/assets_image/app_images.dart';
import '../../../../../../../utils/static_strings/static_strings.dart';
import '../../../../../../../widget/app_alert.dart';
import '../../../../../../../widget/custom_appbar.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  // Current confirmed order status (reactive)
  final RxString orderStatus = 'Order Placed'.obs;

  // Available statuses
  final List<String> statuses = [
    'Pending',
    'Confirmed',
    'Shipped',
    'Delivered',
    'Canceled',
  ];

  // ── helpers ────────────────────────────────────────────────────────────────

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

  // ── bottom sheet ───────────────────────────────────────────────────────────

  void _showUpdateStatusBottomSheet() {
    // Temp reactive selection (starts at current status or first status)
    final tempSelected = (statuses.contains(orderStatus.value)
            ? orderStatus.value
            : statuses.first)
        .obs;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(
          Dimensions.w(20),
          Dimensions.h(20),
          Dimensions.w(20),
          Dimensions.h(20),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.r(25)),
            topRight: Radius.circular(Dimensions.r(25)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.updateOrderStatusDash.tr,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: Dimensions.fs(16),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
            Dimensions.gapH(6),
            Text(
              AppStrings.updateOrderStatusSubtitleDash.tr,
              style: TextStyle(
                fontSize: Dimensions.fs(11),
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            Dimensions.gapH(16),

            // ── Label ───────────────────────────────────────────────────────
            Text(
              AppStrings.orderStatusSelect.tr,
              style: TextStyle(
                fontSize: Dimensions.fs(12),
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            Dimensions.gapH(10),

            // ── Radio list ──────────────────────────────────────────────────
            Obx(() => Column(
                  children: statuses.map((status) {
                    final isSelected = tempSelected.value == status;
                    return GestureDetector(
                      onTap: () => tempSelected.value = status,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: Dimensions.h(6)),
                        child: Row(
                          children: [
                            // Radio circle
                            Container(
                              width: Dimensions.w(20),
                              height: Dimensions.w(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade400,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        width: Dimensions.w(10),
                                        height: Dimensions.w(10),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            Dimensions.gapW(12),
                            Text(
                              status.tr,
                              style: TextStyle(
                                fontSize: Dimensions.fs(13),
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )),

            Dimensions.gapH(20),

            // ── Update button ────────────────────────────────────────────────
            GestureDetector(
              onTap: () {
                final chosen = tempSelected.value;
                Get.back(); // close bottom sheet
                _showConfirmUpdateDialog(chosen);
              },
              child: Container(
                width: double.infinity,
                height: Dimensions.h(50),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1B1B),
                  borderRadius: BorderRadius.circular(Dimensions.r(12)),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.updateBtn.tr,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: Dimensions.fs(14),
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
            Dimensions.gapH(15),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // ── confirm dialog ─────────────────────────────────────────────────────────

  void _showConfirmUpdateDialog(String newStatus) {
    AppAlerts.warning(
      title: AppStrings.updateOrderStatusTitle.tr,
      message: AppStrings.updateOrderStatusConfirmMsg.tr,
      confirmLabel: AppStrings.confirm.tr,
      cancelLabel: AppStrings.cancel.tr,
      onConfirm: () {
        orderStatus.value = newStatus;
        AppAlerts.success(message: AppStrings.orderStatusUpdatedSuccess.tr);
      },
    );
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Accept arguments if passed from ProductOrder screen
    final args = Get.arguments as Map<String, dynamic>?;
    final orderId = args?['orderId'] as String? ?? 'KDF143625879';
    final orderDate = args?['date'] as String? ?? '27 Aug 2020 - 06:20 AM';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: CommonAppBar(
        title: AppStrings.ordersDetailsTitle.tr,
        backgroundColor: const Color(0xFFF4F4F4),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Dimensions.gapH(10),

                  // ── Main Order Details Card ──────────────────────────────
                  Container(
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
                        // Order ID & Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${AppStrings.orderIdLabelWithDash.tr}$orderId',
                                    style: TextStyle(
                                      fontSize: Dimensions.fs(13),
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Dimensions.gapH(4),
                                  Text(
                                    orderDate,
                                    style: TextStyle(
                                      fontSize: Dimensions.fs(10),
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Obx(() {
                              final status = orderStatus.value;
                              final badgeColor = _statusColor(status);
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.w(8),
                                  vertical: Dimensions.h(4),
                                ),
                                decoration: BoxDecoration(
                                  color: badgeColor.withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(Dimensions.r(20)),
                                ),
                                child: Text(
                                  '• ${status.tr}',
                                  style: TextStyle(
                                    color: badgeColor,
                                    fontSize: Dimensions.fs(9),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                        Dimensions.gapH(15),
                        const Divider(height: 1, color: Color(0xFFF5F5F5)),
                        Dimensions.gapH(15),

                        // Inner Product Card
                        Container(
                          padding: EdgeInsets.all(Dimensions.w(10)),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBFBFB),
                            borderRadius:
                                BorderRadius.circular(Dimensions.r(12)),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.05)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: Dimensions.w(65),
                                height: Dimensions.w(65),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(Dimensions.r(10)),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.1)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(Dimensions.w(5)),
                                  child: Image.asset(
                                    AppImages.kidsCottonSho,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Dimensions.gapW(12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppStrings.dummyOrderProductName.tr,
                                      style: TextStyle(
                                        fontSize: Dimensions.fs(12),
                                        fontWeight: FontWeight.w800,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Dimensions.gapH(4),
                                    Text(
                                      '${AppStrings.quantityPrefix.tr}01${AppStrings.sizeVariantPrefix.tr}S',
                                      style: TextStyle(
                                        fontSize: Dimensions.fs(10),
                                        color: Colors.grey[500],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Dimensions.gapH(6),
                                    Text(
                                      AppStrings.dummyOrderPrice.tr,
                                      style: TextStyle(
                                        fontSize: Dimensions.fs(13),
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Dimensions.gapH(20),

                  // ── Ordered By ──────────────────────────────────────────
                  Text(
                    AppStrings.orderedBy.tr,
                    style: TextStyle(
                      fontSize: Dimensions.fs(13),
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  Dimensions.gapH(10),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Dimensions.w(12)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Dimensions.r(15)),
                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: Dimensions.r(22),
                          backgroundImage: const NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
                        ),
                        Dimensions.gapW(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Roberts Junior',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Dimensions.fs(13),
                                ),
                              ),
                              Dimensions.gapH(4),
                              Text(
                                'robert@junior.com',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: Dimensions.fs(11),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.snackbar(
                              AppStrings.chatInfo.tr,
                              AppStrings.messageCustomerFeature.tr,
                              backgroundColor: AppColors.primaryColor,
                              colorText: Colors.black,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.w(8)),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.r(8)),
                            ),
                            child: const Icon(
                              Icons.message_outlined,
                              color: Colors.black,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Dimensions.gapH(20),

                  // ── Delivery Address ────────────────────────────────────
                  Text(
                    AppStrings.deliveryAddressTitle.tr,
                    style: TextStyle(
                      fontSize: Dimensions.fs(13),
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  Dimensions.gapH(10),
                  Container(
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
                        Row(
                          children: [
                            Text(
                              'Roberts Junior',
                              style: TextStyle(
                                fontSize: Dimensions.fs(13),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Dimensions.gapW(8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '• ${AppStrings.home.tr}',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: Dimensions.fs(8),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Dimensions.gapH(8),
                        Text(
                          '+359 77 123 4567',
                          style: TextStyle(
                            fontSize: Dimensions.fs(11),
                            color: Colors.grey[700],
                          ),
                        ),
                        Dimensions.gapH(4),
                        Text(
                          '25 "Ivan Vazov" Street, Plovdiv 4000, Bulgaria',
                          style: TextStyle(
                            fontSize: Dimensions.fs(11),
                            color: Colors.grey[500],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Dimensions.gapH(30),

                  // ── Update Order Status button ───────────────────────────
                  GestureDetector(
                    onTap: _showUpdateStatusBottomSheet,
                    child: Container(
                      width: double.infinity,
                      height: Dimensions.h(50),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B1B1B),
                        borderRadius: BorderRadius.circular(Dimensions.r(12)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        AppStrings.updateOrderStatusBtn.tr,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: Dimensions.fs(14),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Dimensions.gapH(40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
