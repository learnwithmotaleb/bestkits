import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../service/api_service.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/static_strings/static_strings.dart';
import '../../../../../widget/app_alert.dart';

class AddDeliveryOptionController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  // ── Form Key ──────────────────────────────────────────────
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ── Controllers ──────────────────────────────────────────
  final TextEditingController domesticPartnerCtrl = TextEditingController();
  final TextEditingController domesticCostCtrl = TextEditingController();
  final TextEditingController domesticMinDaysCtrl = TextEditingController();
  final TextEditingController domesticMaxDaysCtrl = TextEditingController();

  final TextEditingController internationalPartnerCtrl =
      TextEditingController();
  final TextEditingController internationalCostCtrl = TextEditingController();
  final TextEditingController internationalMinDaysCtrl =
      TextEditingController();
  final TextEditingController internationalMaxDaysCtrl =
      TextEditingController();

  // ── Loading ───────────────────────────────────────────────
  final RxBool isLoading = false.obs;

  // ── Validators ────────────────────────────────────────────

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? validateCost(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Delivery cost is required';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed < 0) {
      return 'Enter a valid cost (e.g. 4.99)';
    }
    return null;
  }

  String? validateDays(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed < 1) {
      return 'Enter a valid number (min 1)';
    }
    return null;
  }

  String? validateMaxDays(String? value, String minValue, String label) {
    final error = validateDays(value, label);
    if (error != null) return error;
    final min = int.tryParse(minValue.trim()) ?? 0;
    final max = int.tryParse(value!.trim()) ?? 0;
    if (max < min) {
      return 'Max must be ≥ min days';
    }
    return null;
  }

  // ── Submit ────────────────────────────────────────────────

  Future<void> saveDeliveryOptions() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      // Build combined body
      final body = <String, dynamic>{
        "domestic_partner": domesticPartnerCtrl.text.trim(),
        "domestic_cost": double.parse(domesticCostCtrl.text.trim()),
        "domestic_days_min": int.parse(domesticMinDaysCtrl.text.trim()),
        "domestic_days_max": int.parse(domesticMaxDaysCtrl.text.trim()),
        "international_partner": internationalPartnerCtrl.text.trim(),
        "international_cost": double.parse(internationalCostCtrl.text.trim()),
        "international_days_min":
            int.parse(internationalMinDaysCtrl.text.trim()),
        "international_days_max":
            int.parse(internationalMaxDaysCtrl.text.trim()),
      };

      final response = await _apiClient.put(
        url: ApiUrl.addDeliveryOption,
        body: body,
        isToken: true,
      );

      final statusCode = response.statusCode ?? 500;
      if (statusCode == 200 || statusCode == 201) {
        AppAlerts.success(message: AppStrings.deliveryOptionSavedSuccess.tr);
        Future.delayed(const Duration(milliseconds: 1600), () {
          Get.back(result: true);
        });
      } else {
        final raw = response.body?['message'] ??
            response.statusText ??
            'Failed to save delivery options';
        final msg = raw is List ? raw.join(', ') : raw.toString();
        AppAlerts.error(message: msg);
      }
    } catch (e) {
      AppAlerts.error(message: 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    domesticPartnerCtrl.dispose();
    domesticCostCtrl.dispose();
    domesticMinDaysCtrl.dispose();
    domesticMaxDaysCtrl.dispose();
    internationalPartnerCtrl.dispose();
    internationalCostCtrl.dispose();
    internationalMinDaysCtrl.dispose();
    internationalMaxDaysCtrl.dispose();
    super.onClose();
  }
}