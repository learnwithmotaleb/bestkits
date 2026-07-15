import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:bestkits/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';
import '../controller/product_details_controller.dart';
import '../widget/product_action_section.dart';
import '../widget/product_image_section.dart';
import '../widget/product_info_section.dart';
import '../widget/product_tabs_section.dart';
import '../../favorite/controller/favourite_controller.dart';
import 'package:bestkits/data/model/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final ProductDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductDetailsController());
    // Read the product ID from navigation arguments
    final args = Get.arguments as Map<String, dynamic>?;
    final productId = args?['productId']?.toString() ?? '';
    if (productId.isNotEmpty) {
      controller.fetchProductDetails(productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: AppStrings.productDetailsHeader.tr,
        actions: [
          Obx(() {
            final product = controller.productDetails.value;
            if (product == null) return const SizedBox(width: 48);
            final favController = Get.find<FavouriteController>();
            final isFav = favController.isFavoriteById(product.id);
            return IconButton(
              onPressed: () {
                favController.toggleFavoriteProduct(product);
              },
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: AppColors.redColor,
              ),
            );
          }),
          const SizedBox(width: 10),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.w(24)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final args = Get.arguments as Map<String, dynamic>?;
                      final productId = args?['productId']?.toString() ?? '';
                      if (productId.isNotEmpty) {
                        controller.fetchProductDetails(productId);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final ProductModel? product = controller.productDetails.value;
        if (product == null) {
          return const Center(child: Text('No product data'));
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductImageSection(controller: controller),
                    const SizedBox(height: 20),
                    ProductInfoSection(product: product),
                    const SizedBox(height: 10),
                    ProductActionSection(
                        controller: controller, product: product),
                    const SizedBox(height: 10),
                    ProductTabsSection(
                        controller: controller, product: product),
                    const SizedBox(height: 30),

                    // Related Products Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.relatedProducts.tr,
                          style: AppTextStyles.h4.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          AppStrings.seeAll.tr,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
