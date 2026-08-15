import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/service/api_service.dart';
import 'package:bestkits/service/api_url.dart';
import '../../../../utils/static_strings/static_strings.dart';
import '../model/CustomerOrderModel.dart';
import '../model/CustomerOrderDetailsModel.dart' as details_model;

class CustomerOrderController extends GetxController {
  final List<String> tabs = [
    AppStrings.orderPlaced,
    AppStrings.confirmed,
    AppStrings.shipped,
    AppStrings.delivered,
    AppStrings.canceled
  ];

  final RxString selectedTab = AppStrings.orderPlaced.obs;

  final RxList<Data> allOrders = <Data>[].obs;
  final RxBool isLoading = false.obs;

  int page = 1;
  int limit = 50;
  bool hasNextPage = true;
  String? currentStatus;

  final Rx<details_model.Data?> selectedOrderDetails = Rx<details_model.Data?>(null);
  final RxBool isDetailsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders({bool isLoadMore = false, String? status}) async {
    if (isLoadMore) {
      if (!hasNextPage) return;
      page++;
    } else {
      page = 1;
      hasNextPage = true;
      isLoading.value = true;
      if (allOrders.isEmpty) {
        // keep old list until refreshed if desired
      }
    }

    if (status != null) {
      currentStatus = status;
    }

    try {
      final tabParam = _getSellerTabParam(selectedTab.value);
      String url = '${ApiUrl.customerOrder}?page=$page&limit=$limit&sellerTab=$tabParam';
      if (currentStatus != null && currentStatus!.isNotEmpty) {
        url += '&status=$currentStatus';
      }

      final response = await ApiClient().get(
        url: url,
        isToken: true,
      );
      if (response.statusCode == 200) {
        final model = CustomerOrderModel.fromJson(response.body);
        if (isLoadMore) {
          if (model.data != null) allOrders.addAll(model.data!);
        } else {
          if (model.data != null) allOrders.assignAll(model.data!);
        }

        if (model.meta != null) {
          hasNextPage = page < (model.meta!.pages?.toInt() ?? 1);
        } else {
          hasNextPage = false;
        }
      }
    } catch (e) {
      debugPrint("Error fetching customer orders: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String _getSellerTabParam(String tab) {
    if (tab == AppStrings.orderPlaced) return 'ORDER_PLACED';
    if (tab == AppStrings.confirmed) return 'CONFIRMED';
    if (tab == AppStrings.shipped) return 'SHIPPED';
    if (tab == AppStrings.delivered) return 'DELIVERED';
    if (tab == AppStrings.canceled) return 'CANCELED';
    return 'ORDER_PLACED';
  }

  List<Data> get filteredOrders {
    // Return allOrders directly since they are already filtered by the backend
    return allOrders;
  }

  void setTab(String tab) {
    if (selectedTab.value != tab) {
      selectedTab.value = tab;
      fetchOrders();
    }
  }

  void updateOrderStatus(String orderId, String newStatus) {
    // API update status logic would go here
    final index = allOrders.indexWhere(
        (o) => o.id.toString() == orderId || o.displayId == orderId);
    if (index != -1) {
      // Local UI update for now
      fetchOrders();
    }
    
    if (selectedOrderDetails.value != null && 
        (selectedOrderDetails.value!.id.toString() == orderId || selectedOrderDetails.value!.displayId == orderId)) {
      selectedOrderDetails.value = selectedOrderDetails.value!.copyWith(status: newStatus);
    }
  }

  Future<void> fetchOrderDetails(String id) async {
    isDetailsLoading.value = true;
    selectedOrderDetails.value = null; // reset before fetch
    try {
      final response = await ApiClient().get(
        url: ApiUrl.orderDetails(id),
        isToken: true,
      );
      if (response.statusCode == 200) {
        final model = details_model.CustomerOrderDetailsModel.fromJson(response.body);
        selectedOrderDetails.value = model.data;
      }
    } catch (e) {
      debugPrint("Error fetching customer order details: $e");
    } finally {
      isDetailsLoading.value = false;
    }
  }
}
