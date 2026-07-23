import 'package:get/get.dart';
import '../../../service/api_service.dart';
import '../../../service/api_url.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../helper/tost_message/show_snackbar.dart';
import '../model/ReturnOrderModel.dart';
import '../../my_return/model/MyReturnDetailsModel.dart' as detail_model;

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
  final RxList<Data> allOrders = <Data>[].obs;

  // Detail state
  final RxBool isDetailLoading = false.obs;
  final Rx<detail_model.Data?> selectedReturnDetail = Rx<detail_model.Data?>(null);

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

  Future<void> fetchOrders() async {
    isLoading.value = true;
    selectedReturnDetail.value = null;
    try {
      final tabParam = _getSellerTabParam(selectedTab.value);
      final url = '${ApiUrl.returnOrder}?sellerTab=$tabParam';
      final response = await ApiClient().get(url: url, isToken: true);

      if (response.statusCode == 200) {
        final model = ReturnOrderModel.fromJson(response.body);
        allOrders.assignAll(model.data ?? []);
      } else {
        AppSnackBar.fail(response.statusText ?? 'Failed to load return orders');
      }
    } catch (e) {
      AppSnackBar.fail('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReturnDetails(String id) async {
    isDetailLoading.value = true;
    try {
      final response = await ApiClient().get(
        url: ApiUrl.myReturnDetails(id),
        isToken: true,
      );

      if (response.statusCode == 200) {
        final model = detail_model.MyReturnDetailsModel.fromJson(response.body);
        selectedReturnDetail.value = model.data;
      } else {
        AppSnackBar.fail(response.statusText ?? 'Failed to load return details');
      }
    } catch (e) {
      AppSnackBar.fail('An error occurred: $e');
    } finally {
      isDetailLoading.value = false;
    }
  }

  void setTab(String tab) {
    if (selectedTab.value != tab) {
      selectedTab.value = tab;
      fetchOrders();
    }
  }

  void viewDetails(Data order) {
    fetchReturnDetails(order.id.toString());
  }

  void backToList() {
    selectedReturnDetail.value = null;
  }
}