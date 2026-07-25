import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/data/model/product_model.dart';
import 'package:bestkits/service/api_service.dart';
import 'package:bestkits/service/api_url.dart';
import 'package:bestkits/widget/show_snackbar.dart';
import '../../../../utils/static_strings/static_strings.dart';
import '../../bottom_nav/page/cart/controller/cart_controller.dart';

class ProductDetailsController extends GetxController {
  // Product state
  final Rx<ProductModel?> productDetails = Rx<ProductModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isAddingToCart = false.obs;
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
        errorMessage.value = 'Failed to load product (${response.statusCode})';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      print('Error fetching product details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart() async {
    if (productDetails.value == null) return;

    // Find selected variant ID
    final variant = productDetails.value!.variants.firstWhere(
      (v) => v.variantName == selectedVariant.value,
      orElse: () => ProductVariant(
          id: 0, productId: 0, variantName: '', price: 0), // fallback
    );

    if (variant.id == 0 && productDetails.value!.variants.isNotEmpty) {
      ShowAppSnackBar.fail('Please select a valid variant');
      return;
    }

    isAddingToCart.value = true;
    try {
      final body = {
        "productId": productDetails.value!.id,
        "variantId": variant.id,
        "quantity": quantity.value
      };

      final response = await _apiClient.post(
        url: ApiUrl.addToCart,
        body: body,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ShowAppSnackBar.success("Product added to cart successfully");
        // Increment cart badge count on home header immediately
        if (Get.isRegistered<CartController>()) {
          Get.find<CartController>().incrementCount();
        }
      } else {
        final raw = response.body?['message'] ??
            response.statusText ??
            "Failed to add to cart";
        final msg = raw is List ? raw.join(', ') : raw.toString();
        ShowAppSnackBar.fail(msg);
      }
    } catch (e) {
      ShowAppSnackBar.fail("An error occurred: $e");
    } finally {
      isAddingToCart.value = false;
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
