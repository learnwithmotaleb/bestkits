import 'package:get/get.dart';
import '../../../../widget/show_snackbar.dart';
import '../../bottom_nav/page/home/pages/categories/model/CategoryModel.dart';
import 'package:bestkits/data/model/product_model.dart';
import '../../../../service/api_service.dart';
import '../../../../service/api_url.dart';
import '../model/favourite_model.dart';

class FavouriteController extends GetxController {
  // Keep list of favorited products (as ProductModel)
  final RxList<ProductModel> favoriteList = <ProductModel>[].obs;

  // Keep list of favorited categories
  final RxList<Data> favoriteCategories = <Data>[].obs;

  final RxBool isLoading = false.obs;
  final ApiClient _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(
        url: ApiUrl.getWishlist,
        isToken: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final wishlistResponse = WishlistResponseModel.fromJson(response.body);
        if (wishlistResponse.success) {
          final List<ProductModel> products =
              wishlistResponse.data.map((item) => item.product).toList();
          favoriteList.assignAll(products);
        }
      } else {
        ShowAppSnackBar.error("Failed to load favorites");
      }
    } catch (e) {
      print("Error fetching wishlist: $e");
      ShowAppSnackBar.error("Error loading favorites");
    } finally {
      isLoading.value = false;
    }
  }

  // ── Product Favorites (by ProductModel) ──
  bool isFavoriteById(int productId) {
    return favoriteList.any((item) => item.id == productId);
  }

  /// Legacy: check if a product (still a Map, from old code) is favorited.
  bool isFavorite(Map<String, dynamic> product) {
    final id = product['id'];
    if (id == null) return false;
    return favoriteList.any((item) => item.id == id);
  }

  Future<void> toggleFavoriteProduct(ProductModel product) async {
    final productIdStr = product.id.toString();
    final wasFavorite = isFavoriteById(product.id);

    // Optimistic UI update
    if (wasFavorite) {
      favoriteList.removeWhere((item) => item.id == product.id);
    } else {
      favoriteList.add(product);
    }

    try {
      if (wasFavorite) {
        final response = await _apiClient.delete(
          url: ApiUrl.removeWishlist(productIdStr),
          isToken: true,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          ShowAppSnackBar.info("Removed from favorites", title: product.name);
        } else {
          // Revert
          favoriteList.add(product);
          ShowAppSnackBar.error("Failed to remove from favorites", title: product.name);
        }
      } else {
        final response = await _apiClient.post(
          url: ApiUrl.saveWishlist(productIdStr),
          isToken: true,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          ShowAppSnackBar.success("Added to favorites", title: product.name);
        } else {
          // Revert
          favoriteList.removeWhere((item) => item.id == product.id);
          ShowAppSnackBar.error("Failed to add to favorites", title: product.name);
        }
      }
    } catch (e) {
      // Revert on exception
      if (wasFavorite) {
        favoriteList.add(product);
      } else {
        favoriteList.removeWhere((item) => item.id == product.id);
      }
      print("Error toggling favorite: $e");
      ShowAppSnackBar.error("Connection error. Try again.", title: product.name);
    }
  }

  /// Legacy: toggle favorite using a raw Map (for backward compatibility).
  void toggleFavorite(Map<String, dynamic> product) {
    final id = product['id'];
    if (id == null) return;
    if (isFavorite(product)) {
      favoriteList.removeWhere((item) => item.id == id);
      ShowAppSnackBar.info("Removed from favorites",
          title: (product['name'] ?? '').toString());
    } else {
      // Convert raw map to a minimal ProductModel if needed
      ShowAppSnackBar.info("Use ProductModel for favorites",
          title: "Please update calling code");
    }
  }

  // ── Category Favorites ──
  bool isCategoryFavorite(Data category) {
    return favoriteCategories.any((item) => item.id == category.id);
  }

  void toggleCategoryFavorite(Data category) {
    final name = category.name ?? '';
    if (isCategoryFavorite(category)) {
      favoriteCategories.removeWhere((item) => item.id == category.id);
      ShowAppSnackBar.info("Removed category from favorites",
          title: name.toString().tr);
    } else {
      favoriteCategories.add(category);
      ShowAppSnackBar.success("Added category to favorites",
          title: name.toString().tr);
    }
  }
}