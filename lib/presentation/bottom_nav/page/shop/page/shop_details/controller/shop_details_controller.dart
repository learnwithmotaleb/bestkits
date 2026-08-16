import 'package:bestkits/presentation/cart/controller/cart_controller.dart';
import 'package:bestkits/presentation/checkout/screen/checkout_screen.dart';
import 'package:bestkits/presentation/my_address/controller/my_address_controller.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/presentation/bottom_nav/page/shop/page/shop_details/model/shop_details_model.dart';
import 'package:bestkits/service/api_service.dart';
import 'package:bestkits/service/api_url.dart';
import 'package:bestkits/presentation/message/page/chat/chat_screen/chat_screen.dart';
import 'package:bestkits/presentation/message/controller/message_controller.dart';
import 'package:bestkits/widget/show_snackbar.dart';
import 'package:bestkits/presentation/message/page/chat/model/my_chat_room_model.dart'
    as chat_room_model;

class ShopDetailsController extends GetxController {
  // Product state
  final Rx<ShopDetailsData?> productDetails = Rx<ShopDetailsData?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isAddingToCart = false.obs;
  final RxBool isOrderingNow = false.obs;
  final RxString errorMessage = ''.obs;

  // Image selection
  final selectedImageIndex = 0.obs;

  // Variant selection
  final selectedVariant = ''.obs;

  // Quantity selection
  final quantity = 1.obs;

  // Tab selection
  final selectedTabIndex = 0.obs;
  final List<String> tabs = [
    AppStrings.description,
    AppStrings.sellerProfile,
  ];

  final ApiClient _apiClient = ApiClient();

  Future<void> fetchProductDetails(String id) async {
    isLoading.value = true;
    errorMessage.value = '';
    selectedImageIndex.value = 0;

    try {
      final response = await _apiClient.get(
        url: ApiUrl.detailsProduct(id),
        isToken: true,
      );

      if (response.statusCode == 200 &&
          response.body is Map &&
          response.body['data'] != null) {
        final dataJson = response.body['data'] as Map<String, dynamic>;
        productDetails.value = ShopDetailsData.fromJson(dataJson);
      } else {
        errorMessage.value = response.body?['message']?.toString() ??
            'Failed to load product (${response.statusCode})';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      debugPrint('Error fetching product details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart() async {
    if (productDetails.value == null) return;

    isAddingToCart.value = true;
    try {
      final body = {
        "productId": productDetails.value!.id,
      };

      final response = await _apiClient.post(
        url: ApiUrl.addToCart,
        body: body,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ShowAppSnackBar.success("Product added to cart successfully");
        if (Get.isRegistered<CartController>()) {
          Get.find<CartController>().incrementCount();
        }
      } else {
        final raw = response.body?['message'] ??
            response.statusText ??
            "Failed to add to cart";
        final msg = raw is List ? raw.join(', ') : raw.toString();
        ShowAppSnackBar.fail(msg);
      }
    } catch (e) {
      ShowAppSnackBar.fail("An error occurred: $e");
    } finally {
      isAddingToCart.value = false;
    }
  }

  Future<void> orderNow() async {
    if (productDetails.value == null) return;

    isOrderingNow.value = true;
    try {
      final addressController = Get.isRegistered<MyAddressController>()
          ? Get.find<MyAddressController>()
          : Get.put(MyAddressController());

      await addressController.getAddresses();
      final addresses = addressController.addresses;

      int addressId = 0;
      if (addresses.isNotEmpty) {
        final defaultAddress =
            addresses.firstWhereOrNull((a) => a.isDefault == true);
        if (defaultAddress != null) {
          addressId = defaultAddress.id?.toInt() ?? 0;
        } else {
          addressId = addresses.first.id?.toInt() ?? 0;
        }
      }

      if (addressId == 0) {
        ShowAppSnackBar.fail("Please add a delivery address first.");
        return;
      }

      final args = {
        'isBuyNow': true,
        'productId': productDetails.value!.id,
        'addressId': addressId,
      };

      ShowAppSnackBar.success("Proceeding to checkout");
      Get.to(() => const CheckoutScreen(), arguments: args);
    } catch (e) {
      ShowAppSnackBar.fail("An error occurred: $e");
    } finally {
      isOrderingNow.value = false;
    }
  }

  void selectImage(int index) => selectedImageIndex.value = index;
  void selectVariant(String variant) => selectedVariant.value = variant;
  void selectTab(int index) => selectedTabIndex.value = index;

  Future<void> messageSeller() async {
    final sellerId = productDetails.value?.user?.id;
    if (sellerId == null) {
      ShowAppSnackBar.fail("Seller information is not available.");
      return;
    }

    try {
      ShowAppSnackBar.success("Connecting to seller...");

      final body = {
        "sellerId": sellerId,
      };

      final response = await _apiClient.post(
        url: ApiUrl.createChatRoom,
        body: body,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body['data'];
        if (data != null && data['id'] != null) {
          final roomId = data['id'].toString();

          final seller = productDetails.value?.user;
          String name = seller?.profile?.fullName ?? 'Unknown';
          String initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

          // Use avatarUrl if available, otherwise fallback to initial
          String avatar = seller?.profile?.avatarUrl ?? initial;

          bool isProf = seller?.sellerTier == "PROFESSIONAL_SELLER";

          final chatSummary = ChatSummary(
            id: roomId,
            name: name,
            avatar: avatar,
            lastMessage: 'No messages yet',
            time: '',
            isUnread: false,
            unreadCount: 0,
            isProfessional: isProf,
          );

          Get.to(() => ChatScreen(chatSummary: chatSummary));
        } else {
          ShowAppSnackBar.fail("Failed to create chat room.");
        }
      } else {
        final msg = response.body?['message'] ?? "Failed to create chat room.";
        ShowAppSnackBar.fail(msg.toString());
      }
    } catch (e) {
      ShowAppSnackBar.fail("An error occurred: $e");
    }
  }
}
