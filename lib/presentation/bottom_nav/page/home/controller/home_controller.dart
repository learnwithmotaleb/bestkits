import 'dart:convert';
import 'package:get/get.dart';
import '../../../../../helper/local_db/local_db.dart';
import '../../../../../utils/assets_image/app_images.dart';
import '../../profile/model/user_model.dart';
import '../../../../../service/api_service.dart';
import '../../../../../service/api_url.dart';
import '../pages/categories/model/CategoryModel.dart';
import 'package:bestkits/data/model/product_model.dart';

class BannerModel {
  final String tag;
  final String title;
  final String titleHighlight;
  final String subtitle;
  final String description;
  final String? image;
  final String? badgeColor;

  const BannerModel({
    required this.tag,
    required this.title,
    required this.titleHighlight,
    required this.subtitle,
    required this.description,
    this.image,
    this.badgeColor,
  });
}

class HomeController extends GetxController {
  // Banners from server
  final RxList<BannerModel> banners = <BannerModel>[].obs;
  final RxBool isLoadingBanners = false.obs;

  // User Data
  var userData = Rxn<UserData>();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    fetchBanners();
    fetchCategoriesFromApi();
    fetchProducts();
  }

  void _loadUserData() {
    final userDataJson = SharePrefsHelper.getUserData();
    if (userDataJson != null && userDataJson.isNotEmpty) {
      try {
        final Map<String, dynamic> data = jsonDecode(userDataJson);
        userData.value = UserData.fromJson(data);
      } catch (e) {
        print("Error parsing cached user data in home: $e");
      }
    }
  }

  Future<void> fetchBanners() async {
    isLoadingBanners.value = true;
    try {
      // Simulate network request
      await Future.delayed(const Duration(milliseconds: 1500));
      
      banners.value = [
        const BannerModel(
          tag: 'Kids Sneakers',
          title: 'Get ',
          titleHighlight: '5% OFF',
          subtitle: 'Use Code: KIDS20',
          description: 'Valid for all Kids Sneakers products from May 20, 2026 – May 31, 2026. Limited to the first 100 uses only. Apply the coupon code at checkout and enjoy exclusive savings on selected styles.',
          image: AppImages.kidsCollections,
          badgeColor: 'yellow',
        ),
        const BannerModel(
          tag: 'Kids Clothing',
          title: 'Flat ',
          titleHighlight: '€15 OFF',
          subtitle: 'Use Code: KIDS20',
          description: 'Enjoy an instant €15 discount on all Kids Clothing items. Offer valid from June 01, 2026 – June 15, 2026 with unlimited coupon usage during the campaign period.',
          image: AppImages.kidsCollections,
          badgeColor: 'yellow',
        ),
        const BannerModel(
          tag: 'Buy & Sell Kids Fashion',
          title: 'Trusted Marketplace ',
          titleHighlight: 'For Kids Fashion',
          subtitle: '',
          description: '"Discover quality pre-loved and new kids\' fashion from trusted sellers across Europe. BestKid makes buying and selling simple, secure, and family-friendly — all in one place."',
          image: null,
          badgeColor: 'green',
        ),
      ];
    } catch (e) {
      banners.clear();
    } finally {
      isLoadingBanners.value = false;
    }
  }
  // Categories from server
  final RxList<Data> categories = <Data>[].obs;
  final RxBool isLoadingCategories = false.obs;
  final ApiClient _apiClient = ApiClient();

  Future<void> fetchCategoriesFromApi() async {
    isLoadingCategories.value = true;
    try {
      final response = await _apiClient.get(url: ApiUrl.getCategories);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final categoryModel = CategoryModel.fromJson(response.body);
        if (categoryModel.success == true && categoryModel.data != null) {
          categories.assignAll(categoryModel.data!);
        }
      }
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      isLoadingCategories.value = false;
    }
  }
  // Trending Products fetched from API
  final RxList<ProductModel> trendingProducts = <ProductModel>[].obs;

  // Recently Viewed - populated from API (same products list for now)
  final RxList<ProductModel> recentlyViewed = <ProductModel>[].obs;

  // Fetch products from API
  Future<void> fetchProducts() async {
    try {
      final response = await _apiClient.get(url: ApiUrl.getProducts);
      if (response.statusCode == 200 &&
          response.body is Map &&
          response.body['data'] != null) {
        final List<dynamic> data = response.body['data'];
        final products = data
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
        trendingProducts.assignAll(products);
        // Use same products for recently viewed (sliced for variety)
        recentlyViewed.assignAll(
            products.length > 4 ? products.sublist(products.length - 4) : products);
      } else {
        print('Failed to fetch products: \${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: \$e');
    }
  }
}