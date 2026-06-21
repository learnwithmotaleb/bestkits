import 'package:flutter/material.dart';
import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../widget/app_button.dart';

class DeliveryOptionWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onUpdate;

  const DeliveryOptionWidget({
    super.key,
    required this.data,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(12)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(Dimensions.w(16)),
            child: Row(
              children: [
                Text(
                  data['type'],
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: Dimensions.fs(14),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(width: Dimensions.w(4)),
                Text(
                  data['subtitle'],
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.greyColor,
                    fontSize: Dimensions.fs(10),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.greyColor.withOpacity(0.15)),
          
          // Body Details
          Padding(
            padding: EdgeInsets.all(Dimensions.w(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Delivery Partner', data['partner']),
                SizedBox(height: Dimensions.h(16)),
                _buildDetailRow('Delivery Cost', '€${data['cost']}'),
                SizedBox(height: Dimensions.h(16)),
                _buildDetailRow('Estimated Time', data['time']),
                
                SizedBox(height: Dimensions.h(24)),
                
                // Update Button
                AppButton(
                  label: 'Update',
                  onPressed: onUpdate,
                  backgroundColor: AppColors.blackColor,
                  textColor: AppColors.primaryColor,
                  borderRadius: 8,
                  height: 42,
                  width: 150,
                  leadingIcon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.primaryColor,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontSize: Dimensions.fs(11),
            color: AppColors.greyColor,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: Dimensions.h(4)),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            fontSize: Dimensions.fs(14),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
