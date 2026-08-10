import 'package:bestkits/helper/tost_message/show_snackbar.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../service/api_service.dart';
import '../../../../../service/api_url.dart';
import '../model/MyOrderModel.dart';
import '../../../../../widget/show_snackbar.dart';
import '../model/MyOrderDetailsModel.dart';

class MyOrderController extends GetxController {
  final List<String> tabs = [
    AppStrings.activeOrder,
    AppStrings.complete,
    AppStrings.canceled
  ];
  final RxInt selectedTab = 0.obs;

  final Rx<Data?> selectedOrder = Rx<Data?>(null);
  final Rx<OrderDetail?> selectedOrderDetail = Rx<OrderDetail?>(null);
  final RxBool isDetailLoading = false.obs;

  final RxBool isLoading = false.obs;
  final RxList<Data> orders = <Data>[].obs;

  final RxList<String> returnEvidenceImages = <String>[].obs;
  final RxDouble reviewRating = 0.0.obs;
  final TextEditingController reviewTextController = TextEditingController();
  final TextEditingController returnReasonController = TextEditingController();
  final TextEditingController returnMessageController = TextEditingController();
  final RxBool isReturnSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    try {
      // ACTIVE, COMPLETE, CANCELED
      String tabStr = "ACTIVE";
      if (selectedTab.value == 1)
        tabStr = "COMPLETE";
      else if (selectedTab.value == 2) tabStr = "CANCELED";

      String url = "${ApiUrl.myOrder}?page=1&limit=10&tab=$tabStr";

      var response = await ApiClient().get(url: url, isToken: true);

      if (response.statusCode == 200) {
        MyOrderModel model = MyOrderModel.fromJson(response.body);
        orders.assignAll(model.data ?? []);
      } else {
        AppSnackBar.fail(response.statusText ?? "Failed to load orders");
      }
    } catch (e) {
      AppSnackBar.fail("An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchOrderDetail(String id) async {
    isDetailLoading.value = true;
    selectedOrderDetail.value = null;
    try {
      String url = ApiUrl.myOrderDetails(id);
      var response = await ApiClient().get(url: url, isToken: true);

      if (response.statusCode == 200) {
        MyOrderDetailsModel model = MyOrderDetailsModel.fromJson(response.body);
        selectedOrderDetail.value = model.data;
      } else {
        AppSnackBar.fail(response.statusText ?? "Failed to load order details");
      }
    } catch (e) {
      AppSnackBar.fail("An error occurred: $e");
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<bool> submitReview(
      String orderItemId, double rating, String reviewText) async {
    try {
      String url = ApiUrl.orderDeliveryItemReview(orderItemId);
      var body = {
        "rating": rating.toInt(),
        "review": reviewText,
      };
      var response =
          await ApiClient().post(url: url, body: body, isToken: true);

      if (response.statusCode == 201 || response.statusCode == 200) {
        AppSnackBar.success("Review submitted successfully");
        if (selectedOrder.value != null) {
          fetchOrderDetail(selectedOrder.value!.id.toString());
        }
        return true;
      } else {
        AppSnackBar.fail(response.body?['message'] ??
            response.statusText ??
            "Failed to submit review");
        return false;
      }
    } catch (e) {
      AppSnackBar.fail("An error occurred: $e");
      return false;
    }
  }

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
    returnReasonController.clear();
    returnMessageController.clear();
    isReturnSubmitting.value = false;
  }

  Future<bool> submitReturnRequest(String orderItemId) async {
    final reason = returnReasonController.text.trim();
    final message = returnMessageController.text.trim();

    if (reason.isEmpty) {
      AppSnackBar.fail("Please enter a return reason");
      return false;
    }

    isReturnSubmitting.value = true;
    try {
      // Step 1: Upload each evidence image to /uploads and collect URLs
      final List<String> imageUrls = [];
      for (final imagePath in returnEvidenceImages) {
        final uploadResponse = await ApiClient().multipart(
          url: ApiUrl.upload,
          fields: {},
          files: [MultipartFileData(key: 'file', path: imagePath)],
          isToken: true,
        );
        if (uploadResponse.statusCode == 200 ||
            uploadResponse.statusCode == 201) {
          final body = uploadResponse.body;
          final filePath =
              body is Map ? (body['data']?['filePath'] as String?) : null;
          if (filePath != null && filePath.isNotEmpty) {
            imageUrls.add(ApiUrl.buildImageUrl(filePath));
          }
        }
      }

      // Step 2: POST JSON to /returns — server expects JSON body, not multipart
      final body = <String, dynamic>{
        'orderItemId': int.tryParse(orderItemId) ?? orderItemId,
        'reason': reason,
        'message': message,
        'images': imageUrls,
      };

      final response = await ApiClient().post(
        url: ApiUrl.returnRequest,
        body: body,
        isToken: true,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ShowAppSnackBar.success("Return request submitted successfully");
        clearReturnState();
        if (selectedOrder.value != null) {
          fetchOrderDetail(selectedOrder.value!.id.toString());
        }
        return true;
      } else {
        final raw = response.body?['message'] ??
            response.statusText ??
            "Failed to submit return request";
        // message can be a List<dynamic> from validation errors
        final msg = raw is List ? raw.join(', ') : raw.toString();
        ShowAppSnackBar.fail(msg);
        return false;
      }
    } catch (e) {
      ShowAppSnackBar.fail("An error occurred: $e");
      return false;
    } finally {
      isReturnSubmitting.value = false;
    }
  }

  List<Data> get currentTabOrders {
    return orders.toList();
  }

  void changeTab(int index) {
    selectedTab.value = index;
    selectedOrder.value = null;
    selectedOrderDetail.value = null;
    fetchOrders();
  }

  void viewOrderDetails(Data order) {
    clearReturnState();
    selectedOrder.value = order;
    fetchOrderDetail(order.id.toString());
  }

  void backToList() {
    selectedOrder.value = null;
    selectedOrderDetail.value = null;
  }

  final TextEditingController cancelReasonController = TextEditingController();
  final RxBool isCancelSubmitting = false.obs;

  Future<bool> cancelOrder(String orderId) async {
    final reason = cancelReasonController.text.trim();
    if (reason.isEmpty) {
      ShowAppSnackBar.fail("Please enter a cancel reason");
      return false;
    }

    isCancelSubmitting.value = true;
    try {
      final body = <String, dynamic>{
        'reason': reason,
      };

      final response = await ApiClient().patch(
        url: ApiUrl.cancelOrder(orderId),
        body: body,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ShowAppSnackBar.success("Order canceled successfully");
        cancelReasonController.clear();
        fetchOrders();
        if (selectedOrder.value != null) {
          fetchOrderDetail(selectedOrder.value!.id.toString());
        }
        return true;
      } else {
        final raw = response.body?['message'] ??
            response.statusText ??
            "Failed to cancel order";
        final msg = raw is List ? raw.join(', ') : raw.toString();
        ShowAppSnackBar.fail(msg);
        return false;
      }
    } catch (e) {
      ShowAppSnackBar.fail("An error occurred: $e");
      return false;
    } finally {
      isCancelSubmitting.value = false;
    }
  }
}
