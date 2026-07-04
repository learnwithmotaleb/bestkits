import 'package:flutter/material.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../service/api_url.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final String items;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.name,
    this.imageUrl,
    required this.items,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Dimensions.w(150),
        margin: EdgeInsets.only(right: Dimensions.w(15)),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(Dimensions.r(15)),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Stack(
          children: [
            // Badge
            Positioned(
              top: Dimensions.h(10),
              right: Dimensions.w(10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.w(6), vertical: Dimensions.h(2)),
                decoration: BoxDecoration(
                  color: AppColors.navBarColor,
                  borderRadius: BorderRadius.circular(Dimensions.r(10)),
                  border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
                ),
                child: Text(
                  items,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: Dimensions.fs(8),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(Dimensions.w(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: (imageUrl != null && imageUrl!.isNotEmpty)
                        ? Image.network(
                            ApiUrl.buildImageUrl(imageUrl),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.category, color: Colors.grey),
                          )
                        : const Icon(Icons.category, color: Colors.grey, size: 50),
                  ),
                  Dimensions.gapH(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: Dimensions.w(10),
                        height: 1,
                        color: Colors.grey,
                      ),
                      Dimensions.gapW(5),
                      Flexible(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyText.copyWith(
                            fontSize: Dimensions.fs(12),
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
