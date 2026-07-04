import 'package:get/get.dart';
import '../../../../../../../service/api_service.dart';
import '../../../../../../../service/api_url.dart';
import '../model/CategoryModel.dart';

class CategoriesController extends GetxController {
  final RxList<Data> categories = <Data>[].obs;
  final RxBool isLoadingCategories = false.obs;
  final ApiClient _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    fetchCategoriesFromApi();
  }

  Future<void> fetchCategoriesFromApi() async {
    isLoadingCategories.value = true;
    try {
      final response = await _apiClient.get(url: ApiUrl.getCategories);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final categoryModel = CategoryModel.fromJson(response.body);
        if (categoryModel.success == true && categoryModel.data != null) {
          categories.assignAll(categoryModel.data!);
        }
      }
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      isLoadingCategories.value = false;
    }
  }
}