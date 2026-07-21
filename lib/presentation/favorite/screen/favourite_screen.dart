import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/static_strings/static_strings.dart';
import '../../../../widget/app_empty_state.dart';
import '../../../../widget/custom_appbar.dart';
import '../../bottom_nav/page/home/widget/product_card.dart';
import '../../bottom_nav/page/home/pages/categories/widget/category_grid_card.dart';
import '../controller/favourite_controller.dart';
import 'package:bestkits/data/model/product_model.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavouriteController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: AppStrings.favorite.tr,
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.favoriteList.isEmpty &&
            controller.favoriteCategories.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        final hasProducts = controller.favoriteList.isNotEmpty;
        final hasCategories = controller.favoriteCategories.isNotEmpty;

        // ── Empty state ──
        if (!hasProducts && !hasCategories) {
          return RefreshIndicator(
            onRefresh: () => controller.fetchWishlist(),
            color: AppColors.primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - kToolbarHeight - 100,
                child: const AppEmptyState(
                  icon: Icons.favorite_border_rounded,
                  title: "No Favorites Yet",
                  subtitle: "Explore products and categories to add them here.",
                ),
              ),
            ),
          );
        }

        // ── Loaded state with CustomScrollView ──
        return RefreshIndicator(
          onRefresh: () => controller.fetchWishlist(),
          color: AppColors.primaryColor,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ── Categories Header ──
              if (hasCategories) ...[
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    Dimensions.w(16),
                    Dimensions.h(16),
                    Dimensions.w(16),
                    Dimensions.h(8),
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "Favorite Categories",
                      style: TextStyle(
                        fontSize: Dimensions.fs(16),
                        fontWeight: FontWeight.w800,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
                // ── Categories Grid ──
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(16)),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.55,
                      crossAxisSpacing: Dimensions.w(12),
                      mainAxisSpacing: Dimensions.h(12),
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final category = controller.favoriteCategories[index];
                        return CategoryGridCard(category: category);
                      },
                      childCount: controller.favoriteCategories.length,
                    ),
                  ),
                ),
              ],

              // ── Products Header ──
              if (hasProducts) ...[
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    Dimensions.w(16),
                    Dimensions.h(24),
                    Dimensions.w(16),
                    Dimensions.h(8),
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "Favorite Products",
                      style: TextStyle(
                        fontSize: Dimensions.fs(16),
                        fontWeight: FontWeight.w800,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
                // ── Products Grid ──
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    Dimensions.w(16),
                    0,
                    Dimensions.w(16),
                    Dimensions.h(24),
                  ),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: Dimensions.w(15),
                      mainAxisSpacing: Dimensions.h(15),
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final ProductModel product = controller.favoriteList[index];
                        return ProductCard(product: product);
                      },
                      childCount: controller.favoriteList.length,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
