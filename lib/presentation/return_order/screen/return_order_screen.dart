import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/responsive_layout/dimensions.dart';
import '../../../service/api_url.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../widget/custom_appbar.dart';
import '../../../widget/app_button.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../controller/return_order_controller.dart';
import '../model/ReturnOrderModel.dart';
import '../../my_return/widget/my_return_details_view.dart';

class ReturnOrderScreen extends StatefulWidget {
  const ReturnOrderScreen({super.key});

  @override
  State<ReturnOrderScreen> createState() => _ReturnOrderScreenState();
}

class _ReturnOrderScreenState extends State<ReturnOrderScreen> {
  // Use Get.put so it initializes even if accessed via Get.to() instead of Get.toNamed()
  final _ctrl = Get.put(ReturnOrderController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (_ctrl.selectedReturnDetail.value != null) {
          _ctrl.backToList();
        } else {
          Get.back();
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: AppStrings.returnOrdersTitle.tr,
        onBack: () {
          if (_ctrl.selectedReturnDetail.value != null) {
            _ctrl.backToList();
          } else {
            Get.back();
          }
        },
      ),
      body: Column(
        children: [
          SizedBox(height: Dimensions.h(10)),
          // ── Horizontal Tabs ───────────────────────────────────────────────
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
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.w(16)),
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

          // ── Body ──────────────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              // Show detail loading
              if (_ctrl.isDetailLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primaryColor),
                );
              }

              // Show detail view when selected
              if (_ctrl.selectedReturnDetail.value != null) {
                return MyReturnDetailsView(
                  returnDetail: _ctrl.selectedReturnDetail.value!,
                  onBack: () => _ctrl.backToList(),
                );
              }

              // Show list loading
              if (_ctrl.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primaryColor),
                );
              }

              final orders = _ctrl.allOrders;

              if (orders.isEmpty) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(vertical: Dimensions.h(32)),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.r(12)),
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
                          AppStrings.noReturnOrdersFound.tr,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.greyColor,
                            fontSize: Dimensions.fs(13),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.w(20),
                    vertical: Dimensions.h(4)),
                itemCount: orders.length,
                separatorBuilder: (_, __) =>
                    SizedBox(height: Dimensions.h(16)),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return _buildOrderCard(order);
                },
              );
            }),
          ),
        ],
      ),
    ));
  }

  Widget _buildOrderCard(Data order) {
    final status = order.status ?? '';
    final statusLabel = order.statusLabel ?? status;
    final imageUrl =
        ApiUrl.buildImageUrl(order.previewItem?.imageUrl);

    return Container(
      padding: Dimensions.pSym(h: 16, v: 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(16)),
        border:
            Border.all(color: AppColors.greyColor.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: order ID + status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "- ${AppStrings.orderIdLabel.tr}: ${order.displayOrderId ?? ''}",
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: Dimensions.fs(13),
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Dimensions.h(4)),
                    Text(
                      order.submittedOn ?? '',
                      style: AppTextStyles.body.copyWith(
                        fontSize: Dimensions.fs(10),
                        color: AppColors.greyColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.w(8),
                    vertical: Dimensions.h(4)),
                decoration: BoxDecoration(
                  color: _statusBgColor(status),
                  borderRadius: BorderRadius.circular(Dimensions.r(12)),
                ),
                child: Text(
                  "• $statusLabel",
                  style: AppTextStyles.body.copyWith(
                    fontSize: Dimensions.fs(10),
                    fontWeight: FontWeight.w600,
                    color: _statusTextColor(status),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.h(16)),
          Divider(
              height: 1,
              color: AppColors.greyColor.withOpacity(0.15)),
          SizedBox(height: Dimensions.h(12)),

          // Product row
          Row(
            children: [
              // Product image
              Container(
                width: Dimensions.w(56),
                height: Dimensions.h(56),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.r(10)),
                  border: Border.all(color: AppColors.primaryColor),
                ),
                child: imageUrl.isNotEmpty
                    ? Image.network(imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported,
                            size: 20,
                            color: AppColors.greyColor))
                    : const Icon(Icons.image_not_supported,
                        size: 20, color: AppColors.greyColor),
              ),
              SizedBox(width: Dimensions.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.previewItem?.name ?? '',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: Dimensions.fs(13),
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Dimensions.h(4)),
                    Text(
                      "${AppStrings.quantity.tr}: ${(order.previewItem?.quantity ?? 0).toString().padLeft(2, '0')}",
                      style: AppTextStyles.body.copyWith(
                        fontSize: Dimensions.fs(10),
                        color: AppColors.greyColor,
                      ),
                    ),
                    SizedBox(height: Dimensions.h(4)),
                    Text(
                      "€${order.previewItem?.price?.toStringAsFixed(2) ?? '0.00'}",
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: Dimensions.fs(13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.h(12)),

          // Buyer info
          if (order.buyer?.profile?.fullName != null) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: Dimensions.r(14),
                  backgroundImage: NetworkImage(
                      ApiUrl.buildImageUrl(
                          order.buyer?.profile?.avatarUrl)),
                  backgroundColor:
                      AppColors.greyColor.withOpacity(0.2),
                  onBackgroundImageError: (_, __) {},
                ),
                SizedBox(width: Dimensions.w(8)),
                Text(
                  order.buyer!.profile!.fullName!,
                  style: AppTextStyles.body.copyWith(
                    fontSize: Dimensions.fs(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.h(12)),
          ],

          Divider(
              height: 1,
              color: AppColors.greyColor.withOpacity(0.15)),
          SizedBox(height: Dimensions.h(12)),

          // View details button
          AppButton(
            label: AppStrings.viewDetailsBtn.tr,
            onPressed: () => _ctrl.viewDetails(order),
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
  }

  Color _statusBgColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange.withOpacity(0.12);
      case 'APPROVED':
        return Colors.green.withOpacity(0.12);
      case 'PROCESSING':
        return Colors.blue.withOpacity(0.12);
      case 'COMPLETED':
        return Colors.teal.withOpacity(0.12);
      case 'REJECTED':
        return Colors.red.withOpacity(0.12);
      default:
        return AppColors.greyColor.withOpacity(0.12);
    }
  }

  Color _statusTextColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'APPROVED':
        return Colors.green;
      case 'PROCESSING':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.teal;
      case 'REJECTED':
        return Colors.red;
      default:
        return AppColors.greyColor;
    }
  }
}
