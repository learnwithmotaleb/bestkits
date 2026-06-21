import 'package:get/get.dart';
import '../../../../utils/assets_image/app_images.dart';
import '../../../utils/app_icons/app_icons.dart';
import '../../../../utils/static_strings/static_strings.dart';

class CustomerOrderController extends GetxController {
  final List<String> tabs = [
    AppStrings.orderPlaced,
    AppStrings.confirmed,
    AppStrings.shipped,
    AppStrings.delivered,
    AppStrings.canceled
  ];
  
  final RxString selectedTab = AppStrings.orderPlaced.obs;

  // Mock data for orders
  final RxList<Map<String, dynamic>> allOrders = <Map<String, dynamic>>[
    {
      'id': 'KDF143625879',
      'date': '27 Aug 2020 - 06:20 AM',
      'status': AppStrings.orderPlaced,
      'product': {
        'name': 'D.D. Step - Comfort',
        'quantity': '01',
        'size': 'S',
        'price': '260.00',
        // Fallback or real image
        'image': AppImages.kidsCottonSho, 
      },
      'customer': {
        'name': 'Roberts Junior',
        'email': 'robert1@junior.com',
        'image': AppImages.profileImage,
      },
      'delivery': {
        'phone': '+359 77 123 4567',
        'address': '25 "Ivan Vazov" Street, Plovdiv 4000, Bulgaria',
      }
    },
    {
      'id': 'DDF143625869',
      'date': '27 Aug 2020 - 06:20 AM',
      'status': AppStrings.orderPlaced,
      'product': {
        'name': 'Kids Cotton Hoodie',
        'quantity': '02',
        'size': 'M',
        'price': '45.00',
        'image': AppImages.kidAccessor,
      },
      'customer': {
        'name': 'Roberts Junior',
        'email': 'robert1@junior.com',
        'image': AppImages.profileImage,
      },
      'delivery': {
        'phone': '+359 77 123 4567',
        'address': '25 "Ivan Vazov" Street, Plovdiv 4000, Bulgaria',
      }
    },
    {
      'id': 'KDF143625880',
      'date': '28 Aug 2020 - 08:30 AM',
      'status': AppStrings.shipped,
      'product': {
        'name': 'D.D. Step - Comfort',
        'quantity': '01',
        'size': 'S',
        'price': '260.00',
        'image': AppImages.kidsCottonSho,
      },
      'customer': {
        'name': 'John Doe',
        'email': 'john@doe.com',
        'image': AppImages.profileImage,
      },
      'delivery': {
        'phone': '+123 456 7890',
        'address': '123 Main St, NY, USA',
      }
    }
  ].obs;

  List<Map<String, dynamic>> get filteredOrders {
    return allOrders.where((order) => order['status'] == selectedTab.value).toList();
  }

  void setTab(String tab) {
    selectedTab.value = tab;
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = allOrders.indexWhere((o) => o['id'] == orderId);
    if (index != -1) {
      final updatedOrder = Map<String, dynamic>.from(allOrders[index]);
      updatedOrder['status'] = newStatus;
      allOrders[index] = updatedOrder;
      // Refresh the list if needed, RxList assignments trigger updates automatically if we replace the element
    }
  }
}