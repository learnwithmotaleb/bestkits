import 'package:bestkits/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/static_strings/static_strings.dart';
import '../controller/sell_controller.dart';
import '../../home/widget/product_card.dart';
import '../page/update_product/widget/update_product_card.dart';
import '../widget/sell_toggle.dart';
import '../widget/sell_empty_state.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final controller = Get.put(SellController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: CommonAppBar(
        title: AppStrings.sellingItems.tr,
        backgroundColor: const Color(0xFFF4F4F4),
        actions: [
          GestureDetector(
            onTap: controller.onAddProductTap,
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.blackColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primaryColor, width: 1.5),
              ),
              child: Icon(
                Icons.add,
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            SellToggle(controller: controller),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final isAct = controller.isActiveTab.value;
                final list = isAct
                    ? controller.activeProducts
                    : controller.inactiveProducts;

                if (list.isEmpty) {
                  return Column(
                    children: [
                      SellEmptyState(
                        message: isAct
                            ? AppStrings.noActiveProductFound.tr
                            : AppStrings.noInactiveProductFound.tr,
                      ),
                    ],
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return UpdateProductCard(
                      productData: list[index],
                      width: double.infinity,
                      margin: EdgeInsets.zero,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
