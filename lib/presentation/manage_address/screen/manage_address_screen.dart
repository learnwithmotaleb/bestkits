import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../widget/app_button.dart';
import '../../../widget/app_text_field.dart';
import '../controller/manage_address_controller.dart';

class ManageAddressScreen extends StatefulWidget {
  const ManageAddressScreen({super.key});

  @override
  State<ManageAddressScreen> createState() => _ManageAddressScreenState();
}

class _ManageAddressScreenState extends State<ManageAddressScreen> {
  final ManageAddressController controller = Get.put(ManageAddressController());

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
          "Manage Addresses",
          style: AppTextStyles.h2.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: Dimensions.fs(18),
            color: AppColors.blackColor.withOpacity(0.8),
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.w(20),
          vertical: Dimensions.h(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: controller.nameController,
              label: "Address Name",
              hint: "e.g. Home, Office",
              radius: Dimensions.r(8),
            ),
            SizedBox(height: Dimensions.h(20)),
            AppTextField(
              controller: controller.addressController,
              label: "Address",
              hint: "Enter full address (street, city, postal code)",
              maxLines: 1,
              radius: Dimensions.r(8),
            ),
            SizedBox(height: Dimensions.h(30)),
            Obx(() => AppButton(
              label: "Save The Changes",
              onPressed: controller.isLoading.value ? null : controller.saveChanges,
              isLoading: controller.isLoading.value,
              backgroundColor: const Color(0xFF1A1A1A),
              textColor: AppColors.primaryColor,
              borderRadius: Dimensions.r(8),
              borderSideColor: Colors.transparent,
              height: Dimensions.h(50),
            )),
          ],
        ),
      ),
    );
  }
}
