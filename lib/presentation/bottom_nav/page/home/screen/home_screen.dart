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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(
                height: Dimensions.h(160),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return CategoryCard(
                      name: category['name'].toString().tr,
                      image: category['image'],
                      items: '${category['items']} ${AppStrings.itemsCountLabel.tr}',
                    );
                  },
                ),
              ),
              Dimensions.gapH(30),

              // Now Trending
              SectionTitle(
                title: AppStrings.nowTrending.tr,
                onTapViewAll: () {},
              ),
              Dimensions.gapH(15),
              SizedBox(
                height: Dimensions.h(280),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.trendingProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.trendingProducts[index];
                    return ProductCard(product: product);
                  },
                ),
              ),
              Dimensions.gapH(30),

              // Recently Viewed
              SectionTitle(
                title: AppStrings.recentlyViewed.tr,
                onTapViewAll: () {},
              ),
              Dimensions.gapH(15),
              SizedBox(
                height: Dimensions.h(280),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.recentlyViewed.length,
                  itemBuilder: (context, index) {
                    final product = controller.recentlyViewed[index];
                    return ProductCard(product: product);
                  },
                ),
              ),
              Dimensions.gapH(30),

              // New Arrivals
              SectionTitle(
                title: AppStrings.newArrivals.tr,
                onTapViewAll: () {},
              ),
              Dimensions.gapH(15),
              SizedBox(
                height: Dimensions.h(280),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.trendingProducts.length, // Reusing trending for demo
                  itemBuilder: (context, index) {
                    final product = controller.trendingProducts[index];
                    return ProductCard(product: product);
                  },
                ),
              ),
              
              // Seller Banner
              const SellerBanner(),
              
              Dimensions.gapH(20),
            ],
          ),
        ),
      ),
    );
  }
}