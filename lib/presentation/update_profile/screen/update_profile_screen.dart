import 'package:bestkits/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/responsive_layout/dimensions.dart';
import '../../../service/api_url.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../widget/app_button.dart';
import '../../../widget/app_text_field.dart';
import '../controller/update_profile_controller.dart';

class UpdateProfileScreen extends GetView<UpdateProfileController> {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure the controller is initialized
    Get.put(UpdateProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: CommonAppBar(
        title: AppStrings.myProfile.tr,
      ),
      body: SingleChildScrollView(
        padding: Dimensions.pSym(h: 20, v: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Dimensions.h(20)),
            // Avatar Stack
            SizedBox(
              width: Dimensions.rs(100),
              height: Dimensions.rs(100),
              child: Stack(
                children: [
                  Obx(() {
                    Widget? imageWidget;
                    if (controller.selectedImage.value != null) {
                      imageWidget = Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.r(24)),
                          image: DecorationImage(
                            image: FileImage(controller.selectedImage.value!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else if (controller.existingImageUrl.value != null && controller.existingImageUrl.value!.isNotEmpty) {
                      imageWidget = ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.r(24)),
                        child: Image.network(
                          ApiUrl.buildImageUrl(controller.existingImageUrl.value!),
                          fit: BoxFit.cover,
                          width: Dimensions.rs(100),
                          height: Dimensions.rs(100),
                          errorBuilder: (context, error, stackTrace) => _buildDummyName(controller),
                        ),
                      );
                    } else {
                      imageWidget = _buildDummyName(controller);
                    }

                    return Container(
                      width: Dimensions.rs(100),
                      height: Dimensions.rs(100),
                      decoration: BoxDecoration(
                        color: AppColors.navBarColor,
                        borderRadius: BorderRadius.circular(Dimensions.r(24)),
                      ),
                      alignment: Alignment.center,
                      child: imageWidget,
                    );
                  }),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => controller.pickImage(),
                      child: Container(
                        padding: Dimensions.pAll(6),
                        decoration: BoxDecoration(
                          color: AppColors.blackColor,
                          borderRadius: BorderRadius.circular(Dimensions.r(8)),
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.primaryColor,
                          size: Dimensions.rs(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.h(40)),

            // Text Fields
            AppTextField(
              controller: controller.nameController,
              label: AppStrings.fullName.tr,
              hint: AppStrings.enterFullName.tr,
            ),
            SizedBox(height: Dimensions.h(16)),

            AppTextField(
              controller: controller.phoneController,
              label: AppStrings.phoneNumber.tr,
              hint: AppStrings.enterPhoneNumber.tr,
              keyboardType: TextInputType.phone,
            ),

            SizedBox(height: Dimensions.h(24)),

            // Save Button
            Obx(() => AppButton(
                  label: AppStrings.saveTheChanges.tr,
                  backgroundColor: AppColors.secondaryColor, // Black background
                  textColor: AppColors.primaryColor, // Yellow text
                  borderSideColor: Colors.transparent,
                  isLoading: controller.isLoading.value,
                  onPressed: () {
                    controller.showConfirmationDialog();
                  },
                )),

            SizedBox(height: Dimensions.h(16)),

            // Warning Banner
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: Dimensions.pAll(8),
                  decoration: BoxDecoration(
                    color: AppColors.redColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Dimensions.r(8)),
                  ),
                  child: Icon(
                    Icons.error_outline,
                    color: AppColors.redColor,
                    size: Dimensions.rs(20),
                  ),
                ),
                SizedBox(width: Dimensions.w(12)),
                Expanded(
                  child: Text(
                    AppStrings.emailUpdateRestriction.tr,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.greyColor,
                      fontSize: Dimensions.fs(12),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDummyName(UpdateProfileController controller) {
    return Text(
      controller.nameController.text.isNotEmpty 
          ? controller.nameController.text[0].toUpperCase()
          : AppStrings.dummyUserName.tr[0].toUpperCase(),
      style: AppTextStyles.h1.copyWith(
        fontSize: Dimensions.fs(40),
        fontStyle: FontStyle.italic,
        color: AppColors.primaryColor,
      ),
    );
  }
}
