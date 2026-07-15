import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/data/model/product_model.dart';
import '../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../utils/static_strings/static_strings.dart';
import '../controller/search_controller.dart';
import '../widget/filter_bottom_sheet.dart';
import '../../home/widget/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = Get.put(AppSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar and Filter Button
            Padding(
              padding: EdgeInsets.all(Dimensions.w(20)),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: TextField(
                        controller: controller.searchTextController,
                        decoration: InputDecoration(
                          hintText: AppStrings.search.tr,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: Dimensions.fs(14),
                          ),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: Dimensions.h(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.w(15)),
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        FilterBottomSheet(controller: controller),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.w(12)),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.tune,
                        color: AppColors.primaryColor,
                        size: Dimensions.icon(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.filteredProducts.isEmpty) {
                  return _buildNoMatchesState();
                }
                return _buildSearchResults();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMatchesState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.w(40)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.w(30)),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.search_off,
                size: Dimensions.icon(80),
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
            SizedBox(height: Dimensions.h(30)),
            Text(
              AppStrings.noMatchesFound.tr,
              textAlign: TextAlign.center,
              style: AppTextStyles.h3.copyWith(
                fontSize: Dimensions.fs(18),
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.w(20),
        vertical: Dimensions.h(10),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.62,
      ),
      itemCount: controller.filteredProducts.length,
      itemBuilder: (context, index) {
        final ProductModel product = controller.filteredProducts[index];
        return ProductCard(
          product: product,
          width: double.infinity,
          margin: EdgeInsets.zero,
        );
      },
    );
  }
}
