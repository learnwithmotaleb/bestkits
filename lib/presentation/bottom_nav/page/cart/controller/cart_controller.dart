import 'package:get/get.dart';
import 'package:bestkits/service/api_service.dart';
import 'package:bestkits/service/api_url.dart';
import 'package:bestkits/widget/show_snackbar.dart';
import '../model/CartModel.dart';

class CartController extends GetxController {
  final Rx<CartModel?> cartModel = Rx<CartModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isActionLoading = false.obs;
  final RxInt cartItemCount = 0.obs;

  final ApiClient _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  Future<void> fetchCart() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(
        url: ApiUrl.getCart,
        isToken: true,
      );

      if (response.statusCode == 200) {
        cartModel.value = CartModel.fromJson(response.body);
        cartItemCount.value = totalItemCount; // sync count from API
      } else {
        final raw = response.body?['message'] ??
            response.statusText ??
            "Failed to fetch cart";
        final msg = raw is List ? raw.join(', ') : raw.toString();
        ShowAppSnackBar.fail(msg);
      }
    } catch (e) {
      ShowAppSnackBar.fail("An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateQty(String itemId, int newQuantity) async {
    if (newQuantity < 1) return;

    isActionLoading.value = true;
    try {
      final body = {"quantity": newQuantity};
      final response = await _apiClient.patch(
        url: ApiUrl.updateQuantityCart(itemId),
        body: body,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchCart(); // Refresh cart after successful update
      } else {
        final raw = response.body?['message'] ??
            response.statusText ??
            "Failed to update quantity";
        final msg = raw is List ? raw.join(', ') : raw.toString();
        ShowAppSnackBar.fail(msg);
      }
    } catch (e) {
      ShowAppSnackBar.fail("An error occurred: $e");
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> removeItem(String itemId) async {
    isActionLoading.value = true;
    try {
      final response = await _apiClient.delete(
        url: ApiUrl.deleteCartItem(itemId),
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        ShowAppSnackBar.success("Item removed from cart");
        await fetchCart();
      } else {
        final raw = response.body?['message'] ??
            response.statusText ??
            "Failed to remove item";
        final msg = raw is List ? raw.join(', ') : raw.toString();
        ShowAppSnackBar.fail(msg);
      }
    } catch (e) {
      ShowAppSnackBar.fail("An error occurred: $e");
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> emptyCart() async {
    isActionLoading.value = true;
    try {
      final response = await _apiClient.delete(
        url: ApiUrl.clearEnterCart,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        ShowAppSnackBar.success("Cart emptied successfully");
        cartModel.value = null;
        await fetchCart();
      } else {
        final raw = response.body?['message'] ??
            response.statusText ??
            "Failed to empty cart";
        final msg = raw is List ? raw.join(', ') : raw.toString();
        ShowAppSnackBar.fail(msg);
      }
    } catch (e) {
      ShowAppSnackBar.fail("An error occurred: $e");
    } finally {
      isActionLoading.value = false;
    }
  }

  /// Increment count by 1 when a new item is added to cart
  void incrementCount() {
    cartItemCount.value++;
  }

  // Helper Getters
  int get totalItemCount {
    int count = 0;
    final groups = cartModel.value?.data?.sellerGroups;
    if (groups != null) {
      for (var group in groups) {
        if (group.items != null) {
          count += group.items!.length;
        }
      }
    }
    return count;
  }

  double get subtotal {
    double total = 0;
    final groups = cartModel.value?.data?.sellerGroups;
    if (groups != null) {
      for (var group in groups) {
        total += (group.subtotal?.toDouble() ?? 0.0);
      }
    }
    return total;
  }

  double get shippingFee {
    double fee = 0;
    final groups = cartModel.value?.data?.sellerGroups;
    if (groups != null) {
      for (var group in groups) {
        fee += (group.deliveryCost?.toDouble() ?? 0.0);
      }
    }
    return fee;
  }

  double get total {
    return cartModel.value?.data?.grandTotal?.toDouble() ?? 0.0;
  }
}
