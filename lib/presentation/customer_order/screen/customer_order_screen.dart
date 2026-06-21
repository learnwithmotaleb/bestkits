import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';
import '../../../../utils/static_strings/static_strings.dart';
import '../../../../widget/custom_appbar.dart';
import '../../../../widget/app_button.dart';
import '../controller/customer_order_controller.dart';
import 'customer_order_details.dart';

class CustomerOrderScreen extends StatefulWidget {
  const CustomerOrderScreen({super.key});

  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  final _ctrl = Get.put(CustomerOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(title: AppStrings.customerOrder.tr),
      body: Column(
        children: [
          SizedBox(height: Dimensions.h(10)),
          // ── Horizontal Tabs ──────────────────────────────────────────────────
          SizedBox(
            height: Dimensions.h(38),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
              itemCount: _ctrl.tabs.length,
              separatorBuilder: (_, __) => SizedBox(width: Dimensions.w(10)),
              itemBuilder: (context, index) {
                final tab = _ctrl.tabs[index];
                return Obx(() {
                  final isSelected = _ctrl.selectedTab.value == tab;
                  return GestureDetector(
                    onTap: () => _ctrl.setTab(tab),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimensions.w(16)),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.blackColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(Dimensions.r(8)),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.blackColor
                              : AppColors.greyColor.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        tab.tr,
                        style: AppTextStyles.body.copyWith(
                          fontSize: Dimensions.fs(13),
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primaryColor
                              : AppColors.greyColor,
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          SizedBox(height: Dimensions.h(20)),

          // ── Orders List / Empty State ────────────────────────────────────────
          Expanded(
            child: Obx(() {
              final orders = _ctrl.filteredOrders;

              if (orders.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: Dimensions.h(32)),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(Dimensions.r(12)),
                          border: Border.all(
                              color: AppColors.greyColor.withOpacity(0.15)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined,
                                size: Dimensions.icon(48),
                                color: AppColors.greyColor.withOpacity(0.5)),
                            SizedBox(height: Dimensions.h(12)),
                            Text(
                              "${AppStrings.noOrdersFoundText.tr} ${_ctrl.selectedTab.value.tr} ${AppStrings.ordersFoundText.tr}",
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.greyColor,
                                fontSize: Dimensions.fs(13),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.w(20), vertical: Dimensions.h(4)),
                itemCount: orders.length,
                separatorBuilder: (_, __) => SizedBox(height: Dimensions.h(16)),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Container(
                    padding: Dimensions.pSym(h: 16, v: 16),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(Dimensions.r(16)),
                      border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppStrings.orderIdPrefix.tr}${order['id']}",
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Dimensions.fs(13),
                                  ),
                                ),
                                SizedBox(height: Dimensions.h(4)),
                                Text(
                                  order['date'],
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
                                color: _getStatusBgColor(order['status']),
                                borderRadius:
                                    BorderRadius.circular(Dimensions.r(12)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.circle,
                                      size: 6,
                                      color:
                                          _getStatusTextColor(order['status'])),
                                  SizedBox(width: Dimensions.w(4)),
                                  Text(
                                    order['status'].toString().tr,
                                    style: AppTextStyles.body.copyWith(
                                      fontSize: Dimensions.fs(10),
                                      fontWeight: FontWeight.w600,
                                      color:
                                          _getStatusTextColor(order['status']),
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
                        AppButton(
                          label: AppStrings.viewDetails.tr,
                          onPressed: () {
                            Get.to(
                                () => CustomerOrderDetails(orderData: order));
                          },
                          backgroundColor: AppColors.blackColor,
                          textColor: AppColors.primaryColor,
                          trailingIcon: const Icon(
                            Icons.double_arrow_rounded,
                            color: AppColors.primaryColor,
                            size: 16,
                          ),
                          height: 38,
                          borderRadius: 8,
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Color _getStatusBgColor(String status) {
    if (status == AppStrings.orderPlaced || status == AppStrings.pending) {
      return Colors.blue.withOpacity(0.15);
    } else if (status == AppStrings.confirmed) {
      return Colors.purple.withOpacity(0.15);
    } else if (status == AppStrings.shipped) {
      return Colors.orange.withOpacity(0.15);
    } else if (status == AppStrings.delivered) {
      return Colors.green.withOpacity(0.15);
    } else if (status == AppStrings.canceled) {
      return Colors.red.withOpacity(0.15);
    }
    return AppColors.greyColor.withOpacity(0.15);
  }

  Color _getStatusTextColor(String status) {
    if (status == AppStrings.orderPlaced || status == AppStrings.pending) {
      return Colors.blue;
    } else if (status == AppStrings.confirmed) {
      return Colors.purple;
    } else if (status == AppStrings.shipped) {
      return Colors.orange;
    } else if (status == AppStrings.delivered) {
      return Colors.green;
    } else if (status == AppStrings.canceled) {
      return Colors.red;
    }
    return AppColors.greyColor;
  }
}
