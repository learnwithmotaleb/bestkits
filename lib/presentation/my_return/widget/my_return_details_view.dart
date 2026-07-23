import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../service/api_url.dart';
import '../../../../widget/app_button.dart';
import '../controller/my_return_controller.dart';
import '../model/MyReturnDetailsModel.dart';

class MyReturnDetailsView extends StatelessWidget {
  final Data returnDetail;
  final VoidCallback? onBack;

  const MyReturnDetailsView({super.key, required this.returnDetail, this.onBack});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.w(24), vertical: Dimensions.h(8)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.r(16)),
          border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Divider(height: 1, color: AppColors.greyColor.withOpacity(0.2)),
            _buildOrderSummary(),
            Divider(height: 1, color: AppColors.greyColor.withOpacity(0.2)),
            _buildItemsList(),
            _buildReturnDetails(),
            if (returnDetail.status == 'REJECTED') _buildRejectedDetails(),
            if (returnDetail.returnAddress != null) _buildReturnAddress(),
            Padding(
              padding: EdgeInsets.all(Dimensions.w(16)),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: AppStrings.backToMyReturns.tr,
                      onPressed: onBack ?? () =>
                          Get.find<MyReturnController>().backToList(),
                      backgroundColor: const Color(0xFF1A1A1A),
                      textColor: AppColors.primaryColor,
                      borderSideColor: const Color(0xFF1A1A1A),
                      height: 44,
                      borderRadius: 8,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    Color badgeColor;
    Color badgeTextColor;

    final status = returnDetail.status ?? '';
    if (status == 'PENDING' || status == 'IN_REVIEW') {
      badgeColor = AppColors.primaryColor.withOpacity(0.15);
      badgeTextColor = AppColors.primaryColor;
    } else if (status == 'APPROVED') {
      badgeColor = Colors.green.withOpacity(0.1);
      badgeTextColor = Colors.green;
    } else if (status == 'REJECTED' || status == 'CANCELLED') {
      badgeColor = Colors.red.withOpacity(0.1);
      badgeTextColor = Colors.red;
    } else {
      badgeColor = Colors.grey.withOpacity(0.1);
      badgeTextColor = Colors.grey;
    }

    return Padding(
      padding: EdgeInsets.all(Dimensions.w(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "- ${AppStrings.orderIdLabel.tr}: ${returnDetail.order?.displayId ?? ""}",
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    color: AppColors.blackColor,
                  ),
                ),
                SizedBox(height: Dimensions.h(4)),
                Text(
                  returnDetail.submittedOn ?? "",
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 10,
                    color: AppColors.darkGreyColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(8), vertical: Dimensions.h(4)),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(Dimensions.r(20)),
            ),
            child: Text(
              "• ${returnDetail.statusLabel ?? ""}",
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: badgeTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    final seller = returnDetail.order?.seller;
    final sellerName = seller?.profile?.fullName ?? seller?.email ?? "";
    final total = returnDetail.order?.total ?? 0;

    return Padding(
      padding: EdgeInsets.all(Dimensions.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "- ${AppStrings.orderSummary.tr} ( $sellerName )",
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              color: AppColors.blackColor,
            ),
          ),
          SizedBox(height: Dimensions.h(8)),
          RichText(
            text: TextSpan(
              text: "${AppStrings.totalAmount.tr} :- ",
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                color: AppColors.darkGreyColor,
              ),
              children: [
                TextSpan(
                  text: "€${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    final item = returnDetail.returnedItem;
    if (item == null) return const SizedBox.shrink();

    final imageUrl = item.product?.imageUrls?.isNotEmpty == true
        ? ApiUrl.buildImageUrl(item.product!.imageUrls!.first)
        : null;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.w(16), vertical: Dimensions.h(8)),
      child: Container(
        padding: EdgeInsets.all(Dimensions.w(12)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.r(12)),
          border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: Dimensions.w(64),
              height: Dimensions.h(64),
              padding: EdgeInsets.all(Dimensions.w(4)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.r(12)),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported, size: 24))
                  : const Icon(Icons.image_not_supported, size: 24),
            ),
            SizedBox(width: Dimensions.w(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product?.name ?? "",
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                      color: AppColors.blackColor,
                    ),
                  ),
                  SizedBox(height: Dimensions.h(4)),
                  Text(
                    "${AppStrings.quantity.tr} :- ${(item.quantity ?? 0).toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 10,
                      color: AppColors.darkGreyColor,
                    ),
                  ),
                  SizedBox(height: Dimensions.h(8)),
                  Text(
                    "€${item.price?.toStringAsFixed(2) ?? "0.00"}",
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReturnDetails() {
    final images = returnDetail.images ?? [];
    final reason = returnDetail.reason ?? "No reason provided";
    final msg = returnDetail.message?.toString() ?? "No message";

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Dimensions.w(16), vertical: Dimensions.h(8)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.r(12)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(Dimensions.w(16)),
            child: Text(
              AppStrings.returnDetails.tr,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ),
          Divider(height: 1, color: AppColors.greyColor.withOpacity(0.2)),
          Padding(
            padding: EdgeInsets.all(Dimensions.w(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Return Reason
                Text(
                  AppStrings.returnReason.tr,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: AppColors.blackColor,
                  ),
                ),
                SizedBox(height: Dimensions.h(4)),
                Text(
                  reason,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: AppColors.darkGreyColor,
                  ),
                ),
                SizedBox(height: Dimensions.h(16)),

                // Submitted On
                Text(
                  AppStrings.submittedOn.tr,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: AppColors.blackColor,
                  ),
                ),
                SizedBox(height: Dimensions.h(4)),
                Text(
                  returnDetail.submittedOn ?? "—",
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: AppColors.darkGreyColor,
                  ),
                ),
                SizedBox(height: Dimensions.h(16)),

                // Evidence Images
                Text(
                  AppStrings.evidence.tr,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: AppColors.blackColor,
                  ),
                ),
                SizedBox(height: Dimensions.h(8)),
                if (images.isEmpty)
                  Text(
                    "No evidence uploaded",
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      color: AppColors.darkGreyColor,
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: images.map((imgUrl) {
                      return Container(
                        width: 60,
                        height: 60,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.greyColor.withOpacity(0.2)),
                        ),
                        child: Image.network(
                          ApiUrl.buildImageUrl(imgUrl),
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported, size: 24),
                        ),
                      );
                    }).toList(),
                  ),
                SizedBox(height: Dimensions.h(16)),

                // Message
                Text(
                  AppStrings.message.tr,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: AppColors.blackColor,
                  ),
                ),
                SizedBox(height: Dimensions.h(4)),
                Text(
                  msg,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 10,
                    color: AppColors.darkGreyColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectedDetails() {
    final rejectionReason =
        returnDetail.sellerRejectionReason?.toString() ?? "No reason provided";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: Dimensions.w(16), vertical: Dimensions.h(8)),
          padding: EdgeInsets.all(Dimensions.w(16)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.r(12)),
            border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
          ),
          child: Row(
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
                      AppStrings.sellerRejectedRequest.tr,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: Dimensions.h(4)),
                    Text(
                      "${AppStrings.onDate.tr} ${returnDetail.resolvedAt?.toString() ?? returnDetail.submittedOn ?? "—"}",
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 10,
                        color: AppColors.darkGreyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: Dimensions.w(16), vertical: Dimensions.h(4)),
          padding: EdgeInsets.all(Dimensions.w(16)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.r(12)),
            border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.reasonForRejection.tr,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: Dimensions.h(8)),
              Text(
                rejectionReason,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 10,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReturnAddress() {
    final addr = returnDetail.returnAddress;
    String addressText = "No address provided";
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

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.w(16), vertical: Dimensions.h(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "- ${AppStrings.returnAddress.tr}",
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              color: AppColors.blackColor,
            ),
          ),
          SizedBox(height: Dimensions.h(12)),
          Container(
            padding: EdgeInsets.all(Dimensions.w(16)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.r(12)),
              border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(Dimensions.w(10)),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(Dimensions.r(12)),
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
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                          color: AppColors.blackColor,
                        ),
                      ),
                      SizedBox(height: Dimensions.h(4)),
                      Text(
                        addressText,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color: AppColors.darkGreyColor,
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
}
