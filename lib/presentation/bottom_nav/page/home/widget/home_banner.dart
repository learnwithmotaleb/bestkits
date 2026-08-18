import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../core/routes/route_path.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../utils/assets_image/app_images.dart';
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
    _pageController = PageController(initialPage: 1000);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients &&
          controller.promotedProducts.length > 1) {
        _pageController.nextPage(
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
        return const SizedBox.shrink();
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
            productList.length == 1
                ? _buildBannerItem(productList.first)
                : PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      if (productList.isNotEmpty) {
                        setState(() {
                          _currentPage = index % productList.length;
                        });
                      }
                      _startAutoPlay();
                    },
                    itemBuilder: (context, index) {
                      if (productList.isEmpty) return const SizedBox.shrink();
                      final realIndex = index % productList.length;
                      return _buildBannerItem(productList[realIndex]);
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

  Widget _buildBannerItem(dynamic product) {
    final imageUrl = product.primaryImageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.r(15)),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.homeBannerImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            // Left content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(16),
                  vertical: Dimensions.h(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Category pill
                    if (product.categoryName != null &&
                        product.categoryName!.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.w(10),
                          vertical: Dimensions.h(4),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius:
                              BorderRadius.circular(Dimensions.r(20)),
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
                            Flexible(
                              child: Text(
                                product.categoryName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: Dimensions.fs(11),
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Dimensions.gapH(8),

                    // "Get X% OFF" / "Flat €X OFF" title
                    Builder(builder: (context) {
                      bool hasPercentage =
                          product.discountPercentage != null &&
                              product.discountPercentage! > 0;
                      String prefix = hasPercentage ? 'Get ' : 'Flat ';
                      String discount = hasPercentage
                          ? '${product.discountPercentage}%'
                          : '€${((product.originalPrice ?? 0) - (product.effectivePrice ?? 0)).toStringAsFixed(0)}';
                      return RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: prefix,
                              style: AppTextStyles.h2.copyWith(
                                fontSize: Dimensions.fs(20),
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            TextSpan(
                              text: discount,
                              style: AppTextStyles.h2.copyWith(
                                fontSize: Dimensions.fs(20),
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            TextSpan(
                              text: ' OFF',
                              style: AppTextStyles.h2.copyWith(
                                fontSize: Dimensions.fs(20),
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    Dimensions.gapH(6),

                    // "Use Code: KIDS20"
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Use Code: ',
                            style: TextStyle(
                              fontSize: Dimensions.fs(13),
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: 'KIDS20',
                            style: TextStyle(
                              fontSize: Dimensions.fs(13),
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Dimensions.gapH(6),

                    // Description
                    Text(
                      'Enjoy exclusive savings on all ${product.categoryName ?? 'selected'} items. Offer valid for a limited time. Apply the coupon code at checkout.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: Dimensions.fs(9),
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Right image
            if (imageUrl.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(Dimensions.w(12)),
                child: Container(
                  width: Dimensions.w(90),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimensions.r(16)),
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.r(15)),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
