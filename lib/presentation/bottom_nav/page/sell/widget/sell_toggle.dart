import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../controller/sell_controller.dart';

/// Returns the accent color for each status index
Color statusColor(int index) {
  switch (index) {
    case 0:
      return const Color(0xFFFFB000); // Under Review — Amber
    case 1:
      return const Color(0xFF22C55E); // Live — Green
    case 2:
      return const Color(0xFFFF6B35); // Action Required — Orange
    case 3:
      return const Color(0xFFB3261E); // Rejected — Red
    case 4:
      return const Color(0xFF6366F1); // Sold — Indigo
    case 5:
      return const Color(0xFF9E9E9E); // Inactive — Grey
    default:
      return AppColors.primaryColor;
  }
}

/// Returns the light background for each status
Color statusBgColor(int index) {
  switch (index) {
    case 0:
      return const Color(0xFFFFF8E1); // Amber light
    case 1:
      return const Color(0xFFE8F5E9); // Green light
    case 2:
      return const Color(0xFFFFF3E0); // Orange light
    case 3:
      return const Color(0xFFFFEBEE); // Red light
    case 4:
      return const Color(0xFFEDE9FE); // Indigo light
    case 5:
      return const Color(0xFFF5F5F5); // Grey light
    default:
      return const Color(0xFFFFF8E1);
  }
}

class SellToggle extends StatelessWidget {
  final SellController controller;

  const SellToggle({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedIndex = controller.selectedTabIndex.value;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(controller.tabs.length, (index) {
            final tab = controller.tabs[index];
            final isSelected = selectedIndex == index;
            final color = statusColor(index);

            return GestureDetector(
              onTap: () => controller.selectTab(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                margin: EdgeInsets.only(
                  right: index < controller.tabs.length - 1 ? 10 : 0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF1A1A1A) : Colors.grey.withOpacity(0.25),
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Status dot indicator
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? AppColors.primaryColor : color,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      tab.label,
                      style: TextStyle(
                        color: isSelected ? AppColors.primaryColor : Colors.grey[600],
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
