import 'package:get/get.dart';
import '../../../../utils/assets_image/app_images.dart';
import '../../../../utils/static_strings/static_strings.dart';

class EarningController extends GetxController {
  final RxString selectedFilter = AppStrings.last24Hours.obs;

  final List<String> filterOptions = [
    AppStrings.allText,
    AppStrings.last24Hours,
    AppStrings.lastWeek,
    AppStrings.lastFortnight,
    AppStrings.lastMonth,
    AppStrings.lastYear,
  ];

  final RxList<Map<String, dynamic>> paymentHistory = <Map<String, dynamic>>[
    {
      'name': 'Emily Carter',
      'date': 'Feb 9, 2026 • 8:30 PM',
      'amount': '32',
      'image': AppImages.profileImage,
      'filter': AppStrings.last24Hours
    },
    {
      'name': 'John Miller',
      'date': 'Feb 9, 2026 • 8:30 PM',
      'amount': '28',
      'image': AppImages.profileImage,
      'filter': AppStrings.last24Hours
    },
    {
      'name': 'Thomas Baker',
      'date': 'Feb 9, 2026 • 8:30 PM',
      'amount': '12',
      'image': AppImages.profileImage,
      'filter': AppStrings.last24Hours
    },
    {
      'name': 'Chris Brown',
      'date': 'Feb 9, 2026 • 8:30 PM',
      'amount': '13',
      'image': AppImages.profileImage,
      'filter': AppStrings.lastWeek
    },
    {
      'name': 'Robert Davis',
      'date': 'Feb 9, 2026 • 8:30 PM',
      'amount': '5',
      'image': AppImages.profileImage,
      'filter': AppStrings.lastWeek
    },
  ].obs;

  List<Map<String, dynamic>> get filteredHistory {
    if (selectedFilter.value == AppStrings.allText) {
      return paymentHistory.toList();
    }
    // Simple mock logic: match the 'filter' field exactly to the selected filter.
    // Real logic would filter by date.
    return paymentHistory
        .where((item) => item['filter'] == selectedFilter.value)
        .toList();
  }

  String get totalEarnings {
    if (filteredHistory.isEmpty) return '00';
    double total = 0;
    for (var item in filteredHistory) {
      total += double.tryParse(item['amount'].toString()) ?? 0;
    }
    return total.toStringAsFixed(0); // e.g. "00" or "90"
  }

  String get filterTextForDisplay {
    if (selectedFilter.value == AppStrings.last24Hours) return AppStrings.earningsForToday.tr;
    if (selectedFilter.value == AppStrings.allText) return AppStrings.allEarnings.tr;
    return '${AppStrings.earningsFor.tr} ${selectedFilter.value.tr}';
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
