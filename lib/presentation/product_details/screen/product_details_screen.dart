import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:bestkits/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';
import '../../../utils/assets_image/app_images.dart';
import '../../bottom_nav/page/search/widget/search_product_card.dart';
import '../controller/product_details_controller.dart';
import '../widget/product_action_section.dart';
import '../widget/product_image_section.dart';
import '../widget/product_info_section.dart';
import '../widget/product_tabs_section.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final controller = Get.put(ProductDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: AppStrings.productDetailsHeader.tr,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductImageSection(controller: controller),
                  const SizedBox(height: 20),
                  const ProductInfoSection(),
                  const SizedBox(height: 10),
                  ProductActionSection(controller: controller),
                  const SizedBox(height: 10),
                  ProductTabsSection(controller: controller),
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
                  const SizedBox(height: 15),

                  // Related Products Grid (2 items as per design)
                  Row(
                    children: [
                      Expanded(
                        child: SearchProductCard(
                          product: {
                            'name': 'Kids Cotton Hoodie...',
                            'image': AppImages.kidsCottonHoodie,
                            'price': '18.00',
                            'oldPrice': '21.99',
                            'rating': '4.5/5.0',
                            'material': 'Cotton Pull-On',
                            'discount': '20%',
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: SearchProductCard(
                          product: {
                            'name': 'Kids Cotton Hoodie...',
                            'image': AppImages.kidAccessor,
                            'price': '18.00',
                            'oldPrice': '21.99',
                            'rating': '4.5/5.0',
                            'material': 'Cotton Pull-On',
                            'discount': '10%',
                          },
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
      ),
    );
  }
}
