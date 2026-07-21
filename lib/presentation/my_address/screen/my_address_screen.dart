import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_button.dart';
import '../controller/my_address_controller.dart';
import '../model/MyAddressModel.dart';

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({super.key});

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  final MyAddressController controller = Get.put(MyAddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: Dimensions.w(70),
        leading: Padding(
          padding: EdgeInsets.only(left: Dimensions.w(20)),
          child: Center(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                height: Dimensions.h(40),
                width: Dimensions.h(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withOpacity(0.1),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.blackColor.withOpacity(0.7),
                  size: Dimensions.rs(20),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          AppStrings.myAddresses.tr,
          style: AppTextStyles.h2.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: Dimensions.fs(18),
            color: AppColors.blackColor.withOpacity(0.8),
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.w(20),
            vertical: Dimensions.h(20),
          ),
          itemCount: controller.addresses.length + 1,
          separatorBuilder: (_, __) => SizedBox(height: Dimensions.h(16)),
          itemBuilder: (context, index) {
            if (index == controller.addresses.length) {
              return Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: Dimensions.w(150),
                  child: AppButton(
                    label: AppStrings.addAddress.tr,
                    onPressed: controller.goToAddAddress,
                    backgroundColor: const Color(0xFF1A1A1A),
                    textColor: AppColors.primaryColor,
                    borderRadius: Dimensions.r(8),
                    borderSideColor: Colors.transparent,
                    height: Dimensions.h(40),
                    leadingIcon: Icon(Icons.add,
                        color: AppColors.primaryColor,
                        size: Dimensions.rs(18)),
                  ),
                ),
              );
            }
            final Data address = controller.addresses[index];
            return Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(Dimensions.r(12)),
                border:
                    Border.all(color: AppColors.greyColor.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.w(16),
                      vertical: Dimensions.h(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.home_outlined,
                            color: AppColors.primaryColor,
                            size: Dimensions.rs(20)),
                        SizedBox(width: Dimensions.w(8)),
                        Expanded(
                          child: Text(
                            address.addressName ?? "",
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: Dimensions.fs(14),
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.goToEditAddress(address),
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.r(6)),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius:
                                  BorderRadius.circular(Dimensions.r(6)),
                            ),
                            child: Icon(Icons.edit_outlined,
                                color: AppColors.primaryColor,
                                size: Dimensions.rs(16)),
                          ),
                        ),
                        SizedBox(width: Dimensions.w(8)),
                        GestureDetector(
                          onTap: () => controller.deleteAddress(index),
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.r(6)),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF15151),
                              borderRadius:
                                  BorderRadius.circular(Dimensions.r(6)),
                            ),
                            child: Icon(Icons.delete_outline,
                                color: AppColors.whiteColor,
                                size: Dimensions.rs(16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                      color: AppColors.greyColor.withOpacity(0.2), height: 1),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.w(16),
                      vertical: Dimensions.h(12),
                    ),
                    child: Text(
                      address.address ?? "",
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.greyColor,
                        fontSize: Dimensions.fs(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
