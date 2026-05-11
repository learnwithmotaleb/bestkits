import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../utils/assets_image/app_images.dart';

class OrderItem {
  final String image;
  final String name;
  final int quantity;
  final String variant;
  final double price;

  OrderItem({
    required this.image,
    required this.name,
    required this.quantity,
    required this.variant,
    required this.price,
  });
}

class OrderModel {
  final String id;
  final String orderId;
  final String date;
  final String status; // 'Active Oder', 'Complete', 'Canceled'
  final String subStatus; // 'Order Placed', 'Delivered', 'Canceled'
  final String sellerName;
  final double totalAmount;
  final List<OrderItem> items;
  final String location;
  final String locationTag;
  final bool isReviewed;

  OrderModel({
    required this.id,
    required this.orderId,
    required this.date,
    required this.status,
    required this.subStatus,
    required this.sellerName,
    required this.totalAmount,
    required this.items,
    required this.location,
    required this.locationTag,
    this.isReviewed = false,
  });
}

class OrderController extends GetxController {
  final List<String> tabs = [AppStrings.activeOrder, AppStrings.complete, AppStrings.canceled];
  final RxInt selectedTab = 0.obs;

  final Rx<OrderModel?> selectedOrder = Rx<OrderModel?>(null);

  final List<OrderModel> orders = [
    OrderModel(
      id: '1',
      orderId: 'KDF143625879',
      date: '27 Aug 2020 - 08:30 AM',
      status: AppStrings.activeOrder,
      subStatus: AppStrings.orderPlaced,
      sellerName: 'Mayoral Reseller',
      totalAmount: 520.00,
      location: '25 "Ivan Vazov" Street, Plovdiv 4000, Bulgaria',
      locationTag: AppStrings.locationTag,
      items: [
        OrderItem(
          image: AppImages.kidsCottonSho,
          name: AppStrings.dummyOrderProductName,
          quantity: 1,
          variant: 'S',
          price: 260.00,
        ),
        OrderItem(
          image: AppImages.kidsCottonSho,
          name: AppStrings.dummyOrderProductName,
          quantity: 1,
          variant: 'S',
          price: 260.00,
        ),
      ],
    ),
    OrderModel(
      id: '2',
      orderId: 'DDF143625869',
      date: '27 Aug 2020 - 08:30 AM',
      status: AppStrings.activeOrder,
      subStatus: AppStrings.orderPlaced,
      sellerName: 'Mayoral Reseller',
      totalAmount: 260.00,
      location: '25 "Ivan Vazov" Street, Plovdiv 4000, Bulgaria',
      locationTag: AppStrings.locationTag,
      items: [
        OrderItem(
          image: AppImages.kidsCottonSho,
          name: AppStrings.dummyOrderProductName,
          quantity: 1,
          variant: 'S',
          price: 260.00,
        ),
      ],
    ),
    OrderModel(
      id: '3',
      orderId: 'KDF143625879',
      date: '27 Aug 2020 - 08:30 AM',
      status: AppStrings.complete,
      subStatus: AppStrings.delivered,
      sellerName: 'Mayoral Reseller',
      totalAmount: 520.00,
      location: '25 "Ivan Vazov" Street, Plovdiv 4000, Bulgaria',
      locationTag: AppStrings.locationTag,
      isReviewed: true,
      items: [
        OrderItem(
          image: AppImages.kidsCottonSho,
          name: AppStrings.dummyOrderProductName,
          quantity: 1,
          variant: 'S',
          price: 260.00,
        ),
        OrderItem(
          image: AppImages.kidsCottonSho,
          name: AppStrings.dummyOrderProductName,
          quantity: 1,
          variant: 'S',
          price: 260.00,
        ),
      ],
    ),
    OrderModel(
      id: '4',
      orderId: 'DDF143625869',
      date: '27 Aug 2020 - 08:30 AM',
      status: AppStrings.complete,
      subStatus: AppStrings.delivered,
      sellerName: 'Mayoral Reseller',
      totalAmount: 260.00,
      location: '25 "Ivan Vazov" Street, Plovdiv 4000, Bulgaria',
      locationTag: AppStrings.locationTag,
      items: [
        OrderItem(
          image: AppImages.kidsCottonSho,
          name: AppStrings.dummyOrderProductName,
          quantity: 1,
          variant: 'S',
          price: 260.00,
        ),
      ],
    ),
    OrderModel(
      id: '5',
      orderId: 'KDF143625879',
      date: '27 Aug 2020 - 08:30 AM',
      status: AppStrings.canceled,
      subStatus: AppStrings.canceled,
      sellerName: 'Mayoral Reseller',
      totalAmount: 520.00,
      location: '25 "Ivan Vazov" Street, Plovdiv 4000, Bulgaria',
      locationTag: AppStrings.locationTag,
      items: [
        OrderItem(
          image: AppImages.kidsCottonSho,
          name: AppStrings.dummyOrderProductName,
          quantity: 1,
          variant: 'S',
          price: 260.00,
        ),
        OrderItem(
          image: AppImages.kidsCottonSho,
          name: AppStrings.dummyOrderProductName,
          quantity: 1,
          variant: 'S',
          price: 260.00,
        ),
      ],
    ),
  ];

  final RxList<String> returnEvidenceImages = <String>[].obs;
  final RxDouble reviewRating = 0.0.obs;
  final TextEditingController reviewTextController = TextEditingController();

  void updateReviewRating(double rating) {
    reviewRating.value = rating;
  }

  Future<void> pickReturnEvidenceImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        returnEvidenceImages.add(image.path);
      }
    } catch (e) {
      // Handle error gracefully
    }
  }

  void removeReturnEvidenceImage(int index) {
    if (index >= 0 && index < returnEvidenceImages.length) {
      returnEvidenceImages.removeAt(index);
    }
  }

  void clearReturnState() {
    returnEvidenceImages.clear();
    reviewRating.value = 0.0;
    reviewTextController.clear();
  }

  List<OrderModel> get currentTabOrders {
    final status = tabs[selectedTab.value];
    return orders.where((o) => o.status == status).toList();
  }

  void changeTab(int index) {
    selectedTab.value = index;
    selectedOrder.value = null;
  }

  void viewOrderDetails(OrderModel order) {
    clearReturnState();
    selectedOrder.value = order;
  }

  void backToList() {
    selectedOrder.value = null;
  }
}