import 'package:get/get.dart';
import '../../../../../../../service/api_service.dart';
import '../../../../../../../service/api_url.dart';
import '../model/CategorieModel.dart';

class CategorieDetailsController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final Rx<Data?> category = Rx<Data?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  String categoryId = '';

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is Map) {
      categoryId = args['categoryId']?.toString() ?? '';
    } else if (args != null) {
      categoryId = args.toString();
    }

    fetchCategoryDetails();
  }

  Future<void> fetchCategoryDetails() async {
    if (categoryId.isEmpty) {
      hasError.value = true;
      return;
    }

    isLoading.value = true;
    hasError.value = false;
    try {
      final response =
          await _apiClient.get(url: ApiUrl.detailsCategory(categoryId));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = CategorieModel.fromJson(response.body);
        if (model.success == true && model.data != null) {
          category.value = model.data;
        } else {
          hasError.value = true;
        }
      } else {
        hasError.value = true;
      }
    } catch (e) {
      print("Error fetching category details: $e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
