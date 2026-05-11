import 'package:get/get.dart';
import '../../../widget/app_alert.dart';

class CurrencyPreferenceController extends GetxController {
  final List<Map<String, String>> currencies = [
    {'name': 'USD', 'symbol': '\$'},
    {'name': 'EUR', 'symbol': '€'},
    {'name': 'AED', 'symbol': 'د.إ'},
    {'name': 'GBP', 'symbol': '£'},
  ];

  final RxString selectedCurrency = 'USD'.obs;
  final String initialCurrency = 'USD';

  void selectCurrency(String currency) {
    selectedCurrency.value = currency;
  }

  bool get isChanged => selectedCurrency.value != initialCurrency;

  void switchCurrency() {
    AppAlerts.warning(
      title: 'Change Currency !',
      message: 'Are you sure you want to change your currency preference?',
      confirmLabel: 'Confirm',
      cancelLabel: 'Cancel',
      onConfirm: () {
        // Handle currency change logic here
        _performSwitch();
      },
    );
  }

  void _performSwitch() async {
    // Simulate API call or local storage update
    await Future.delayed(const Duration(milliseconds: 500));
    AppAlerts.success(message: 'Currency preference updated successfully');
    Get.back();
  }
}
