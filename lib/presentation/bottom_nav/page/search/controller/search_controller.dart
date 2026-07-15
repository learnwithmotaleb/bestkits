import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/data/model/product_model.dart';
import 'package:bestkits/service/api_service.dart';
import 'package:bestkits/service/api_url.dart';
import '../../home/pages/categories/model/CategoryModel.dart';
import '../../../../../utils/static_strings/static_strings.dart';

class AppSearchController extends GetxController {
  final searchTextController = TextEditingController();
  final searchQuery = ''.obs;
  final isSearching = false.obs;
  final isLoading = false.obs;

  // Filter state
  final selectedCategory = ''.obs;
  final selectedSubcategory = ''.obs;
  final selectedSortBy = ''.obs;
  final priceRangeMin = 0.0.obs;
  final priceRangeMax = 500.0.obs;
  final selectedRating = AppStrings.anyRating.tr.obs;

  // Category text controllers for bottom sheet fields
  final categoryController = TextEditingController();
  final subcategoryController = TextEditingController();
  final sortByController = TextEditingController();

  // Dynamic filter data
  final RxList<Data> categoryData = <Data>[].obs;
  final RxList<String> categoryNames = <String>[].obs;
  final RxList<String> subcategoryNames = <String>[].obs;

  final List<String> sortByOptions = [
    AppStrings.newestFirst.tr,
    AppStrings.priceLowToHigh.tr,
    AppStrings.priceHighToLow.tr,
    AppStrings.popularItems.tr,
    AppStrings.inStockOnly.tr,
    AppStrings.discounted.tr,
    AppStrings.bestRated.tr,
  ];

  final List<String> ratingOptions = [
    AppStrings.anyRating.tr,
    '${AppStrings.upToRating.tr} ★1',
    '${AppStrings.upToRating.tr} ★2',
    '${AppStrings.upToRating.tr} ★3',
    '${AppStrings.upToRating.tr} ★4',
    '${AppStrings.onlyRating.tr} ★1',
  ];

  // Products from API
  final List<ProductModel> _allProducts = [];
  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProducts();

    debounce(searchQuery, (_) {
      isSearching.value = searchQuery.value.isNotEmpty;
      fetchProducts();
    }, time: const Duration(milliseconds: 500));

    searchTextController.addListener(() {
      searchQuery.value = searchTextController.text;
    });

    categoryController.addListener(() {
      _updateSubcategories();
    });
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
      print("Error fetching categories in search: \$e");
    }
  }

  void _updateSubcategories() {
    final selectedCatName = categoryController.text;
    final selectedCat =
        categoryData.firstWhereOrNull((c) => c.name == selectedCatName);

    subcategoryNames.clear();
    if (selectedCat != null && selectedCat.subCategories != null) {
      subcategoryNames.assignAll(selectedCat.subCategories!
          .map((s) => s.name ?? '')
          .where((n) => n.isNotEmpty)
          .toList());
    }
    // If the currently selected subcategory isn't in the new list, clear it
    if (!subcategoryNames.contains(subcategoryController.text)) {
      subcategoryController.clear();
    }
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      final apiClient = ApiClient();

      final queryParams = <String, String>{};
      queryParams['page'] = '1';
      queryParams['limit'] = '20';

      if (searchQuery.value.isNotEmpty) {
        queryParams['search'] = searchQuery.value;
      }

      // Find the ID for the selected category text
      if (selectedCategory.value.isNotEmpty) {
        final cat = categoryData
            .firstWhereOrNull((c) => c.name == selectedCategory.value);
        if (cat != null && cat.id != null) {
          queryParams['categoryId'] = cat.id.toString();
        }
      }

      // Find the ID for the selected subcategory text
      if (selectedSubcategory.value.isNotEmpty) {
        final cat = categoryData
            .firstWhereOrNull((c) => c.name == selectedCategory.value);
        if (cat != null && cat.subCategories != null) {
          final sub = cat.subCategories!
              .firstWhereOrNull((s) => s.name == selectedSubcategory.value);
          if (sub != null && sub.id != null) {
            queryParams['subCategoryId'] = sub.id.toString();
          }
        }
      }
      if (priceRangeMin.value > 0) {
        queryParams['minPrice'] = priceRangeMin.value.toInt().toString();
      }
      if (priceRangeMax.value < 500) {
        queryParams['maxPrice'] = priceRangeMax.value.toInt().toString();
      }

      if (selectedSortBy.value.isNotEmpty) {
        if (selectedSortBy.value == AppStrings.newestFirst.tr) {
          queryParams['sort'] = 'latest';
        } else if (selectedSortBy.value == AppStrings.priceLowToHigh.tr) {
          queryParams['sort'] = 'price_low';
        } else if (selectedSortBy.value == AppStrings.priceHighToLow.tr) {
          queryParams['sort'] = 'price_high';
        } else if (selectedSortBy.value == AppStrings.popularItems.tr) {
          queryParams['sort'] = 'popular';
        } else if (selectedSortBy.value == AppStrings.bestRated.tr) {
          queryParams['sort'] = 'rating';
        } else if (selectedSortBy.value == AppStrings.discounted.tr) {
          queryParams['discountedOnly'] = 'true';
        }
      }

      if (selectedRating.value != AppStrings.anyRating.tr) {
        if (selectedRating.value.contains('4'))
          queryParams['minRating'] = '4';
        else if (selectedRating.value.contains('3'))
          queryParams['minRating'] = '3';
        else if (selectedRating.value.contains('2'))
          queryParams['minRating'] = '2';
        else if (selectedRating.value.contains('1'))
          queryParams['minRating'] = '1';
      }

      final uri =
          Uri.parse(ApiUrl.getProducts).replace(queryParameters: queryParams);

      final response = await apiClient.get(url: uri.toString());
      if (response.statusCode == 200 &&
          response.body is Map &&
          response.body['data'] != null) {
        final List<dynamic> data = response.body['data'];
        final products = data
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
        filteredProducts.assignAll(products);
      }
    } catch (e) {
      print('Error fetching search products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilter() {
    selectedCategory.value = categoryController.text;
    selectedSubcategory.value = subcategoryController.text;
    selectedSortBy.value = sortByController.text;

    fetchProducts();
    Get.back();
  }

  void resetFilter() {
    categoryController.clear();
    subcategoryController.clear();
    sortByController.clear();
    selectedCategory.value = '';
    selectedSubcategory.value = '';
    selectedSortBy.value = '';
    priceRangeMin.value = 0;
    priceRangeMax.value = 500;
    selectedRating.value = AppStrings.anyRating.tr;

    fetchProducts();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    categoryController.dispose();
    subcategoryController.dispose();
    sortByController.dispose();
    super.onClose();
  }
}
