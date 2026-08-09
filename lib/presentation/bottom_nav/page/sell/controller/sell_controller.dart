import 'package:get/get.dart';
import '../../../../../service/api_service.dart';
import '../../../../../service/api_url.dart';
import '../model/SellerMyModel.dart';
import '../page/update_product/screen/add_product.dart';

/// Status strings expected from backend
class ProductStatus {
  static const String underReview = 'UNDER_REVIEW';
  static const String live = 'ACTIVE';
  static const String actionRequired = 'ACTION_REQUIRED';
  static const String rejected = 'REJECTED';
  static const String sold = 'SOLD';
  static const String inactive = 'INACTIVE';
}

/// Tab model for sell screen tab bar
class SellTab {
  final String label;
  final String status;

  const SellTab({required this.label, required this.status});
}

class SellController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  // ── Tab Selection ──────────────────────────────────────────────────────────
  final RxInt selectedTabIndex = 0.obs;

  final List<SellTab> tabs = const [
    SellTab(label: 'Under Review', status: ProductStatus.underReview),
    SellTab(label: 'Live', status: ProductStatus.live),
    SellTab(label: 'Action Required', status: ProductStatus.actionRequired),
    SellTab(label: 'Rejected', status: ProductStatus.rejected),
    SellTab(label: 'Sold', status: ProductStatus.sold),
    SellTab(label: 'Inactive', status: ProductStatus.inactive),
  ];

  // ── Loading ─────────────────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;

  // ── Per-status Product Lists ────────────────────────────────────────────────
  final RxList<Data> underReviewProducts = <Data>[].obs;
  final RxList<Data> liveProducts = <Data>[].obs;
  final RxList<Data> actionRequiredProducts = <Data>[].obs;
  final RxList<Data> rejectedProducts = <Data>[].obs;
  final RxList<Data> soldProducts = <Data>[].obs;
  final RxList<Data> inactiveProducts = <Data>[].obs;

  // Legacy compat — points to liveProducts
  RxList<Data> get activeProducts => liveProducts;

  // ── Current visible list based on selected tab ──────────────────────────────
  RxList<Data> get currentList {
    switch (selectedTabIndex.value) {
      case 0:
        return underReviewProducts;
      case 1:
        return liveProducts;
      case 2:
        return actionRequiredProducts;
      case 3:
        return rejectedProducts;
      case 4:
        return soldProducts;
      case 5:
        return inactiveProducts;
      default:
        return liveProducts;
    }
  }

  String get currentStatus => tabs[selectedTabIndex.value].status;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  // Legacy — kept for compatibility
  void toggleTab(bool isActive) {
    selectedTabIndex.value = isActive ? 1 : 5;
  }

  void onAddProductTap() {
    Get.to(() => const AddProduct());
  }

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (!isRefresh) isLoading.value = true;
    try {
      await Future.wait([
        _fetchByStatus(ProductStatus.underReview, underReviewProducts),
        _fetchByStatus(ProductStatus.live, liveProducts),
        _fetchByStatus(ProductStatus.actionRequired, actionRequiredProducts),
        _fetchByStatus(ProductStatus.rejected, rejectedProducts),
        _fetchByStatus(ProductStatus.sold, soldProducts),
        _fetchByStatus(ProductStatus.inactive, inactiveProducts),
      ]);
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      if (!isRefresh) isLoading.value = false;
    }
  }

  Future<void> _fetchByStatus(
      String status, RxList<Data> targetList) async {
    try {
      final response = await _apiClient.get(
        url: '${ApiUrl.productSellerMe}?status=$status',
        isToken: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = SellerMyModel.fromJson(response.body);
        targetList.value = model.data ?? [];
      }
    } catch (e) {
      print('Error fetching $status products: $e');
    }
  }
}
