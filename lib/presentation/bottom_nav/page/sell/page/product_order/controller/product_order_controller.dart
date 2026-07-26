import 'package:get/get.dart';
import '../../../../../../../service/api_service.dart';
import '../../../../../../../service/api_url.dart';
import '../model/ProductOrderModel.dart';

class ProductOrderController extends GetxController {
  var isLoading = false.obs;
  var isUpdatingStatus = false.obs;
  var productOrderModel = ProductOrderModel().obs;
  var ordersList = <Data>[].obs;
  var metaData = Rxn<Meta>();

  Future<void> getProductOrders({
    required String productId,
    int page = 1,
    int limit = 10,
    String? status,
    String? tab,
    String? sellerTab,
  }) async {
    isLoading(true);

    try {
      String url = '${ApiUrl.productOrder(productId)}?page=$page&limit=$limit';
      
      if (status != null && status.isNotEmpty) {
        url += '&status=$status';
      }
      if (tab != null && tab.isNotEmpty) {
        url += '&tab=$tab';
      }
      if (sellerTab != null && sellerTab.isNotEmpty) {
        url += '&sellerTab=$sellerTab';
      }

      var response = await ApiClient().get(
        url: url,
        isToken: true,
      );

      if (response.statusCode == 200) {
        productOrderModel.value = ProductOrderModel.fromJson(response.body);
        metaData.value = productOrderModel.value.meta;
        if (productOrderModel.value.data != null) {
          if (page == 1) {
            ordersList.assignAll(productOrderModel.value.data!);
          } else {
            ordersList.addAll(productOrderModel.value.data!);
          }
        }
      } else {
        Get.snackbar("Error", response.statusText ?? "Failed to fetch orders");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  /// Update order status via PATCH /orders/seller/{orderId}
  Future<bool> updateOrderStatus({
    required String orderId,
    required String newStatus,
  }) async {
    isUpdatingStatus(true);
    try {
      final response = await ApiClient().patch(
        url: ApiUrl.orderDetails(orderId),
        body: {'status': newStatus},
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final msg = (response.body is Map)
            ? response.body['message']?.toString() ?? 'Failed to update status'
            : 'Failed to update status';
        Get.snackbar("Error", msg);
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isUpdatingStatus(false);
    }
  }
}