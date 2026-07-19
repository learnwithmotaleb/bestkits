import 'package:get/get.dart';
import '../../../../utils/static_strings/static_strings.dart';
import '../../../../service/api_service.dart';
import '../../../../service/api_url.dart';
import '../../../../widget/show_snackbar.dart';
import '../model/delivery_option_model.dart';

class DeliveryOptionsController extends GetxController {
  final RxList<Map<String, dynamic>> deliveryOptions =
      <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDeliveryOptions();
  }

  Future<void> fetchDeliveryOptions() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(
        url: ApiUrl.deliveryGetAll,
        isToken: true,
      );

      final statusCode = response.statusCode ?? 500;
      if (statusCode == 200) {
        final deliveryModel = DeliveryOptionModel.fromJson(response.body);
        final data = deliveryModel.data?.data;

        if (data != null) {
          deliveryOptions.value = [
            {
              'id': '1',
              'type': AppStrings.domesticDelivery,
              'subtitle': AppStrings.insideCountry,
              'partner': data.domesticPartner ?? '',
              'cost': data.domesticCost?.toString() ?? '0.0',
              'time':
                  '${data.domesticDaysMin ?? 1}-${data.domesticDaysMax ?? 1} Business Days',
            },
            {
              'id': '2',
              'type': AppStrings.internationalDelivery,
              'subtitle': AppStrings.outsideCountry,
              'partner': data.internationalPartner ?? '',
              'cost': data.internationalCost?.toString() ?? '0.0',
              'time':
                  '${data.internationalDaysMin ?? 1}-${data.internationalDaysMax ?? 1} Business Days',
            },
          ];
        }
      } else {
        ShowAppSnackBar.fail('Failed to fetch delivery options');
      }
    } catch (e) {
      ShowAppSnackBar.fail('An error occurred while fetching delivery options');
    } finally {
      isLoading.value = false;
    }
  }

  var isUpdating = false.obs;
  final ApiClient _apiClient = ApiClient();

  Future<void> updateOption(String id, String partner, String cost,
      String minDaysStr, String maxDaysStr) async {
    isUpdating.value = true;
    try {
      final double parsedCost = double.tryParse(cost) ?? 0.0;
      final int minDays = int.tryParse(minDaysStr) ?? 1;
      final int maxDays = int.tryParse(maxDaysStr) ?? 1;

      String url = '';
      Map<String, dynamic> body = {};

      if (id == '1') {
        // Domestic
        url = ApiUrl.deliveryMeDomestic;
        body = {
          "domestic_partner": partner,
          "domestic_cost": parsedCost,
          "domestic_days_min": minDays,
          "domestic_days_max": maxDays,
        };
      } else if (id == '2') {
        // International
        url = ApiUrl.deliveryMeInternation;
        body = {
          "international_partner": partner,
          "international_cost": parsedCost,
          "international_days_min": minDays,
          "international_days_max": maxDays,
        };
      } else {
        isUpdating.value = false;
        return;
      }

      final response = await _apiClient.put(
        url: url,
        body: body,
        isToken: true,
      );

      final statusCode = response.statusCode ?? 500;
      if (statusCode == 200 || statusCode == 201) {
        // Update local state
        final index = deliveryOptions.indexWhere((opt) => opt['id'] == id);
        if (index != -1) {
          final updated = Map<String, dynamic>.from(deliveryOptions[index]);
          updated['partner'] = partner;
          updated['cost'] = cost;
          updated['time'] = '$minDays-$maxDays Business Days';
          deliveryOptions[index] = updated;
        }
        ShowAppSnackBar.success('Delivery option updated successfully');
      } else {
        ShowAppSnackBar.fail('Failed to update delivery option');
      }
    } catch (e) {
      ShowAppSnackBar.fail('An error occurred: $e');
    } finally {
      isUpdating.value = false;
    }
  }
}
