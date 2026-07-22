import 'dart:convert';
import 'package:get/get.dart';
import '../../../../../helper/local_db/local_db.dart';
import '../../../../../utils/assets_image/app_images.dart';
import '../../profile/model/user_model.dart';
import '../../../../../service/api_service.dart';
import '../../../../../service/api_url.dart';
import 'package:bestkits/data/model/product_model.dart';
import '../model/home_model.dart' hide UserData;
import '../model/recently_view_model.dart';

class HomeController extends GetxController {
  // User Data
  var userData = Rxn<UserData>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchUserProfile(); // Sync fresh profile on startup
    fetchHomeData();
    fetchRecentlyViewed();
  }

  void loadUserData() {
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

  Future<void> fetchUserProfile() async {
    try {
      final response = await _apiClient.get(
        url: ApiUrl.getProfile,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.body;
        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];
          userData.value = UserData.fromJson(data);
          await SharePrefsHelper.saveUserData(jsonEncode(data));
        }
      }
    } catch (e) {
      print("Error fetching profile in home: $e");
    }
  }

  // Data from Home API
  final RxList<CategoryData> categories = <CategoryData>[].obs;
  final RxList<ProductModel> trendingProducts = <ProductModel>[].obs;
  final RxList<ProductModel> promotedProducts = <ProductModel>[].obs;
  final RxList<ProductModel> newArrivals = <ProductModel>[].obs;
  final RxList<TrustCardData> trustCards = <TrustCardData>[].obs;

  final RxBool isLoadingHome = false.obs;
  final ApiClient _apiClient = ApiClient();

  Future<void> fetchHomeData() async {
    isLoadingHome.value = true;
    try {
      final response = await _apiClient.get(url: ApiUrl.home, isToken: false);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final homeModel = HomeModel.fromJson(response.body);
        if (homeModel.success == true && homeModel.data != null) {
          if (homeModel.data!.categories != null)
            categories.assignAll(homeModel.data!.categories!);
          if (homeModel.data!.trending != null)
            trendingProducts.assignAll(homeModel.data!.trending!);
          if (homeModel.data!.promoted != null)
            promotedProducts.assignAll(homeModel.data!.promoted!);
          if (homeModel.data!.newArrivals != null)
            newArrivals.assignAll(homeModel.data!.newArrivals!);
          if (homeModel.data!.trustCards != null)
            trustCards.assignAll(homeModel.data!.trustCards!);
        }
      }
    } catch (e) {
      print("Error fetching home data: $e");
    } finally {
      isLoadingHome.value = false;
    }
  }

  // Recently Viewed - populated from API
  final RxList<ProductModel> recentlyViewed = <ProductModel>[].obs;
  final RxBool isLoadingRecentlyViewed = false.obs;

  Future<void> fetchRecentlyViewed() async {
    isLoadingRecentlyViewed.value = true;
    try {
      final response = await _apiClient.get(
        url: ApiUrl.recentlyViewed,
        isToken: true, // Need token for recently viewed
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final recentlyViewModel = RecentlyViewModel.fromJson(response.body);
        if (recentlyViewModel.success == true &&
            recentlyViewModel.data != null) {
          recentlyViewed.assignAll(recentlyViewModel.data!);
        }
      }
    } catch (e) {
      print('Error fetching recently viewed: $e');
    } finally {
      isLoadingRecentlyViewed.value = false;
    }
  }
}
