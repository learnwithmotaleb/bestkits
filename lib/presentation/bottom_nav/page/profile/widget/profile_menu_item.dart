import 'package:flutter/material.dart';
import '../../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../../utils/app_colors/app_colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.h(12)),
        padding: EdgeInsets.symmetric(horizontal: Dimensions.w(16), vertical: Dimensions.h(12)),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.withOpacity(0.02) : Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.r(12)),
          border: Border.all(
            color: isDestructive ? Colors.red.withOpacity(0.3) : AppColors.greyColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive ? Colors.red.withOpacity(0.1) : const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : AppColors.primaryColor,
                size: 20,
              ),
            ),
            SizedBox(width: Dimensions.w(16)),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: isDestructive ? Colors.red : AppColors.blackColor,
                ),
              ),
            ),
            if (!isDestructive)
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
