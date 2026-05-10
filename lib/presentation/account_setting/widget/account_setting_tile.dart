import 'package:flutter/material.dart';

import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';

class AccountSettingTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;

  const AccountSettingTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.h(12)),
        padding: Dimensions.pSym(h: 16, v: 12),
        decoration: BoxDecoration(
          color: isDestructive ? AppColors.redColor.withOpacity(0.1) : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(Dimensions.r(12)),
          border: Border.all(
            color: isDestructive
                ? AppColors.redColor.withOpacity(0.3)
                : AppColors.greyColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            if (!isDestructive)
              Container(
                width: Dimensions.rs(40),
                height: Dimensions.rs(40),
                decoration: BoxDecoration(
                  color: AppColors.blackColor,
                  borderRadius: BorderRadius.circular(Dimensions.r(10)),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: AppColors.primaryColor,
                  size: Dimensions.rs(20),
                ),
              )
            else
              Container(
                width: Dimensions.rs(40),
                height: Dimensions.rs(40),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: AppColors.redColor,
                  size: Dimensions.rs(20),
                ),
              ),
            SizedBox(width: Dimensions.w(16)),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(
                  fontStyle: isDestructive ? FontStyle.normal : FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: isDestructive ? AppColors.redColor : AppColors.darkGreyColor,
                  fontSize: Dimensions.fs(14),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDestructive ? AppColors.redColor : AppColors.greyColor.withOpacity(0.5),
              size: Dimensions.rs(20),
            ),
          ],
        ),
      ),
    );
  }
}
