import 'package:get/get.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_alert.dart';
import '../../../service/api_service.dart';
import '../../../service/api_url.dart';
import '../../../helper/tost_message/show_snackbar.dart';

class CurrencyPreferenceController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final RxBool isLoading = false.obs;

  final List<Map<String, String>> currencies = [
    {'name': 'USD', 'symbol': '\$'},
    {'name': 'EUR', 'symbol': '€'},
    {'name': 'AED', 'symbol': 'د.إ'},
    {'name': 'GBP', 'symbol': '£'},
  ];

  final RxString selectedCurrency = 'USD'.obs;
  String initialCurrency = 'USD';

  void selectCurrency(String currency) {
    selectedCurrency.value = currency;
  }

  bool get isChanged => selectedCurrency.value != initialCurrency;

  void switchCurrency() {
    AppAlerts.warning(
      title: AppStrings.currencyAlertTitle.tr,
      message: AppStrings.currencyAlertSubtitle.tr,
      confirmLabel: AppStrings.confirm.tr,
      cancelLabel: AppStrings.cancel.tr,
      onConfirm: () {
        _performSwitch();
      },
    );
  }

  void _performSwitch() async {
    isLoading.value = true;
    final Map<String, dynamic> body = {"currency": selectedCurrency.value};

    final response = await _apiClient.patch(
      url: ApiUrl.currency,
      body: body,
      isToken: true,
    );

    isLoading.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      initialCurrency = selectedCurrency.value;
      Get.back();
      AppSnackBar.success(AppStrings.currencyUpdatedSuccess.tr);
    } else {
      AppSnackBar.fail("Failed to update currency preference");
    }
  }
}
