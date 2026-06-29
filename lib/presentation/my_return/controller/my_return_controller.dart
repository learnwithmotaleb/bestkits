import 'package:get/get.dart';
import '../../../../../utils/assets_image/app_images.dart';
import '../../../../../utils/static_strings/static_strings.dart';
import '../../bottom_nav/page/order/controller/order_controller.dart';

class ReturnModel {
  final String id;
  final String orderId;
  final String date;
  final String statusTab; // AppStrings key
  final String returnStatus; // AppStrings key
  final String sellerName;
  final double totalAmount;
  final List<OrderItem> items;
  final String returnReason;
  final String submittedOn;
  final String message;
  final List<String> evidenceImages;
  final String? location;
  final String? rejectionReason;
  final String? rejectedOn;

  ReturnModel({
    required this.id,
    required this.orderId,
    required this.date,
    required this.statusTab,
    required this.returnStatus,
    required this.sellerName,
    required this.totalAmount,
    required this.items,
    required this.returnReason,
    required this.submittedOn,
    required this.message,
    required this.evidenceImages,
    this.location,
    this.rejectionReason,
    this.rejectedOn,
  });
}

class MyReturnController extends GetxController {
  final List<String> tabs = [
    AppStrings.returnRequests,
    AppStrings.accepted,
    AppStrings.rejected
  ];
  final RxInt selectedTab = 0.obs;

  final Rx<ReturnModel?> selectedReturn = Rx<ReturnModel?>(null);

  final List<ReturnModel> returns = [
    ReturnModel(
      id: '1',
      orderId: 'KDF143625879',
      date: '27 Aug 2020 - 08:30 AM',
      statusTab: AppStrings.returnRequests,
      returnStatus: AppStrings.inReview,
      sellerName: 'Mayoral Reseller',
      totalAmount: 520.00,
      returnReason: 'Damage Product',
      submittedOn: 'Jul 13, 2025',
      message: 'I recently noticed that I am unable to log into my account and received a notification that it has been blocked. I believe this may have been a misunderstanding. Could you please review my account and let me know the reason for the restriction? I would appreciate your assistance in resolving this matter as soon as possible.',
      evidenceImages: [
        AppImages.kidsCottonHoodie,
        AppImages.kidsCottonHoddieTshirt,
        AppImages.kidShorts,
      ],
      items: [
        OrderItem(
          image: AppImages.kidsCottonSho,
          name: 'D.D. Step - Comfort',
          quantity: 1,
          variant: 'S',
          price: 260.00,
        ),
        OrderItem(
          image: AppImages.kidsCottonSho,
          name: 'D.D. Step - Comfort',
          quantity: 1,
          variant: 'S',
          price: 260.00,
        ),
      ],
    ),
    ReturnModel(
      id: '2',
      orderId: 'DDF143625869',
      date: '27 Aug 2020 - 08:30 AM',
      statusTab: AppStrings.returnRequests,
      returnStatus: AppStrings.inReview,
      sellerName: 'Mayoral Reseller',
      totalAmount: 260.00,
      returnReason: 'Damage Product',
      submittedOn: 'Jul 13, 2025',
      message: 'Product arrived damaged.',
      evidenceImages: [
        AppImages.kidsCottonHoodie,
      ],
      items: [
        OrderItem(
          image: AppImages.kidsCottonSho,
          name: 'D.D. Step - Comfort',
          quantity: 1,
          variant: 'S',
          price: 260.00,
        ),
      ],
    ),
    ReturnModel(
      id: '3',
      orderId: 'KDF143625879',
      date: '27 Aug 2020 - 08:30 AM',
      statusTab: AppStrings.accepted,
      returnStatus: AppStrings.processing,
      sellerName: 'Mayoral Reseller',
      totalAmount: 520.00,
      returnReason: 'Damage Product',
      submittedOn: 'Jul 13, 2025',
      message: 'I recently noticed that I am unable to log into my account and received a notification that it has been blocked. I believe this may have been a misunderstanding. Could you please review my account and let me know the reason for the restriction? I would appreciate your assistance in resolving this matter as soon as possible.',
      evidenceImages: [
        AppImages.kidsCottonHoodie,
        AppImages.kidsCottonHoddieTshirt,
        AppImages.kidShorts,
      ],
      location: '25 "Ivan Vazov" Street, Plovdiv 4000, Bulgaria',
      items: [
        OrderItem(
          image: AppImages.kidsCottonSho,
          name: 'D.D. Step - Comfort',
          quantity: 1,
          variant: 'S',
          price: 260.00,
        ),
      ],
    ),
    ReturnModel(
      id: '4',
      orderId: 'DDF143625869',
      date: '27 Aug 2020 - 08:30 AM',
      statusTab: AppStrings.accepted,
      returnStatus: AppStrings.completed,
      sellerName: 'Mayoral Reseller',
      totalAmount: 260.00,
      returnReason: 'Damage Product',
      submittedOn: 'Jul 13, 2025',
      message: 'Product arrived damaged.',
      evidenceImages: [
        AppImages.kidsCottonHoodie,
      ],
      location: '25 "Ivan Vazov" Street, Plovdiv 4000, Bulgaria',
      items: [
        OrderItem(
          image: AppImages.kidsCottonSho,
          name: 'D.D. Step - Comfort',
          quantity: 1,
          variant: 'S',
          price: 260.00,
        ),
      ],
    ),
    ReturnModel(
      id: '5',
      orderId: 'KDF143625879',
      date: '27 Aug 2020 - 08:30 AM',
      statusTab: AppStrings.rejected,
      returnStatus: AppStrings.rejected,
      sellerName: 'Mayoral Reseller',
      totalAmount: 520.00,
      returnReason: 'Damage Product',
      submittedOn: 'Jul 13, 2025',
      message: 'I recently noticed that I am unable to log into my account and received a notification that it has been blocked. I believe this may have been a misunderstanding. Could you please review my account and let me know the reason for the restriction? I would appreciate your assistance in resolving this matter as soon as possible.',
      evidenceImages: [
        AppImages.kidsCottonHoodie,
        AppImages.kidsCottonHoddieTshirt,
        AppImages.kidShorts,
      ],
      rejectedOn: '27 Aug 2020 - 08:20 AM',
      rejectionReason: 'I received the product in a damaged condition. The sole appears to be slightly torn, and the stitching on one side is loose. The packaging was intact, so the issue seems to be with the product itself. I have attached images for your review. Please assist with the return process.',
      items: [
        OrderItem(
          image: AppImages.kidsCottonSho,
          name: 'D.D. Step - Comfort',
          quantity: 1,
          variant: 'S',
          price: 260.00,
        ),
        OrderItem(
          image: AppImages.kidsCottonSho,
          name: 'D.D. Step - Comfort',
          quantity: 1,
          variant: 'S',
          price: 260.00,
        ),
      ],
    ),
  ];

  List<ReturnModel> get currentTabReturns {
    final status = tabs[selectedTab.value];
    return returns.where((r) => r.statusTab == status).toList();
  }

  void changeTab(int index) {
    selectedTab.value = index;
    selectedReturn.value = null;
  }

  void viewReturnDetails(ReturnModel r) {
    selectedReturn.value = r;
  }

  void backToList() {
    selectedReturn.value = null;
  }
}