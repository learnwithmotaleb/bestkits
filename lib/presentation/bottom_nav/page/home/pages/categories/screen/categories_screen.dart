import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../utils/app_text_style/app_text_style.dart';
import '../controller/categories_controller.dart';
import '../widget/category_grid_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final controller = Get.put(CategoriesController());

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
                      decoration: BoxDecoration(
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
                  Text(
                    AppStrings.categories.tr,
                    style: AppTextStyles.h3.copyWith(
                      fontSize: Dimensions.fs(20),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(width: Dimensions.w(40)),
                ],
              ),
            ),

            // Categories Grid
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(20),
                  vertical: Dimensions.h(5),
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.55,
                ),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  return CategoryGridCard(
                    category: controller.categories[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
