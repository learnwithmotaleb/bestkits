import 'package:get/get.dart';
import '../../../../../utils/assets_image/app_images.dart';
import '../../../../../utils/static_strings/static_strings.dart';

class HomeController extends GetxController {
  // Dummy Categories
  final List<Map<String, dynamic>> categories = [
    {
      'name': AppStrings.kidsShorts,
      'image': AppImages.kidShorts,
      'items': '20+',
    },
    {
      'name': AppStrings.kidsAccessories,
      'image': AppImages.kidAccessor,
      'items': '20+',
    },
    {
      'name': AppStrings.kidsCollection,
      'image': AppImages.kidsCollections,
      'items': '15+',
    },
  ].obs;

  // Dummy Trending Products
  final List<Map<String, dynamic>> trendingProducts = [
    {
      'name': AppStrings.dummyProductName,
      'image': AppImages.kidsCottonHoodie,
      'price': '18.00',
      'oldPrice': '21.99',
      'rating': '4.5/5.0',
      'material': AppStrings.cottonPullOn,
      'discount': '20%',
    },
    {
      'name': AppStrings.dummyProductName,
      'image': AppImages.kidsCottonSho, // Using available sho image
      'price': '18.00',
      'oldPrice': '21.99',
      'rating': '4.5/5.0',
      'material': AppStrings.cottonPullOn,
      'discount': '10%',
    },
  ].obs;

  // Dummy Recently Viewed
  final List<Map<String, dynamic>> recentlyViewed = [
    {
      'name': AppStrings.dummyProductName,
      'image': AppImages.kidsCottonHoddieTshirt,
      'price': '18.00',
      'oldPrice': '21.99',
      'rating': '4.5/5.0',
      'material': AppStrings.cottonPullOn,
      'discount': '20%',
    },
    {
      'name': AppStrings.dummyProductName,
      'image': AppImages.kidAccessor,
      'price': '18.00',
      'oldPrice': '21.99',
      'rating': '4.5/5.0',
      'material': AppStrings.cottonPullOn,
      'discount': '15%',
    },
  ].obs;
}