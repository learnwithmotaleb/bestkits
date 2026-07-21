import 'package:get/get.dart';
import '../../../service/api_service.dart';
import '../../../service/api_url.dart';
import '../model/PrivacyPolicyModel.dart';

class PrivacyPolicyController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final RxBool isLoading = false.obs;
  final RxString policyText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.get(
        url: ApiUrl.legal('PRIVACY_POLICY'),
        isToken: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = PrivacyPolicyModel.fromJson(response.body);
        policyText.value = model.data?.content ?? '';
      }
    } catch (e) {
      print('Error fetching privacy policy: $e');
    } finally {
      isLoading.value = false;
    }
  }
}