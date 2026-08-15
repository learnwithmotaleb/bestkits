import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../service/api_service.dart';
import '../../../service/api_url.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../helper/tost_message/show_snackbar.dart';
import '../model/ReturnOrderModel.dart' as list_model;
import '../model/ReturnOrderDetailsModel.dart' as detail_model;

class ReturnOrderController extends GetxController {
  final List<String> tabs = [
    AppStrings.inReview,
    AppStrings.processing,
    AppStrings.completed,
    AppStrings.rejected,
  ];

  final RxString selectedTab = AppStrings.inReview.obs;

  // List state
  final RxBool isLoading = false.obs;
  final RxList<list_model.Data> allOrders = <list_model.Data>[].obs;

  // Detail state
  final RxBool isDetailLoading = false.obs;
  final Rx<detail_model.Data?> selectedReturnDetail =
      Rx<detail_model.Data?>(null);

  final RxBool isUpdateLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  String _getSellerTabParam(String tab) {
    if (tab == AppStrings.inReview) return 'IN_REVIEW';
    if (tab == AppStrings.processing) return 'PROCESSING';
    if (tab == AppStrings.completed) return 'COMPLETED';
    if (tab == AppStrings.rejected) return 'REJECTED';
    return 'IN_REVIEW';
  }

  Future<void> fetchOrders({bool isRefresh = false}) async {
    if (!isRefresh) {
      isLoading.value = true;
      selectedReturnDetail.value = null;
    }
    try {
      final tabParam = _getSellerTabParam(selectedTab.value);
      final url = '${ApiUrl.returnOrder}?sellerTab=$tabParam&page=1&limit=20';
      final response = await ApiClient().get(url: url, isToken: true);

      if (response.statusCode == 200) {
        final model = list_model.ReturnOrderModel.fromJson(response.body);
        allOrders.assignAll(model.data ?? []);
      } else {
        AppSnackBar.fail(response.statusText ?? 'Failed to load return orders');
      }
    } catch (e) {
      AppSnackBar.fail('An error occurred: $e');
    } finally {
      if (!isRefresh) isLoading.value = false;
    }
  }

  Future<void> fetchReturnDetails(String id, {bool isRefresh = false}) async {
    if (!isRefresh) isDetailLoading.value = true;
    try {
      final response = await ApiClient().get(
        url: ApiUrl.returnOrderDetails(id),
        isToken: true,
      );

      if (response.statusCode == 200) {
        final model =
            detail_model.ReturnOrderDetailsModel.fromJson(response.body);
        selectedReturnDetail.value = model.data;
      } else {
        AppSnackBar.fail(
            response.statusText ?? 'Failed to load return details');
      }
    } catch (e) {
      AppSnackBar.fail('An error occurred: $e');
    } finally {
      if (!isRefresh) isDetailLoading.value = false;
    }
  }

  Future<void> updateReturnStatus({
    required String id,
    required String status,
    String? sellerResponse,
    String? sellerRejectionReason,
    String? returnAddress,
    num? refundAmount,
  }) async {
    try {
      isUpdateLoading.value = true;
      final body = {
        "status": status,
        if (sellerResponse != null && sellerResponse.isNotEmpty)
          "seller_response": sellerResponse,
        if (sellerRejectionReason != null && sellerRejectionReason.isNotEmpty)
          "seller_rejection_reason": sellerRejectionReason,
        if (returnAddress != null && returnAddress.isNotEmpty)
          "return_address": returnAddress,
        if (refundAmount != null) "refund_amount": refundAmount,
      };

      final response = await ApiClient().patch(
        url: ApiUrl.returnOrderStatusUpdate(id),
        body: body,
        isToken: true,
      );

      if (response.statusCode == 200) {
        AppSnackBar.success('Return status updated successfully');
        await fetchReturnDetails(id, isRefresh: true);
        fetchOrders(isRefresh: true);
      } else {
        AppSnackBar.fail(
            response.statusText ?? 'Failed to update return status');
      }
    } catch (e) {
      AppSnackBar.fail('An error occurred: $e');
    } finally {
      isUpdateLoading.value = false;
    }
  }

  void setTab(String tab) {
    if (selectedTab.value != tab) {
      selectedTab.value = tab;
      fetchOrders();
    }
  }

  void viewDetails(list_model.Data order) {
    fetchReturnDetails(order.id.toString());
  }

  void backToList() {
    selectedReturnDetail.value = null;
  }
}
