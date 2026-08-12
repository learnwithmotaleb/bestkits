import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/seller_product_details/model/seller_product_details.dart'
    as sellModel;
import 'package:bestkits/service/api_service.dart';
import 'package:bestkits/service/api_url.dart';
import 'package:bestkits/widget/show_snackbar.dart';
import '../../../../../../../core/routes/route_path.dart';
import '../../../../../../../utils/static_strings/static_strings.dart';

import '../../../../../../../widget/app_alert.dart';
import '../../../controller/sell_controller.dart';
import '../../../../home/controller/home_controller.dart';

class SellerProductDetailsController extends GetxController {
  // Product state
  final Rx<sellModel.Data?> productDetails = Rx<sellModel.Data?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Image selection
  final selectedImageIndex = 0.obs;

  // Tab selection
  final selectedTabIndex = 0.obs;
  final List<String> tabs = [
    AppStrings.description,
  ];

  final ApiClient _apiClient = ApiClient();

  /// Call this after navigation with the product ID.
  Future<void> fetchProductDetails(String id) async {
    isLoading.value = true;
    errorMessage.value = '';
    selectedImageIndex.value = 0;

    try {
      final response = await _apiClient.get(
        url: ApiUrl.productSellerDetails(id),
        isToken: true,
      );

      if (response.statusCode == 200 && response.body != null) {
        final sellModel.SellerProductDetails model =
            sellModel.SellerProductDetails.fromJson(response.body);
        if (model.success == true && model.data != null) {
          productDetails.value = model.data;
        } else {
          errorMessage.value = model.message ?? 'Product data not found';
        }
      } else {
        errorMessage.value = 'Failed to load product (${response.statusCode})';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      print('Error fetching product details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectImage(int index) => selectedImageIndex.value = index;
  void selectTab(int index) => selectedTabIndex.value = index;

  void markAsInactive() {
    final currentStatus = productDetails.value?.status ?? 'ACTIVE';
    final isCurrentlyActive =
        currentStatus == 'ACTIVE' || currentStatus == 'LIVE';
    final newStatus = isCurrentlyActive ? 'INACTIVE' : 'ACTIVE';

    AppAlerts.warning(
      title: isCurrentlyActive
          ? AppStrings.markAsInactiveTitle.tr
          : 'Mark as Active',
      message: isCurrentlyActive
          ? AppStrings.markAsInactiveSubtitle.tr
          : 'Are you sure you want to mark this product as active?',
      confirmLabel: AppStrings.confirm.tr,
      cancelLabel: AppStrings.cancel.tr,
      onConfirm: () async {
        final prodId = productDetails.value?.id;
        if (prodId == null) {
          ShowAppSnackBar.fail('No product ID found.');
          return;
        }

        Get.back(); // close dialog
        try {
          final response = await _apiClient.patch(
            url: ApiUrl.markStatusChange(prodId.toString()),
            body: {'status': newStatus},
            isToken: true,
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            // Refresh the details
            fetchProductDetails(prodId.toString());

            // Refresh the sell list and home list
            if (Get.isRegistered<SellController>()) {
              Get.find<SellController>().fetchProducts(isRefresh: true);
            }
            if (Get.isRegistered<HomeController>()) {
              Get.find<HomeController>().fetchHomeData();
            }

            ShowAppSnackBar.success(isCurrentlyActive
                ? AppStrings.productMarkedInactiveSuccess.tr
                : 'Product marked as active successfully!');
          } else {
            final msg = response.body?['message']?.toString() ??
                'Failed to update status';
            ShowAppSnackBar.fail(msg);
          }
        } catch (e) {
          ShowAppSnackBar.fail('Error: $e');
        }
      },
    );
  }

  void deleteProduct() {
    AppAlerts.delete(
      title: AppStrings.deleteProductTitle.tr,
      message: AppStrings.deleteProductSubtitle.tr,
      onDelete: () async {
        final prodId = productDetails.value?.id;
        if (prodId == null) {
          ShowAppSnackBar.fail('No product ID found.');
          return;
        }

        Get.back(); // close dialog
        try {
          final response = await _apiClient.delete(
            url: ApiUrl.deleteProduct(prodId.toString()),
            isToken: true,
          );

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 204) {
            // Refresh the sell list
            if (Get.isRegistered<SellController>()) {
              Get.find<SellController>().fetchProducts(isRefresh: true);
            }
            if (Get.isRegistered<HomeController>()) {
              Get.find<HomeController>().fetchHomeData();
            }

            Get.back(); // go back to sell screen
            ShowAppSnackBar.success(AppStrings.productDeletedSuccess.tr);
          } else {
            final msg = response.body?['message']?.toString() ??
                'Failed to delete product';
            ShowAppSnackBar.fail(msg);
          }
        } catch (e) {
          ShowAppSnackBar.fail('Error: $e');
        }
      },
    );
  }
}
