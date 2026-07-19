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
import '../../../utils/static_strings/static_strings.dart';
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
    final costCtrl = TextEditingController(text: data['cost']?.toString());

    // Parse existing time string like "2-4 Business Days" or "2-4" to get min and max
    String minStr = '1';
    String maxStr = '1';
    final timeStr = data['time']?.toString() ?? '';
    final RegExp timeRegex = RegExp(r'(\d+)\s*-\s*(\d+)');
    final match = timeRegex.firstMatch(timeStr);
    if (match != null) {
      minStr = match.group(1) ?? '1';
      maxStr = match.group(2) ?? '1';
    }

    final minDaysCtrl = TextEditingController(text: minStr);
    final maxDaysCtrl = TextEditingController(text: maxStr);

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
                      AppStrings.updateDeliveryOption.tr,
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
                AppStrings.makeChangesDeliveryOptions.tr,
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
              SizedBox(height: Dimensions.h(24)),
              Text(
                AppStrings.deliveryPartner.tr,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: Dimensions.fs(14),
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: Dimensions.h(10)),
              AppTextField(
                controller: partnerCtrl,
                hint: AppStrings.enterDeliveryPartner.tr,
                hintTextStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
              SizedBox(height: Dimensions.h(20)),
              Text(
                AppStrings.deliveryCostEuro.tr,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: Dimensions.fs(14),
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: Dimensions.h(10)),
              AppTextField(
                controller: costCtrl,
                hint: AppStrings.enterDeliveryCost.tr,
                keyboardType: TextInputType.number,
                hintTextStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
              SizedBox(height: Dimensions.h(20)),
              Text(
                'Estimated Delivery Days',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: Dimensions.fs(14),
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: Dimensions.h(10)),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: minDaysCtrl,
                      hint: 'Min Days (e.g. 2)',
                      keyboardType: TextInputType.number,
                      hintTextStyle:
                          TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  ),
                  SizedBox(width: Dimensions.w(10)),
                  Text('-', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: Dimensions.w(10)),
                  Expanded(
                    child: AppTextField(
                      controller: maxDaysCtrl,
                      hint: 'Max Days (e.g. 4)',
                      keyboardType: TextInputType.number,
                      hintTextStyle:
                          TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.h(24)),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: AppStrings.cancel.tr,
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
                    child: Obx(() {
                      return AppButton(
                        label: _ctrl.isUpdating.value
                            ? 'Saving...'
                            : AppStrings.saveChanges.tr,
                        onPressed: _ctrl.isUpdating.value
                            ? () {}
                            : () {
                                Get.back(); // close bottom sheet
                                AppAlerts.warning(
                                  title: AppStrings
                                      .updateDeliveryOptionAlertTitle.tr,
                                  message: AppStrings
                                      .updateDeliveryOptionAlertSubtitle.tr,
                                  confirmLabel: AppStrings.confirm.tr,
                                  cancelLabel: AppStrings.cancel.tr,
                                  onConfirm: () {
                                    _ctrl.updateOption(
                                      data['id'],
                                      partnerCtrl.text,
                                      costCtrl.text,
                                      minDaysCtrl.text,
                                      maxDaysCtrl.text,
                                    );
                                  },
                                );
                              },
                        backgroundColor: const Color(0xFF1A1A1A),
                        textColor: AppColors.primaryColor,
                        borderSideColor: const Color(0xFF1A1A1A),
                        height: 44,
                        borderRadius: 8,
                      );
                    }),
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
      appBar: CommonAppBar(title: AppStrings.deliveryOption.tr),
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }
        final options = _ctrl.deliveryOptions;
        if (options.isEmpty) {
          return Center(
            child: Text('No delivery options available', style: TextStyle(color: Colors.grey)),
          );
        }
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
