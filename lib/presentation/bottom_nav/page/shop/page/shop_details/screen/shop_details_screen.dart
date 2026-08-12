import 'package:bestkits/core/responsive_layout/dimensions.dart';
import 'package:bestkits/core/routes/route_path.dart';
import '../widget/shop_product_info_section.dart';
import 'package:bestkits/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:bestkits/widget/custom_appbar.dart';
import 'package:bestkits/presentation/bottom_nav/controller/bottom_nav_controller.dart';
import '../controller/shop_details_controller.dart';
import '../model/shop_details_model.dart';
import '../widget/shop_image_section.dart';
import '../widget/shop_action_section.dart';
import '../widget/shop_tabs_section.dart';
import 'package:bestkits/service/api_url.dart';

class ShopDetailsScreen extends StatefulWidget {
  const ShopDetailsScreen({super.key});

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  late final ShopDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<ShopDetailsController>()
        ? Get.find<ShopDetailsController>()
        : Get.put(ShopDetailsController());

    final args = Get.arguments;
    final Map<String, dynamic>? argsMap =
        args is Map<String, dynamic> ? args : null;
    final String productId = argsMap?['productId']?.toString() ?? '';

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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                // Add to favorites logic
              },
              child: const Icon(
                Icons.favorite,
                color: AppColors.redColor,
                size: 24,
              ),
            ),
          )
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

        final ShopDetailsData? product = controller.productDetails.value;
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
                    ShopImageSection(controller: controller),
                    const SizedBox(height: 20),
                    ShopProductInfoSection(product: product),
                    const SizedBox(height: 10),
                    ShopActionSection(controller: controller, product: product),
                    const SizedBox(height: 10),
                    ShopTabsSection(controller: controller, product: product),

                    // Related Products Header
                    if (product.relatedProducts != null &&
                        product.relatedProducts!.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Related Products',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[800],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (Get.isRegistered<BottomNavController>()) {
                                Get.until((route) =>
                                    route.settings.name == RoutePath.bottomNav ||
                                    Get.currentRoute == RoutePath.bottomNav);
                                Get.find<BottomNavController>().changeIndex(1);
                              } else {
                                Get.offAllNamed(RoutePath.bottomNav);
                              }
                            },
                            child: Text(
                              'View all',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: product.relatedProducts!.length,
                        itemBuilder: (context, index) {
                          final related = product.relatedProducts![index];
                          return _RelatedProductCard(product: related);
                        },
                      ),
                    ],
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

class _RelatedProductCard extends StatelessWidget {
  final ShopDetailsRelatedProduct product;

  const _RelatedProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final imageUrl = ApiUrl.buildImageUrl(
        product.imageUrls?.isNotEmpty == true ? product.imageUrls!.first : null);
    final name = product.name ?? 'Unknown';
    final price = product.effectivePrice ?? product.discountedPrice ?? 0;

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          '/shop-details',
          arguments: {'productId': product.id?.toString() ?? ''},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.image_not_supported,
                            color: Colors.grey),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$$price',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryColor,
                    ),
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
