import 'package:get/get.dart';
import '../../../../../../../utils/assets_image/app_images.dart';
import '../../../../../../../utils/static_strings/static_strings.dart';

class CategoriesController extends GetxController {
  final List<Map<String, dynamic>> categories = [
    {
      'name': AppStrings.underwearAndSocks,
      'image': AppImages.kidShorts,
      'itemsCount': '26+',
      'subcategories': ['Slim Fit Jeans', 'Cotton Sun Dresses', 'Rash Guards', 'Polo Shirts', 'Knee High Stockings'],
    },
    {
      'name': AppStrings.sleepwearAndSwaddles,
      'image': AppImages.kidAccessor,
      'itemsCount': '26+',
      'subcategories': ['Hooded Windbreakers', 'Silk Robes', 'Kimono Bodysuits', 'Gym Leggings', 'Denim Shorts'],
    },
    {
      'name': AppStrings.leggings,
      'image': AppImages.kidsCottonSho,
      'itemsCount': '26+',
      'subcategories': ['Slit Robes', 'Baseball Caps', 'Slim Fit Jeans', 'Ankle Socks', 'Corduroy Trousers'],
    },
    {
      'name': AppStrings.pajamaSets,
      'image': AppImages.kidCottonShoStand,
      'itemsCount': '26+',
      'subcategories': ['Costume Sets', 'Tutu Skirts', 'Thermal Pajamas', 'Hooded Windbreakers', 'Oversized Sleep Tees'],
    },
    {
      'name': AppStrings.pufferJackets,
      'image': AppImages.kidsCottonHoddieTshirt,
      'itemsCount': '26+',
      'subcategories': ['Ankle Socks', 'Denim Cut-offs', 'Smocked Bodices', 'Oversized Sleep Tees', 'Fleece Jackets'],
    },
    {
      'name': AppStrings.shortsAndSkirts,
      'image': AppImages.kidsCollections,
      'itemsCount': '26+',
      'subcategories': ['Silk Robes', 'Ankle Socks', 'One-Piece Swimsuits', 'Ankle Socks', 'Suspenders & Beanies'],
    },
  ];
}