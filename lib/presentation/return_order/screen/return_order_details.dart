import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../widget/app_alert.dart';
import '../../../widget/app_button.dart';
import '../../../widget/app_text_field.dart';
import '../../../widget/custom_appbar.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../controller/return_order_controller.dart';

class ReturnOrderDetails extends StatefulWidget {
  final Map<String, dynamic>? orderData;

  const ReturnOrderDetails({super.key, this.orderData});

  @override
  State<ReturnOrderDetails> createState() => _ReturnOrderDetailsState();
}

class _ReturnOrderDetailsState extends State<ReturnOrderDetails> {
  late final ReturnOrderController _ctrl;
  final List<String> _statusOptions = [
    AppStrings.inReview,
    AppStrings.processing,
    AppStrings.completed,
    AppStrings.rejected
  ];

  late String currentStatus;
  late Map<String, dynamic> order;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<ReturnOrderController>();
    order = widget.orderData ?? {};
    currentStatus = order['status'] ?? AppStrings.inReview;
  }

  void _openUpdateStatusSheet() {
    String tempStatus = currentStatus;
    final addressCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setSheetState) {
          String buttonText = AppStrings.updateStatus.tr;
          if (tempStatus == AppStrings.processing) {
            buttonText = AppStrings.confirmAndSendInstructions.tr;
          } else if (tempStatus == AppStrings.completed) {
            buttonText = AppStrings.issueRefundAndCompleted.tr;
          } else if (tempStatus == AppStrings.rejected) {
            buttonText = AppStrings.confirmRejection.tr;
          }

          return Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(Dimensions.r(20))),
            ),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
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
                          AppStrings.updateReturnStatusTitle.tr,
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
                      AppStrings.updateReturnStatusSubtitle2.tr,
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
                        AppStrings.returnStatusSelect.tr,
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
                              tempStatus.tr,
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

                  // Dynamic fields based on status
                  if (tempStatus == AppStrings.processing) ...[
                    SizedBox(height: Dimensions.h(16)),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.returnShippingAddress.tr,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.fs(14),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.h(8)),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                      child: AppTextField(
                        controller: addressCtrl,
                        hint: AppStrings.enterWarehouseAddress.tr,
                      ),
                    ),
                  ],

                  if (tempStatus == AppStrings.rejected) ...[
                    SizedBox(height: Dimensions.h(16)),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.rejectionNote.tr,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.fs(14),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.h(8)),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                      child: AppTextField(
                        controller: noteCtrl,
                        maxLines: 4,
                        hint: AppStrings.enterRejectionReason.tr,
                      ),
                    ),
                  ],

                  SizedBox(height: Dimensions.h(24)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                    child: AppButton(
                      label: buttonText,
                      onPressed: () {
                        Get.back(); // close sheet
                        _confirmUpdateStatus(tempStatus,
                            address: addressCtrl.text, note: noteCtrl.text);
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
                    item.tr,
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

  void _confirmUpdateStatus(String newStatus, {String? address, String? note}) {
    if (newStatus == currentStatus) return;

    AppAlerts.warning(
      title: AppStrings.updateReturnStatusAlertTitle.tr,
      message: AppStrings.updateReturnStatusAlertSubtitle2.tr,
      confirmLabel: AppStrings.confirm.tr,
      cancelLabel: AppStrings.cancel.tr,
      onConfirm: () {
        setState(() {
          currentStatus = newStatus;
        });
        _ctrl.updateReturnStatus(order['id'], newStatus,
            address: address, note: note);
        // Refresh local order data from controller
        final index = _ctrl.allOrders.indexWhere((o) => o['id'] == order['id']);
        if (index != -1) {
          order = _ctrl.allOrders[index];
        }

        Get.back(); // close alert
        Get.snackbar(
          'Success',
          '${AppStrings.returnStatusUpdatedTo.tr} ${newStatus.tr}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canUpdate =
        currentStatus == 'In review' || currentStatus == 'Processing';
    final details = order['returnDetails'] ?? {};
    final evidence = details['evidence'] as List<dynamic>? ?? [];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(title: AppStrings.returnDetails.tr),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.w(20), vertical: Dimensions.h(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                            "${AppStrings.orderIdLabelWithDash.tr}${order['id'] ?? 'N/A'}",
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
                            Icon(
                              currentStatus == AppStrings.rejected
                                  ? Icons.remove
                                  : Icons.add,
                              size: 10,
                              color: _getStatusTextColor(currentStatus),
                            ),
                            SizedBox(width: Dimensions.w(2)),
                            Text(
                              currentStatus.tr,
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

                  // Product Info (could be list, using one for simplicity as per mock)
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
                      "${AppStrings.quantityPrefix.tr}${order['product']['quantity']}${AppStrings.sizeVariantPrefix.tr}${order['product']['size']}",
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
                ],
              ),
            ),

            SizedBox(height: Dimensions.h(16)),

            // Delivered On
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
                    AppStrings.deliveredOn.tr,
                    style: AppTextStyles.body.copyWith(
                      fontSize: Dimensions.fs(11),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(height: Dimensions.h(4)),
                  Text(
                    order['deliveredOn'] ?? '22 February 2026 at 6:30 PM',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: Dimensions.fs(13),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Dimensions.h(16)),

            // ── Return Details ─────────────────────────────────────────────
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
                  Text(
                    AppStrings.returnDetails.tr,
                    style: AppTextStyles.body.copyWith(
                      fontSize: Dimensions.fs(12),
                      color: AppColors.greyColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: Dimensions.h(12)),
                  Divider(
                      height: 1, color: AppColors.greyColor.withOpacity(0.15)),
                  SizedBox(height: Dimensions.h(16)),
                  Text(
                    AppStrings.returnReason.tr,
                    style: AppTextStyles.body.copyWith(
                      fontSize: Dimensions.fs(12),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Dimensions.h(4)),
                  Text(
                    details['reason'] ?? '',
                    style: AppTextStyles.body.copyWith(
                      fontSize: Dimensions.fs(11),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(height: Dimensions.h(16)),
                  Text(
                    AppStrings.submittedOn.tr,
                    style: AppTextStyles.body.copyWith(
                      fontSize: Dimensions.fs(12),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Dimensions.h(4)),
                  Text(
                    details['submittedOn'] ?? '',
                    style: AppTextStyles.body.copyWith(
                      fontSize: Dimensions.fs(11),
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(height: Dimensions.h(16)),
                  if (evidence.isNotEmpty) ...[
                    Text(
                      AppStrings.evidence.tr,
                      style: AppTextStyles.body.copyWith(
                        fontSize: Dimensions.fs(12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: Dimensions.h(8)),
                    Row(
                      children: evidence.map((img) {
                        return Container(
                          margin: EdgeInsets.only(right: Dimensions.w(8)),
                          width: Dimensions.w(60),
                          height: Dimensions.h(60),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.r(8)),
                            border: Border.all(
                                color: AppColors.greyColor.withOpacity(0.2)),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.r(7)),
                            child: Image.asset(img, fit: BoxFit.cover),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: Dimensions.h(16)),
                  ],
                  Text(
                    AppStrings.message.tr,
                    style: AppTextStyles.body.copyWith(
                      fontSize: Dimensions.fs(12),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Dimensions.h(8)),
                  Text(
                    details['message'] ?? '',
                    style: AppTextStyles.body.copyWith(
                      fontSize: Dimensions.fs(11),
                      color: AppColors.greyColor,
                      height: 1.5,
                    ),
                  ),
                  if (order['returnAddress'] != null) ...[
                    SizedBox(height: Dimensions.h(24)),
                    Text(
                      "- ${AppStrings.returnAddress.tr}",
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.fs(13),
                      ),
                    ),
                    SizedBox(height: Dimensions.h(12)),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(Dimensions.w(8)),
                          decoration: BoxDecoration(
                            color: AppColors.blackColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.r(8)),
                          ),
                          child: Icon(Icons.location_on_outlined,
                              color: AppColors.primaryColor,
                              size: Dimensions.icon(16)),
                        ),
                        SizedBox(width: Dimensions.w(12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.location.tr,
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Dimensions.fs(13),
                                ),
                              ),
                              SizedBox(height: Dimensions.h(2)),
                              Text(
                                order['returnAddress'],
                                style: AppTextStyles.body.copyWith(
                                  fontSize: Dimensions.fs(11),
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (currentStatus == AppStrings.completed) ...[
                    SizedBox(height: Dimensions.h(24)),
                    Container(
                      width: double.infinity,
                      padding: Dimensions.pSym(h: 12, v: 12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(Dimensions.r(8)),
                        border:
                            Border.all(color: Colors.green.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: Colors.green, size: 20),
                          SizedBox(width: Dimensions.w(12)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.returnCompletedAndRefunded.tr,
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fs(12),
                                    color: AppColors.blackColor,
                                  ),
                                ),
                                SizedBox(height: Dimensions.h(2)),
                                Text(
                                  "On ${details['completedOn'] ?? ''}",
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: Dimensions.fs(11),
                                    color: AppColors.greyColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                  if (currentStatus == AppStrings.rejected) ...[
                    SizedBox(height: Dimensions.h(24)),
                    Container(
                      width: double.infinity,
                      padding: Dimensions.pSym(h: 12, v: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(Dimensions.r(8)),
                        border: Border.all(color: Colors.red.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.cancel_outlined,
                              color: Colors.red, size: 20),
                          SizedBox(width: Dimensions.w(12)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.youRejectedReturnRequest.tr,
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fs(12),
                                    color: AppColors.blackColor,
                                  ),
                                ),
                                SizedBox(height: Dimensions.h(2)),
                                Text(
                                  "On ${details['rejectedOn'] ?? ''}",
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: Dimensions.fs(11),
                                    color: AppColors.greyColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.h(16)),
                    Container(
                      width: double.infinity,
                      padding: Dimensions.pSym(h: 12, v: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.r(8)),
                        border: Border.all(
                            color: AppColors.greyColor.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.reasonForRejection2.tr,
                            style: AppTextStyles.body.copyWith(
                              fontSize: Dimensions.fs(11),
                              color: AppColors.greyColor,
                            ),
                          ),
                          SizedBox(height: Dimensions.h(8)),
                          Text(
                            details['rejectionNote'] ?? '',
                            style: AppTextStyles.body.copyWith(
                              fontSize: Dimensions.fs(11),
                              color: AppColors.blackColor,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: Dimensions.h(24)),

            // ── Update Return Status Button ───────────────
            if (canUpdate)
              AppButton(
                label: 'Update Return Status',
                onPressed: _openUpdateStatusSheet,
                backgroundColor: AppColors.blackColor,
                textColor: AppColors.primaryColor,
                borderRadius: 12,
                height: 52,
              ),

            SizedBox(height: Dimensions.h(40)),
          ],
        ),
      ),
    );
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'In review':
        return Colors.orange.withOpacity(0.15);
      case 'Processing':
        return Colors.blue.withOpacity(0.15);
      case 'Completed':
        return Colors.green.withOpacity(0.15);
      case 'Rejected':
        return Colors.red.withOpacity(0.15);
      default:
        return AppColors.greyColor.withOpacity(0.15);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'In review':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return AppColors.greyColor;
    }
  }
}
