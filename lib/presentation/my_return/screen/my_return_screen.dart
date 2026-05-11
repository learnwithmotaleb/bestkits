import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../controller/my_return_controller.dart';
import '../widget/my_return_list_view.dart';
import '../widget/my_return_details_view.dart';

class MyReturnScreen extends StatefulWidget {
  const MyReturnScreen({super.key});

  @override
  State<MyReturnScreen> createState() => _MyReturnScreenState();
}

class _MyReturnScreenState extends State<MyReturnScreen> {
  final MyReturnController controller = Get.put(MyReturnController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () {
              if (controller.selectedReturn.value != null) {
                controller.backToList();
              } else {
                Get.back();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back,
                  color: AppColors.blackColor, size: 20),
            ),
          ),
        ),
        title: Text(
          AppStrings.myReturns.tr,
          style: const TextStyle(
            color: AppColors.blackColor,
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: Dimensions.h(20)),
          _buildTabs(),
          SizedBox(height: Dimensions.h(20)),
          Expanded(
            child: Obx(() {
              if (controller.selectedReturn.value != null) {
                return MyReturnDetailsView(
                    returnModel: controller.selectedReturn.value!);
              } else {
                return const MyReturnListView();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.w(24)),
      child: Obx(
        () => Row(
          children: List.generate(controller.tabs.length, (index) {
            final isSelected = controller.selectedTab.value == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.changeTab(index),
                child: Container(
                  margin: EdgeInsets.only(
                      right: index < controller.tabs.length - 1 ? 8 : 0),
                  padding: EdgeInsets.symmetric(vertical: Dimensions.h(12)),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.blackColor : Colors.white,
                    borderRadius: BorderRadius.circular(Dimensions.r(8)),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.blackColor
                          : AppColors.greyColor.withOpacity(0.3),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    controller.tabs[index].tr,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.darkGreyColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
