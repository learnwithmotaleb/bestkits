import 'package:get/get.dart';
import '../../../global/language/controller/language_controller.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_alert.dart';
import '../../../service/api_service.dart';
import '../../../service/api_url.dart';
import '../../../helper/tost_message/show_snackbar.dart';

class LanguagePreferenceController extends GetxController {
  final LanguageController _lc = Get.find<LanguageController>();
  final ApiClient _apiClient = ApiClient();

  final RxString selectedLanguage = ''.obs;
  final RxBool isLoading = false.obs;
  late String initialLanguage;

  @override
  void onInit() {
    super.onInit();
    selectedLanguage.value = _lc.isEnglish ? 'en' : 'bg';
    initialLanguage = selectedLanguage.value;
  }

  void selectLanguage(String lang) {
    selectedLanguage.value = lang;
  }

  bool get isChanged => selectedLanguage.value != initialLanguage;

  void switchLanguage() {
    AppAlerts.warning(
      title: AppStrings.languageAlertTitle.tr,
      message: AppStrings.languageAlertSubtitle.tr,
      confirmLabel: AppStrings.confirm.tr,
      cancelLabel: AppStrings.cancel.tr,
      onConfirm: () {
        _performSwitch();
      },
    );
  }

  void _performSwitch() async {
    isLoading.value = true;
    final Map<String, dynamic> body = {
      "language": selectedLanguage.value.toUpperCase() // 'EN' or 'BG'
    };

    final response = await _apiClient.patch(
      url: ApiUrl.language,
      body: body,
      isToken: true,
    );

    isLoading.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      await _lc.switchLanguage(selectedLanguage.value == 'en');
      initialLanguage = selectedLanguage.value;
      Get.back();
      AppSnackBar.success(AppStrings.languageUpdatedSuccess.tr);
    } else {
      AppSnackBar.fail("Failed to update language preference");
    }
  }
}
