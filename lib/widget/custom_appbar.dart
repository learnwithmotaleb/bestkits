import 'package:flutter/material.dart';
import '../../utils/app_colors/app_colors.dart';
import '../../core/responsive_layout/dimensions.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final Color backgroundColor;
  final Color titleColor;
  final double? height;
  final Color backIconColor;
  final List<Widget>? actions;
  final bool centerTitle;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.onBack,
    this.backgroundColor = AppColors.backgroundColor,
    this.titleColor = AppColors.blackColor,
    this.backIconColor = AppColors.blackColor,
    this.actions,
    this.height = 56,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: centerTitle,
      leading: showBack
          ? IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: backIconColor,
          size: 20,
        ),
        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      )
          : null,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'Nunito',
          color: titleColor,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: actions,
    );
  }
}