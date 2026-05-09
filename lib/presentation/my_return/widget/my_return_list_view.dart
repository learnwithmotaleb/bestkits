import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../widget/app_button.dart';
import '../controller/my_return_controller.dart';

class MyReturnListView extends GetView<MyReturnController> {
  const MyReturnListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final returns = controller.currentTabReturns;

      if (returns.isEmpty) {
        return Center(
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
                  "No Return Requests Found",
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.w(24)),
        itemCount: returns.length,
        itemBuilder: (context, index) {
          final r = returns[index];
          return _buildReturnCard(r);
        },
      );
    });
  }

  Widget _buildReturnCard(ReturnModel r) {
    Color badgeColor;
    Color badgeTextColor;

    switch (r.returnStatus) {
      case 'In Review':
        badgeColor = AppColors.primaryColor.withOpacity(0.15);
        badgeTextColor = AppColors.primaryColor;
        break;
      case 'Processing':
        badgeColor = Colors.blue.withOpacity(0.1);
        badgeTextColor = Colors.blue;
        break;
      case 'Completed':
        badgeColor = Colors.green.withOpacity(0.1);
        badgeTextColor = Colors.green;
        break;
      case 'Rejected':
        badgeColor = Colors.red.withOpacity(0.1);
        badgeTextColor = Colors.red;
        break;
      default:
        badgeColor = Colors.grey.withOpacity(0.1);
        badgeTextColor = Colors.grey;
    }

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
                        "- Order ID: ${r.orderId}",
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
                        r.date,
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
                    "• ${r.returnStatus}",
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
          Divider(height: 1, color: AppColors.greyColor.withOpacity(0.2)),
          Padding(
            padding: EdgeInsets.all(Dimensions.w(16)),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: "View Details >>",
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
