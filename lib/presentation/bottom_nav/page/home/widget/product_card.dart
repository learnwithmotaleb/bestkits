import 'package:flutter/material.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import 'package:get/get.dart';
import '../../../../product_details/screen/product_details_screen.dart';
import 'package:bestkits/presentation/favorite/controller/favourite_controller.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final favouriteController = Get.find<FavouriteController>();

    return GestureDetector(
      onTap: () => Get.to(() => const ProductDetailsScreen()),
      child: Container(
      width: Dimensions.w(170),
      margin: EdgeInsets.only(right: Dimensions.w(15)),
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
                    child: Image.asset(
                      product['image'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  top: Dimensions.h(10),
                  left: Dimensions.w(10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.w(6), vertical: Dimensions.h(2)),
                    decoration: BoxDecoration(
                      color: AppColors.navBarColor,
                      borderRadius: BorderRadius.circular(Dimensions.r(5)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, size: Dimensions.icon(10), color: AppColors.primaryColor),
                        Dimensions.gapW(2),
                        Text(
                          product['discount'],
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
                    final isFav = favouriteController.isFavorite(product);
                    return GestureDetector(
                      onTap: () {
                        favouriteController.toggleFavorite(product);
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
                      product['name'].toString().tr,
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
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.w(6), vertical: Dimensions.h(2)),
                            decoration: BoxDecoration(
                              color: AppColors.navBarColor,
                              borderRadius: BorderRadius.circular(Dimensions.r(5)),
                              border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
                            ),
                            child: Text(
                              product['material'].toString().tr,
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
                              Icon(Icons.star, size: Dimensions.icon(12), color: AppColors.primaryColor),
                              Dimensions.gapW(2),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    product['rating'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: Dimensions.fs(8), color: Colors.grey),
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
                              '€${product['price']}',
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
                              product['oldPrice'],
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

    )
    );
  }
}
