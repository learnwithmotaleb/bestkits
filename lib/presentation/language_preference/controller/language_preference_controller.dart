import 'package:get/get.dart';
import '../../../global/language/controller/language_controller.dart';
import '../../../widget/app_alert.dart';

class LanguagePreferenceController extends GetxController {
  final LanguageController _lc = Get.find<LanguageController>();

  final RxString selectedLanguage = ''.obs;
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
      title: 'Change Language !',
      message: 'Are you sure you want to change your language preference?',
      confirmLabel: 'Confirm',
      cancelLabel: 'Cancel',
      onConfirm: () {
        _performSwitch();
      },
    );
  }

  void _performSwitch() async {
    await _lc.switchLanguage(selectedLanguage.value == 'en');
    initialLanguage = selectedLanguage.value;
    AppAlerts.success(message: 'Language preference updated successfully');
    Get.back();
  }
}