import 'package:flutter/material.dart';
import '../../utils/app_colors/app_colors.dart';

class CustomAlertDialog {
  static show({
    required BuildContext context,
    required String title,
    required String body,
    VoidCallback? onYes,
    VoidCallback? onNo,
    String yesLabel = "Yes",
    String noLabel = "No",
    bool isDestructive = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  body,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGreyColor,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onNo ?? () => Navigator.pop(context),
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.greyColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            noLabel,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              color: AppColors.darkGreyColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: onYes,
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isDestructive ? AppColors.redColor : AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            yesLabel,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
