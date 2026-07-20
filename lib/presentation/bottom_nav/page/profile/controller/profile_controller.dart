import 'dart:convert';
import 'package:bestkits/core/routes/route_path.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:get/get.dart';
import '../../../../../widget/app_alert.dart';
import '../../../../../service/api_service.dart';
import '../../../../../service/api_url.dart';
import '../../../../../helper/local_db/local_db.dart';
import '../../home/controller/home_controller.dart';
import '../model/user_model.dart';

class ProfileController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  var isLoading = false.obs;
  var userData = Rxn<UserData>();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.get(
        url: ApiUrl.getProfile,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.body;
        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];
          userData.value = UserData.fromJson(data);

          // Save to Local DB for other screens to use
          await SharePrefsHelper.saveUserData(jsonEncode(data));

          // Notify HomeController to reload data if registered
          if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().loadUserData();
          }
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    AppAlerts.warning(
      title: AppStrings.logoutTitle.tr,
      message: AppStrings.logoutConfirmSubtitle.tr,
      confirmLabel: AppStrings.logoutButton.tr,
      cancelLabel: AppStrings.cancel.tr,
      onConfirm: () {
        // Implement actual logout logic here
        _performLogout();
      },
    );
  }

  void _performLogout() async {
    // Clear all session data, token, user info etc.
    await SharePrefsHelper.clearAll();

    // Navigate to login screen
    Get.offAllNamed(RoutePath.login);
  }
}
