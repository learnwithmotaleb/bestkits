import 'package:bestkits/presentation/product_details/screen/product_details_screen.dart';
import 'package:bestkits/service/api_url.dart';
import 'package:flutter/material.dart';
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
    final rating = (productData.averageRating ?? 0).toString();
    final price = productData.effectivePrice ??
        productData.discountedPrice ??
        productData.originalPrice ??
        0;
    final oldPrice = productData.originalPrice ?? 0;

    return GestureDetector(
        onTap: () {
          Get.to(() => const ProductDetailsScreen(),
              arguments: {'productId': productData.id});
        },
        child: Container(
          width: width ?? Dimensions.w(170),
          margin: margin ?? EdgeInsets.only(right: Dimensions.w(15)),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(Dimensions.r(15)),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image and Discount
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.w(8)),
                        child: imagePath.isNotEmpty
                            ? Image.network(
                                ApiUrl.buildImageUrl(imagePath),
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.image_not_supported),
                              )
                            : const Icon(Icons.image_not_supported),
                      ),
                    ),
                    Positioned(
                      top: Dimensions.h(10),
                      left: Dimensions.w(10),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.w(6),
                            vertical: Dimensions.h(2)),
                        decoration: BoxDecoration(
                          color: AppColors.navBarColor,
                          borderRadius: BorderRadius.circular(Dimensions.r(5)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time,
                                size: Dimensions.icon(10),
                                color: AppColors.primaryColor),
                            Dimensions.gapW(2),
                            Text(
                              discount,
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: Dimensions.fs(8),
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
                        final productId = productData.id?.toInt() ?? 0;
                        final isFav =
                            favouriteController.isFavoriteById(productId);
                        return GestureDetector(
                          onTap: () {
                            // Build a minimal ProductModel from seller Data so the API call works
                            final pm = ProductModel(
                              id: productId,
                              name: productData.name ?? '',
                              description: '',
                              originalPrice: productData.originalPrice ?? 0,
                              discountedPrice: productData.discountedPrice,
                              discountPercentage:
                                  productData.discountPercentage,
                              imageUrls: productData.imageUrls ?? [],
                              categoryId:
                                  productData.category?.id?.toInt() ?? 0,
                              subCategoryId:
                                  productData.subCategory?.id?.toInt() ?? 0,
                              userId: 0,
                              condition: '',
                              status: productData.status ?? '',
                              views: 0,
                              totalReviews:
                                  productData.totalReviews?.toInt() ?? 0,
                              averageRating: productData.averageRating ?? 0,
                              isAuthenticated: false,
                              authenticationStatus: '',
                              createdAt: productData.createdAt ?? '',
                              updatedAt: productData.updatedAt ?? '',
                              variants: [],
                              effectivePrice: productData.effectivePrice ??
                                  productData.originalPrice ??
                                  0,
                              isWishlisted: isFav,
                            );
                            favouriteController.toggleFavoriteProduct(pm);
                          },
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.w(6)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              size: Dimensions.icon(16),
                              color: isFav ? Colors.red : Colors.grey,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              // Details
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(Dimensions.w(10)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Dimensions.r(15)),
                      bottomRight: Radius.circular(Dimensions.r(15)),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyText.copyWith(
                            fontSize: Dimensions.fs(12),
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 13,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.w(6),
                                    vertical: Dimensions.h(2)),
                                decoration: BoxDecoration(
                                  color: AppColors.navBarColor,
                                  borderRadius:
                                      BorderRadius.circular(Dimensions.r(5)),
                                  border: Border.all(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.3)),
                                ),
                                child: Text(
                                  material,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: Dimensions.fs(8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.star,
                                      size: Dimensions.icon(12),
                                      color: AppColors.primaryColor),
                                  Dimensions.gapW(2),
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        rating,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: Dimensions.fs(8),
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '\$$price',
                                  style: AppTextStyles.h4.copyWith(
                                    fontSize: Dimensions.fs(14),
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Dimensions.gapW(5),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '\$$oldPrice',
                                  style: TextStyle(
                                    fontSize: Dimensions.fs(10),
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
