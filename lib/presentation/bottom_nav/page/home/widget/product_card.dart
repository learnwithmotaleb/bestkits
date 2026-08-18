import 'package:bestkits/data/model/product_model.dart';
import 'package:bestkits/presentation/favorite/controller/favourite_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../utils/app_icons/app_icons.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap; // Add this

  final EdgeInsetsGeometry? margin;
  final double? width;

  const ProductCard({
    super.key,
    required this.product,
    this.margin,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final favouriteController = Get.find<FavouriteController>();
    final imageUrl = product.primaryImageUrl;
    final discountLabel = product.discountLabel ?? '';

    return Container(
      margin: margin,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.r(15)),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image, Discount and Favorite
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.w(0)),
                      child: imageUrl.isNotEmpty
                          ? (imageUrl.contains('assets/')
                              ? Image.asset(
                                  product.imageUrls.first,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey),
                                )
                              : Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey),
                                ))
                          : const Icon(Icons.image_not_supported,
                              color: Colors.grey),
                    ),
                  ),
                  if (discountLabel.isNotEmpty)
                    Positioned(
                      top: Dimensions.h(10),
                      left: Dimensions.w(10),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.w(6),
                            vertical: Dimensions.h(2)),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.1),
                          border: Border.all(
                              color: AppColors.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(Dimensions.r(20)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppIcons.offer,
                              height: Dimensions.icon(10),
                              width: Dimensions.icon(10),
                              colorFilter: const ColorFilter.mode(
                                  AppColors.primaryColor, BlendMode.srcIn),
                            ),
                            Dimensions.gapW(2),
                            Text(
                              discountLabel,
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: Dimensions.fs(10),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    top: Dimensions.h(10),
                    right: Dimensions.w(10),
                    child: Obx(() {
                      final isFav =
                          favouriteController.isFavoriteById(product.id);
                      return GestureDetector(
                        onTap: () {
                          favouriteController.toggleFavoriteProduct(product);
                        },
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          size: Dimensions.icon(18),
                          color: isFav ? Colors.red : Colors.grey[700],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Divider between image and details
            Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey.withValues(alpha: 0.2)),

            // Details
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(Dimensions.w(12)),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.h2.copyWith(
                        fontSize: Dimensions.fs(16),
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.w(10),
                          vertical: Dimensions.h(3)),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(Dimensions.r(20)),
                        border:
                            Border.all(color: AppColors.primaryColor, width: 1),
                      ),
                      child: Text(
                        product.subCategoryName.isNotEmpty
                            ? product.subCategoryName
                            : product.categoryName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: Dimensions.fs(11),
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              product.formattedPrice,
                              style: AppTextStyles.h4.copyWith(
                                fontSize: Dimensions.fs(20),
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        if (product.discountedPrice != null) ...[
                          Dimensions.gapW(5),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Text(
                                  product.formattedOriginalPrice,
                                  style: TextStyle(
                                    fontSize: Dimensions.fs(12),
                                    color: Colors.grey.shade500,
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
