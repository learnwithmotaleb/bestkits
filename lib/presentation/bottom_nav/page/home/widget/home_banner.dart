import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../utils/assets_image/app_images.dart';
import '../controller/home_controller.dart';
import '../model/features_coupon_model.dart';
import '../model/home_model.dart';

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
      if (!mounted) return;
      final totalSlides = _getTotalSlides();
      if (_pageController.hasClients && totalSlides > 1) {
        final nextPage = (_currentPage + 1) % totalSlides;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  int _getTotalSlides() {
    final hasCoupon = controller.featuredCoupon.value != null;
    final promotedCount = controller.promotedProducts.length;
    return (hasCoupon ? 1 : 0) + promotedCount;
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
      final coupon = controller.featuredCoupon.value;
      final promotedList = controller.promotedProducts;
      final isLoading = controller.isLoadingHome.value ||
          controller.isLoadingFeaturedCoupon.value;

      final bool hasCoupon = coupon != null;
      final int totalSlides = (hasCoupon ? 1 : 0) + promotedList.length;

      if (isLoading && totalSlides == 0) {
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

      if (totalSlides == 0) {
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
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.r(15)),
              child: totalSlides == 1
                  ? _buildSlide(
                      index: 0,
                      coupon: coupon,
                      promotedList: promotedList,
                      hasCoupon: hasCoupon,
                    )
                  : PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index % totalSlides;
                        });
                        _startAutoPlay();
                      },
                      itemCount: totalSlides,
                      itemBuilder: (context, index) {
                        return _buildSlide(
                          index: index,
                          coupon: coupon,
                          promotedList: promotedList,
                          hasCoupon: hasCoupon,
                        );
                      },
                    ),
            ),

            // Indicator Dots
            if (totalSlides > 1)
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    totalSlides,
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

  Widget _buildSlide({
    required int index,
    required Data? coupon,
    required List<PromotedData> promotedList,
    required bool hasCoupon,
  }) {
    // First slide = featured coupon (if available)
    if (hasCoupon && index == 0) {
      return _buildCouponSlide(coupon!);
    }

    // Subsequent slides = promoted products
    final promotedIndex = hasCoupon ? index - 1 : index;
    if (promotedIndex >= 0 && promotedIndex < promotedList.length) {
      return _buildPromotedSlide(promotedList[promotedIndex]);
    }

    return const SizedBox.shrink();
  }

  // ── Featured Coupon Slide ──────────────────────────────────────────────────
  Widget _buildCouponSlide(Data coupon) {
    final isPercentage = coupon.discountType == 'PERCENTAGE';
    final discountValue = coupon.discountValue ?? 0;
    final prefix = isPercentage ? 'Get ' : 'Flat ';
    final discount = isPercentage ? '$discountValue%' : '€$discountValue';
    final categoryName =
        coupon.discountCategory?.name ?? coupon.category?.name ?? '';
    final code = coupon.code ?? '';
    final campaignReason = coupon.campaignReason ?? '';
    final categoryImageUrl = (coupon.category?.imageUrl != null &&
            coupon.category!.imageUrl!.isNotEmpty)
        ? ApiUrl.buildImageUrl(coupon.category!.imageUrl!)
        : '';

    return Container(
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
                  if (categoryName.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.w(10),
                        vertical: Dimensions.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
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
                          Flexible(
                            child: Text(
                              categoryName,
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

                  // "Get X% OFF" title
                  RichText(
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
                  ),

                  Dimensions.gapH(6),

                  // "Use Code: KIDS10"
                  if (code.isNotEmpty)
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
                            text: code,
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
                  if (campaignReason.isNotEmpty)
                    Text(
                      'Enjoy exclusive savings on all $categoryName items. Offer valid for a limited time. Apply the coupon code at checkout.',
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
          if (categoryImageUrl.isNotEmpty)
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
                    categoryImageUrl,
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
    );
  }

  // ── Promoted Product Slide ─────────────────────────────────────────────────
  Widget _buildPromotedSlide(PromotedData product) {
    final imageUrl = product.primaryImageUrl;
    final bool hasPercentage =
        product.discountPercentage != null && product.discountPercentage! > 0;
    final String prefix = hasPercentage ? 'Get ' : 'Flat ';
    final String discount = hasPercentage
        ? '${product.discountPercentage}%'
        : '€${((product.originalPrice ?? 0) - (product.effectivePrice ?? 0)).toStringAsFixed(0)}';

    return Container(
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
                  RichText(
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
                  ),

                  Dimensions.gapH(6),

                  // Product name
                  Text(
                    product.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Dimensions.fs(13),
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Dimensions.gapH(6),

                  // Price
                  Text(
                    product.formattedPrice,
                    maxLines: 1,
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
    );
  }
}
