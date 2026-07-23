import 'package:get/get.dart';
import '../../../../../utils/static_strings/static_strings.dart';
import '../../../../../service/api_service.dart';
import '../../../../../service/api_url.dart';
import '../../../../../helper/tost_message/show_snackbar.dart';
import '../model/MyReturnModel.dart' as list_model;
import '../model/MyReturnDetailsModel.dart' as detail_model;

class MyReturnController extends GetxController {
  final List<String> tabs = [
    AppStrings.returnRequests,
    AppStrings.accepted,
    AppStrings.rejected
  ];
  final RxInt selectedTab = 0.obs;

  // List state
  final RxBool isLoading = false.obs;
  final RxList<list_model.Data> returns = <list_model.Data>[].obs;

  // Detail state
  final RxBool isDetailLoading = false.obs;
  final Rx<detail_model.Data?> selectedReturnDetail =
      Rx<detail_model.Data?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchReturns();
  }

  Future<void> fetchReturns() async {
    isLoading.value = true;
    try {
      String? statusFilter;
      if (selectedTab.value == 1)
        statusFilter = 'APPROVED';
      else if (selectedTab.value == 2) statusFilter = 'REJECTED';

      String url = ApiUrl.myReturn;
      if (statusFilter != null) {
        url += '?status=$statusFilter';
      }

      var response = await ApiClient().get(url: url, isToken: true);

      if (response.statusCode == 200) {
        list_model.MyReturnModel model =
            list_model.MyReturnModel.fromJson(response.body);
        returns.assignAll(model.data ?? []);
      } else {
        AppSnackBar.fail(response.statusText ?? "Failed to load returns");
      }
    } catch (e) {
      AppSnackBar.fail("An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReturnDetails(String id) async {
    isDetailLoading.value = true;
    try {
      var response = await ApiClient().get(
        url: ApiUrl.myReturnDetails(id),
        isToken: true,
      );

      if (response.statusCode == 200) {
        detail_model.MyReturnDetailsModel model =
            detail_model.MyReturnDetailsModel.fromJson(response.body);
        selectedReturnDetail.value = model.data;
      } else {
        AppSnackBar.fail(
            response.statusText ?? "Failed to load return details");
      }
    } catch (e) {
      AppSnackBar.fail("An error occurred: $e");
    } finally {
      isDetailLoading.value = false;
    }
  }

  List<list_model.Data> get currentTabReturns => returns.toList();

  void changeTab(int index) {
    selectedTab.value = index;
    selectedReturnDetail.value = null;
    fetchReturns();
  }

  void viewReturnDetails(list_model.Data r) {
    fetchReturnDetails(r.id.toString());
  }

  void backToList() {
    selectedReturnDetail.value = null;
  }
}
