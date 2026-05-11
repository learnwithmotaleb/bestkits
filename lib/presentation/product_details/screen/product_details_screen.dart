import 'package:bestkits/utils/static_strings/static_strings.dart';
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
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20), vertical: Dimensions.h(10)),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.w(10)),
                      decoration: BoxDecoration(
                        color: AppColors.navBarColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        size: Dimensions.icon(20),
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    AppStrings.productDetailsHeader.tr,
                    style: AppTextStyles.h3.copyWith(
                      fontSize: Dimensions.fs(18),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Spacer(),
                  // Placeholder to balance
                  SizedBox(width: Dimensions.w(40)),
                ],
              ),
            ),

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
      ),
    );
  }
}
