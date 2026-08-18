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
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.r(15)),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Stack(
          children: [

            // Content
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(0), vertical: Dimensions.h(0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: (imageUrl != null && imageUrl!.isNotEmpty)
                        ? (imageUrl!.startsWith('assets/')
                            ? Image.asset(
                                imageUrl!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.category,
                                        color: Colors.grey),
                              )
                            : Image.network(
                                ApiUrl.buildImageUrl(imageUrl!),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.category,
                                        color: Colors.grey),
                              ))
                        : const Icon(Icons.category,
                            color: Colors.grey, size: 50),
                  ),
                  Dimensions.gapH(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: Dimensions.w(15),
                        height: 1.5,
                        color: Colors.grey.shade600,
                      ),
                      Dimensions.gapW(8),
                      Flexible(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyText.copyWith(
                            fontSize: Dimensions.fs(14),
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Badge
            Positioned(
              top: Dimensions.h(10),
              right: Dimensions.w(10),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.w(8), vertical: Dimensions.h(4)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.r(20)),
                  border: Border.all(color: AppColors.primaryColor, width: 1),
                ),
                child: Text(
                  items,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: Dimensions.fs(10),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
