import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/assets_image/app_images.dart';

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
  final selectedRating = 'Any Rating'.obs;

  // Category text controllers for bottom sheet fields
  final categoryController = TextEditingController();
  final subcategoryController = TextEditingController();
  final sortByController = TextEditingController();

  // Filter data
  final List<String> categories = [
    'Beanies & Hats',
    'Swimwear',
    'Pajama Sets',
    'Cardigans & Sweaters',
    'Denim & Jeans',
    'Leggings',
    'Underwear & Socks',
  ];

  final List<String> subcategories = [
    'Baseball Caps',
    'Trench Coats',
    'Flannel Shirts',
    'Knitted Beanies',
    'Gym Leggings',
    'One-Piece Swimsuits',
  ];

  final List<String> sortByOptions = [
    'Newest First',
    'Price: Low to High',
    'Price: High to Low',
    'Popular Items',
    'In Stock Only',
    'Discounted',
    'Best Rated',
  ];

  final List<String> ratingOptions = [
    'Any Rating',
    'Up to ★1',
    'Up to ★2',
    'Up to ★3',
    'Up to ★4',
    'Only ★1',
  ];

  // Dummy product data
  final List<Map<String, dynamic>> allProducts = [
    {
      'name': 'Kids Cotton Hoodie...',
      'image': AppImages.kidsCottonHoodie,
      'price': '18.00',
      'oldPrice': '21.99',
      'rating': '4.5/5.0',
      'material': 'Cotton Pull-On',
      'discount': '20%',
    },
    {
      'name': 'Kids Cotton Hoodie...',
      'image': AppImages.kidsCottonSho,
      'price': '18.00',
      'oldPrice': '21.99',
      'rating': '4.5/5.0',
      'material': 'Cotton Pull-On',
      'discount': '10%',
    },
    {
      'name': 'Kids Cotton Hoodie...',
      'image': AppImages.kidsCottonHoddieTshirt,
      'price': '18.00',
      'oldPrice': '21.99',
      'rating': '4.5/5.0',
      'material': 'Cotton Pull-On',
      'discount': '20%',
    },
    {
      'name': 'Kids Cotton Hoodie...',
      'image': AppImages.kidAccessor,
      'price': '38.00',
      'oldPrice': '45.99',
      'rating': '4.5/5.0',
      'material': 'Cotton Pull-On',
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
    selectedRating.value = 'Any Rating';
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