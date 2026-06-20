import 'package:bestkits/presentation/bottom_nav/page/sell/page/update_product/controller/update_product_controller.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/update_product/widget/product_action_section.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/update_product/widget/product_image_section.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/update_product/widget/product_info_section.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/update_product/widget/product_tabs_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get.dart';

import '../../../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../../../utils/assets_image/app_images.dart';
import '../../../../../../../utils/static_strings/static_strings.dart';
import '../../../../../../../widget/custom_appbar.dart';
import '../../../../home/widget/product_card.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({super.key});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final controller = Get.put(UpdateProductController());

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
                  ProductInfoSection(controller: controller),
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
                        child: ProductCard(
                          product: {
                            'name': 'Kids Cotton Hoodie...',
                            'image': AppImages.kidsCottonHoodie,
                            'price': '18.00',
                            'oldPrice': '21.99',
                            'rating': '4.5/5.0',
                            'material': 'Cotton Pull-On',
                            'discount': '20%',
                          },
                          width: double.infinity,
                          margin: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ProductCard(
                          product: {
                            'name': 'Kids Cotton Hoodie...',
                            'image': AppImages.kidAccessor,
                            'price': '18.00',
                            'oldPrice': '21.99',
                            'rating': '4.5/5.0',
                            'material': 'Cotton Pull-On',
                            'discount': '10%',
                          },
                          width: double.infinity,
                          margin: EdgeInsets.zero,
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
