import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../../../service/api_url.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../../../utils/static_strings/static_strings.dart';
import '../controller/categorie_details_controller.dart';
import '../model/CategorieModel.dart';

class CategoriesDetailsScreen extends StatefulWidget {
  const CategoriesDetailsScreen({super.key});

  @override
  State<CategoriesDetailsScreen> createState() =>
      _CategoriesDetailsScreenState();
}

class _CategoriesDetailsScreenState extends State<CategoriesDetailsScreen> {
  final controller = Get.put(CategorieDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(20),
                vertical: Dimensions.h(15),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.w(10)),
                      decoration: const BoxDecoration(
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
                  Obx(() => Text(
                        controller.category.value?.name ??
                            AppStrings.categories.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.h3.copyWith(
                          fontSize: Dimensions.fs(20),
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  const Spacer(),
                  SizedBox(width: Dimensions.w(40)),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.hasError.value ||
                    controller.category.value == null) {
                  return Center(
                    child: Text(
                      AppStrings.noMatchesFound.tr,
                      style: AppTextStyles.bodyText,
                    ),
                  );
                }

                final category = controller.category.value!;
                final subCategories = category.subCategories ?? [];

                return RefreshIndicator(
                  color: AppColors.primaryColor,
                  onRefresh: controller.fetchCategoryDetails,
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.w(20),
                      vertical: Dimensions.h(5),
                    ),
                    children: [
                      _CategoryBanner(category: category),
                      Dimensions.gapH(24),
                      Row(
                        children: [
                          Text(
                            AppStrings.subCategories.tr,
                            style: AppTextStyles.h4.copyWith(
                              fontSize: Dimensions.fs(16),
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Dimensions.gapW(8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.w(8),
                              vertical: Dimensions.h(2),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.navBarColor,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.r(20)),
                            ),
                            child: Text(
                              '${subCategories.length}',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: Dimensions.fs(12),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Dimensions.gapH(16),
                      if (subCategories.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.h(40)),
                          child: Center(
                            child: Text(
                              AppStrings.noMatchesFound.tr,
                              style: AppTextStyles.bodyText,
                            ),
                          ),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: Dimensions.w(12),
                            mainAxisSpacing: Dimensions.h(12),
                            childAspectRatio: 2.4,
                          ),
                          itemCount: subCategories.length,
                          itemBuilder: (context, index) {
                            return _SubCategoryTile(
                                subCategory: subCategories[index]);
                          },
                        ),
                      Dimensions.gapH(24),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBanner extends StatelessWidget {
  final Data category;

  const _CategoryBanner({required this.category});

  @override
  Widget build(BuildContext context) {
    final imageUrl = category.imageUrl;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.r(15)),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimensions.r(15)),
              bottomLeft: Radius.circular(Dimensions.r(15)),
            ),
            child: Container(
              width: Dimensions.w(100),
              height: Dimensions.w(100),
              color: AppColors.navBarColor,
              padding: EdgeInsets.all(Dimensions.w(12)),
              child: (imageUrl != null && imageUrl.isNotEmpty)
                  ? Image.network(
                      ApiUrl.buildImageUrl(imageUrl),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.category,
                          color: AppColors.primaryColor,
                          size: Dimensions.icon(36)),
                    )
                  : Icon(Icons.category,
                      color: AppColors.primaryColor, size: Dimensions.icon(36)),
            ),
          ),
          Dimensions.gapW(14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.h(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.h4.copyWith(
                      fontSize: Dimensions.fs(16),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  if ((category.description ?? '').isNotEmpty) ...[
                    Dimensions.gapH(4),
                    Text(
                      category.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyText.copyWith(
                        fontSize: Dimensions.fs(12),
                        color: AppColors.greyColor,
                      ),
                    ),
                  ],
                  Dimensions.gapH(8),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.w(8),
                      vertical: Dimensions.h(3),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Dimensions.r(20)),
                      border:
                          Border.all(color: AppColors.primaryColor, width: 1),
                    ),
                    child: Text(
                      '${category.productCount ?? 0} ${AppStrings.itemsCountLabel.tr}',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: Dimensions.fs(11),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Dimensions.gapW(14),
        ],
      ),
    );
  }
}

class _SubCategoryTile extends StatelessWidget {
  final SubCategories subCategory;

  const _SubCategoryTile({required this.subCategory});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.w(14),
        vertical: Dimensions.h(10),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.r(12)),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            subCategory.name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyText.copyWith(
              fontSize: Dimensions.fs(13),
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: AppColors.darkGreyColor,
            ),
          ),
          Dimensions.gapH(6),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.w(8),
              vertical: Dimensions.h(2),
            ),
            decoration: BoxDecoration(
              color: AppColors.navBarColor,
              borderRadius: BorderRadius.circular(Dimensions.r(20)),
            ),
            child: Text(
              '${subCategory.productCount ?? 0} ${AppStrings.itemsCountLabel.tr}',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: Dimensions.fs(10),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
