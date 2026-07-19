import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../core/routes/route_path.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../utils/assets_image/app_images.dart';
import '../../../../product_details/screen/product_details_screen.dart';
import '../controller/home_controller.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final HomeController controller = Get.find<HomeController>();
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      final bannerCount = controller.promotedProducts.isNotEmpty ? controller.promotedProducts.length : 1;
      if (_pageController.hasClients && bannerCount > 1) {
        final nextPage = (_currentPage + 1) % bannerCount;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final productList = controller.promotedProducts;
      final bool isLoading = controller.isLoadingHome.value;

      if (isLoading && productList.isEmpty) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
          height: Dimensions.h(180),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.r(15)),
            color: Colors.grey.shade100,
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      if (productList.isEmpty) {
        return const SizedBox.shrink(); // hide if no promoted products
      }

      return Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
        height: Dimensions.h(180),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.r(15)),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Stack(
          children: [
            // PageView Slider
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                _startAutoPlay(); // Reset timer on manual swipe
              },
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];
                final hasDiscount = product.discountPercentage != null && product.discountPercentage! > 0;
                final imageUrl = product.primaryImageUrl;

                return GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      RoutePath.productDetail,
                      arguments: {'productId': product.id.toString()},
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.r(15)),
                      image: const DecorationImage(
                        image: AssetImage(AppImages.homeBannerImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Left content layout
                        Padding(
                          padding: EdgeInsets.all(Dimensions.w(15)),
                          child: SizedBox(
                            width: imageUrl.isNotEmpty
                                ? Dimensions.w(200)
                                : double.infinity,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Pill tag
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.w(10),
                                      vertical: Dimensions.h(4),
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(Dimensions.r(20)),
                                      border: Border.all(
                                        color: AppColors.primaryColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 5,
                                          height: 5,
                                          decoration: const BoxDecoration(
                                            color: AppColors.primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          product.condition.toUpperCase(),
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: Dimensions.fs(10),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Dimensions.gapH(8),
                              
                                  // Title Text
                                  Text(
                                    product.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.h2.copyWith(
                                      fontSize: Dimensions.fs(16),
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                              
                                  // Price
                                  Dimensions.gapH(4),
                                  Row(
                                    children: [
                                      Text(
                                        product.formattedPrice,
                                        style: TextStyle(
                                          fontSize: Dimensions.fs(14),
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      if (hasDiscount) ...[
                                        const SizedBox(width: 8),
                                        Text(
                                          product.formattedOriginalPrice,
                                          style: TextStyle(
                                            fontSize: Dimensions.fs(10),
                                            color: Colors.grey,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Dimensions.gapH(6),
                              
                                  // Long Description
                                  Text(
                                    product.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: Dimensions.fs(9),
                                      color: Colors.grey.shade600,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
 
                        // Image layout right-aligned
                        if (imageUrl.isNotEmpty)
                          Positioned(
                            right: Dimensions.w(10),
                            bottom: Dimensions.h(10),
                            top: Dimensions.h(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.r(10)),
                              child: Image.network(
                                imageUrl,
                                width: Dimensions.w(110),
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Indicator Dots
            if (productList.length > 1)
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    productList.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 16 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: _currentPage == index
                            ? AppColors.primaryColor
                            : AppColors.greyColor.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
