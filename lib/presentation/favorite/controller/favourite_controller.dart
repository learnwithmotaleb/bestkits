import 'package:get/get.dart';
import '../../../../widget/show_snackbar.dart';
import '../../bottom_nav/page/home/pages/categories/model/CategoryModel.dart';

class FavouriteController extends GetxController {
  // Keep list of favorited products (as Map<String, dynamic>)
  final RxList<Map<String, dynamic>> favoriteList = <Map<String, dynamic>>[].obs;
  
  // Keep list of favorited categories
  final RxList<Data> favoriteCategories = <Data>[].obs;

  final RxBool isLoading = false.obs;

  // ── Product Favorites ──
  bool isFavorite(Map<String, dynamic> product) {
    return favoriteList.any((item) =>
        item['name'] == product['name'] && item['image'] == product['image']);
  }

  void toggleFavorite(Map<String, dynamic> product) {
    final name = product['name'] ?? '';
    if (isFavorite(product)) {
      favoriteList.removeWhere((item) =>
          item['name'] == product['name'] && item['image'] == product['image']);
      ShowAppSnackBar.info("Removed from favorites", title: name.toString().tr);
    } else {
      favoriteList.add(product);
      ShowAppSnackBar.success("Added to favorites", title: name.toString().tr);
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
      ShowAppSnackBar.info("Removed category from favorites", title: name.toString().tr);
    } else {
      favoriteCategories.add(category);
      ShowAppSnackBar.success("Added category to favorites", title: name.toString().tr);
    }
  }
}