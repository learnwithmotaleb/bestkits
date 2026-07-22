import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/update_product/screen/update_product.dart';

import '../../../../../../../widget/app_alert.dart';
import '../../../../../../../utils/static_strings/static_strings.dart';
import '../../../../../../../utils/assets_image/app_images.dart';
import '../../../controller/sell_controller.dart';
import '../screen/product_order.dart';
import 'package:bestkits/service/api_service.dart';
import 'package:bestkits/service/api_url.dart';
import 'package:bestkits/presentation/bottom_nav/page/home/pages/categories/model/CategoryModel.dart';
import 'package:bestkits/presentation/bottom_nav/page/home/controller/home_controller.dart';
import 'package:bestkits/presentation/favorite/controller/favourite_controller.dart';

class UpdateProductController extends GetxController {
  late final RxMap<String, dynamic> product;

  // ── Image selection (viewer for existing product images) ──────────────────
  final selectedImageIndex = 0.obs;
  final RxList<String> productImages = <String>[].obs;

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

  // Size selection
  final selectedSize = 'S'.obs;
  final List<String> sizes = ['S', 'M', 'L', 'XL', '2XL', '3XL'];

  // Quantity selection
  final quantity = 1.obs;

  // Tab selection
  final selectedTabIndex = 0.obs;
  final List<String> tabs = [AppStrings.description, AppStrings.reviews];

  // Dummy Reviews (matching screenshot)
  final List<Map<String, dynamic>> reviewsList = [
    {
      'name': 'Maximilian Becker',
      'initials': 'MB',
      'rating': '4.9/5.0',
      'date': '12 Feb 2026',
      'content':
          'Very comfortable and lightweight sneakers. My son has been wearing them almost every day, and they still look great. The fit is perfect and easy to put on. Definitely a good purchase.',
    },
    {
      'name': 'Noah Hoffmann',
      'initials': 'NH',
      'rating': '4.9/5.0',
      'date': '03 Feb 2026',
      'content':
          'Good quality overall and the design looks really nice. The material feels durable and suitable for daily use. Delivery was smooth and packaging was proper. Happy with the purchase.',
    },
    {
      'name': 'Clara Vogel',
      'initials': 'CV',
      'rating': '4.9/5.0',
      'date': '28 Jan 2026',
      'content':
          'Exactly as described. The sneakers look clean and well-made, and the size fits perfectly. My child finds them very comfortable for school and outdoor play. Would recommend.',
    },
    {
      'name': 'Alex Müller',
      'initials': 'AM',
      'rating': '4.9/5.0',
      'date': '19 Jan 2026',
      'content':
          'Comfortable and stylish sneakers. The sole has good grip and the build quality feels solid. Slightly snug at first, but after a few uses it fits better. Overall a good value product.',
    },
    {
      'name': 'Jonas Weber',
      'initials': 'JW',
      'rating': '4.9/5.0',
      'date': '28 Jan 2026',
      'content':
          'Very comfortable and lightweight sneakers. My son has been wearing them almost every day, and they still look great. The fit is perfect and easy to put on. Definitely a good purchase.',
    },
  ];

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

    // Populate images based on product image
    productImages.clear();
    if (product['image_urls'] != null && product['image_urls'] is List && (product['image_urls'] as List).isNotEmpty) {
      productImages.addAll(List<String>.from(product['image_urls']));
    } else {
      final mainImg = product['image_url'] ?? product['image'] ?? AppImages.kidsCottonSho;
      productImages.addAll([
        mainImg,
        mainImg,
        mainImg,
        mainImg,
        mainImg,
      ]);
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
    AppAlerts.warning(
      title: AppStrings.markAsInactiveTitle.tr,
      message: AppStrings.markAsInactiveSubtitle.tr,
      confirmLabel: AppStrings.confirm.tr,
      cancelLabel: AppStrings.cancel.tr,
      onConfirm: () {
        try {
          final sellController = Get.find<SellController>();
          final prodId = product['id'];

          if (prodId != null) {
            final activeItem = sellController.activeProducts.firstWhereOrNull((p) => p.id == prodId);
            if (activeItem != null) {
              sellController.activeProducts.remove(activeItem);
              sellController.inactiveProducts.add(activeItem);
            }
          } else {
            // Fallback for dummy data
            sellController.activeProducts
                .removeWhere((p) => p.name == product['name']);
          }
          sellController.isActiveTab.value = false;

          Get.back(); // go back
          AppAlerts.success(message: AppStrings.productMarkedInactiveSuccess.tr);
        } catch (e) {
          Get.back();
        }
      },
    );
  }

  void deleteProduct() {
    AppAlerts.delete(
      title: AppStrings.deleteProductTitle.tr,
      message: AppStrings.deleteProductSubtitle.tr,
      onDelete: () {
        try {
          final sellController = Get.find<SellController>();
          final prodId = product['id'];

          if (prodId != null) {
            sellController.activeProducts.removeWhere((p) => p.id == prodId);
            sellController.inactiveProducts.removeWhere((p) => p.id == prodId);
          } else {
            sellController.activeProducts
                .removeWhere((p) => p.name == product['name']);
            sellController.inactiveProducts
                .removeWhere((p) => p.name == product['name']);
          }

          Get.back(); // go back
          AppAlerts.success(message: AppStrings.productDeletedSuccess.tr);
        } catch (e) {
          Get.back();
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
        Get.to(() => const ProductOrder());
      },
    );
  }

  // ── Form Data for Updating ──────────────────────────────────────────────
  final RxString name = ''.obs;
  final RxString description = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxString selectedSubCategory = ''.obs;
  final RxList<String> selectedSizes = <String>[].obs;
  final RxBool isLoading = false.obs;

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
        }
      }
    } catch (e) {
      print("Error fetching categories in UpdateProductController: $e");
    }
  }

  void updateSubCategories(String categoryName) {
    final selectedCat = categoryData.firstWhereOrNull(
      (c) => c.name?.toLowerCase().trim() == categoryName.toLowerCase().trim()
    );
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
          } else if (data is Map && data['data'] != null && data['data']['url'] != null) {
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
    required double discountPrice,
    required String status,
  }) async {
    final prodId = product['id']?.toString() ?? '1'; // Fallback to 1 if dummy

    isLoading.value = true;
    try {
      final apiClient = ApiClient();
      
      // Upload images if any picked, otherwise reuse existing
      final List<String> imageUrls = [];
      if (pickedImages.isNotEmpty) {
        imageUrls.addAll(await _uploadImages());
      }
      if (imageUrls.isEmpty) {
        imageUrls.addAll(productImages);
      }
      if (imageUrls.isEmpty) {
        imageUrls.add("https://example.com/images/iphone15pro-front.jpg");
      }

      double discountPercentage = 0;
      if (price > 0 && discountPrice > 0 && discountPrice < price) {
        discountPercentage = ((price - discountPrice) / price) * 100;
      }

      // Resolve category & subcategory IDs
      int categoryId = 1;
      int subCategoryId = 1;

      if (selectedCategory.value.isNotEmpty) {
        final cat = categoryData.firstWhereOrNull(
          (c) => c.name?.toLowerCase().trim() == selectedCategory.value.toLowerCase().trim()
        );
        if (cat != null && cat.id != null) {
          categoryId = cat.id!.toInt();
          
          if (selectedSubCategory.value.isNotEmpty && cat.subCategories != null) {
            final sub = cat.subCategories!.firstWhereOrNull(
              (s) => s.name?.toLowerCase().trim() == selectedSubCategory.value.toLowerCase().trim()
            );
            if (sub != null && sub.id != null) {
              subCategoryId = sub.id!.toInt();
            }
          }
        }
      }

      // Map sizes to variants
      final List<Map<String, dynamic>> variants = [];
      final List<String> variantNames = [];

      if (selectedSizes.isNotEmpty) {
        variantNames.add("Size");
        for (final size in selectedSizes) {
          variants.add({
            "variantName": size,
            "price": price,
          });
        }
      } else {
        variants.add({
          "variantName": "Default",
          "price": price,
        });
      }

      String statusPayload = "ACTIVE";
      if (status.toLowerCase().contains("inactive")) {
        statusPayload = "INACTIVE";
      }

      final body = {
        "name": name.value.isNotEmpty ? name.value : product['name']?.toString() ?? '',
        "description": description.value.isNotEmpty ? description.value : product['description']?.toString() ?? '',
        "original_price": price,
        "discounted_price": discountPrice,
        "discount_percentage": discountPercentage.round(),
        "image_urls": imageUrls,
        "categoryId": categoryId,
        "subCategoryId": subCategoryId,
        "condition": "NEW",
        "status": statusPayload,
        "variants": variants,
        "variant_names": variantNames,
        "replace_variants": true
      };

      final response = await apiClient.patch(
        url: ApiUrl.updateProduct(prodId),
        body: body,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (Get.isRegistered<HomeController>()) Get.find<HomeController>().fetchHomeData();
        if (Get.isRegistered<SellController>()) Get.find<SellController>().fetchProducts();
        if (Get.isRegistered<FavouriteController>()) Get.find<FavouriteController>().fetchWishlist();
        return null; // success
      } else {
        final resBody = response.body;
        if (resBody is Map && resBody.containsKey('message')) {
          return resBody['message'].toString();
        }
        return "Failed to update product. Status code: ${response.statusCode}";
      }
    } catch (e) {
      print("Error updating product: $e");
      return "Something went wrong: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
