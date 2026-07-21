import 'package:get/get.dart';
import '../../../../utils/static_strings/static_strings.dart';
import '../../../../service/api_service.dart';
import '../../../../service/api_url.dart';
import '../model/ErningModel.dart';

class EarningController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  
  final RxString selectedFilter = AppStrings.last24Hours.obs;
  final RxBool isLoading = false.obs;
  
  final Rx<ErningModel?> earningModel = Rx<ErningModel?>(null);

  final List<String> filterOptions = [
    AppStrings.allText,
    AppStrings.last24Hours,
    AppStrings.lastWeek,
    AppStrings.lastFortnight,
    AppStrings.lastMonth,
    AppStrings.lastYear,
  ];

  @override
  void onInit() {
    super.onInit();
    fetchEarnings();
  }

  String _getPeriod(String filter) {
    if (filter == AppStrings.last24Hours) return 'LAST_24_HOURS';
    if (filter == AppStrings.lastWeek) return 'LAST_WEEK';
    if (filter == AppStrings.lastFortnight) return 'LAST_FORTNIGHT';
    if (filter == AppStrings.lastMonth) return 'LAST_MONTH';
    if (filter == AppStrings.lastYear) return 'LAST_YEAR';
    return 'ALL';
  }

  Future<void> fetchEarnings() async {
    try {
      isLoading.value = true;
      final period = _getPeriod(selectedFilter.value);
      final response = await _apiClient.get(
        url: '${ApiUrl.sellerEarning}?period=$period&page=1&limit=100',
        isToken: true, // Requires user token
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        earningModel.value = ErningModel.fromJson(response.body);
      }
    } catch (e) {
      print('Error fetching earnings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String get totalEarnings {
    final earnings = earningModel.value?.data?.earnings ?? 0;
    return earnings.toStringAsFixed(0);
  }
  
  List<PaymentHistory> get paymentHistoryList {
    return earningModel.value?.data?.paymentHistory ?? [];
  }

  String get filterTextForDisplay {
    if (selectedFilter.value == AppStrings.last24Hours) return AppStrings.earningsForToday.tr;
    if (selectedFilter.value == AppStrings.allText) return AppStrings.allEarnings.tr;
    return '${AppStrings.earningsFor.tr} ${selectedFilter.value.tr}';
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    fetchEarnings(); // Fetch again when filter changes
  }
}
