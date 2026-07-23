import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';
import '../../../../service/api_url.dart';
import '../../../../widget/app_alert.dart';
import '../../../../widget/app_button.dart';
import '../../../../widget/custom_appbar.dart';
import '../../../../utils/static_strings/static_strings.dart';
import '../controller/customer_order_controller.dart';
import '../model/CustomerOrderDetailsModel.dart' as details;

class CustomerOrderDetails extends StatefulWidget {
  final String orderId;

  const CustomerOrderDetails({super.key, required this.orderId});

  @override
  State<CustomerOrderDetails> createState() => _CustomerOrderDetailsState();
}

class _CustomerOrderDetailsState extends State<CustomerOrderDetails> {
  late final CustomerOrderController _ctrl;
  final List<String> _statusOptions = [
    AppStrings.pending,
    AppStrings.confirmed,
    AppStrings.shipped,
    AppStrings.delivered,
    AppStrings.canceled
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<CustomerOrderController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.fetchOrderDetails(widget.orderId);
    });
  }

  void _openUpdateStatusSheet() {
    final order = _ctrl.selectedOrderDetails.value;
    if (order == null) return;
    String currentStatus = order.status ?? AppStrings.orderPlaced;
    // Temporary controller for bottom sheet selection
    String tempStatus = currentStatus;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(Dimensions.r(20))),
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
                        AppStrings.updateOrderStatusTitle.tr,
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
                    AppStrings.updateOrderStatusSubtitle.tr,
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
                      AppStrings.orderStatusSelect.tr,
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
                SizedBox(height: Dimensions.h(24)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                  child: AppButton(
                    label: AppStrings.update.tr,
                    onPressed: () {
                      Get.back(); // close sheet
                      final order = _ctrl.selectedOrderDetails.value;
                      if (order != null) {
                        _confirmUpdateStatus(
                            tempStatus, order.status ?? 'PENDING', order);
                      }
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

  void _confirmUpdateStatus(
      String newStatus, String currentStatus, details.Data order) {
    if (newStatus == currentStatus) return;

    AppAlerts.warning(
      title: AppStrings.updateOrderStatusAlertTitle.tr,
      message: AppStrings.updateOrderStatusAlertSubtitle.tr,
      confirmLabel: AppStrings.confirm.tr,
      cancelLabel: AppStrings.cancel.tr,
      onConfirm: () {
        _ctrl.updateOrderStatus(order.id.toString(), newStatus);
        Get.back(); // close alert

        // Show success snackbar
        Get.snackbar(
          AppStrings.success.tr,
          '${AppStrings.orderStatusUpdatedTo.tr} ${newStatus.tr}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(title: AppStrings.orderDetailsTitle.tr),
      body: Obx(() {
        if (_ctrl.isDetailsLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final order = _ctrl.selectedOrderDetails.value;
        if (order == null) {
          return const Center(child: Text("Failed to load order details"));
        }

        final currentStatus = order.status ?? 'PENDING';
        final bool canUpdate =
            currentStatus != 'DELIVERED' && currentStatus != 'CANCELLED';

        return SingleChildScrollView(
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
                              "${AppStrings.orderIdPrefix.tr}${order.displayId ?? order.id ?? 'N/A'}",
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: Dimensions.fs(13),
                              ),
                            ),
                            SizedBox(height: Dimensions.h(4)),
                            Text(
                              order.createdAt ?? '',
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
                            borderRadius:
                                BorderRadius.circular(Dimensions.r(12)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle,
                                  size: 6,
                                  color: _getStatusTextColor(currentStatus)),
                              SizedBox(width: Dimensions.w(4)),
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
                        height: 1,
                        color: AppColors.greyColor.withOpacity(0.15)),
                    SizedBox(height: Dimensions.h(16)),

                    // Product Info
                    Row(
                      children: [
                        Container(
                          width: Dimensions.w(50),
                          height: Dimensions.h(50),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.r(8)),
                            border: Border.all(color: AppColors.primaryColor),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.r(7)),
                            child: (order.items != null &&
                                    order.items!.isNotEmpty &&
                                    order.items![0].product != null)
                                ? Image.network(
                                    ApiUrl.buildImageUrl(
                                        order.items![0].product!.imageUrl),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                        Icons.image,
                                        color: AppColors.greyColor))
                                : const Icon(Icons.image,
                                    color: AppColors.greyColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.h(12)),
                    if (order.items != null && order.items!.isNotEmpty) ...[
                      Text(
                        order.items![0].product?.name ?? '',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: Dimensions.fs(14),
                        ),
                      ),
                      SizedBox(height: Dimensions.h(4)),
                      Text(
                        "${AppStrings.quantityPrefix.tr}${order.items![0].quantity}",
                        style: AppTextStyles.body.copyWith(
                          fontSize: Dimensions.fs(11),
                          color: AppColors.greyColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: Dimensions.h(8)),
                      Text(
                        "€${order.items![0].price}",
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: Dimensions.fs(14),
                        ),
                      ),
                    ],
                    SizedBox(height: Dimensions.h(16)),
                    Divider(
                        height: 1,
                        color: AppColors.greyColor.withOpacity(0.15)),
                    SizedBox(height: Dimensions.h(16)),

                    // Ordered By
                    Text(
                      AppStrings.orderedBy.tr,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.fs(13),
                      ),
                    ),
                    SizedBox(height: Dimensions.h(12)),
                    if (order.buyer != null)
                      Row(
                        children: [
                          CircleAvatar(
                            radius: Dimensions.r(20),
                            backgroundImage: NetworkImage(ApiUrl.buildImageUrl(
                                order.buyer?.profile?.avatarUrl)),
                            backgroundColor:
                                AppColors.greyColor.withOpacity(0.2),
                          ),
                          SizedBox(width: Dimensions.w(12)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.buyer?.profile?.fullName ?? '',
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fs(13),
                                  ),
                                ),
                                Text(
                                  order.buyer?.email ?? '',
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
                              borderRadius:
                                  BorderRadius.circular(Dimensions.r(8)),
                            ),
                            child: Icon(Icons.chat_bubble_outline,
                                color: AppColors.primaryColor,
                                size: Dimensions.icon(16)),
                          ),
                        ],
                      ),
                    SizedBox(height: Dimensions.h(16)),
                    Divider(
                        height: 1,
                        color: AppColors.greyColor.withOpacity(0.15)),
                    SizedBox(height: Dimensions.h(16)),

                    // Delivery Address
                    Text(
                      AppStrings.deliveryAddress.tr,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.fs(13),
                      ),
                    ),
                    SizedBox(height: Dimensions.h(12)),
                    if (order.buyer != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            order.buyer?.profile?.fullName ?? '',
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
                              borderRadius:
                                  BorderRadius.circular(Dimensions.r(12)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.circle,
                                    size: 6, color: AppColors.primaryColor),
                                SizedBox(width: Dimensions.w(4)),
                                Text(
                                  AppStrings.home.tr,
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
                        order.buyer?.profile?.phone ?? '',
                        style: AppTextStyles.body.copyWith(
                          fontSize: Dimensions.fs(12),
                          color: AppColors.greyColor,
                        ),
                      ),
                      SizedBox(height: Dimensions.h(4)),
                      Text(
                        order.deliveryAddress != null
                            ? "${order.deliveryAddress!.address ?? ''}, ${order.deliveryAddress!.city ?? ''}, ${order.deliveryAddress!.country ?? ''}"
                            : "Address not provided",
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
                  label: AppStrings.updateOrderStatusBtn.tr,
                  onPressed: _openUpdateStatusSheet,
                  backgroundColor: AppColors.blackColor,
                  textColor: AppColors.primaryColor,
                  borderRadius: 12,
                  height: 52,
                )
              else if (currentStatus == AppStrings.delivered)
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
                        order.createdAt ?? '',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: Dimensions.fs(13),
                        ),
                      ),
                    ],
                  ),
                )
              else if (currentStatus == AppStrings.canceled)
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
                        AppStrings.canceledByCustomerOn.tr,
                        style: AppTextStyles.body.copyWith(
                          fontSize: Dimensions.fs(11),
                          color: AppColors.greyColor,
                        ),
                      ),
                      SizedBox(height: Dimensions.h(4)),
                      Text(
                        order.createdAt ?? '',
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
        );
      }),
    );
  }

  Color _getStatusBgColor(String status) {
    if (status == 'PENDING') {
      return Colors.blue.withOpacity(0.15);
    } else if (status == 'CONFIRMED' || status == 'PROCESSING') {
      return Colors.purple.withOpacity(0.15);
    } else if (status == 'SHIPPED') {
      return Colors.orange.withOpacity(0.15);
    } else if (status == 'DELIVERED') {
      return Colors.green.withOpacity(0.15);
    } else if (status == 'CANCELLED') {
      return Colors.red.withOpacity(0.15);
    }
    return AppColors.greyColor.withOpacity(0.15);
  }

  Color _getStatusTextColor(String status) {
    if (status == 'PENDING') {
      return Colors.blue;
    } else if (status == 'CONFIRMED' || status == 'PROCESSING') {
      return Colors.purple;
    } else if (status == 'SHIPPED') {
      return Colors.orange;
    } else if (status == 'DELIVERED') {
      return Colors.green;
    } else if (status == 'CANCELLED') {
      return Colors.red;
    }
    return AppColors.greyColor;
  }
}
