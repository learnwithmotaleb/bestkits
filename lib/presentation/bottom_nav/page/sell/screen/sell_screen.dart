import 'package:bestkits/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/static_strings/static_strings.dart';
import '../controller/sell_controller.dart';
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

  String _emptyMessage(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'No Under Review Products Found';
      case 1:
        return 'No Live Products Found';
      case 2:
        return 'No Action Required Products Found';
      case 3:
        return 'No Rejected Products Found';
      case 4:
        return 'No Sold Products Found';
      case 5:
        return AppStrings.noInactiveProductFound.tr;
      default:
        return 'No Products Found';
    }
  }

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
            // Horizontal Scrollable Tab Bar
            SellToggle(controller: controller),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }

                final tabIndex = controller.selectedTabIndex.value;
                final list = controller.currentList;

                if (list.isEmpty) {
                  return RefreshIndicator(
                    color: AppColors.primaryColor,
                    onRefresh: () => controller.fetchProducts(isRefresh: true),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          SellEmptyState(
                            message: _emptyMessage(tabIndex),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primaryColor,
                  onRefresh: () => controller.fetchProducts(isRefresh: true),
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
