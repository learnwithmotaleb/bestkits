import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bestkits/service/api_service.dart';
import 'package:bestkits/service/api_url.dart';
import 'package:bestkits/presentation/bottom_nav/page/home/pages/categories/model/CategoryModel.dart';
import 'package:bestkits/presentation/bottom_nav/page/home/controller/home_controller.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/controller/sell_controller.dart';
import 'package:bestkits/presentation/favorite/controller/favourite_controller.dart';

class AddProductController extends GetxController {
  final _picker = ImagePicker();
  final RxList<File> pickedImages = <File>[].obs;
  final RxBool isLoading = false.obs;

  // Form Data
  final RxString name = ''.obs;
  final RxString description = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxString selectedSubCategory = ''.obs;

  final RxString price = ''.obs;
  final RxString discount = ''.obs;
  final RxString condition = 'New'.obs;

  // Verification Page Data
  final RxList<File> verificationImages = <File>[].obs;
  final RxString selectedBrand = ''.obs;
  final RxList<String> brandNames = <String>[].obs;

  final RxList<Data> categoryData = <Data>[].obs;
  final RxList<String> categoryNames = <String>[].obs;
  final RxList<String> subCategoryNames = <String>[].obs;

  // LegitGrails categories list
  final RxList<String> legitgrailsCategories = <String>[].obs;
  final RxString selectedLegitCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchLegitgrailsBrands();
    fetchLegitgrailsCategories();
  }

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
      print("Error fetching categories in AddProductController: $e");
    }
  }

  Future<void> fetchLegitgrailsBrands() async {
    try {
      final apiClient = ApiClient();
      final response = await apiClient.get(url: ApiUrl.legitgrailsBrandAPI);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body is Map && response.body['data'] != null) {
          final List dataList = response.body['data'];
          final brands = dataList
              .map((b) => b['name']?.toString() ?? '')
              .where((n) => n.isNotEmpty)
              .toList();
          brandNames.assignAll(brands);
        }
      }
    } catch (e) {
      print("Error fetching legitgrails brands: $e");
    }
  }

  Future<void> fetchLegitgrailsCategories() async {
    try {
      final apiClient = ApiClient();
      final response =
          await apiClient.get(url: ApiUrl.legitgrailsCategoriesAPI);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body is Map && response.body['data'] != null) {
          final List dataList = response.body['data'];
          final categories = dataList
              .map((c) => c['name']?.toString() ?? '')
              .where((n) => n.isNotEmpty)
              .toList();
          legitgrailsCategories.assignAll(categories);
        }
      }
    } catch (e) {
      print("Error fetching legitgrails categories: $e");
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

  Future<void> pickVerificationImages() async {
    final List<XFile> result = await _picker.pickMultiImage(imageQuality: 80);
    if (result.isEmpty) return;
    for (final xFile in result) {
      if (verificationImages.length < 6) {
        verificationImages.add(File(xFile.path));
      }
    }
  }

  void removeVerificationImage(int index) {
    if (index >= 0 && index < verificationImages.length) {
      verificationImages.removeAt(index);
    }
  }

  Future<List<String>> _uploadImages(List<File> imagesList) async {
    final List<String> urls = [];
    final apiClient = ApiClient();
    for (final img in imagesList) {
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
          final filePath =
              data is Map ? (data['data']?['filePath'] as String?) : null;
          if (filePath != null && filePath.isNotEmpty) {
            // Keep the exact relative filePath returned by the API so that product creation payload is correct.
            urls.add(filePath);
          }
        }
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
    return urls;
  }

  Future<Map<String, dynamic>?> saveProduct({
    String status = "INACTIVE",
  }) async {
    isLoading.value = true;
    try {
      final apiClient = ApiClient();

      // Upload product main images first
      final List<String> imageUrls = await _uploadImages(pickedImages);

      double p = double.tryParse(price.value) ?? 0.0;
      double enteredDiscountPercentage = double.tryParse(discount.value) ?? 0.0;

      double discountedPrice = p;
      if (p > 0 &&
          enteredDiscountPercentage > 0 &&
          enteredDiscountPercentage <= 100) {
        discountedPrice = p - (p * (enteredDiscountPercentage / 100.0));
      }

      int categoryId = 1;
      int subCategoryId = 1;

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
        "name": name.value,
        "description": description.value,
        "original_price": p,
        "discounted_price": discountedPrice,
        "discount_percentage": enteredDiscountPercentage.round(),
        "image_urls": imageUrls,
        "categoryId": categoryId,
        "subCategoryId": subCategoryId,
        "condition": condition.value.toUpperCase(),
        "status": status,
      };

      final response = await apiClient.post(
        url: ApiUrl.createProduct,
        body: body,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (Get.isRegistered<HomeController>())
          Get.find<HomeController>().fetchHomeData();
        if (Get.isRegistered<SellController>())
          Get.find<SellController>().fetchProducts();
        if (Get.isRegistered<FavouriteController>())
          Get.find<FavouriteController>().fetchWishlist();

        if (response.body is Map && response.body['data'] != null) {
          return response.body['data'] as Map<String, dynamic>;
        }
        return {};
      } else {
        return null;
      }
    } catch (e) {
      print("Error creating product: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> submitVerification(int productId) async {
    isLoading.value = true;
    try {
      final apiClient = ApiClient();
      // Upload verification images
      final List<String> vImages = await _uploadImages(verificationImages);

      final List<Map<String, String>> photos = [];
      for (int i = 0; i < vImages.length; i++) {
        photos.add({
          "index_code": (i + 1).toString(),
          "url": vImages[i],
        });
      }

      final body = {
        "category_code": selectedLegitCategory.value,
        "brand_code": selectedBrand.value,
        "item": name.value,
        "photos": photos,
        "answer_time": 1440,
        "note": "First submission"
      };

      final response = await apiClient.post(
        url: ApiUrl.authenticationSubmitAPI(productId.toString()),
        body: body,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error submitting verification: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
