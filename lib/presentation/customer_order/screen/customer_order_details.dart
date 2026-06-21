import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';
import '../../../../widget/app_alert.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/custom_appbar.dart';
import '../controller/customer_order_controller.dart';

class CustomerOrderDetails extends StatefulWidget {
  final Map<String, dynamic>? orderData;

  const CustomerOrderDetails({super.key, this.orderData});

  @override
  State<CustomerOrderDetails> createState() => _CustomerOrderDetailsState();
}

class _CustomerOrderDetailsState extends State<CustomerOrderDetails> {
  late final CustomerOrderController _ctrl;
  final List<String> _statusOptions = [
    'Pending',
    'Confirmed',
    'Shipped',
    'Delivered',
    'Canceled'
  ];

  late String currentStatus;
  late Map<String, dynamic> order;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<CustomerOrderController>();
    // Make a local copy so we can render immediately if needed, 
    // but we can also rely on the controller.
    order = widget.orderData ?? {};
    currentStatus = order['status'] ?? 'Order Placed';
  }

  void _openUpdateStatusSheet() {
    // Temporary controller for bottom sheet selection
    String tempStatus = currentStatus == 'Order Placed' ? 'Pending' : currentStatus;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Dimensions.r(20))),
            ),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: Dimensions.h(12)),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.greyColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: Dimensions.h(20)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '- Update Order Status',
                        style: AppTextStyles.body.copyWith(
                          fontSize: Dimensions.fs(16),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(Icons.close,
                            color: AppColors.blackColor,
                            size: Dimensions.icon(20)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.h(8)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                  child: Text(
                    'Update the current order status to keep the customer informed about the delivery progress.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.greyColor,
                      fontSize: Dimensions.fs(13),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.h(24)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Order Status (Select)',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.fs(14),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.h(8)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                  child: GestureDetector(
                    onTap: () {
                      _openStatusOptionsSheet(tempStatus, (selected) {
                        setSheetState(() {
                          tempStatus = selected;
                        });
                      });
                    },
                    child: Container(
                      padding: Dimensions.pSym(h: 16, v: 14),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(Dimensions.r(12)),
                        border: Border.all(
                            color: AppColors.greyColor.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tempStatus,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.blackColor,
                              fontSize: Dimensions.fs(14),
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded,
                              color: AppColors.greyColor),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.h(24)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                  child: AppButton(
                    label: 'Update',
                    onPressed: () {
                      Get.back(); // close sheet
                      _confirmUpdateStatus(tempStatus);
                    },
                    backgroundColor: AppColors.blackColor,
                    textColor: AppColors.primaryColor,
                    trailingIcon: const Icon(
                      Icons.double_arrow_rounded,
                      color: AppColors.primaryColor,
                      size: 16,
                    ),
                    borderRadius: 12,
                    height: 52,
                  ),
                ),
                SizedBox(height: Dimensions.h(30)),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _openStatusOptionsSheet(String current, Function(String) onSelect) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(Dimensions.r(20))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: Dimensions.h(12)),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: Dimensions.h(20)),
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(20), vertical: Dimensions.h(8)),
              itemCount: _statusOptions.length,
              separatorBuilder: (_, __) => Divider(
                  height: 1, color: AppColors.greyColor.withOpacity(0.1)),
              itemBuilder: (_, i) {
                final item = _statusOptions[i];
                final isChosen = item == current;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item,
                    style: AppTextStyles.body.copyWith(
                      fontSize: Dimensions.fs(14),
                      fontStyle: FontStyle.italic,
                      fontWeight: isChosen ? FontWeight.w600 : FontWeight.w400,
                      color: AppColors.blackColor,
                    ),
                  ),
                  trailing: Icon(
                    isChosen
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isChosen
                        ? AppColors.blackColor.withOpacity(0.7)
                        : AppColors.greyColor,
                    size: 20,
                  ),
                  onTap: () {
                    onSelect(item);
                    Get.back();
                  },
                );
              },
            ),
            SizedBox(height: Dimensions.h(30)),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _confirmUpdateStatus(String newStatus) {
    if (newStatus == currentStatus || (currentStatus == 'Order Placed' && newStatus == 'Pending')) return;

    AppAlerts.warning(
      title: 'Update Order Status !',
      message:
          'Are you sure you want to update this order status? The customer will be notified immediately.',
      confirmLabel: 'Confirm',
      cancelLabel: 'Cancel',
      onConfirm: () {
        setState(() {
          currentStatus = newStatus;
          order['status'] = newStatus;
        });
        _ctrl.updateOrderStatus(order['id'], newStatus);
        Get.back(); // close alert
        
        // Show success snackbar
        Get.snackbar(
          'Success',
          'Order status updated to $newStatus',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canUpdate = currentStatus != 'Delivered' && currentStatus != 'Canceled';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CommonAppBar(title: "Order's Details"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.w(20), vertical: Dimensions.h(20)),
        child: Column(
          children: [
            // ── Main Card ──────────────────────────────────────────────────
            Container(
              padding: EdgeInsets.all(Dimensions.w(16)),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(Dimensions.r(16)),
                border:
                    Border.all(color: AppColors.greyColor.withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order ID & Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "- Order ID: ${order['id'] ?? 'N/A'}",
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: Dimensions.fs(13),
                            ),
                          ),
                          SizedBox(height: Dimensions.h(4)),
                          Text(
                            order['date'] ?? '',
                            style: AppTextStyles.body.copyWith(
                              fontSize: Dimensions.fs(10),
                              color: AppColors.greyColor,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.w(8),
                            vertical: Dimensions.h(4)),
                        decoration: BoxDecoration(
                          color: _getStatusBgColor(currentStatus),
                          borderRadius: BorderRadius.circular(Dimensions.r(12)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle,
                                size: 6,
                                color: _getStatusTextColor(currentStatus)),
                            SizedBox(width: Dimensions.w(4)),
                            Text(
                              currentStatus,
                              style: AppTextStyles.body.copyWith(
                                fontSize: Dimensions.fs(10),
                                fontWeight: FontWeight.w600,
                                color: _getStatusTextColor(currentStatus),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: Dimensions.h(16)),
                  Divider(
                      height: 1, color: AppColors.greyColor.withOpacity(0.15)),
                  SizedBox(height: Dimensions.h(16)),

                  // Product Info
                  Row(
                    children: [
                      Container(
                        width: Dimensions.w(50),
                        height: Dimensions.h(50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.r(8)),
                          border: Border.all(color: AppColors.primaryColor),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.r(7)),
                          child: (order['product'] != null &&
                                  order['product']['image'] != null)
                              ? Image.asset(order['product']['image'],
                                  fit: BoxFit.cover)
                              : const Icon(Icons.image,
                                  color: AppColors.greyColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.h(12)),
                  if (order['product'] != null) ...[
                    Text(
                      order['product']['name'] ?? '',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: Dimensions.fs(14),
                      ),
                    ),
                    SizedBox(height: Dimensions.h(4)),
                    Text(
                      "Quantity :- ${order['product']['quantity']} • Size / Variant :- ${order['product']['size']}",
                      style: AppTextStyles.body.copyWith(
                        fontSize: Dimensions.fs(11),
                        color: AppColors.greyColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: Dimensions.h(8)),
                    Text(
                      "€${order['product']['price']}",
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: Dimensions.fs(14),
                      ),
                    ),
                  ],
                  SizedBox(height: Dimensions.h(16)),
                  Divider(
                      height: 1, color: AppColors.greyColor.withOpacity(0.15)),
                  SizedBox(height: Dimensions.h(16)),

                  // Ordered By
                  Text(
                    "- Ordered By",
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: Dimensions.fs(13),
                    ),
                  ),
                  SizedBox(height: Dimensions.h(12)),
                  if (order['customer'] != null)
                    Row(
                      children: [
                        CircleAvatar(
                          radius: Dimensions.r(20),
                          backgroundImage:
                              AssetImage(order['customer']['image']),
                          backgroundColor: AppColors.greyColor.withOpacity(0.2),
                        ),
                        SizedBox(width: Dimensions.w(12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order['customer']['name'] ?? '',
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Dimensions.fs(13),
                                ),
                              ),
                              Text(
                                order['customer']['email'] ?? '',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: Dimensions.fs(11),
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(Dimensions.w(8)),
                          decoration: BoxDecoration(
                            color: AppColors.blackColor,
                            borderRadius: BorderRadius.circular(Dimensions.r(8)),
                          ),
                          child: Icon(Icons.chat_bubble_outline,
                              color: AppColors.primaryColor,
                              size: Dimensions.icon(16)),
                        ),
                      ],
                    ),
                  SizedBox(height: Dimensions.h(16)),
                  Divider(
                      height: 1, color: AppColors.greyColor.withOpacity(0.15)),
                  SizedBox(height: Dimensions.h(16)),

                  // Delivery Address
                  Text(
                    "- Delivery Address",
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: Dimensions.fs(13),
                    ),
                  ),
                  SizedBox(height: Dimensions.h(12)),
                  if (order['delivery'] != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order['customer']?['name'] ?? '',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.fs(13),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.w(8),
                              vertical: Dimensions.h(4)),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(Dimensions.r(12)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.circle,
                                  size: 6, color: AppColors.primaryColor),
                              SizedBox(width: Dimensions.w(4)),
                              Text(
                                'Home',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: Dimensions.fs(10),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.h(4)),
                    Text(
                      order['delivery']['phone'] ?? '',
                      style: AppTextStyles.body.copyWith(
                        fontSize: Dimensions.fs(12),
                        color: AppColors.greyColor,
                      ),
                    ),
                    SizedBox(height: Dimensions.h(4)),
                    Text(
                      order['delivery']['address'] ?? '',
                      style: AppTextStyles.body.copyWith(
                        fontSize: Dimensions.fs(12),
                        color: AppColors.greyColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: Dimensions.h(24)),

            // ── Update Order Status Button OR Status Banner ───────────────
            if (canUpdate)
              AppButton(
                label: 'Update Order Status',
                onPressed: _openUpdateStatusSheet,
                backgroundColor: AppColors.blackColor,
                textColor: AppColors.primaryColor,
                borderRadius: 12,
                height: 52,
              )
            else if (currentStatus == 'Delivered')
              Container(
                width: double.infinity,
                padding: Dimensions.pSym(h: 16, v: 16),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(Dimensions.r(8)),
                  border: Border.all(color: AppColors.primaryColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivered On',
                      style: AppTextStyles.body.copyWith(
                        fontSize: Dimensions.fs(11),
                        color: AppColors.greyColor,
                      ),
                    ),
                    SizedBox(height: Dimensions.h(4)),
                    Text(
                      order['date'] ?? '22 February 2026 at 6:30 PM', // Mock
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.fs(13),
                      ),
                    ),
                  ],
                ),
              )
            else if (currentStatus == 'Canceled')
              Container(
                width: double.infinity,
                padding: Dimensions.pSym(h: 16, v: 16),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(Dimensions.r(8)),
                  border: Border.all(color: Colors.red.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Canceled By Customer On',
                      style: AppTextStyles.body.copyWith(
                        fontSize: Dimensions.fs(11),
                        color: AppColors.greyColor,
                      ),
                    ),
                    SizedBox(height: Dimensions.h(4)),
                    Text(
                      order['date'] ?? '27 August 2020 at 6:30 PM', // Mock
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.fs(13),
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: Dimensions.h(40)),
          ],
        ),
      ),
    );
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'Order Placed':
      case 'Pending':
        return Colors.blue.withOpacity(0.15);
      case 'Confirmed':
        return Colors.purple.withOpacity(0.15);
      case 'Shipped':
        return Colors.orange.withOpacity(0.15);
      case 'Delivered':
        return Colors.green.withOpacity(0.15);
      case 'Canceled':
        return Colors.red.withOpacity(0.15);
      default:
        return AppColors.greyColor.withOpacity(0.15);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Order Placed':
      case 'Pending':
        return Colors.blue;
      case 'Confirmed':
        return Colors.purple;
      case 'Shipped':
        return Colors.orange;
      case 'Delivered':
        return Colors.green;
      case 'Canceled':
        return Colors.red;
      default:
        return AppColors.greyColor;
    }
  }
}
