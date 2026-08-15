import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../service/api_url.dart';
import '../../../../widget/app_button.dart';
import '../controller/my_return_controller.dart';
import '../model/MyReturnModel.dart';

class MyReturnListView extends GetView<MyReturnController> {
  const MyReturnListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        );
      }

      final returns = controller.currentTabReturns;

      if (returns.isEmpty) {
        return RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () => controller.fetchReturns(isRefresh: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: Dimensions.w(24)),
                padding: EdgeInsets.symmetric(vertical: Dimensions.h(40)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.r(12)),
                ),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
                    SizedBox(height: Dimensions.h(16)),
                    Text(
                      AppStrings.noReturnRequestsFound.tr,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      return RefreshIndicator(
        color: AppColors.primaryColor,
        onRefresh: () => controller.fetchReturns(isRefresh: true),
        child: ListView.builder(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: Dimensions.w(24)),
          itemCount: returns.length + (controller.isPaginationLoading.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == returns.length) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.h(16)),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primaryColor),
                ),
              );
            }
            return _buildReturnCard(returns[index]);
          },
        ),
      );
    });
  }

  Color _statusBadgeColor(String status) {
    switch (status) {
      case 'PENDING':
      case 'IN_REVIEW':
        return AppColors.primaryColor.withOpacity(0.15);
      case 'APPROVED':
      case 'PROCESSING':
      case 'COMPLETED':
        return Colors.green.withOpacity(0.1);
      case 'REJECTED':
        return Colors.red.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  Color _statusTextColor(String status) {
    switch (status) {
      case 'PENDING':
      case 'IN_REVIEW':
        return AppColors.primaryColor;
      case 'APPROVED':
      case 'PROCESSING':
      case 'COMPLETED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildReturnCard(Data r) {
    final status = r.status ?? '';
    final badgeColor = _statusBadgeColor(status);
    final badgeTextColor = _statusTextColor(status);

    final sellerName = r.seller?.profile?.fullName ?? r.seller?.email ?? '';
    final imageUrl = r.previewItem?.imageUrl != null
        ? ApiUrl.buildImageUrl(r.previewItem!.imageUrl!)
        : null;

    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.h(16)),
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
          // Header: order ID + status badge
          Padding(
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
                        '- ${AppStrings.orderIdLabel.tr}: ${r.displayOrderId ?? ''}',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                          color: AppColors.blackColor,
                        ),
                      ),
                      if (sellerName.isNotEmpty) ...[
                        SizedBox(height: Dimensions.h(2)),
                        Text(
                          sellerName,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 11,
                            color: AppColors.darkGreyColor,
                          ),
                        ),
                      ],
                      SizedBox(height: Dimensions.h(4)),
                      Text(
                        r.submittedOn ?? '',
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
                    '• ${r.statusLabel ?? ''}',
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
          ),

          // Preview item row
          if (r.previewItem != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.w(16)),
              child: Row(
                children: [
                  // Product image
                  Container(
                    width: Dimensions.w(50),
                    height: Dimensions.h(50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.r(8)),
                      border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.4)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.r(8)),
                      child: imageUrl != null && imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image_not_supported, size: 20),
                            )
                          : const Icon(Icons.image_not_supported, size: 20),
                    ),
                  ),
                  SizedBox(width: Dimensions.w(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.previewItem?.name ?? '',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blackColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '€${r.previewItem?.price?.toStringAsFixed(2) ?? '0.00'}',
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
            ),

          SizedBox(height: Dimensions.h(12)),
          Divider(height: 1, color: AppColors.greyColor.withOpacity(0.2)),

          // View Details button
          Padding(
            padding: EdgeInsets.all(Dimensions.w(16)),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: AppStrings.viewDetails.tr,
                    onPressed: () => controller.viewReturnDetails(r),
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
    );
  }
}
