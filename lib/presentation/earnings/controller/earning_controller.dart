import 'package:get/get.dart';
import '../../../../utils/assets_image/app_images.dart';

class EarningController extends GetxController {
  final RxString selectedFilter = 'Last 24 Hours'.obs;

  final List<String> filterOptions = [
    'All',
    'Last 24 Hours',
    'Last Week',
    'Last Fortnight',
    'Last Month',
    'Last Year',
  ];

  final RxList<Map<String, dynamic>> paymentHistory = <Map<String, dynamic>>[
    {
      'name': 'Emily Carter',
      'date': 'Feb 9, 2026 • 8:30 PM',
      'amount': '32',
      'image': AppImages.profileImage,
      'filter': 'Last 24 Hours'
    },
    {
      'name': 'John Miller',
      'date': 'Feb 9, 2026 • 8:30 PM',
      'amount': '28',
      'image': AppImages.profileImage,
      'filter': 'Last 24 Hours'
    },
    {
      'name': 'Thomas Baker',
      'date': 'Feb 9, 2026 • 8:30 PM',
      'amount': '12',
      'image': AppImages.profileImage,
      'filter': 'Last 24 Hours'
    },
    {
      'name': 'Chris Brown',
      'date': 'Feb 9, 2026 • 8:30 PM',
      'amount': '13',
      'image': AppImages.profileImage,
      'filter': 'Last Week'
    },
    {
      'name': 'Robert Davis',
      'date': 'Feb 9, 2026 • 8:30 PM',
      'amount': '5',
      'image': AppImages.profileImage,
      'filter': 'Last Week'
    },
  ].obs;

  List<Map<String, dynamic>> get filteredHistory {
    if (selectedFilter.value == 'All') {
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
    if (selectedFilter.value == 'Last 24 Hours') return 'Earnings for Today';
    if (selectedFilter.value == 'All') return 'All Earnings';
    return 'Earnings for ${selectedFilter.value}';
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
