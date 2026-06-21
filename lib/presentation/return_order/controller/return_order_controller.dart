import 'package:get/get.dart';
import '../../../utils/assets_image/app_images.dart';

class ReturnOrderController extends GetxController {
  final List<String> tabs = [
    'In review',
    'Processing',
    'Completed',
    'Rejected'
  ];
  
  final RxString selectedTab = 'In review'.obs;

  // Mock data for return orders
  final RxList<Map<String, dynamic>> allOrders = <Map<String, dynamic>>[
    {
      'id': 'KDF143625879',
      'date': '27 Aug 2020 - 06:20 AM',
      'status': 'In review',
      'product': {
        'name': 'D.D. Step - Comfort',
        'quantity': '01',
        'size': 'S',
        'price': '260.00',
        'image': AppImages.kidsCottonSho, 
      },
      'deliveredOn': '22 February 2026 at 6:30 PM',
      'returnDetails': {
        'reason': 'Damage Product',
        'submittedOn': 'Jul 13, 2025',
        'evidence': [
          AppImages.kidsCottonSho,
          AppImages.kidAccessor,
          AppImages.kidsCottonSho,
        ],
        'message': 'I recently noticed that I am unable to log into my account and received a notification that it has been blocked. I believe this may have been a misunderstanding. Could you please review my account and let me know the reason for the restriction? I would appreciate your assistance in resolving this matter as soon as possible.',
      },
    },
    {
      'id': 'DDF143625869',
      'date': '27 Aug 2020 - 06:20 AM',
      'status': 'Processing',
      'product': {
        'name': 'Kids Cotton Hoodie',
        'quantity': '02',
        'size': 'M',
        'price': '45.00',
        'image': AppImages.kidAccessor,
      },
      'deliveredOn': '20 February 2026 at 2:00 PM',
      'returnDetails': {
        'reason': 'Wrong Item Sent',
        'submittedOn': 'Jul 14, 2025',
        'evidence': [
          AppImages.kidAccessor,
        ],
        'message': 'The item I received is different from what I ordered.',
      },
      'returnAddress': '25 "Ivan Vazov" Street, Plovdiv 4000, Bulgaria',
    },
    {
      'id': 'KDF143625880',
      'date': '28 Aug 2020 - 08:30 AM',
      'status': 'Completed',
      'product': {
        'name': 'D.D. Step - Comfort',
        'quantity': '01',
        'size': 'S',
        'price': '260.00',
        'image': AppImages.kidsCottonSho,
      },
      'deliveredOn': '15 February 2026 at 1:15 PM',
      'returnDetails': {
        'reason': 'Did not fit',
        'submittedOn': 'Jul 15, 2025',
        'evidence': [],
        'message': 'The shoes are too small.',
        'completedOn': '27 Aug 2020 - 06:20 AM',
      },
    },
    {
      'id': 'KDF143625881',
      'date': '29 Aug 2020 - 09:00 AM',
      'status': 'Rejected',
      'product': {
        'name': 'D.D. Step - Comfort',
        'quantity': '01',
        'size': 'S',
        'price': '260.00',
        'image': AppImages.kidsCottonSho,
      },
      'deliveredOn': '10 February 2026 at 10:00 AM',
      'returnDetails': {
        'reason': 'Damage Product',
        'submittedOn': 'Jul 16, 2025',
        'evidence': [AppImages.kidsCottonSho],
        'message': 'Product is damaged.',
        'rejectedOn': '27 Aug 2020 - 06:20 AM',
        'rejectionNote': 'I received the product in a damaged condition. The sole appears to be slightly torn, and the stitching on one side is loose. The packaging was intact, so the issue seems to be with the product itself. I have attached images for your review. Please assist with the return process.',
      },
    }
  ].obs;

  List<Map<String, dynamic>> get filteredOrders {
    return allOrders.where((order) => order['status'] == selectedTab.value).toList();
  }

  void setTab(String tab) {
    selectedTab.value = tab;
  }

  void updateReturnStatus(String orderId, String newStatus, {String? address, String? note}) {
    final index = allOrders.indexWhere((o) => o['id'] == orderId);
    if (index != -1) {
      final updatedOrder = Map<String, dynamic>.from(allOrders[index]);
      updatedOrder['status'] = newStatus;
      
      final details = Map<String, dynamic>.from(updatedOrder['returnDetails']);
      
      if (newStatus == 'Processing' && address != null) {
        updatedOrder['returnAddress'] = address;
      } else if (newStatus == 'Completed') {
        details['completedOn'] = 'Just now'; // Ideally use real date format
      } else if (newStatus == 'Rejected') {
        details['rejectedOn'] = 'Just now';
        details['rejectionNote'] = note ?? '';
      }
      
      updatedOrder['returnDetails'] = details;
      allOrders[index] = updatedOrder;
    }
  }
}