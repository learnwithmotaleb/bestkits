import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
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
      final bannerCount = controller.banners.isNotEmpty ? controller.banners.length : 1;
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
      final bannerList = controller.banners;
      final bool isLoading = controller.isLoadingBanners.value;

      // Fallback single item list if loading or empty
      final List<BannerModel> activeBanners = (isLoading || bannerList.isEmpty)
          ? [
              const BannerModel(
                tag: 'Limited Time Offer',
                title: 'Up To ',
                titleHighlight: '40% OFF',
                subtitle: 'Spring Sale',
                description: 'Apply the coupon code at checkout and enjoy exclusive savings on selected styles.',
                image: AppImages.kidsCollections,
                badgeColor: 'yellow',
              ),
            ]
          : bannerList;

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
              itemCount: activeBanners.length,
              itemBuilder: (context, index) {
                final banner = activeBanners[index];
                final isYellow = banner.badgeColor != 'green';

                return GestureDetector(
                  onTap: () => Get.to(() => const ProductDetailsScreen()),
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
                        // Left & center text content layout
                        Padding(
                          padding: EdgeInsets.all(Dimensions.w(15)),
                          child: SizedBox(
                            width: banner.image != null
                                ? Dimensions.w(200)
                                : double.infinity,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: banner.image != null
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Pill tag
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.w(10),
                                      vertical: Dimensions.h(4),
                                    ),
                                    decoration: BoxDecoration(
                                      color: isYellow
                                          ? AppColors.primaryColor.withOpacity(0.1)
                                          : const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(Dimensions.r(20)),
                                      border: Border.all(
                                        color: isYellow
                                            ? AppColors.primaryColor
                                            : AppColors.applyCouponCodeColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (!isYellow) ...[
                                          const Icon(
                                            Icons.wb_sunny_outlined,
                                            color: AppColors.applyCouponCodeColor,
                                            size: 11,
                                          ),
                                          const SizedBox(width: 4),
                                        ] else ...[
                                          Container(
                                            width: 5,
                                            height: 5,
                                            decoration: const BoxDecoration(
                                              color: AppColors.primaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                        ],
                                        Text(
                                          banner.tag,
                                          style: TextStyle(
                                            color: isYellow
                                                ? AppColors.primaryColor
                                                :AppColors.applyCouponCodeColor,
                                            fontSize: Dimensions.fs(10),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Dimensions.gapH(10),
                              
                                  // Title Text with styled highlights
                                  RichText(
                                    textAlign: banner.image != null
                                        ? TextAlign.start
                                        : TextAlign.center,
                                    text: TextSpan(
                                      style: AppTextStyles.h2.copyWith(
                                        fontSize: Dimensions.fs(20),
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: banner.title,
                                          style: TextStyle(
                                            color: !isYellow && banner.image == null
                                                ? AppColors.primaryColor
                                                : Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: banner.titleHighlight,
                                          style: TextStyle(
                                            color: isYellow
                                                ? AppColors.primaryColor
                                                : (banner.image == null
                                                    ? Colors.black
                                                    : const Color(0xFF2E7D32)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              
                                  // Subtitle / Promo Code
                                  if (banner.subtitle.isNotEmpty) ...[
                                    Dimensions.gapH(4),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: Dimensions.fs(12),
                                          color: Colors.black87,
                                        ),
                                        children: [
                                          const TextSpan(text: 'Use Code: '),
                                          TextSpan(
                                            text: banner.subtitle.replaceAll('Use Code: ', ''),
                                            style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  Dimensions.gapH(8),
                              
                                  // Long Description
                                  Text(
                                    banner.description,
                                    textAlign: banner.image != null
                                        ? TextAlign.start
                                        : TextAlign.center,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: Dimensions.fs(8.5),
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
                        if (banner.image != null)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            top: 0,
                            child: Image.asset(
                              banner.image!,
                              width: Dimensions.w(130),
                              fit: BoxFit.contain,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Indicator Dots
            if (activeBanners.length > 1)
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    activeBanners.length,
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
