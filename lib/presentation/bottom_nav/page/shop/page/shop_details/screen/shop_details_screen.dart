import 'package:bestkits/core/responsive_layout/dimensions.dart';
import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/presentation/bottom_nav/page/home/widget/product_card.dart';
import '../widget/shop_product_info_section.dart';
import 'package:bestkits/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:bestkits/widget/custom_appbar.dart';
import 'package:bestkits/presentation/bottom_nav/controller/bottom_nav_controller.dart';
import '../controller/shop_details_controller.dart';
import '../widget/shop_image_section.dart';
import '../widget/shop_action_section.dart';
import '../widget/shop_tabs_section.dart';
import 'package:bestkits/data/model/product_model.dart';

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
    final dynamic productModel = argsMap?['productModel'];

    if (productModel != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.productDetails.value = productModel;
        controller.isLoading.value = false;
        controller.errorMessage.value = '';
        if (productModel.variants != null &&
            (productModel.variants as List).isNotEmpty) {
          controller.selectedVariant.value =
              (productModel.variants as List).first.variantName;
        }
      });
    } else if (productId.isNotEmpty) {
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
                    ShopImageSection(controller: controller),
                    const SizedBox(height: 20),
                    ShopProductInfoSection(product: product),
                    const SizedBox(height: 10),
                    ShopActionSection(controller: controller, product: product),
                    const SizedBox(height: 10),
                    ShopTabsSection(controller: controller, product: product),

                    // Related Products Header
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

                    // Dummy related products layout
                    // Normally we would use a GridView or a horizontal list. The design shows a grid.
                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(), // Since it's inside a SingleChildScrollView
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: 2, // Dummy count
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product:
                              product, // Using the same product as dummy data
                          width: double.infinity,
                          margin: EdgeInsets.zero,
                        );
                      },
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
