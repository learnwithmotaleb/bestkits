import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/data/model/product_model.dart';
import 'package:bestkits/service/api_service.dart';
import 'package:bestkits/service/api_url.dart';
import '../../../../utils/static_strings/static_strings.dart';

class ProductDetailsController extends GetxController {
  // Product state
  final Rx<ProductModel?> productDetails = Rx<ProductModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Image selection
  final selectedImageIndex = 0.obs;

  // Variant selection (using variant name)
  final selectedVariant = ''.obs;

  // Quantity selection
  final quantity = 1.obs;

  // Tab selection
  final selectedTabIndex = 0.obs;
  final List<String> tabs = [
    AppStrings.description,
    AppStrings.reviews,
    AppStrings.sellerLabel,
  ];

  final ApiClient _apiClient = ApiClient();

  /// Call this after navigation with the product ID.
  Future<void> fetchProductDetails(String id) async {
    isLoading.value = true;
    errorMessage.value = '';
    selectedImageIndex.value = 0;

    try {
      final response = await _apiClient.get(
        url: ApiUrl.detailsProduct(id),
        isToken: true,
      );

      if (response.statusCode == 200 &&
          response.body is Map &&
          response.body['data'] != null) {
        // The API returns data as a List (array of products matching id)
        final dynamic data = response.body['data'];
        Map<String, dynamic>? productMap;

        if (data is List && data.isNotEmpty) {
          productMap = data.first as Map<String, dynamic>;
        } else if (data is Map<String, dynamic>) {
          productMap = data;
        }

        if (productMap != null) {
          productDetails.value = ProductModel.fromJson(productMap);
          // Set the first variant as selected by default
          if (productDetails.value!.variants.isNotEmpty) {
            selectedVariant.value =
                productDetails.value!.variants.first.variantName;
          }
        } else {
          errorMessage.value = 'Product data not found';
        }
      } else {
        errorMessage.value =
            'Failed to load product (${response.statusCode})';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      print('Error fetching product details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void incrementQuantity() => quantity.value++;
  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void selectImage(int index) => selectedImageIndex.value = index;
  void selectVariant(String variant) => selectedVariant.value = variant;
  void selectTab(int index) => selectedTabIndex.value = index;
}