import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../utils/static_strings/static_strings.dart';

import '../../../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../../../widget/app_alert.dart';
import '../../../../../../../widget/app_button.dart';
import '../../../../../../../widget/app_text_field.dart';
import '../../../../../../../widget/custom_appbar.dart';
import '../controller/update_product_controller.dart';

class UpdateProductPrice extends StatefulWidget {
  const UpdateProductPrice({super.key});

  @override
  State<UpdateProductPrice> createState() => _UpdateProductPriceState();
}

class _UpdateProductPriceState extends State<UpdateProductPrice> {
  final _formKey = GlobalKey<FormState>();

  final _priceController = TextEditingController(text: '21.99');
  final _discountController = TextEditingController(text: '10%');
  late final _statusController = TextEditingController(text: AppStrings.activeStatus.tr);

  late final List<String> _statusOptions = [AppStrings.activeStatus.tr, AppStrings.inactiveStatus.tr, AppStrings.outOfStockStatus.tr];

  @override
  void dispose() {
    _priceController.dispose();
    _discountController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _openStatusSheet() {
    Get.bottomSheet(
      _StatusSheet(
        items: _statusOptions,
        selected: _statusController.text,
        onSelect: (val) {
          setState(() => _statusController.text = val);
          Get.back();
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  final UpdateProductController _ctrl = Get.find<UpdateProductController>();

  void _onSaveAndContinue() async {
    if (!_formKey.currentState!.validate()) return;
        
    final price = double.tryParse(_priceController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    final discountPrice = double.tryParse(_discountController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    final status = _statusController.text;

    final errorMsg = await _ctrl.updateProductApi(
      price: price,
      discountPrice: discountPrice,
      status: status,
    );

    if (errorMsg == null) {
      AppAlerts.success(message: AppStrings.productUpdatedSuccess.tr);
      // Pop all screens back to the bottom nav (sell screen)
      Get.until((route) => route.isFirst);
    } else {
      AppAlerts.error(message: errorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(title: AppStrings.updateProductTitle.tr),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // ── Scrollable fields ─────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(20),
                  vertical: Dimensions.h(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Price ───────────────────────────────────────────
                    _FieldLabel(label: AppStrings.priceLabel.tr),
                    SizedBox(height: Dimensions.h(8)),
                    AppTextField(
                      controller: _priceController,
                      hint: '€21.99',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return AppStrings.priceRequired.tr;
                        if (double.tryParse(v.replaceAll('€', '').trim()) ==
                            null) {
                          return AppStrings.enterValidPrice.tr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: Dimensions.h(18)),

                    // ── Discount (optional) ─────────────────────────────
                    _FieldLabel(label: AppStrings.discountOptionalLower.tr),
                    SizedBox(height: Dimensions.h(8)),
                    AppTextField(
                      controller: _discountController,
                      hint: '10%',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: Dimensions.h(18)),

                    // ── Product Status ──────────────────────────────────
                    _FieldLabel(label: AppStrings.productStatusLabel.tr),
                    SizedBox(height: Dimensions.h(8)),
                    _StatusDropdown(
                      controller: _statusController,
                      onTap: _openStatusSheet,
                    ),
                    SizedBox(height: Dimensions.h(24)),
                  ],
                ),
              ),
            ),

            // ── Save And Continue button ──────────────────────────────────
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(20),
                vertical: Dimensions.h(16),
              ),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                border: Border(
                  top: BorderSide(color: AppColors.greyColor.withOpacity(0.12)),
                ),
              ),
              child: Obx(() => AppButton(
                label: AppStrings.saveAndContinue.tr,
                onPressed: _ctrl.isLoading.value ? null : _onSaveAndContinue,
                isLoading: _ctrl.isLoading.value,
                backgroundColor: AppColors.secondaryColor,
                textColor: AppColors.primaryColor,
                trailingIcon: const Icon(
                  Icons.double_arrow_rounded,
                  color: AppColors.primaryColor,
                  size: 18,
                ),
                borderRadius: 14,
                height: 52,
              )),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Field Label ─────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.body.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: Dimensions.fs(14),
        color: AppColors.blackColor.withOpacity(0.8),
      ),
    );
  }
}

// ─── Status Dropdown Field ────────────────────────────────────────────────────
class _StatusDropdown extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;

  const _StatusDropdown({required this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          readOnly: true,
          style: AppTextStyles.body.copyWith(
            color: AppColors.blackColor,
            fontSize: Dimensions.fs(14),
          ),
          decoration: InputDecoration(
            hintText: AppStrings.activeStatus.tr,
            hintStyle: AppTextStyles.hint,
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.greyColor,
            ),
            filled: true,
            fillColor: AppColors.whiteColor,
            contentPadding: Dimensions.pSym(h: 16, v: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.r(12)),
              borderSide:
                  BorderSide(color: AppColors.greyColor.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.r(12)),
              borderSide:
                  BorderSide(color: AppColors.greyColor.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.r(12)),
              borderSide:
                  const BorderSide(color: AppColors.primaryColor, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Status Bottom Sheet ──────────────────────────────────────────────────────
class _StatusSheet extends StatelessWidget {
  final List<String> items;
  final String selected;
  final void Function(String) onSelect;

  const _StatusSheet({
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Dimensions.r(20))),
      ),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: Dimensions.h(12)),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: Dimensions.h(20)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.productStatusLabel.tr,
                style: AppTextStyles.body.copyWith(
                  fontSize: Dimensions.fs(18),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(height: Dimensions.h(12)),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(20),
                vertical: Dimensions.h(8),
              ),
              itemCount: items.length,
              separatorBuilder: (_, __) => Divider(
                  height: 1, color: AppColors.greyColor.withOpacity(0.1)),
              itemBuilder: (_, i) {
                final item = items[i];
                final isChosen = item == selected;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item,
                    style: AppTextStyles.body.copyWith(
                      fontSize: Dimensions.fs(15),
                      fontWeight: isChosen ? FontWeight.w700 : FontWeight.w500,
                      color: isChosen
                          ? AppColors.primaryColor
                          : AppColors.blackColor,
                    ),
                  ),
                  trailing: isChosen
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.primaryColor, size: 18)
                      : const Icon(Icons.arrow_forward_ios_rounded,
                          size: 14, color: AppColors.greyColor),
                  onTap: () => onSelect(item),
                );
              },
            ),
          ),
          SizedBox(height: Dimensions.h(30)),
        ],
      ),
    );
  }
}
