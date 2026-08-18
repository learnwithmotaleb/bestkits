import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../utils/assets_image/app_images.dart';
import '../controller/home_controller.dart';
import '../model/features_coupon_model.dart';

class FeaturedCouponBanner extends StatelessWidget {
  const FeaturedCouponBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final coupon = controller.featuredCoupon.value;
      final isLoading = controller.isLoadingFeaturedCoupon.value;

      if (isLoading && coupon == null) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
          height: Dimensions.h(180),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.r(15)),
            color: Colors.grey.shade100,
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      if (coupon == null) return const SizedBox.shrink();

      return _buildBannerCard(coupon);
    });
  }

  Widget _buildBannerCard(Data coupon) {
    final isPercentage = coupon.discountType == 'PERCENTAGE';
    final discountValue = coupon.discountValue ?? 0;
    final prefix = isPercentage ? 'Get ' : 'Flat ';
    final discount = isPercentage ? '$discountValue%' : '€$discountValue';
    final categoryName =
        coupon.discountCategory?.name ?? coupon.category?.name ?? '';
    final campaignReason = coupon.campaignReason ?? '';
    final code = coupon.code ?? '';
    final categoryImageUrl = (coupon.category?.imageUrl != null &&
            coupon.category!.imageUrl!.isNotEmpty)
        ? ApiUrl.buildImageUrl(coupon.category!.imageUrl!)
        : '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
      height: Dimensions.h(180),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.r(15)),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        image: const DecorationImage(
          image: AssetImage(AppImages.homeBannerImage),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.r(15)),
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
                    // Category pill tag
                    if (categoryName.isNotEmpty)
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
      ),
    );
  }
}
