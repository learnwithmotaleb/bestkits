import 'package:bestkits/utils/app_text_style/app_text_style.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:bestkits/core/routes/route_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../controller/home_controller.dart';
import '../widget/category_card.dart';
import '../widget/home_banner.dart';
import '../widget/home_header.dart';
import '../widget/product_card.dart';
import '../widget/section_title.dart';
import '../widget/seller_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Dimensions.gapH(10),
            // Header
            const HomeHeader(),
            Dimensions.gapH(20),

            // Banner
            const HomeBanner(),
            Dimensions.gapH(30),

            // Shop By Category
            SectionTitle(
              title: AppStrings.shopByCategory.tr,
              onTapViewAll: () {
                Get.toNamed(RoutePath.categoriesScreen);
              },
            ),
            Dimensions.gapH(15),
            Obx(() {
              if (controller.isLoadingHome.value) {
                return SizedBox(
                  height: Dimensions.h(160),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              if (controller.categories.isEmpty) {
                return SizedBox(
                  height: Dimensions.h(160),
                  child: Center(
                    child: Text(
                      AppStrings.noMatchesFound.tr,
                      style: AppTextStyles.bodyText,
                    ),
                  ),
                );
              }
              return SizedBox(
                height: Dimensions.h(160),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return CategoryCard(
                      name: category.name ?? '',
                      imageUrl: category.imageUrl,
                      items:
                          '${category.subCategories?.length ?? 0} ${AppStrings.itemsCountLabel.tr}',
                      onTap: () {
                        Get.toNamed(RoutePath.categoriesScreen,
                            arguments: {'categoryId': category.id});
                      },
                    );
                  },
                ),
              );
            }),
            Dimensions.gapH(30),

            // Now Trending

            SectionTitle(
              title: AppStrings.nowTrending.tr,
              onTapViewAll: () {
                //  Get.toNamed(RoutePath.searchscreen);
              },
            ),
            Dimensions.gapH(15),
            Obx(() {
              return SizedBox(
                height: Dimensions.h(280),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.trendingProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.trendingProducts[index];
                    return ProductCard(
                      product: product,
                      width: Dimensions.w(160),
                      margin: EdgeInsets.only(right: Dimensions.w(15)),
                    );
                  },
                ),
              );
            }),
            Dimensions.gapH(30),

            // Recently Viewed
            SectionTitle(
              title: AppStrings.recentlyViewed.tr,
              onTapViewAll: () {
                //  Get.toNamed(RoutePath.searchscreen);
              },
            ),
            Dimensions.gapH(15),
            Obx(() {
              if (controller.isLoadingRecentlyViewed.value) {
                return SizedBox(
                  height: Dimensions.h(280),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (controller.recentlyViewed.isEmpty) {
                return SizedBox.shrink(); // hide if empty
              }
              return SizedBox(
                height: Dimensions.h(280),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.recentlyViewed.length,
                  itemBuilder: (context, index) {
                    final product = controller.recentlyViewed[index];
                    return ProductCard(
                      product: product,
                      width: Dimensions.w(160),
                      margin: EdgeInsets.only(right: Dimensions.w(15)),
                    );
                  },
                ),
              );
            }),
            Dimensions.gapH(30),

            // New Arrivals
            SectionTitle(
              title: AppStrings.newArrivals.tr,
              onTapViewAll: () {
                //  Get.toNamed(RoutePath.searchscreen);
              },
            ),
            Dimensions.gapH(15),
            Obx(() {
              if (controller.isLoadingHome.value &&
                  controller.newArrivals.isEmpty) {
                return SizedBox(
                  height: Dimensions.h(280),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (controller.newArrivals.isEmpty) {
                return SizedBox.shrink(); // hide if empty
              }
              return SizedBox(
                height: Dimensions.h(280),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.newArrivals.length,
                  itemBuilder: (context, index) {
                    final product = controller.newArrivals[index];
                    return ProductCard(
                      product: product,
                      width: Dimensions.w(160),
                      margin: EdgeInsets.only(right: Dimensions.w(15)),
                    );
                  },
                ),
              );
            }),

            // Seller Banner
            const SellerBanner(),

            Dimensions.gapH(20),
          ]),
        ),
      ),
    );
  }
}
