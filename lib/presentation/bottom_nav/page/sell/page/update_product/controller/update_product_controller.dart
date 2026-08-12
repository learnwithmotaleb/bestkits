import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/update_product/screen/update_product.dart';

import '../../../../../../../widget/app_alert.dart';
import '../../../../../../../widget/show_snackbar.dart';
import '../../../../../../../utils/static_strings/static_strings.dart';
import '../../../../../../../utils/assets_image/app_images.dart';
import '../../../controller/sell_controller.dart';
import '../../product_order/screen/product_order.dart';
import 'package:bestkits/service/api_service.dart';
import 'package:bestkits/service/api_url.dart';
import 'package:bestkits/data/model/product_model.dart';
import 'package:bestkits/presentation/bottom_nav/page/home/pages/categories/model/CategoryModel.dart';
import 'package:bestkits/presentation/bottom_nav/page/home/controller/home_controller.dart';
import 'package:bestkits/presentation/favorite/controller/favourite_controller.dart';

class UpdateProductController extends GetxController {
  late final RxMap<String, dynamic> product;
  final isLoading = false.obs;
  final Rxn<ProductModel> productModel = Rxn<ProductModel>();

  // ── Image selection (viewer for existing product images) ──────────────────
  final selectedImageIndex = 0.obs;
  final RxList<String> productImages = <String>[].obs;

  // ── Existing images from server (shown in update form) ─────────────────────
  final RxList<String> existingImageUrls = <String>[].obs;

  // ── Image picker (for update product form) ─────────────────────────────────
  final _picker = ImagePicker();
  final RxList<File> pickedImages = <File>[].obs;

  Future<void> pickImages() async {
    final List<XFile> result = await _picker.pickMultiImage(imageQuality: 80);
    if (result.isEmpty) return;
    for (final xFile in result) {
      if (pickedImages.length < 6) {
        pickedImages.add(File(xFile.path));
      }
    }
  }

  void removePickedImage(int index) {
    if (index >= 0 && index < pickedImages.length) {
      pickedImages.removeAt(index);
    }
  }

  void removeExistingImage(int index) {
    if (index >= 0 && index < existingImageUrls.length) {
      existingImageUrls.removeAt(index);
      // Also sync productImages
      _initImages();
    }
  }

  // Size selection
  final selectedSize = 'S'.obs;
  final List<String> sizes = ['S', 'M', 'L', 'XL', '2XL', '3XL'];

  // Quantity selection
  final quantity = 1.obs;

  // Tab selection
  final selectedTabIndex = 0.obs;
  final List<String> tabs = [AppStrings.description, AppStrings.reviews];

  // Real reviews loaded from API
  final RxList<Map<String, dynamic>> reviewsList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      product = RxMap<String, dynamic>(args);
    } else {
      product = RxMap<String, dynamic>({
        'name': AppStrings.dummyProductName,
        'image': AppImages.kidsCottonSho,
        'price': '180.00',
        'oldPrice': '21.99',
        'rating': '4.9/5.0',
        'material': AppStrings.dummyMaterial,
        'discount': '20%',
      });
    }

    // Initialize images synchronously with available data to prevent UI crash
    _initImages();

    // Extract ID if available to fetch fresh data
    final productId = product['id']?.toString() ?? '';
    if (productId.isNotEmpty) {
      fetchProductDetails(productId);
    }
  }

  Future<void> fetchProductDetails(String id) async {
    isLoading.value = true;
    try {
      final ApiClient apiClient = ApiClient();
      final response = await apiClient.get(
        url: ApiUrl.productSellerDetails(id),
        isToken: true,
      );

      if (response.statusCode == 200 &&
          response.body is Map &&
          response.body['data'] != null) {
        final dynamic data = response.body['data'];
        Map<String, dynamic>? productMap;
        if (data is List && data.isNotEmpty) {
          productMap = data.first as Map<String, dynamic>;
        } else if (data is Map<String, dynamic>) {
          productMap = data;
        }

        if (productMap != null) {
          product.value = productMap;
          _initImages();
          _syncExistingImages();
          _populateReviews(productMap);
          // Re-populate subcategories after fresh data
          final cat = productMap['category'];
          if (cat is Map && cat['name'] != null) {
            updateSubCategories(cat['name'].toString());
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching product details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _initImages() {
    productImages.clear();
    final urls = existingImageUrls.isNotEmpty
        ? existingImageUrls
        : (product['image_urls'] is List
            ? List<String>.from(product['image_urls'])
            : <String>[]);
    if (urls.isNotEmpty) {
      productImages.addAll(urls);
    } else {
      final mainImg =
          product['image_url'] ?? product['image'] ?? AppImages.kidsCottonSho;
      productImages.add(mainImg);
    }
  }

  void _syncExistingImages() {
    if (existingImageUrls.isEmpty) {
      final raw = product['image_urls'];
      if (raw is List && raw.isNotEmpty) {
        existingImageUrls.assignAll(List<String>.from(raw));
      } else {
        final img = product['image_url'];
        if (img != null && img.toString().isNotEmpty) {
          existingImageUrls.add(img.toString());
        }
      }
    }
  }

  void _populateReviews(Map<String, dynamic> productMap) {
    final rawReviews =
        productMap['reviews'] ?? productMap['authentication_requests'];
    if (rawReviews == null || rawReviews is! List) return;
    reviewsList.clear();
    for (final r in rawReviews) {
      if (r is! Map) continue;
      final user = r['user'];
      String fullName = '';
      String avatarUrl = '';
      if (user is Map) {
        final profile = user['profile'];
        if (profile is Map) {
          fullName = profile['full_name']?.toString() ?? '';
          avatarUrl = profile['avatar_url']?.toString() ?? '';
        }
      }
      final parts = fullName.trim().split(' ');
      final initials = parts.length >= 2
          ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
          : fullName.isNotEmpty
              ? fullName[0].toUpperCase()
              : '?';
      final createdAt = r['createdAt']?.toString() ?? '';
      final date =
          createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt;
      final rating = r['rating'];
      reviewsList.add({
        'name': fullName.isNotEmpty ? fullName : 'Anonymous',
        'initials': initials,
        'rating': rating != null ? '$rating/5.0' : '0/5.0',
        'date': date,
        'content': r['review']?.toString() ?? '',
        'avatar_url': avatarUrl,
      });
    }
  }

  void incrementQuantity() => quantity.value++;
  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void selectImage(int index) => selectedImageIndex.value = index;
  void selectSize(String size) => selectedSize.value = size;
  void selectTab(int index) => selectedTabIndex.value = index;

  void markAsInactive() {
    final currentStatus = product['status'] ?? 'ACTIVE';
    final isCurrentlyActive = currentStatus == 'ACTIVE';
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
        final prodId = product['id'];
        if (prodId == null) {
          ShowAppSnackBar.fail('No product ID found.');
          return;
        }

        Get.back(); // close dialog
        try {
          final apiClient = ApiClient();
          final response = await apiClient.patch(
            url: ApiUrl.markStatusChange(prodId.toString()),
            body: {'status': newStatus},
            isToken: true,
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            // Update local product status
            product['status'] = newStatus;

            // Refresh the sell list
            if (Get.isRegistered<SellController>()) {
              await Get.find<SellController>().fetchProducts(isRefresh: true);
            }
            Get.back(); // go back to sell screen
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
        final prodId = product['id'];
        if (prodId == null) {
          ShowAppSnackBar.fail('No product ID found.');
          return;
        }

        Get.back(); // close dialog
        try {
          final apiClient = ApiClient();
          final response = await apiClient.delete(
            url: ApiUrl.deleteProduct(prodId.toString()),
            isToken: true,
          );

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 204) {
            // Refresh the sell list
            if (Get.isRegistered<SellController>()) {
              await Get.find<SellController>().fetchProducts(isRefresh: true);
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

  void updateProduct() {
    AppAlerts.warning(
      title: AppStrings.proceedToUpdateProductTitle.tr,
      message: AppStrings.proceedToUpdateProductSubtitle.tr,
      confirmLabel: AppStrings.yesText.tr,
      cancelLabel: AppStrings.noText.tr,
      onConfirm: () {
        Get.to(() => const UpdateProduct());
      },
    );
  }

  void viewOrders() {
    AppAlerts.warning(
      title: AppStrings.viewOrdersTitle.tr,
      message: AppStrings.viewOrdersSubtitle.tr,
      confirmLabel: AppStrings.viewOrdersBtn.tr,
      cancelLabel: AppStrings.cancel.tr,
      onConfirm: () {
        Get.to(
          () => const ProductOrder(),
          arguments: {'productId': product['id']?.toString() ?? ''},
        );
      },
    );
  }

  // ── Form Data for Updating ──────────────────────────────────────────────
  final RxString name = ''.obs;
  final RxString description = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxString selectedSubCategory = ''.obs;

  final RxString price = ''.obs;
  final RxString discount = ''.obs;
  final RxString condition = 'New'.obs;

  final RxList<Data> categoryData = <Data>[].obs;
  final RxList<String> categoryNames = <String>[].obs;
  final RxList<String> subCategoryNames = <String>[].obs;

  Future<void> fetchCategories() async {
    try {
      final apiClient = ApiClient();
      final response = await apiClient.get(url: ApiUrl.getCategories);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final categoryModel = CategoryModel.fromJson(response.body);
        if (categoryModel.success == true && categoryModel.data != null) {
          categoryData.assignAll(categoryModel.data!);
          categoryNames.assignAll(categoryData
              .map((c) => c.name ?? '')
              .where((n) => n.isNotEmpty)
              .toList());

          // Pre-populate subcategories if the product has an initial category
          final cat = product['category'];
          if (cat is Map && cat['name'] != null) {
            updateSubCategories(cat['name'].toString());
          }
        }
      }
    } catch (e) {
      print("Error fetching categories in UpdateProductController: $e");
    }
  }

  void updateSubCategories(String categoryName) {
    final selectedCat = categoryData.firstWhereOrNull((c) =>
        c.name?.toLowerCase().trim() == categoryName.toLowerCase().trim());
    subCategoryNames.clear();
    if (selectedCat != null && selectedCat.subCategories != null) {
      subCategoryNames.assignAll(selectedCat.subCategories!
          .map((s) => s.name ?? '')
          .where((n) => n.isNotEmpty)
          .toList());
    }
  }

  Future<List<String>> _uploadImages() async {
    final List<String> urls = [];
    final apiClient = ApiClient();
    for (final img in pickedImages) {
      try {
        final response = await apiClient.multipart(
          url: ApiUrl.upload,
          fields: {},
          files: [
            MultipartFileData(
              key: 'file',
              path: img.path,
            )
          ],
          isToken: true,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = response.body;
          if (data is Map && data.containsKey('url')) {
            urls.add(data['url'].toString());
          } else if (data is Map &&
              data['data'] != null &&
              data['data']['url'] != null) {
            urls.add(data['data']['url'].toString());
          }
        }
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
    return urls;
  }

  Future<String?> updateProductApi({
    required double price,
    required double discountPercentage,
    required String conditionValue,
  }) async {
    final prodId = product['id']?.toString() ?? '';
    if (prodId.isEmpty) return 'No product ID found.';

    isLoading.value = true;
    try {
      final apiClient = ApiClient();

      // Upload new images if any were picked, otherwise keep existing
      final List<String> imageUrls = [];
      if (pickedImages.isNotEmpty) {
        imageUrls.addAll(await _uploadImages());
      }
      if (imageUrls.isEmpty) {
        // Keep existing image_urls from the product data
        final existing = product['image_urls'];
        if (existing is List) {
          imageUrls.addAll(List<String>.from(existing));
        }
      }

      // Calculate discounted price from discount %
      double discountedPrice = price;
      if (discountPercentage > 0 && discountPercentage < 100) {
        discountedPrice = price - (price * discountPercentage / 100);
      }

      // Resolve category & subcategory IDs
      int categoryId = (product['categoryId'] as num?)?.toInt() ??
          (product['category']?['id'] as num?)?.toInt() ??
          1;
      int subCategoryId = (product['subCategoryId'] as num?)?.toInt() ??
          (product['subCategory']?['id'] as num?)?.toInt() ??
          1;

      if (selectedCategory.value.isNotEmpty) {
        final cat = categoryData.firstWhereOrNull((c) =>
            c.name?.toLowerCase().trim() ==
            selectedCategory.value.toLowerCase().trim());
        if (cat != null && cat.id != null) {
          categoryId = cat.id!.toInt();
          if (selectedSubCategory.value.isNotEmpty &&
              cat.subCategories != null) {
            final sub = cat.subCategories!.firstWhereOrNull((s) =>
                s.name?.toLowerCase().trim() ==
                selectedSubCategory.value.toLowerCase().trim());
            if (sub != null && sub.id != null) {
              subCategoryId = sub.id!.toInt();
            }
          }
        }
      }

      final body = {
        "name": name.value.isNotEmpty
            ? name.value
            : product['name']?.toString() ?? '',
        "description": description.value.isNotEmpty
            ? description.value
            : product['description']?.toString() ?? '',
        "original_price": price.toInt(),
        "discounted_price": discountedPrice.toInt(),
        "discount_percentage": discountPercentage.toInt(),
        "image_urls": imageUrls,
        "categoryId": categoryId,
        "subCategoryId": subCategoryId,
        "condition": conditionValue.toUpperCase(),
      };

      final response = await apiClient.patch(
        url: ApiUrl.updateProduct(prodId),
        body: body,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh relevant controllers
        if (Get.isRegistered<SellController>()) {
          Get.find<SellController>().fetchProducts(isRefresh: true);
        }
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchHomeData();
        }
        if (Get.isRegistered<FavouriteController>()) {
          Get.find<FavouriteController>().fetchWishlist();
        }
        return null; // success
      } else {
        final resBody = response.body;
        if (resBody is Map && resBody.containsKey('message')) {
          return resBody['message'].toString();
        }
        return "Failed to update product. Status: ${response.statusCode}";
      }
    } catch (e) {
      print("Error updating product: $e");
      return "Something went wrong: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
