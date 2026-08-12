import 'package:get/get.dart';
import '../../../service/api_service.dart';
import '../../../service/api_url.dart';
import '../../../helper/tost_message/show_snackbar.dart';
import '../model/review_model.dart';

class ViewAllReviewController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  
  final RxBool isLoading = false.obs;
  final RxList<Data> reviews = <Data>[].obs;
  
  String productId = ''; 
  final RxInt totalReviews = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Assuming productId is passed via Get.arguments. E.g., Get.to(() => ViewAllReviewScreen(), arguments: '1')
    if (Get.arguments != null) {
      productId = Get.arguments.toString();
      fetchReviews(productId);
    }
  }

  Future<void> fetchReviews(String id) async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(
        url: ApiUrl.productReview(id),
      );

      if (response.statusCode == 200) {
        final reviewModel = ReviewModel.fromJson(response.body);
        if (reviewModel.success == true && reviewModel.data != null) {
          reviews.assignAll(reviewModel.data!);
          totalReviews.value = reviewModel.meta?.total ?? reviews.length;
        }
      } else {
        AppSnackBar.fail('Failed to load reviews', title: 'Error');
      }
    } catch (e) {
      AppSnackBar.fail(e.toString(), title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }
}