import 'package:bestkits/presentation/product_details/screen/product_details_screen.dart';
import 'package:bestkits/service/api_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../../utils/app_icons/app_icons.dart';
import '../../../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import 'package:get/get.dart';
import 'package:bestkits/presentation/favorite/controller/favourite_controller.dart';
import 'package:bestkits/data/model/product_model.dart';
import '../../../model/SellerMyModel.dart' as sellerModel;

import '../../../../../../../utils/app_text_style/app_text_style.dart';

class UpdateProductCard extends StatelessWidget {
  final sellerModel.Data productData;
  final EdgeInsetsGeometry? margin;
  final double? width;

  const UpdateProductCard({
    super.key,
    required this.productData,
    this.margin,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final favouriteController = Get.find<FavouriteController>();

    final imagePath = productData.imageUrl ?? '';
    final discount = '${productData.discountPercentage ?? 0}%';
    final name = productData.name ?? '';
    final material = productData.category?.name ?? 'Unknown';
    final price = productData.effectivePrice ??
        productData.discountedPrice ??
        productData.originalPrice ??
        0;
    final oldPrice = productData.originalPrice ?? 0;

    // We keep pm for the route arguments
    final pm = ProductModel(
      id: productData.id?.toInt() ?? 0,
      name: productData.name ?? '',
      description: '',
      originalPrice: productData.originalPrice ?? 0,
      discountedPrice: productData.discountedPrice,
      discountPercentage: productData.discountPercentage,
      imageUrls: productData.imageUrls ?? [],
      categoryId: productData.category?.id?.toInt() ?? 0,
      subCategoryId: productData.subCategory?.id?.toInt() ?? 0,
      userId: 0,
      condition: '',
      status: productData.status ?? '',
      views: 0,
      totalReviews: productData.totalReviews?.toInt() ?? 0,
      averageRating: productData.averageRating ?? 0,
      isAuthenticated: false,
      authenticationStatus: '',
      createdAt: productData.createdAt ?? '',
      updatedAt: productData.updatedAt ?? '',
      variants: [],
      effectivePrice:
          productData.effectivePrice ?? productData.originalPrice ?? 0,
      isWishlisted:
          favouriteController.isFavoriteById(productData.id?.toInt() ?? 0),
    );

    return Container(
      margin: margin ?? EdgeInsets.only(right: Dimensions.w(15)),
      width: width ?? Dimensions.w(170),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.r(15)),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTap: () {
          Get.to(() => const ProductDetailsScreen(), arguments: {
            'productId': productData.id,
            'productModel': pm,
          });
        },
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
                      padding: EdgeInsets.all(Dimensions.w(8)),
                      child: imagePath.isNotEmpty
                          ? imagePath.startsWith('assets/')
                              ? Image.asset(
                                  imagePath,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey),
                                )
                              : Image.network(
                                  ApiUrl.buildImageUrl(imagePath),
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey),
                                )
                          : const Icon(Icons.image_not_supported,
                              color: Colors.grey),
                    ),
                  ),
                  if ((productData.discountPercentage ?? 0) > 0)
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
                              discount,
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
                  if (productData.status?.toUpperCase() == 'ACTIVE' ||
                      productData.status?.toUpperCase() == 'LIVE')
                    Positioned(
                      top: Dimensions.h(10),
                      right: Dimensions.w(10),
                      child: Obx(() {
                        final productId = productData.id?.toInt() ?? 0;
                        final isFav =
                            favouriteController.isFavoriteById(productId);
                        return GestureDetector(
                          onTap: () {
                            final toggledPm = ProductModel(
                              id: pm.id,
                              name: pm.name,
                              description: pm.description,
                              originalPrice: pm.originalPrice,
                              discountedPrice: pm.discountedPrice,
                              discountPercentage: pm.discountPercentage,
                              imageUrls: pm.imageUrls,
                              categoryId: pm.categoryId,
                              subCategoryId: pm.subCategoryId,
                              userId: pm.userId,
                              condition: pm.condition,
                              status: pm.status,
                              views: pm.views,
                              totalReviews: pm.totalReviews,
                              averageRating: pm.averageRating,
                              isAuthenticated: pm.isAuthenticated,
                              authenticationStatus: pm.authenticationStatus,
                              createdAt: pm.createdAt,
                              updatedAt: pm.updatedAt,
                              variants: pm.variants,
                              effectivePrice: pm.effectivePrice,
                              isWishlisted: isFav,
                            );
                            favouriteController
                                .toggleFavoriteProduct(toggledPm);
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
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyText.copyWith(
                        fontSize: Dimensions.fs(14),
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.w(8),
                          vertical: Dimensions.h(3)),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(Dimensions.r(20)),
                        border:
                            Border.all(color: AppColors.primaryColor, width: 1),
                      ),
                      child: Text(
                        material,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: Dimensions.fs(10),
                          fontWeight: FontWeight.w500,
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
                              '\$$price',
                              style: AppTextStyles.h4.copyWith(
                                fontSize: Dimensions.fs(16),
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        if (oldPrice > 0 && oldPrice != price) ...[
                          Dimensions.gapW(5),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Text(
                                  '\$$oldPrice',
                                  style: TextStyle(
                                    fontSize: Dimensions.fs(11),
                                    color: Colors.grey[500],
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w500,
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
