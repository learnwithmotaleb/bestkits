import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../controller/order_controller.dart';
import '../../../../../widget/app_button.dart';
import '../../../../../widget/app_bottom_sheet.dart';
import '../../../../../widget/app_text_field.dart';
import '../../../../../widget/app_alert.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:io';

class OrderDetailsView extends StatelessWidget {
  final OrderModel order;
  final OrderController controller;

  const OrderDetailsView(
      {super.key, required this.order, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.w(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Order ID and status)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '- ${AppStrings.orderIdLabel.tr}: ${order.orderId}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                fontStyle: FontStyle.italic),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.date,
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[400],
                                fontStyle: FontStyle.italic),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: order.status == AppStrings.complete
                            ? Colors.green.withOpacity(0.1)
                            : (order.status == AppStrings.canceled
                                ? Colors.red.withOpacity(0.1)
                                : Colors.blue.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        order.subStatus.tr,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: order.status == AppStrings.complete
                              ? Colors.green
                              : (order.status == AppStrings.canceled
                                  ? Colors.red
                                  : Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Order Summary Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '- ${AppStrings.orderSummary.tr} ( ${order.sellerName} )',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${AppStrings.totalAmount.tr} :- €${order.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey),
                      ),
                      const SizedBox(height: 16),

                      // Items
                      ...order.items
                          .map((item) => Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          AppColors.greyColor.withOpacity(0.2)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F5F5),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: AppColors.primaryColor,
                                            width: 1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: Image.asset(item.image,
                                            fit: BoxFit.contain,
                                            errorBuilder: (c, e, s) =>
                                                const Icon(Icons.image,
                                                    color: Colors.grey)),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w800,
                                                fontStyle: FontStyle.italic),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${AppStrings.quantity.tr} :- ${item.quantity.toString().padLeft(2, '0')} • ${AppStrings.sizeVariant.tr} :- ${item.variant}',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[500]),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '€${item.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Delivery Address
                Text(
                  '- ${AppStrings.deliveryAddress.tr}',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.location_on_outlined,
                          color: AppColors.primaryColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.locationTag.tr,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.location,
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Extra UI based on status
                if (order.status == AppStrings.canceled) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.error_outline,
                              color: Colors.red, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                AppStrings.sellerCanceledOrder.tr,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.red),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${AppStrings.onDate.tr} ${order.date}',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[500],
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (order.status == AppStrings.complete &&
                    order.isReviewed) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.primaryColor),
                                  ),
                                  child: Text(
                                      AppStrings.dummyReviewerInitials.tr,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppStrings.dummyReviewerName.tr,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            fontStyle: FontStyle.italic)),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: AppColors.primaryColor,
                                            size: 12),
                                        const SizedBox(width: 4),
                                        Text(AppStrings.dummyRating.tr,
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(AppStrings.dummyReviewDate.tr,
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey[400])),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppStrings.dummyReview1.tr,
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                              height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),

        // Bottom Actions
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (order.status != AppStrings.canceled) ...[
                    Expanded(
                      flex: 1,
                      child: _buildBackButton(),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: _buildActionButton(context, order),
                    ),
                  ] else ...[
                    Expanded(
                      child: _buildBackButton(),
                    ),
                  ],
                ],
              ),
              if (order.status == AppStrings.complete) ...[
                const SizedBox(height: 10),
                if (!order.isReviewed)
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: AppButton(
                          label: AppStrings.leaveAReview.tr,
                          onPressed: () => _showReviewBottomSheet(context),
                          backgroundColor: Colors.white,
                          textColor: AppColors.primaryColor,
                          borderSideColor: AppColors.primaryColor,
                          leadingIcon: const Icon(Icons.star_border,
                              color: AppColors.primaryColor, size: 18),
                          height: 44,
                          borderRadius: 8,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(flex: 1, child: SizedBox()),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: AppButton(
                          label: AppStrings.reviewed.tr,
                          onPressed: null,
                          backgroundColor: Colors.white,
                          textColor: Colors.grey[400]!,
                          borderSideColor: Colors.grey.withOpacity(0.3),
                          height: 44,
                          borderRadius: 8,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(flex: 1, child: SizedBox()),
                    ],
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _showReviewBottomSheet(BuildContext context) {
    AppBottomSheet(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '- ${AppStrings.writeAReview.tr}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, size: 20, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.reviewInstruction.tr,
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.selectStars.tr,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 28,
              unratedColor: Colors.grey,
              itemPadding: const EdgeInsets.only(right: 8),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: AppColors.primaryColor,
              ),
              onRatingUpdate: (rating) {
                controller.updateReviewRating(rating);
              },
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.yourReview.tr,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            AppTextField(
              controller: controller.reviewTextController,
              maxLines: 4,
              hint: AppStrings.reviewPlaceholder.tr,
              hintTextStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: AppStrings.cancel.tr,
                    onPressed: () => Get.back(),
                    backgroundColor: Colors.white,
                    textColor: Colors.grey,
                    borderSideColor: Colors.grey.withOpacity(0.3),
                    height: 44,
                    borderRadius: 8,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: AppStrings.submit.tr,
                    onPressed: () => Get.back(),
                    backgroundColor: const Color(0xFF1A1A1A),
                    textColor: AppColors.primaryColor,
                    borderSideColor: const Color(0xFF1A1A1A),
                    height: 44,
                    borderRadius: 8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return AppButton(
      label: AppStrings.backToMyOrders.tr,
      onPressed: controller.backToList,
      backgroundColor: const Color(0xFF1A1A1A),
      textColor: AppColors.primaryColor,
      borderSideColor: const Color(0xFF1A1A1A),
      height: 44,
      borderRadius: 8,
    );
  }

  Widget _buildActionButton(BuildContext context, OrderModel order) {
    if (order.status == AppStrings.activeOrder) {
      return AppButton(
        label: AppStrings.cancelOrders.tr,
        onPressed: () {},
        backgroundColor: Colors.white,
        textColor: Colors.red,
        borderSideColor: Colors.red.withOpacity(0.3),
        height: 44,
        borderRadius: 8,
      );
    } else if (order.status == AppStrings.complete) {
      return AppButton(
        label: AppStrings.returnRequest.tr,
        onPressed: () => _showReturnRequestBottomSheet(context),
        backgroundColor: const Color(0xFF1A1A1A),
        textColor: AppColors.primaryColor,
        borderSideColor: const Color(0xFF1A1A1A),
        leadingIcon: const Icon(Icons.keyboard_return,
            color: AppColors.primaryColor, size: 14),
        height: 44,
        borderRadius: 8,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void _showReturnRequestBottomSheet(BuildContext context) {
    AppBottomSheet(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '- ${AppStrings.returnRequest.tr}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, size: 20, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.returnInstruction.tr,
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.returnReason.tr,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            AppTextField(
              controller: TextEditingController(),
              hint: AppStrings.returnReasonPlaceholder.tr,
              hintTextStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
            const SizedBox(height: 20),
            Text(
              AppStrings.uploadEvidence.tr,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => controller.pickReturnEvidenceImage(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined,
                        color: Colors.grey[400], size: 18),
                    const SizedBox(width: 8),
                    Text(AppStrings.uploadImagesHere.tr,
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 13)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: controller.returnEvidenceImages
                      .asMap()
                      .entries
                      .map((entry) {
                    return _buildMockImage(entry.value, entry.key);
                  }).toList(),
                )),
            const SizedBox(height: 20),
            Text(
              AppStrings.describeReason.tr,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            AppTextField(
              controller: TextEditingController(),
              maxLines: 4,
              hint: AppStrings.returnDetailPlaceholder.tr,
              hintTextStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: AppStrings.cancel.tr,
                    onPressed: () => Get.back(),
                    backgroundColor: Colors.white,
                    textColor: Colors.grey,
                    borderSideColor: Colors.grey.withOpacity(0.3),
                    height: 44,
                    borderRadius: 8,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: AppStrings.submitRequest.tr,
                    onPressed: () {
                      Get.back(); // close bottom sheet
                      AppAlerts.warning(
                        title: AppStrings.returnRequest.tr,
                        message: AppStrings.returnConfirmSubtitle.tr,
                        onConfirm: () {},
                      );
                    },
                    backgroundColor: const Color(0xFF1A1A1A),
                    textColor: AppColors.primaryColor,
                    borderSideColor: const Color(0xFF1A1A1A),
                    height: 44,
                    borderRadius: 8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockImage(String path, int index) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(
                  File(path),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => controller.removeReturnEvidenceImage(index),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 8, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
