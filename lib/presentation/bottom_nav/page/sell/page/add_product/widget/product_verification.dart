import 'dart:io' as dart_io;
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
import '../controller/add_product_controller.dart';

class ProductVerification extends StatefulWidget {
  const ProductVerification({super.key});

  @override
  State<ProductVerification> createState() => _ProductVerificationState();
}

class _ProductVerificationState extends State<ProductVerification> {
  final _formKey = GlobalKey<FormState>();
  final AddProductController _ctrl = Get.find<AddProductController>();

  final _brandController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill category if already selected
    if (_ctrl.selectedCategory.value.isNotEmpty) {
      _categoryController.text = _ctrl.selectedCategory.value;
    }
  }

  @override
  void dispose() {
    _brandController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _openDropdown(
      String title, List<String> items, TextEditingController ctrl) {
    Get.bottomSheet(
      _DropdownSheet(
        title: title,
        items: items,
        selected: ctrl.text,
        onSelect: (val) {
          setState(() {
            ctrl.text = val;
            if (ctrl == _brandController) {
              _ctrl.selectedBrand.value = val;
            }
          });
          Get.back();
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showVerificationAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.r(20)),
          ),
          child: Padding(
            padding: EdgeInsets.all(Dimensions.w(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(Dimensions.w(16)),
                  decoration: BoxDecoration(
                    color: AppColors.redColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Dimensions.r(16)),
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.redColor,
                    size: Dimensions.icon(32),
                  ),
                ),
                SizedBox(height: Dimensions.h(20)),
                Text(
                  'Submit for Verification !',
                  style: AppTextStyles.body.copyWith(
                    fontSize: Dimensions.fs(18),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Dimensions.h(12)),
                Text(
                  'Are you sure you want to submit this product for authenticity verification? Once submitted, your product will be reviewed by LegitGrails before it can be published on BestKits.',
                  style: AppTextStyles.body.copyWith(
                    fontSize: Dimensions.fs(13),
                    fontWeight: FontWeight.w400,
                    color: AppColors.greyColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Dimensions.h(24)),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(vertical: Dimensions.h(14)),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Dimensions.r(12)),
                          ),
                          side: BorderSide(
                              color: AppColors.greyColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTextStyles.body.copyWith(
                            fontSize: Dimensions.fs(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: Dimensions.w(12)),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back(); // close dialog
                          // Proceed with actual API submit if needed. For now just show success.
                          AppAlerts.success(
                              message: AppStrings.productPublishedSuccess.tr);
                          Get.until((route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blackColor,
                          padding:
                              EdgeInsets.symmetric(vertical: Dimensions.h(14)),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Dimensions.r(12)),
                          ),
                        ),
                        child: Text(
                          'Confirm',
                          style: AppTextStyles.body.copyWith(
                            fontSize: Dimensions.fs(14),
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    _showVerificationAlert();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(title: AppStrings.addProductTitle.tr),
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
                    // ── Upload Product Images ────────────────────────────
                    _FieldLabel(label: AppStrings.uploadProductImages.tr),
                    SizedBox(height: Dimensions.h(8)),
                    _VerificationImagePickerBox(
                      images: _ctrl.verificationImages,
                      onPick: _ctrl.pickVerificationImages,
                      onRemove: _ctrl.removeVerificationImage,
                    ),
                    SizedBox(height: Dimensions.h(24)),

                    // ── Brand ────────────────────────────────────────────
                    _FieldLabel(label: 'Brand'),
                    SizedBox(height: Dimensions.h(8)),
                    Obx(() {
                      final brands = _ctrl.brandNames.toList();
                      return _DropdownField(
                        controller: _brandController,
                        hint: 'Select Brand',
                        onTap: () =>
                            _openDropdown('Brand', brands, _brandController),
                      );
                    }),
                    SizedBox(height: Dimensions.h(18)),

                    // ── Category ─────────────────────────────────────────
                    _FieldLabel(label: AppStrings.productCategoryLabel.tr),
                    SizedBox(height: Dimensions.h(8)),
                    Obx(() {
                      final cats = _ctrl.categoryNames.toList();
                      return _DropdownField(
                        controller: _categoryController,
                        hint: 'Select Category',
                        onTap: () => _openDropdown(
                            AppStrings.productCategoryLabel.tr,
                            cats,
                            _categoryController),
                      );
                    }),
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
                    label: 'Submit For Verification >>',
                    onPressed: _ctrl.isLoading.value ? null : _onSubmit,
                    isLoading: _ctrl.isLoading.value,
                    backgroundColor: AppColors.blackColor,
                    textColor: AppColors.primaryColor,
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

// ─── Verification Image Picker Box ─────────────────────────────────────────────
class _VerificationImagePickerBox extends StatelessWidget {
  final RxList<dart_io.File> images;
  final Future<void> Function() onPick;
  final void Function(int) onRemove;

  const _VerificationImagePickerBox({
    required this.images,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPick,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.h(24), horizontal: Dimensions.w(20)),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(Dimensions.r(12)),
              border: Border.all(
                color: AppColors.greyColor.withOpacity(0.2),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  color: AppColors.blackColor,
                  size: Dimensions.icon(32),
                ),
                SizedBox(height: Dimensions.h(12)),
                Text(
                  'Upload Clear, Well-Lit Photos Of Your Product, Including The Front, Back, Left And Right Sides, Brand Label, Logo, And Any Serial Number If Available. You May Also Include The Original Box And Proof Of Purchase To Help With The Verification Process.',
                  style: AppTextStyles.hint.copyWith(
                    fontSize: Dimensions.fs(12),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        Obx(() {
          if (images.isEmpty) return const SizedBox.shrink();
          return Column(
            children: [
              SizedBox(height: Dimensions.h(12)),
              SizedBox(
                height: Dimensions.h(80),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  separatorBuilder: (_, __) => SizedBox(width: Dimensions.w(8)),
                  itemBuilder: (_, i) => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.r(10)),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.greyColor.withOpacity(0.2)),
                            borderRadius:
                                BorderRadius.circular(Dimensions.r(10)),
                          ),
                          child: Image.file(
                            images[i],
                            width: Dimensions.w(80),
                            height: Dimensions.h(80),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -6,
                        right: -6,
                        child: GestureDetector(
                          onTap: () => onRemove(i),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColors.greyColor.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                color: AppColors.whiteColor, size: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

// ─── Dropdown Field ───────────────────────────────────────────────────────────
class _DropdownField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final VoidCallback onTap;

  const _DropdownField(
      {required this.controller, required this.hint, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          readOnly: true,
          style: AppTextStyles.body.copyWith(
              color: AppColors.blackColor, fontSize: Dimensions.fs(14)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.hint,
            suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.greyColor),
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

// ─── Dropdown Bottom Sheet ──────────────────────────────────────────────────────
class _DropdownSheet extends StatelessWidget {
  final String title;
  final List<String> items;
  final String selected;
  final void Function(String) onSelect;

  const _DropdownSheet(
      {required this.title,
      required this.items,
      required this.selected,
      required this.onSelect});

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
      child: SingleChildScrollView(
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
                child: Text(title,
                    style: AppTextStyles.body.copyWith(
                        fontSize: Dimensions.fs(18),
                        fontWeight: FontWeight.w700)),
              ),
            ),
            SizedBox(height: Dimensions.h(12)),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.w(20), vertical: Dimensions.h(8)),
                itemCount: items.length,
                separatorBuilder: (_, __) => Divider(
                    height: 1, color: AppColors.greyColor.withOpacity(0.1)),
                itemBuilder: (_, i) {
                  final item = items[i];
                  final isChosen = item == selected;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item,
                        style: AppTextStyles.body.copyWith(
                          fontSize: Dimensions.fs(14),
                          fontStyle: FontStyle.italic,
                          fontWeight:
                              isChosen ? FontWeight.w600 : FontWeight.w400,
                          color: AppColors.blackColor,
                        )),
                    trailing: Icon(
                      isChosen
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isChosen
                          ? AppColors.blackColor.withOpacity(0.7)
                          : AppColors.greyColor,
                      size: 20,
                    ),
                    onTap: () => onSelect(item),
                  );
                },
              ),
            ),
            SizedBox(height: Dimensions.h(30)),
          ],
        ),
      ),
    );
  }
}
