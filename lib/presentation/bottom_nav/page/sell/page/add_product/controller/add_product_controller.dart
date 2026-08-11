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
  final RxList<String> brandNames = <String>[
    'Nike',
    'Adidas',
    'Puma',
    'Gucci',
    'Prada',
    'Louis Vuitton',
    'Rolex',
    'Other'
  ].obs;

  final RxList<Data> categoryData = <Data>[].obs;
  final RxList<String> categoryNames = <String>[].obs;
  final RxList<String> subCategoryNames = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
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
          final filePath =
              data is Map ? (data['data']?['filePath'] as String?) : null;
          if (filePath != null && filePath.isNotEmpty) {
            urls.add(ApiUrl.buildImageUrl(filePath));
          }
        }
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
    return urls;
  }

  Future<String?> saveProduct({
    String status = "INACTIVE",
  }) async {
    isLoading.value = true;
    try {
      final apiClient = ApiClient();

      // Upload images first
      final List<String> imageUrls = await _uploadImages();

      double p = double.tryParse(price.value) ?? 0.0;
      double enteredDiscountPercentage = double.tryParse(discount.value) ?? 0.0;

      // Calculate discounted price from the percentage entered
      double discountedPrice = p;
      if (p > 0 &&
          enteredDiscountPercentage > 0 &&
          enteredDiscountPercentage <= 100) {
        discountedPrice = p - (p * (enteredDiscountPercentage / 100.0));
      }

      // Resolve category & subcategory IDs
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

      String statusPayload = "ACTIVE";
      if (status.toLowerCase().contains("inactive")) {
        statusPayload = "INACTIVE";
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
        "status": statusPayload,
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
        return null; // success
      } else {
        final resBody = response.body;
        if (resBody is Map && resBody.containsKey('message')) {
          return resBody['message'].toString();
        }
        return "Failed to publish product. Status code: ${response.statusCode}";
      }
    } catch (e) {
      print("Error creating product: $e");
      return "Something went wrong: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
