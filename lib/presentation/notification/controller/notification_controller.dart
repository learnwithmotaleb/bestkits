import 'package:get/get.dart';

class NotificationModel {
  final String id;
  final String title;
  final String date;
  final RxBool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.date,
    bool isRead = false,
  }) : isRead = isRead.obs;
}

class NotificationController extends GetxController {
  final notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockNotifications();
  }

  void _loadMockNotifications() {
    notifications.assignAll([
      NotificationModel(
        id: '1',
        title: 'Your order has been placed successfully',
        date: '18 March 2026',
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: 'Your order has been confirmed by the seller',
        date: '16 March 2026',
        isRead: false,
      ),
      NotificationModel(
        id: '3',
        title: 'Your order is on the way',
        date: '15 March 2026',
        isRead: true,
      ),
      NotificationModel(
        id: '4',
        title: 'Your order has been delivered',
        date: '14 March 2026',
        isRead: true,
      ),
      NotificationModel(
        id: '5',
        title: 'Your order is completed',
        date: '17 March 2026',
        isRead: true,
      ),
      NotificationModel(
        id: '6',
        title: 'Your return request has been approved',
        date: '17 March 2026',
        isRead: true,
      ),
      NotificationModel(
        id: '7',
        title: 'Your return request has been rejected',
        date: '17 March 2026',
        isRead: true,
      ),
    ]);
  }

  void markAsRead(String id) {
    final notification = notifications.firstWhereOrNull((n) => n.id == id);
    if (notification != null) {
      notification.isRead.value = true;
    }
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification.isRead.value = true;
    }
  }
}