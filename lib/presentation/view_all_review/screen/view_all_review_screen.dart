import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/utils/app_colors/app_colors.dart';
import 'package:bestkits/widget/custom_appbar.dart';
import 'package:bestkits/widget/app_loading.dart';
import 'package:bestkits/widget/app_empty_state.dart';
import '../controller/view_all_review_controller.dart';
import '../widget/view_all_review_card.dart';

class ViewAllReviewScreen extends StatefulWidget {
  const ViewAllReviewScreen({super.key});

  @override
  State<ViewAllReviewScreen> createState() => _ViewAllReviewScreenState();
}

class _ViewAllReviewScreenState extends State<ViewAllReviewScreen> {
  late final ViewAllReviewController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<ViewAllReviewController>()
        ? Get.find<ViewAllReviewController>()
        : Get.put(ViewAllReviewController());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: 'All Reviews [ ${controller.totalReviews.value} ]',
        showBack: true,
      ),
      body: _buildBody(),
    ));
  }

  Widget _buildBody() {
    if (controller.isLoading.value) {
      return const AppLoading(isFullPage: true, message: "Loading reviews...");
    }

    if (controller.reviews.isEmpty) {
      return const AppEmptyState(
        icon: Icons.rate_review_outlined,
        title: "No Reviews Yet",
        subtitle: "There are no reviews for this product.",
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: controller.reviews.length,
      itemBuilder: (context, index) {
        final review = controller.reviews[index];
        return ViewAllReviewCard(review: review);
      },
    );
  }
}

