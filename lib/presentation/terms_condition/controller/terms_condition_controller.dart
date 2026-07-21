import 'package:get/get.dart';
import '../../../service/api_service.dart';
import '../../../service/api_url.dart';
import '../model/TermsConditionModel.dart';

class TermsConditionController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final RxBool isLoading = false.obs;
  final RxString termsText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTermsCondition();
  }

  Future<void> fetchTermsCondition() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.get(
        url: ApiUrl.legal('TERMS_AND_CONDITIONS'),
        isToken: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = TermsConditionModel.fromJson(response.body);
        // Terms content is plain text, wrap in <p> tags for HTML rendering
        final rawContent = model.data?.content ?? '';
        termsText.value = rawContent
            .split('\n')
            .map((line) => line.trim().isEmpty ? '<br>' : '<p>$line</p>')
            .join('');
      }
    } catch (e) {
      print('Error fetching terms and conditions: $e');
    } finally {
      isLoading.value = false;
    }
  }
}