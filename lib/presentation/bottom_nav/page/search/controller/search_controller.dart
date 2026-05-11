import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/assets_image/app_images.dart';
import '../../../../../utils/static_strings/static_strings.dart';

class AppSearchController extends GetxController {
  final searchTextController = TextEditingController();
  final searchQuery = ''.obs;
  final isSearching = false.obs;

  // Filter state
  final selectedCategory = ''.obs;
  final selectedSubcategory = ''.obs;
  final selectedSortBy = ''.obs;
  final priceRangeMin = 0.0.obs;
  final priceRangeMax = 100.0.obs;
  final selectedRating = AppStrings.anyRating.tr.obs;

  // Category text controllers for bottom sheet fields
  final categoryController = TextEditingController();
  final subcategoryController = TextEditingController();
  final sortByController = TextEditingController();

  // Filter data
  final List<String> categories = [
    AppStrings.beaniesHats.tr,
    AppStrings.swimwear.tr,
    AppStrings.pajamaSets.tr,
    AppStrings.cardigansSweaters.tr,
    AppStrings.denimJeans.tr,
    AppStrings.leggings.tr,
    AppStrings.underwearSocks.tr,
  ];

  final List<String> subcategories = [
    AppStrings.baseballCaps.tr,
    AppStrings.trenchCoats.tr,
    AppStrings.flannelShirts.tr,
    AppStrings.knittedBeanies.tr,
    AppStrings.gymLeggings.tr,
    AppStrings.onePieceSwimsuits.tr,
  ];

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

  // Dummy product data
  final List<Map<String, dynamic>> allProducts = [
    {
      'name': AppStrings.dummySearchProductName.tr,
      'image': AppImages.kidsCottonHoodie,
      'price': '18.00',
      'oldPrice': '21.99',
      'rating': '4.5/5.0',
      'material': AppStrings.dummyMaterial.tr,
      'discount': '20%',
    },
    {
      'name': AppStrings.dummySearchProductName.tr,
      'image': AppImages.kidsCottonSho,
      'price': '18.00',
      'oldPrice': '21.99',
      'rating': '4.5/5.0',
      'material': AppStrings.dummyMaterial.tr,
      'discount': '10%',
    },
    {
      'name': AppStrings.dummySearchProductName.tr,
      'image': AppImages.kidsCottonHoddieTshirt,
      'price': '18.00',
      'oldPrice': '21.99',
      'rating': '4.5/5.0',
      'material': AppStrings.dummyMaterial.tr,
      'discount': '20%',
    },
    {
      'name': AppStrings.dummySearchProductName.tr,
      'image': AppImages.kidAccessor,
      'price': '38.00',
      'oldPrice': '45.99',
      'rating': '4.5/5.0',
      'material': AppStrings.dummyMaterial.tr,
      'discount': '15%',
    },
  ];

  final filteredProducts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredProducts.assignAll(allProducts);

    searchTextController.addListener(() {
      searchQuery.value = searchTextController.text;
      _filterProducts();
    });
  }

  void _filterProducts() {
    if (searchQuery.value.isEmpty) {
      filteredProducts.assignAll(allProducts);
    } else {
      filteredProducts.assignAll(
        allProducts.where((p) =>
          p['name'].toString().toLowerCase().contains(searchQuery.value.toLowerCase())
        ).toList(),
      );
    }
    isSearching.value = searchQuery.value.isNotEmpty;
  }

  void applyFilter() {
    selectedCategory.value = categoryController.text;
    selectedSubcategory.value = subcategoryController.text;
    selectedSortBy.value = sortByController.text;
    // In a real app, filter the products based on selections
    filteredProducts.assignAll(allProducts);
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
    priceRangeMax.value = 100;
    selectedRating.value = AppStrings.anyRating.tr;
    filteredProducts.assignAll(allProducts);
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