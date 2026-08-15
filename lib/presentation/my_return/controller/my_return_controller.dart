import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/static_strings/static_strings.dart';
import '../../../../../service/api_service.dart';
import '../../../../../service/api_url.dart';
import '../../../../../helper/tost_message/show_snackbar.dart';
import '../model/MyReturnModel.dart' as list_model;
import '../model/MyReturnDetailsModel.dart' as detail_model;

class MyReturnController extends GetxController {
  // Tab labels and API tab values (maps index → tab query param)
  final List<String> tabs = [
    AppStrings.returnRequests,
    AppStrings.accepted,
    AppStrings.rejected,
  ];

  // tab param values matching API: RETURN_REQUESTS, ACCEPTED, REJECTED
  final List<String> _tabParams = [
    'RETURN_REQUESTS',
    'ACCEPTED',
    'REJECTED',
  ];

  final RxInt selectedTab = 0.obs;

  // List state
  final RxBool isLoading = false.obs;
  final RxBool isPaginationLoading = false.obs;
  final RxList<list_model.Data> returns = <list_model.Data>[].obs;

  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  static const int _pageSize = 10;

  // Scroll controller for pagination
  final ScrollController scrollController = ScrollController();

  // Detail state
  final RxBool isDetailLoading = false.obs;
  final Rx<detail_model.Data?> selectedReturnDetail =
      Rx<detail_model.Data?>(null);

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchReturns();
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isPaginationLoading.value &&
        _currentPage < _totalPages) {
      _fetchNextPage();
    }
  }

  Future<void> fetchReturns({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _totalPages = 1;
      returns.clear();
    }

    isLoading.value = true;
    try {
      final tabParam = _tabParams[selectedTab.value];
      final url =
          '${ApiUrl.myReturn}?tab=$tabParam&page=1&limit=$_pageSize';

      var response = await ApiClient().get(url: url, isToken: true);

      if (response.statusCode == 200) {
        list_model.MyReturnModel model =
            list_model.MyReturnModel.fromJson(response.body);
        _currentPage = 1;
        _totalPages = model.meta?.pages?.toInt() ?? 1;
        returns.assignAll(model.data ?? []);
      } else {
        AppSnackBar.fail(response.statusText ?? 'Failed to load returns');
      }
    } catch (e) {
      AppSnackBar.fail('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchNextPage() async {
    isPaginationLoading.value = true;
    try {
      final nextPage = _currentPage + 1;
      final tabParam = _tabParams[selectedTab.value];
      final url =
          '${ApiUrl.myReturn}?tab=$tabParam&page=$nextPage&limit=$_pageSize';

      var response = await ApiClient().get(url: url, isToken: true);

      if (response.statusCode == 200) {
        list_model.MyReturnModel model =
            list_model.MyReturnModel.fromJson(response.body);
        _currentPage = nextPage;
        _totalPages = model.meta?.pages?.toInt() ?? _totalPages;
        returns.addAll(model.data ?? []);
      } else {
        AppSnackBar.fail(response.statusText ?? 'Failed to load more returns');
      }
    } catch (e) {
      AppSnackBar.fail('An error occurred: $e');
    } finally {
      isPaginationLoading.value = false;
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
            response.statusText ?? 'Failed to load return details');
      }
    } catch (e) {
      AppSnackBar.fail('An error occurred: $e');
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<void> refreshReturnDetails() async {
    final current = selectedReturnDetail.value;
    if (current == null) return;
    await fetchReturnDetails(current.id.toString());
  }

  List<list_model.Data> get currentTabReturns => returns.toList();

  bool get hasMorePages => _currentPage < _totalPages;

  void changeTab(int index) {
    if (selectedTab.value == index) return;
    selectedTab.value = index;
    selectedReturnDetail.value = null;
    fetchReturns(isRefresh: true);
  }

  void viewReturnDetails(list_model.Data r) {
    fetchReturnDetails(r.id.toString());
  }

  void backToList() {
    selectedReturnDetail.value = null;
  }
}
