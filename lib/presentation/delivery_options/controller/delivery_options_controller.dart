import 'package:get/get.dart';
import '../../../../utils/static_strings/static_strings.dart';

class DeliveryOptionsController extends GetxController {
  final RxList<Map<String, dynamic>> deliveryOptions = <Map<String, dynamic>>[
    {
      'id': '1',
      'type': AppStrings.domesticDelivery,
      'subtitle': AppStrings.insideCountry,
      'partner': 'Bulgarian Post',
      'cost': '4.99',
      'time': '2-4 Business Days',
    },
    {
      'id': '2',
      'type': AppStrings.internationalDelivery,
      'subtitle': AppStrings.outsideCountry,
      'partner': 'DHL Express',
      'cost': '12.99',
      'time': '5-10 Business Days',
    },
  ].obs;

  void updateOption(String id, String partner, String cost, String time) {
    final index = deliveryOptions.indexWhere((opt) => opt['id'] == id);
    if (index != -1) {
      final updated = Map<String, dynamic>.from(deliveryOptions[index]);
      updated['partner'] = partner;
      updated['cost'] = cost;
      updated['time'] = time;
      deliveryOptions[index] = updated;
    }
  }
}