import 'package:get/get.dart';
import '../../../../../utils/assets_image/app_images.dart';
import '../../../../../utils/static_strings/static_strings.dart';

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

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
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