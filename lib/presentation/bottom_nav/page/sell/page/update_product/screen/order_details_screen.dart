import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../../../utils/assets_image/app_images.dart';
import '../../../../../../../widget/app_alert.dart';
import '../../../../../../../widget/custom_appbar.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  // Current order status state
  final RxString orderStatus = "Order Placed".obs;

  // Status select list (from Image 6)
  final List<String> statuses = [
    "Pending",
    "Confirmed",
    "Shipped",
    "Delivered",
    "Canceled",
  ];

  void _showUpdateStatusBottomSheet() {
    final selectedTempStatus = orderStatus.value.obs;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(Dimensions.w(20)),
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
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Update Order Status",
                  style: AppTextStyles.h3.copyWith(
                    fontSize: Dimensions.fs(18),
                    fontWeight: FontWeight.w700,
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
                    child:
                        const Icon(Icons.close, size: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
            Dimensions.gapH(8),
            Text(
              "Update the current order status to keep the customer informed about the delivery progress.",
              style: TextStyle(
                fontSize: Dimensions.fs(12),
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            Dimensions.gapH(20),

            // Dropdown/Select
            Text(
              "Order Status (Select)",
              style: TextStyle(
                fontSize: Dimensions.fs(12),
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            Dimensions.gapH(8),
            Obx(() => Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.w(15), vertical: Dimensions.h(4)),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(Dimensions.r(10)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedTempStatus.value,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: statuses.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(
                            status,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        if (newVal != null) {
                          selectedTempStatus.value = newVal;
                        }
                      },
                    ),
                  ),
                )),

            Dimensions.gapH(24),

            // Update button
            GestureDetector(
              onTap: () {
                Get.back(); // close bottom sheet
                _showConfirmUpdateDialog(selectedTempStatus.value);
              },
              child: Container(
                width: double.infinity,
                height: Dimensions.h(50),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1B1B),
                  borderRadius: BorderRadius.circular(Dimensions.r(12)),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Update >>",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: Dimensions.fs(14),
                    fontWeight: FontWeight.w700,
                  ),
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

  void _showConfirmUpdateDialog(String newStatus) {
    AppAlerts.warning(
      title: "Update Order Status !",
      message:
          "Are you sure you want to update this order status? The customer will be notified immediately.",
      confirmLabel: "Confirm",
      cancelLabel: "Cancel",
      onConfirm: () {
        orderStatus.value = newStatus;
        AppAlerts.success(message: "Order status updated successfully");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: const CommonAppBar(
        title: "Order's Details",
        backgroundColor: Color(0xFFF4F4F4),
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

                  // Main Order Details Card
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
                        // Order ID & Status Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "- Order ID: KDF143625879",
                                  style: TextStyle(
                                    fontSize: Dimensions.fs(13),
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                                ),
                                Dimensions.gapH(4),
                                Text(
                                  "27 Aug 2020 - 06:20 AM",
                                  style: TextStyle(
                                    fontSize: Dimensions.fs(10),
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            Obx(() {
                              final status = orderStatus.value;
                              Color badgeColor = Colors.orange;
                              if (status == "Confirmed" ||
                                  status == "Delivered") {
                                badgeColor = const Color(0xFF4CAF50);
                              } else if (status == "Canceled") {
                                badgeColor = Colors.red;
                              }
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.w(8),
                                    vertical: Dimensions.h(4)),
                                decoration: BoxDecoration(
                                  color: badgeColor.withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(Dimensions.r(20)),
                                ),
                                child: Text(
                                  "• $status",
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
                                      "D.D. Step – Comfort",
                                      style: TextStyle(
                                        fontSize: Dimensions.fs(12),
                                        fontWeight: FontWeight.w800,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Dimensions.gapH(4),
                                    Text(
                                      "Quantity :- 01 • Size / Variant :- S",
                                      style: TextStyle(
                                        fontSize: Dimensions.fs(10),
                                        color: Colors.grey[500],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Dimensions.gapH(6),
                                    Text(
                                      "€260.00",
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

                  // Ordered By section
                  Text(
                    "- Ordered By",
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
                                "Roberts Junior",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Dimensions.fs(13),
                                ),
                              ),
                              Dimensions.gapH(4),
                              Text(
                                "robert@junior.com",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: Dimensions.fs(11),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Message Button
                        GestureDetector(
                          onTap: () {
                            Get.snackbar(
                              "Chat Info",
                              "Message customer feature is selected",
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

                  // Delivery Address section
                  Text(
                    "- Delivery Address",
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
                              "Roberts Junior",
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
                                "• Home",
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
                          "+359 77 123 4567",
                          style: TextStyle(
                            fontSize: Dimensions.fs(11),
                            color: Colors.grey[700],
                          ),
                        ),
                        Dimensions.gapH(4),
                        Text(
                          "25 \"Ivan Vazov\" Street, Plovdiv 4000, Bulgaria",
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

                  // Bottom Button
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
                        "Update Order Status",
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
