import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/responsive_layout/dimensions.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../widget/app_alert.dart';
import '../../../widget/app_bottom_sheet.dart';
import '../../../widget/app_button.dart';
import '../../../widget/app_text_field.dart';
import '../../../widget/custom_appbar.dart';
import '../controller/delivery_options_controller.dart';
import '../widget/delivery_option_widget.dart';

class DeliveryOptionsScreen extends StatefulWidget {
  const DeliveryOptionsScreen({super.key});

  @override
  State<DeliveryOptionsScreen> createState() => _DeliveryOptionsScreenState();
}

class _DeliveryOptionsScreenState extends State<DeliveryOptionsScreen> {
  final _ctrl = Get.put(DeliveryOptionsController());

  void _showEditBottomSheet(BuildContext context, Map<String, dynamic> data) {
    final partnerCtrl = TextEditingController(text: data['partner']);
    final costCtrl = TextEditingController(text: data['cost']);
    final timeCtrl = TextEditingController(text: data['time']);

    AppBottomSheet(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.all(Dimensions.w(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '- Update Delivery Option',
                      style: AppTextStyles.body.copyWith(
                        fontSize: Dimensions.fs(16),
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child:
                        const Icon(Icons.close, size: 20, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.h(4)),
              Text(
                'Make changes to your delivery options below',
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
              SizedBox(height: Dimensions.h(24)),
              Text(
                'Delivery Partner',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: Dimensions.fs(14),
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: Dimensions.h(10)),
              AppTextField(
                controller: partnerCtrl,
                hint: 'Enter delivery partner (e.g. Local courier)',
                hintTextStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
              SizedBox(height: Dimensions.h(20)),
              Text(
                'Delivery Cost (€)',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: Dimensions.fs(14),
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: Dimensions.h(10)),
              AppTextField(
                controller: costCtrl,
                hint: 'Enter delivery cost',
                keyboardType: TextInputType.number,
                hintTextStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
              SizedBox(height: Dimensions.h(20)),
              Text(
                'Estimated Delivery Time',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: Dimensions.fs(14),
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: Dimensions.h(10)),
              AppTextField(
                controller: timeCtrl,
                hint: 'e.g. 2-4 business days',
                hintTextStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
              SizedBox(height: Dimensions.h(24)),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Cancel',
                      onPressed: () => Get.back(),
                      backgroundColor: Colors.white,
                      textColor: Colors.grey,
                      borderSideColor: Colors.grey.withOpacity(0.3),
                      height: 44,
                      borderRadius: 8,
                    ),
                  ),
                  SizedBox(width: Dimensions.w(12)),
                  Expanded(
                    child: AppButton(
                      label: 'Save Changes',
                      onPressed: () {
                        Get.back();
                        AppAlerts.warning(
                          title: 'Update Delivery Option !',
                          message:
                              'Are you sure you want to update your Product Delivery Option information?',
                          confirmLabel: 'Confirm',
                          cancelLabel: 'Cancel',
                          onConfirm: () {
                            _ctrl.updateOption(
                              data['id'],
                              partnerCtrl.text,
                              costCtrl.text,
                              timeCtrl.text,
                            );
                            Get.snackbar(
                              'Success',
                              'Delivery option updated successfully!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          },
                        );
                      },
                      backgroundColor: const Color(0xFF1A1A1A),
                      textColor: AppColors.primaryColor,
                      borderSideColor: const Color(0xFF1A1A1A),
                      height: 44,
                      borderRadius: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CommonAppBar(title: "Delivery Options"),
      body: Obx(() {
        final options = _ctrl.deliveryOptions;
        return ListView.separated(
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.w(20), vertical: Dimensions.h(20)),
          itemCount: options.length,
          separatorBuilder: (_, __) => SizedBox(height: Dimensions.h(16)),
          itemBuilder: (context, index) {
            final option = options[index];
            return DeliveryOptionWidget(
              data: option,
              onUpdate: () {
                _showEditBottomSheet(context, option);
              },
            );
          },
        );
      }),
    );
  }
}
