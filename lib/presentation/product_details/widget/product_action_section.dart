import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../widget/app_button.dart';
import '../controller/product_details_controller.dart';
import 'package:bestkits/data/model/product_model.dart';

class ProductActionSection extends StatelessWidget {
  final ProductDetailsController controller;
  final ProductModel product;

  const ProductActionSection({
    super.key,
    required this.controller,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final variants = product.variants;
    final rawStatus = product.status.toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Variant Selection ─────────────────────────────────────────────────
        if (variants.isNotEmpty) ...[
          Text(
            '${AppStrings.variant.tr} -',
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
              itemCount: variants.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return Obx(() {
                  final variant = variants[index];
                  final isSelected =
                      controller.selectedVariant.value == variant.variantName;
                  return GestureDetector(
                    onTap: () =>
                        controller.selectVariant(variant.variantName),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Colors.white : Colors.grey[200],
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
                        variant.variantName,
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
          const SizedBox(height: 20),
        ],

        // ── Status-based Action Buttons ───────────────────────────────────────
        _buildStatusButtons(rawStatus),
        const SizedBox(height: 10),
        const Divider(color: Color(0xFFF5F5F5)),
      ],
    );
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

  // ── UNDER REVIEW: Both buttons disabled ──────────────────────────────────────
  Widget _buildUnderReviewButtons() {
    return Row(
      children: [
        Expanded(child: _DisabledButton(label: 'Update Product', icon: Icons.edit_outlined)),
        const SizedBox(width: 15),
        Expanded(child: _DisabledButton(label: "View Order's", icon: Icons.assignment_outlined)),
      ],
    );
  }

  // ── LIVE: Both active ─────────────────────────────────────────────────────────
  Widget _buildLiveButtons() {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: 'Update Product',
            onPressed: () {
              Get.toNamed(RoutePath.updateProductSell, arguments: {
                'id': product.id,
                'name': product.name,
                'description': product.description,
                'original_price': product.originalPrice,
                'discounted_price': product.discountedPrice,
                'condition': product.condition,
                'status': product.status,
                'image_url': product.primaryImageUrl,
                'image_urls': product.imageUrls,
                'category': {'name': product.categoryName},
              });
            },
            backgroundColor: const Color(0xFF1A1A1A),
            textColor: AppColors.primaryColor,
            leadingIcon:
                Icon(Icons.edit_outlined, color: AppColors.primaryColor, size: 18),
            borderRadius: 12,
            height: 50,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: AppButton(
            label: "View Order's",
            onPressed: () {
              Get.toNamed(RoutePath.productOrder, arguments: {'productId': product.id});
            },
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.black,
            leadingIcon:
                const Icon(Icons.assignment_outlined, color: Colors.black, size: 18),
            borderRadius: 12,
            height: 50,
            borderSideColor: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }


  // ── ACTION REQUIRED: Both disabled ───────────────────────────────────────────
  Widget _buildActionRequiredButtons() {
    return Row(
      children: [
        Expanded(child: _DisabledButton(label: 'Update Product', icon: Icons.edit_outlined)),
        const SizedBox(width: 15),
        Expanded(child: _DisabledButton(label: "View Order's", icon: Icons.assignment_outlined)),
      ],
    );
  }

  // ── REJECTED: Both disabled ───────────────────────────────────────────────────
  Widget _buildRejectedButtons() {
    return Row(
      children: [
        Expanded(child: _DisabledButton(label: 'Update Product', icon: Icons.edit_outlined)),
        const SizedBox(width: 15),
        Expanded(child: _DisabledButton(label: "View Order's", icon: Icons.assignment_outlined)),
      ],
    );
  }

  // ── SOLD: View Orders only (full width) ──────────────────────────────────────
  Widget _buildSoldButtons() {
    return AppButton(
      label: "View Order's",
      onPressed: () {
        Get.toNamed(RoutePath.productOrder, arguments: {'productId': product.id});
      },
      backgroundColor: AppColors.primaryColor,
      textColor: Colors.black,
      leadingIcon:
          const Icon(Icons.assignment_outlined, color: Colors.black, size: 18),
      borderRadius: 12,
      height: 50,
      borderSideColor: AppColors.primaryColor,
    );
  }

  // ── INACTIVE: Update active, View Orders disabled ────────────────────────────
  Widget _buildInactiveButtons() {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: 'Update Product',
            onPressed: () {
              Get.toNamed(RoutePath.updateProductSell, arguments: {
                'id': product.id,
                'name': product.name,
                'description': product.description,
                'original_price': product.originalPrice,
                'discounted_price': product.discountedPrice,
                'condition': product.condition,
                'status': product.status,
                'image_url': product.primaryImageUrl,
                'image_urls': product.imageUrls,
                'category': {'name': product.categoryName},
              });
            },
            backgroundColor: const Color(0xFF1A1A1A),
            textColor: AppColors.primaryColor,
            leadingIcon:
                Icon(Icons.edit_outlined, color: AppColors.primaryColor, size: 18),
            borderRadius: 12,
            height: 50,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(child: _DisabledButton(label: "View Order's", icon: Icons.assignment_outlined)),
      ],
    );
  }

}

// ─── Disabled Button ──────────────────────────────────────────────────────────
class _DisabledButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const _DisabledButton({required this.label, required this.icon});

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
