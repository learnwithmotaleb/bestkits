import 'package:get/get.dart';

class DeliveryOptionsController extends GetxController {
  final RxList<Map<String, dynamic>> deliveryOptions = <Map<String, dynamic>>[
    {
      'id': '1',
      'type': 'Domestic Delivery',
      'subtitle': '(Inside Country)',
      'partner': 'Bulgarian Post',
      'cost': '4.99',
      'time': '2-4 Business Days',
    },
    {
      'id': '2',
      'type': 'International Delivery',
      'subtitle': '(Outside Country)',
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