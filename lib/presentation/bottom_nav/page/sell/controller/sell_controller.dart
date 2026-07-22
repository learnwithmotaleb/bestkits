import 'package:get/get.dart';
import '../../../../../service/api_service.dart';
import '../../../../../service/api_url.dart';
import '../model/SellerMyModel.dart';
import '../page/update_product/screen/add_product.dart';

class SellController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final RxBool isActiveTab = true.obs;
  final RxBool isLoading = false.obs;

  final RxList<Data> activeProducts = <Data>[].obs;
  final RxList<Data> inactiveProducts = <Data>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void toggleTab(bool isActive) {
    isActiveTab.value = isActive;
  }

  void onAddProductTap() {
    Get.to(() => const AddProduct());
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _fetchActiveProducts(),
        _fetchInactiveProducts(),
      ]);
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchActiveProducts() async {
    final response = await _apiClient.get(
      url: '${ApiUrl.productSellerMe}?status=ACTIVE',
      isToken: true,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final model = SellerMyModel.fromJson(response.body);
      activeProducts.value = model.data ?? [];
    }
  }

  Future<void> _fetchInactiveProducts() async {
    final response = await _apiClient.get(
      url: '${ApiUrl.productSellerMe}?status=INACTIVE',
      isToken: true,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final model = SellerMyModel.fromJson(response.body);
      inactiveProducts.value = model.data ?? [];
    }
  }
}
