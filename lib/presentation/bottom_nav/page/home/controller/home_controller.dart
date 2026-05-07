import 'package:get/get.dart';
import '../../../../../utils/assets_image/app_images.dart';

class HomeController extends GetxController {
  // Dummy Categories
  final List<Map<String, dynamic>> categories = [
    {
      'name': "Kid's Shorts",
      'image': AppImages.kidShorts,
      'items': '20+ items',
    },
    {
      'name': 'Kids Accessor...',
      'image': AppImages.kidAccessor,
      'items': '20+ items',
    },
    {
      'name': 'Kids Collection',
      'image': AppImages.kidsCollections,
      'items': '15+ items',
    },
  ].obs;

  // Dummy Trending Products
  final List<Map<String, dynamic>> trendingProducts = [
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
      'image': AppImages.kidsCottonSho, // Using available sho image
      'price': '18.00',
      'oldPrice': '21.99',
      'rating': '4.5/5.0',
      'material': 'Cotton Pull-On',
      'discount': '10%',
    },
  ].obs;

  // Dummy Recently Viewed
  final List<Map<String, dynamic>> recentlyViewed = [
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
      'price': '18.00',
      'oldPrice': '21.99',
      'rating': '4.5/5.0',
      'material': 'Cotton Pull-On',
      'discount': '15%',
    },
  ].obs;
}