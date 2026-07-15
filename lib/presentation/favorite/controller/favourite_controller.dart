import 'package:get/get.dart';
import '../../../../widget/show_snackbar.dart';
import '../../bottom_nav/page/home/pages/categories/model/CategoryModel.dart';
import 'package:bestkits/data/model/product_model.dart';

class FavouriteController extends GetxController {
  // Keep list of favorited products (as ProductModel)
  final RxList<ProductModel> favoriteList = <ProductModel>[].obs;

  // Keep list of favorited categories
  final RxList<Data> favoriteCategories = <Data>[].obs;

  final RxBool isLoading = false.obs;

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

  void toggleFavoriteProduct(ProductModel product) {
    if (isFavoriteById(product.id)) {
      favoriteList.removeWhere((item) => item.id == product.id);
      ShowAppSnackBar.info("Removed from favorites", title: product.name);
    } else {
      favoriteList.add(product);
      ShowAppSnackBar.success("Added to favorites", title: product.name);
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