import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../widget/app_button.dart';
import 'package:bestkits/presentation/bottom_nav/page/order/controller/order_controller.dart';
import '../controller/my_return_controller.dart';

class MyReturnDetailsView extends StatelessWidget {
  final ReturnModel returnModel;

  const MyReturnDetailsView({super.key, required this.returnModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.w(24), vertical: Dimensions.h(8)),
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
            if (returnModel.statusTab == AppStrings.rejected) _buildRejectedDetails(),
            if (returnModel.statusTab == AppStrings.accepted) _buildReturnAddress(),
            Padding(
              padding: EdgeInsets.all(Dimensions.w(16)),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: AppStrings.backToMyReturns.tr,
                      onPressed: () => Get.find<MyReturnController>().backToList(),
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

    if (returnModel.returnStatus == AppStrings.inReview) {
      badgeColor = AppColors.primaryColor.withOpacity(0.15);
      badgeTextColor = AppColors.primaryColor;
    } else if (returnModel.returnStatus == AppStrings.processing) {
      badgeColor = Colors.blue.withOpacity(0.1);
      badgeTextColor = Colors.blue;
    } else if (returnModel.returnStatus == AppStrings.completed) {
      badgeColor = Colors.green.withOpacity(0.1);
      badgeTextColor = Colors.green;
    } else if (returnModel.returnStatus == AppStrings.rejected) {
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
                  "- ${AppStrings.orderIdLabel.tr}: ${returnModel.orderId}",
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
                  returnModel.date,
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
            padding: EdgeInsets.symmetric(horizontal: Dimensions.w(8), vertical: Dimensions.h(4)),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(Dimensions.r(20)),
            ),
            child: Text(
              "• ${returnModel.returnStatus.tr}",
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
    return Padding(
      padding: EdgeInsets.all(Dimensions.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "- ${AppStrings.orderSummary.tr} ( ${returnModel.sellerName} )",
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
                  text: "€${returnModel.totalAmount.toStringAsFixed(2)}",
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.w(16), vertical: Dimensions.h(8)),
      child: Column(
        children: returnModel.items.map((OrderItem item) {
          return Container(
            margin: EdgeInsets.only(bottom: Dimensions.h(12)),
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
                  child: Image.asset(item.image, fit: BoxFit.contain),
                ),
                SizedBox(width: Dimensions.w(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
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
                        "${AppStrings.quantity.tr} :- ${item.quantity.toString().padLeft(2, '0')} • ${AppStrings.variant.tr} :- ${item.variant}",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 10,
                          color: AppColors.darkGreyColor,
                        ),
                      ),
                      SizedBox(height: Dimensions.h(8)),
                      Text(
                        "€${item.price.toStringAsFixed(2)}",
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
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReturnDetails() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.w(16), vertical: Dimensions.h(8)),
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
                  returnModel.returnReason,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: AppColors.darkGreyColor,
                  ),
                ),
                SizedBox(height: Dimensions.h(16)),
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
                  returnModel.submittedOn,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: AppColors.darkGreyColor,
                  ),
                ),
                SizedBox(height: Dimensions.h(16)),
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
                Row(
                  children: returnModel.evidenceImages.map((img) {
                    return Container(
                      margin: EdgeInsets.only(right: Dimensions.w(8)),
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: Image.asset(img, fit: BoxFit.contain),
                    );
                  }).toList(),
                ),
                SizedBox(height: Dimensions.h(16)),
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
                  returnModel.message,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: Dimensions.w(16), vertical: Dimensions.h(8)),
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
                child: const Icon(Icons.info_outline, color: Colors.red, size: 20),
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
                      "${AppStrings.onDate.tr} ${returnModel.rejectedOn ?? ''}",
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
          margin: EdgeInsets.symmetric(horizontal: Dimensions.w(16), vertical: Dimensions.h(4)),
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
                returnModel.rejectionReason ?? '',
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.w(16), vertical: Dimensions.h(8)),
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
                  child: const Icon(Icons.location_on_outlined, color: AppColors.primaryColor, size: 20),
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
                        returnModel.location ?? '',
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
