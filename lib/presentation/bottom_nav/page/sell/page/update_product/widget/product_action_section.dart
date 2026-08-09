import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../widget/app_button.dart';
import '../controller/update_product_controller.dart';

class ProductActionSection extends StatelessWidget {
  final UpdateProductController controller;

  const ProductActionSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rawStatus =
          (controller.product['status'] ?? 'INACTIVE').toString().toUpperCase();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Size / Variant Selection ────────────────────────────────────────
          Text(
            '${AppStrings.sizeVariant.tr} -',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 35,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.sizes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return Obx(() {
                  final size = controller.sizes[index];
                  final isSelected = controller.selectedSize.value == size;
                  return GestureDetector(
                    onTap: () => controller.selectSize(size),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        size,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.grey[500],
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          const SizedBox(height: 25),

          // ── Status-based Action Buttons ────────────────────────────────────
          _buildStatusButtons(rawStatus),
          const SizedBox(height: 12),
        ],
      );
    });
  }

  Widget _buildStatusButtons(String status) {
    switch (status) {
      case 'UNDER_REVIEW':
        return _buildUnderReviewButtons();
      case 'ACTIVE':
      case 'LIVE':
        return _buildLiveButtons();
      case 'ACTION_REQUIRED':
        return _buildActionRequiredButtons();
      case 'REJECTED':
        return _buildRejectedButtons();
      case 'SOLD':
        return _buildSoldButtons();
      case 'INACTIVE':
        return _buildInactiveButtons();
      default:
        return _buildLiveButtons();
    }
  }

  // ── UNDER REVIEW: Both buttons disabled ────────────────────────────────────
  Widget _buildUnderReviewButtons() {
    return Row(
      children: [
        Expanded(
          child: _DisabledButton(
            label: AppStrings.updateProductTitle.tr,
            icon: Icons.edit_outlined,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _DisabledButton(
            label: AppStrings.viewOrdersBtn.tr,
            icon: Icons.assignment_outlined,
          ),
        ),
      ],
    );
  }

  // ── LIVE: Both buttons active ──────────────────────────────────────────────
  Widget _buildLiveButtons() {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: AppStrings.updateProductTitle.tr,
            onPressed: () => controller.updateProduct(),
            backgroundColor: const Color(0xFF1A1A1A),
            textColor: AppColors.primaryColor,
            leadingIcon: Icon(Icons.edit_outlined,
                color: AppColors.primaryColor, size: 18),
            borderRadius: 12,
            height: 50,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: AppButton(
            label: AppStrings.viewOrdersBtn.tr,
            onPressed: () => controller.viewOrders(),
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.black,
            leadingIcon: const Icon(Icons.assignment_outlined,
                color: Colors.black, size: 18),
            borderRadius: 12,
            height: 50,
            borderSideColor: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }

  // ── ACTION REQUIRED: Update disabled, View Orders disabled ─────────────────
  Widget _buildActionRequiredButtons() {
    return Row(
      children: [
        Expanded(
          child: _DisabledButton(
            label: AppStrings.updateProductTitle.tr,
            icon: Icons.edit_outlined,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _DisabledButton(
            label: AppStrings.viewOrdersBtn.tr,
            icon: Icons.assignment_outlined,
          ),
        ),
      ],
    );
  }

  // ── REJECTED: Update disabled, View Orders disabled ────────────────────────
  Widget _buildRejectedButtons() {
    return Row(
      children: [
        Expanded(
          child: _DisabledButton(
            label: AppStrings.updateProductTitle.tr,
            icon: Icons.edit_outlined,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _DisabledButton(
            label: AppStrings.viewOrdersBtn.tr,
            icon: Icons.assignment_outlined,
          ),
        ),
      ],
    );
  }

  // ── SOLD: Only View Orders active ─────────────────────────────────────────
  Widget _buildSoldButtons() {
    return AppButton(
      label: AppStrings.viewOrdersBtn.tr,
      onPressed: () => controller.viewOrders(),
      backgroundColor: AppColors.primaryColor,
      textColor: Colors.black,
      leadingIcon:
          const Icon(Icons.assignment_outlined, color: Colors.black, size: 18),
      borderRadius: 12,
      height: 50,
      borderSideColor: AppColors.primaryColor,
    );
  }

  // ── INACTIVE: Update active ───────────────────────────────────────────────
  Widget _buildInactiveButtons() {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: AppStrings.updateProductTitle.tr,
            onPressed: () => controller.updateProduct(),
            backgroundColor: const Color(0xFF1A1A1A),
            textColor: AppColors.primaryColor,
            leadingIcon: Icon(Icons.edit_outlined,
                color: AppColors.primaryColor, size: 18),
            borderRadius: 12,
            height: 50,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _DisabledButton(
            label: AppStrings.viewOrdersBtn.tr,
            icon: Icons.assignment_outlined,
          ),
        ),
      ],
    );
  }
}

// ─── Disabled Button Widget ───────────────────────────────────────────────────
class _DisabledButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const _DisabledButton({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey[400], size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
