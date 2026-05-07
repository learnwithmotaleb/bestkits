import 'package:get/get.dart';
import '../../../../../../../utils/assets_image/app_images.dart';


class CategoriesController extends GetxController {
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Underwear & Socks',
      'image': AppImages.kidShorts,
      'itemsCount': '26+ Items',
      'subcategories': ['Slim Fit Jeans', 'Cotton Sun Dresses', 'Rash Guards', 'Polo Shirts', 'Knee High Stockings'],
    },
    {
      'name': 'Sleepwear & Swaddles',
      'image': AppImages.kidAccessor,
      'itemsCount': '26+ Items',
      'subcategories': ['Hooded Windbreakers', 'Silk Robes', 'Kimono Bodysuits', 'Gym Leggings', 'Denim Shorts'],
    },
    {
      'name': 'Leggings',
      'image': AppImages.kidsCottonSho,
      'itemsCount': '26+ Items',
      'subcategories': ['Slit Robes', 'Baseball Caps', 'Slim Fit Jeans', 'Ankle Socks', 'Corduroy Trousers'],
    },
    {
      'name': 'Pajama Sets',
      'image': AppImages.kidCottonShoStand,
      'itemsCount': '26+ Items',
      'subcategories': ['Costume Sets', 'Tutu Skirts', 'Thermal Pajamas', 'Hooded Windbreakers', 'Oversized Sleep Tees'],
    },
    {
      'name': 'Puffer Jackets',
      'image': AppImages.kidsCottonHoddieTshirt,
      'itemsCount': '26+ Items',
      'subcategories': ['Ankle Socks', 'Denim Cut-offs', 'Smocked Bodices', 'Oversized Sleep Tees', 'Fleece Jackets'],
    },
    {
      'name': 'Shorts & Skirts',
      'image': AppImages.kidsCollections,
      'itemsCount': '26+ Items',
      'subcategories': ['Silk Robes', 'Ankle Socks', 'One-Piece Swimsuits', 'Ankle Socks', 'Suspenders & Beanies'],
    },
  ];
}