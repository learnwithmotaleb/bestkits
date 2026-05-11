import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../utils/app_text_style/app_text_style.dart';
import 'package:get/get.dart';
import '../../../../../../product_details/screen/product_details_screen.dart';

class CategoryGridCard extends StatelessWidget {
  final Map<String, dynamic> category;

  const CategoryGridCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => const ProductDetailsScreen()),
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image Section ──
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Product Image — fills the box
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          category['image'],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  // Badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.navBarColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        '${category['itemsCount']} ${AppStrings.itemsCountLabel.tr}',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        
            // ── Text Section ──
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Name
                  Text(
                    category['name'].toString().tr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.h4.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Subcategory Tags
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      ...(category['subcategories'] as List<String>)
                          .map((tag) => _buildTag(tag)),
                      _buildTag('28+ More', isMore: true),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      )
    );
  }

  Widget _buildTag(String label, {bool isMore = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isMore
            ? Colors.transparent
            : AppColors.navBarColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isMore
              ? Colors.transparent
              : AppColors.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Text(
        isMore ? '+ ${AppStrings.moreLabel.tr}' : label,
        style: TextStyle(
          color: isMore
              ? AppColors.primaryColor
              : AppColors.primaryColor.withOpacity(0.8),
          fontSize: 8,
          fontWeight: isMore ? FontWeight.w700 : FontWeight.w500,
          fontStyle: isMore ? FontStyle.normal : FontStyle.italic,
        ),
      ),
    );
  }
}
