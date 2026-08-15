import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';
import '../../../../utils/static_strings/static_strings.dart';
import '../../../../service/api_url.dart';
import '../../../../widget/app_button.dart';
import '../model/ReturnOrderDetailsModel.dart';
import '../controller/return_order_controller.dart';

class ReturnOrderDetails extends StatelessWidget {
  final Data returnDetail;
  final VoidCallback onBack;

  const ReturnOrderDetails({
    super.key,
    required this.returnDetail,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final status = returnDetail.status ?? '';
    final isCompleted = status == 'COMPLETED';
    final isRejected = status == 'REJECTED';
    final isProcessing = status == 'PROCESSING';

    final canUpdateStatus = returnDetail.actions?.canUpdateStatus ?? false;

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => Get.find<ReturnOrderController>()
                .fetchReturnDetails(returnDetail.id.toString(),
                    isRefresh: true),
            color: AppColors.primaryColor,
            backgroundColor: AppColors.whiteColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(20),
                vertical: Dimensions.h(10),
              ),
              child: Column(
                children: [
                  _buildOrderInfoCard(),
                  SizedBox(height: Dimensions.h(16)),
                  if (returnDetail.order?.deliveredAt != null) ...[
                    _buildDeliveredOnCard(returnDetail.order!.deliveredAt!),
                    SizedBox(height: Dimensions.h(16)),
                  ],
                  _buildReturnDetailsCard(),
                  if (returnDetail.returnAddress != null) ...[
                    SizedBox(height: Dimensions.h(16)),
                    _buildReturnAddressCard(),
                  ],
                  if (isCompleted) ...[
                    SizedBox(height: Dimensions.h(16)),
                    _buildCompletedCard(),
                  ],
                  if (isRejected &&
                      returnDetail.sellerRejectionReason != null) ...[
                    SizedBox(height: Dimensions.h(16)),
                    _buildRejectedCard(),
                  ],
                  SizedBox(height: Dimensions.h(20)),
                ],
              ),
            ),
          ),
        ),
        if (canUpdateStatus)
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(20), vertical: Dimensions.h(24)),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: AppButton(
              label: "Update Return Status",
              onPressed: () => _showUpdateStatusBottomSheet(context, status),
              backgroundColor: AppColors.blackColor,
              textColor: AppColors.primaryColor,
              height: 48,
              borderRadius: 8,
            ),
          ),
      ],
    );
  }

  Widget _buildOrderInfoCard() {
    final status = returnDetail.status ?? '';
    final statusLabel = returnDetail.statusLabel ?? status;
    final submittedOn = returnDetail.submittedOn ?? '';
    final orderId = returnDetail.order?.displayId ?? '';
    final total = returnDetail.order?.total ?? 0.0;

    return Container(
      padding: EdgeInsets.all(Dimensions.w(16)),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(12)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "- ${AppStrings.orderIdLabel.tr}: $orderId",
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: Dimensions.fs(14),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: Dimensions.h(4)),
                    Text(
                      submittedOn,
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
                    horizontal: Dimensions.w(8), vertical: Dimensions.h(4)),
                decoration: BoxDecoration(
                  color: _statusBgColor(status),
                  borderRadius: BorderRadius.circular(Dimensions.r(12)),
                ),
                child: Text(
                  "• $statusLabel",
                  style: AppTextStyles.body.copyWith(
                    fontSize: Dimensions.fs(10),
                    fontWeight: FontWeight.w700,
                    color: _statusTextColor(status),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.h(16)),
          Divider(height: 1, color: AppColors.greyColor.withOpacity(0.15)),
          SizedBox(height: Dimensions.h(16)),
          Text(
            "- ${AppStrings.orderSummary.tr}",
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: Dimensions.fs(14),
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: Dimensions.h(8)),
          Text(
            "${AppStrings.totalAmount.tr} :- €${total.toStringAsFixed(2)}",
            style: AppTextStyles.body.copyWith(
              fontSize: Dimensions.fs(12),
              color: AppColors.greyColor,
            ),
          ),
          SizedBox(height: Dimensions.h(16)),
          if (returnDetail.returnedItem != null)
            _buildProductItem(returnDetail.returnedItem!)
          else if (returnDetail.order?.items != null &&
              returnDetail.order!.items!.isNotEmpty)
            _buildProductItemFromOrder(returnDetail.order!.items!.first),
        ],
      ),
    );
  }

  Widget _buildProductItemFromOrder(Items item) {
    final imageUrl = item.product?.imageUrls?.isNotEmpty == true
        ? ApiUrl.buildImageUrl(item.product!.imageUrls!.first)
        : '';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: Dimensions.w(56),
          height: Dimensions.h(56),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.r(8)),
            border: Border.all(color: AppColors.primaryColor),
          ),
          child: imageUrl.isNotEmpty
              ? Image.network(imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported,
                      color: AppColors.greyColor))
              : const Icon(Icons.image_not_supported,
                  color: AppColors.greyColor),
        ),
        SizedBox(width: Dimensions.w(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product?.name ?? '',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: Dimensions.fs(14),
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: Dimensions.h(4)),
              Text(
                "€${item.price?.toStringAsFixed(2) ?? '0.00'}",
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: Dimensions.fs(13),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(ReturnedItem item) {
    final imageUrl = item.product?.imageUrls?.isNotEmpty == true
        ? ApiUrl.buildImageUrl(item.product!.imageUrls!.first)
        : '';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: Dimensions.w(56),
          height: Dimensions.h(56),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.r(8)),
            border: Border.all(color: AppColors.primaryColor),
          ),
          child: imageUrl.isNotEmpty
              ? Image.network(imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported,
                      color: AppColors.greyColor))
              : const Icon(Icons.image_not_supported,
                  color: AppColors.greyColor),
        ),
        SizedBox(width: Dimensions.w(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product?.name ?? '',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: Dimensions.fs(14),
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: Dimensions.h(4)),
              Text(
                "€${item.price?.toStringAsFixed(2) ?? '0.00'}",
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: Dimensions.fs(13),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveredOnCard(String deliveredAt) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.w(16)),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(12)),
        border: Border.all(color: AppColors.primaryColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delivered On",
            style: AppTextStyles.body.copyWith(
              fontSize: Dimensions.fs(11),
              color: AppColors.greyColor,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: Dimensions.h(4)),
          Text(
            deliveredAt,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: Dimensions.fs(13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnDetailsCard() {
    final reason = returnDetail.reason ?? "No reason provided";
    final msg = returnDetail.message?.toString() ?? "";
    final images = returnDetail.images ?? [];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(12)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(Dimensions.w(16)),
            child: Text(
              "Return Details",
              style: AppTextStyles.body.copyWith(
                fontSize: Dimensions.fs(13),
                fontWeight: FontWeight.w600,
                color: AppColors.greyColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Divider(height: 1, color: AppColors.greyColor.withOpacity(0.15)),
          Padding(
            padding: EdgeInsets.all(Dimensions.w(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.returnReason.tr,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: Dimensions.fs(12),
                  ),
                ),
                SizedBox(height: Dimensions.h(4)),
                Text(
                  reason,
                  style: AppTextStyles.body.copyWith(
                    fontSize: Dimensions.fs(12),
                    color: AppColors.greyColor,
                  ),
                ),
                SizedBox(height: Dimensions.h(16)),
                Text(
                  AppStrings.submittedOn.tr,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: Dimensions.fs(12),
                  ),
                ),
                SizedBox(height: Dimensions.h(4)),
                Text(
                  returnDetail.submittedOn ?? '',
                  style: AppTextStyles.body.copyWith(
                    fontSize: Dimensions.fs(12),
                    color: AppColors.greyColor,
                  ),
                ),
                SizedBox(height: Dimensions.h(16)),
                Text(
                  AppStrings.evidence.tr,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: Dimensions.fs(12),
                  ),
                ),
                SizedBox(height: Dimensions.h(8)),
                if (images.isEmpty)
                  Text(
                    'No evidence uploaded',
                    style: AppTextStyles.body.copyWith(
                      fontSize: Dimensions.fs(12),
                      color: AppColors.greyColor,
                    ),
                  )
                else
                  Wrap(
                    spacing: Dimensions.w(8),
                    runSpacing: Dimensions.h(8),
                    children: images.map((imgUrl) {
                      return Container(
                        width: Dimensions.w(64),
                        height: Dimensions.h(64),
                        padding: EdgeInsets.all(Dimensions.w(4)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.r(8)),
                          border: Border.all(
                              color: AppColors.greyColor.withOpacity(0.2)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.r(4)),
                          child: Image.network(
                            ApiUrl.buildImageUrl(imgUrl),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.image_not_supported,
                                color: AppColors.greyColor),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                if (msg.isNotEmpty) ...[
                  SizedBox(height: Dimensions.h(16)),
                  Text(
                    AppStrings.message.tr,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: Dimensions.fs(12),
                    ),
                  ),
                  SizedBox(height: Dimensions.h(4)),
                  Text(
                    msg,
                    style: AppTextStyles.body.copyWith(
                      fontSize: Dimensions.fs(11),
                      color: AppColors.greyColor,
                      height: 1.5,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnAddressCard() {
    final addr = returnDetail.returnAddress;
    String addressText = 'No address provided';
    if (addr is Map) {
      final parts = <String>[];
      if (addr['address'] != null) parts.add(addr['address'].toString());
      if (addr['city'] != null) parts.add(addr['city'].toString());
      if (addr['postal_code'] != null)
        parts.add(addr['postal_code'].toString());
      if (addr['country'] != null) parts.add(addr['country'].toString());
      if (parts.isNotEmpty) addressText = parts.join(', ');
    } else if (addr != null) {
      addressText = addr.toString();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(12)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(Dimensions.w(16)),
            child: Text(
              "- ${AppStrings.returnAddress.tr}",
              style: AppTextStyles.body.copyWith(
                fontSize: Dimensions.fs(13),
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Divider(height: 1, color: AppColors.greyColor.withOpacity(0.15)),
          Padding(
            padding: EdgeInsets.all(Dimensions.w(16)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(Dimensions.w(10)),
                  decoration: BoxDecoration(
                    color: AppColors.blackColor,
                    borderRadius: BorderRadius.circular(Dimensions.r(8)),
                  ),
                  child: const Icon(Icons.location_on_outlined,
                      color: AppColors.primaryColor, size: 20),
                ),
                SizedBox(width: Dimensions.w(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.location.tr,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: Dimensions.fs(13),
                        ),
                      ),
                      SizedBox(height: Dimensions.h(4)),
                      Text(
                        addressText,
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
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedCard() {
    return Container(
      padding: EdgeInsets.all(Dimensions.w(16)),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(Dimensions.r(12)),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(Dimensions.w(6)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green),
            ),
            child: const Icon(Icons.check, color: Colors.green, size: 16),
          ),
          SizedBox(width: Dimensions.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Return Completed & Refunded",
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: Dimensions.fs(13),
                    color: AppColors.blackColor,
                  ),
                ),
                SizedBox(height: Dimensions.h(4)),
                Text(
                  "On ${returnDetail.completedAt ?? returnDetail.resolvedAt ?? returnDetail.submittedOn ?? ''}",
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
    );
  }

  Widget _buildRejectedCard() {
    return Container(
      padding: EdgeInsets.all(Dimensions.w(16)),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(12)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    const Icon(Icons.info_outline, color: Colors.red, size: 20),
              ),
              SizedBox(width: Dimensions.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "You Rejected This Return Request",
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: Dimensions.fs(13),
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: Dimensions.h(4)),
                    Text(
                      "On ${returnDetail.resolvedAt ?? returnDetail.submittedOn ?? ''}",
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
          SizedBox(height: Dimensions.h(16)),
          Text(
            "Reason For Rejection",
            style: AppTextStyles.body.copyWith(
              fontSize: Dimensions.fs(12),
              fontWeight: FontWeight.w600,
              color: AppColors.greyColor,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: Dimensions.h(4)),
          Text(
            returnDetail.sellerRejectionReason ?? '',
            style: AppTextStyles.body.copyWith(
              fontSize: Dimensions.fs(12),
              color: AppColors.blackColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateStatusBottomSheet(
      BuildContext context, String currentStatus) {
    Get.bottomSheet(
      _UpdateStatusBottomSheet(
        currentStatus: currentStatus,
        returnId: returnDetail.id.toString(),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Color _statusBgColor(String status) {
    switch (status) {
      case 'PENDING':
      case 'IN_REVIEW':
        return Colors.orange.withOpacity(0.12);
      case 'APPROVED':
      case 'PROCESSING':
        return Colors.blue.withOpacity(0.12);
      case 'COMPLETED':
        return Colors.teal.withOpacity(0.12);
      case 'REJECTED':
        return Colors.red.withOpacity(0.12);
      default:
        return Colors.orange.withOpacity(0.12);
    }
  }

  Color _statusTextColor(String status) {
    switch (status) {
      case 'PENDING':
      case 'IN_REVIEW':
        return Colors.orange;
      case 'APPROVED':
      case 'PROCESSING':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.teal;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}

class _UpdateStatusBottomSheet extends StatefulWidget {
  final String currentStatus;
  final String returnId;

  const _UpdateStatusBottomSheet(
      {required this.currentStatus, required this.returnId});

  @override
  _UpdateStatusBottomSheetState createState() =>
      _UpdateStatusBottomSheetState();
}

class _UpdateStatusBottomSheetState extends State<_UpdateStatusBottomSheet> {
  late String selectedStatusUI;

  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _rejectionCtrl = TextEditingController();

  final List<String> statuses = [
    'In review',
    'Processing',
    'Completed',
    'Rejected'
  ];

  @override
  void initState() {
    super.initState();
    selectedStatusUI = _mapApiStatusToUI(widget.currentStatus);
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    _rejectionCtrl.dispose();
    super.dispose();
  }

  String _mapApiStatusToUI(String status) {
    if (status == 'PENDING' || status == 'IN_REVIEW') return 'In review';
    if (status == 'APPROVED' || status == 'PROCESSING') return 'Processing';
    if (status == 'COMPLETED') return 'Completed';
    if (status == 'REJECTED') return 'Rejected';
    return 'In review';
  }

  String _mapUIToApiStatus(String statusUI) {
    if (statusUI == 'In review') return 'PENDING';
    if (statusUI == 'Processing') return 'PROCESSING';
    if (statusUI == 'Completed') return 'COMPLETED';
    if (statusUI == 'Rejected') return 'REJECTED';
    return 'PENDING';
  }

  void _showServiceTypeSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: Dimensions.w(20),
          right: Dimensions.w(20),
          top: Dimensions.h(20),
          bottom: Dimensions.h(20) + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(Dimensions.r(20))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Service Type",
              style: AppTextStyles.body.copyWith(
                fontSize: Dimensions.fs(16),
                fontWeight: FontWeight.w700,
                color: AppColors.greyColor,
              ),
            ),
            SizedBox(height: Dimensions.h(16)),
            ...statuses
                .map((status) => InkWell(
                      onTap: () {
                        setState(() {
                          selectedStatusUI = status;
                        });
                        Get.back();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: Dimensions.h(16)),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: AppColors.greyColor.withOpacity(0.1)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              status,
                              style: AppTextStyles.body.copyWith(
                                fontSize: Dimensions.fs(14),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Icon(
                              selectedStatusUI == status
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: selectedStatusUI == status
                                  ? AppColors.blackColor
                                  : AppColors.greyColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: Dimensions.w(20),
        right: Dimensions.w(20),
        top: Dimensions.h(20),
        bottom: MediaQuery.of(context).viewInsets.bottom + Dimensions.h(20),
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Dimensions.r(20))),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "- Update Return Status",
                  style: AppTextStyles.body.copyWith(
                    fontSize: Dimensions.fs(15),
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close,
                      size: 20, color: AppColors.greyColor),
                ),
              ],
            ),
            SizedBox(height: Dimensions.h(8)),
            Text(
              "Update the current return request status to keep the customer informed about the return progress.",
              style: AppTextStyles.body.copyWith(
                fontSize: Dimensions.fs(12),
                color: AppColors.greyColor,
                height: 1.4,
              ),
            ),
            SizedBox(height: Dimensions.h(20)),
            Text(
              "Return Status (Select)",
              style: AppTextStyles.body.copyWith(
                fontSize: Dimensions.fs(12),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: Dimensions.h(8)),
            GestureDetector(
              onTap: _showServiceTypeSheet,
              child: Container(
                padding: EdgeInsets.all(Dimensions.w(16)),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: AppColors.greyColor.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(Dimensions.r(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedStatusUI,
                        style: AppTextStyles.body
                            .copyWith(fontSize: Dimensions.fs(14))),
                    const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.greyColor),
                  ],
                ),
              ),
            ),
            SizedBox(height: Dimensions.h(20)),
            if (selectedStatusUI == 'Processing') ...[
              Text(
                "Return Shipping Address",
                style: AppTextStyles.body.copyWith(
                  fontSize: Dimensions.fs(12),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: Dimensions.h(8)),
              TextField(
                controller: _addressCtrl,
                decoration: InputDecoration(
                  hintText: "Enter The Warehouse Or Shop Address...",
                  hintStyle: AppTextStyles.body.copyWith(
                      fontSize: Dimensions.fs(12), color: AppColors.greyColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r(12)),
                      borderSide: BorderSide(
                          color: AppColors.greyColor.withOpacity(0.2))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r(12)),
                      borderSide: BorderSide(
                          color: AppColors.greyColor.withOpacity(0.2))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r(12)),
                      borderSide:
                          const BorderSide(color: AppColors.primaryColor)),
                ),
              ),
              SizedBox(height: Dimensions.h(20)),
            ],
            if (selectedStatusUI == 'Rejected') ...[
              Text(
                "Rejection Note",
                style: AppTextStyles.body.copyWith(
                  fontSize: Dimensions.fs(12),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: Dimensions.h(8)),
              TextField(
                controller: _rejectionCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      "Please provide a reason for the rejection. This will be sent to the customer immediately.",
                  hintStyle: AppTextStyles.body.copyWith(
                      fontSize: Dimensions.fs(12), color: AppColors.greyColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r(12)),
                      borderSide: BorderSide(
                          color: AppColors.greyColor.withOpacity(0.2))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r(12)),
                      borderSide: BorderSide(
                          color: AppColors.greyColor.withOpacity(0.2))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r(12)),
                      borderSide:
                          const BorderSide(color: AppColors.primaryColor)),
                ),
              ),
              SizedBox(height: Dimensions.h(20)),
            ],
            AppButton(
              label: _getButtonLabel(),
              onPressed: () {
                _showWarningToster();
              },
              backgroundColor: AppColors.blackColor,
              textColor: AppColors.primaryColor,
              height: 48,
              borderRadius: 8,
              trailingIcon: const Icon(
                Icons.double_arrow_rounded,
                color: AppColors.primaryColor,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonLabel() {
    if (selectedStatusUI == 'Processing') return 'Confirm & Send Instructions';
    if (selectedStatusUI == 'Completed')
      return 'Issue Refund & Completed Request';
    if (selectedStatusUI == 'Rejected') return 'Confirm Rejection';
    return 'Update status';
  }

  void _showWarningToster() {
    Get.back(); // close the bottom sheet
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.r(16))),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(Dimensions.w(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(Dimensions.w(16)),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Dimensions.r(16)),
                ),
                child: const Icon(Icons.error_outline,
                    color: Colors.red, size: 40),
              ),
              SizedBox(height: Dimensions.h(16)),
              Text(
                "Update Return Status !",
                style: AppTextStyles.body.copyWith(
                    fontSize: Dimensions.fs(16), fontWeight: FontWeight.w700),
              ),
              SizedBox(height: Dimensions.h(8)),
              Text(
                "Are you sure you want to update this return request status? The customer will be notified immediately.",
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                    fontSize: Dimensions.fs(12),
                    color: AppColors.greyColor,
                    height: 1.5),
              ),
              SizedBox(height: Dimensions.h(24)),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: Dimensions.h(14)),
                        side: BorderSide(
                            color: AppColors.greyColor.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Dimensions.r(8))),
                      ),
                      child: Text("Cancel",
                          style: AppTextStyles.body.copyWith(
                              color: AppColors.greyColor,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(width: Dimensions.w(12)),
                  Expanded(
                    child: Obx(() => AppButton(
                          label: "Confirm",
                          isLoading: Get.find<ReturnOrderController>()
                              .isUpdateLoading
                              .value,
                          onPressed: () async {
                            final apiStatus =
                                _mapUIToApiStatus(selectedStatusUI);
                            await Get.find<ReturnOrderController>()
                                .updateReturnStatus(
                              id: widget.returnId,
                              status: apiStatus,
                              returnAddress: _addressCtrl.text,
                              sellerRejectionReason: _rejectionCtrl.text,
                            );
                            Get.back(); // close dialog
                            Get.back(); // close bottom sheet
                          },
                          backgroundColor: AppColors.blackColor,
                          textColor: AppColors.primaryColor,
                          height: 48,
                          borderRadius: 8,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
