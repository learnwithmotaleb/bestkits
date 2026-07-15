import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bestkits/service/api_service.dart';
import 'package:bestkits/service/api_url.dart';
import 'package:bestkits/presentation/bottom_nav/page/home/pages/categories/model/CategoryModel.dart';

class AddProductController extends GetxController {
  final _picker = ImagePicker();
  final RxList<File> pickedImages = <File>[].obs;
  final RxBool isLoading = false.obs;

  // Form Data
  final RxString name = ''.obs;
  final RxString description = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxString selectedSubCategory = ''.obs;
  final RxList<String> selectedSizes = <String>[].obs;

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
          final filePath = data is Map ? (data['data']?['filePath'] as String?) : null;
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
    required double price,
    required double discountPrice,
    required String status,
  }) async {
    isLoading.value = true;
    try {
      final apiClient = ApiClient();
      
      // Upload images first
      final List<String> imageUrls = await _uploadImages();
      if (imageUrls.isEmpty) {
        // Fallback placeholder image URL as in the user's example
        imageUrls.add("https://example.com/images/iphone15pro-front.jpg");
      }

      // Compute discount percentage
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
        "name": name.value,
        "description": description.value,
        "original_price": price,
        "discounted_price": discountPrice,
        "discount_percentage": discountPercentage.round(),
        "image_urls": imageUrls,
        "categoryId": categoryId,
        "subCategoryId": subCategoryId,
        "condition": "NEW",
        "status": statusPayload,
        "variants": variants,
        "variant_names": variantNames
      };

      final response = await apiClient.post(
        url: ApiUrl.createProduct,
        body: body,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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
