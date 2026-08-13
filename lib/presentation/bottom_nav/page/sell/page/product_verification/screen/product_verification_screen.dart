import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bestkits/core/responsive_layout/dimensions.dart';
import 'package:bestkits/utils/app_colors/app_colors.dart';
import 'package:bestkits/utils/app_text_style/app_text_style.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:bestkits/widget/app_button.dart';
import 'package:bestkits/widget/app_text_field.dart';
import 'package:bestkits/widget/custom_appbar.dart';
import 'package:bestkits/widget/show_snackbar.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/add_product/controller/add_product_controller.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/product_verification/controller/product_verification_controller.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/product_verification/widget/photo_requirement_widget.dart';

class ProductVerificationScreen extends StatefulWidget {
  const ProductVerificationScreen({super.key});

  @override
  State<ProductVerificationScreen> createState() =>
      _ProductVerificationScreenState();
}

class _ProductVerificationScreenState extends State<ProductVerificationScreen> {
  late final ProductVerificationController _ctrl;
  late final AddProductController _addCtrl;

  final _brandController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(ProductVerificationController());
    _addCtrl = Get.find<AddProductController>();
  }

  @override
  void dispose() {
    _brandController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  // ── Open brand bottom-sheet ────────────────────────────────────────────────
  void _openBrandDropdown() {
    Get.bottomSheet(
      _SearchableDropdownSheet(
        title: 'Select Brand',
        items: _ctrl.brandNames,
        selected: _brandController.text,
        onSelect: (val) {
          setState(() => _brandController.text = val);
          _categoryController.clear();
          _ctrl.selectBrandByName(val);
          Get.back();
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // ── Open category bottom-sheet ─────────────────────────────────────────────
  void _openCategoryDropdown() {
    final cats = _ctrl.categoryNames;
    if (cats.isEmpty) {
      ShowAppSnackBar.info('Please select a brand first');
      return;
    }
    Get.bottomSheet(
      _SearchableDropdownSheet(
        title: AppStrings.productCategoryLabel.tr,
        items: cats,
        selected: _categoryController.text,
        onSelect: (val) {
          setState(() => _categoryController.text = val);
          _ctrl.selectCategoryByName(val);
          Get.back();
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // ── Confirm dialog ─────────────────────────────────────────────────────────
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
                // Icon
                Container(
                  padding: EdgeInsets.all(Dimensions.w(16)),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified_user_outlined,
                    color: AppColors.primaryColor,
                    size: Dimensions.icon(32),
                  ),
                ),
                SizedBox(height: Dimensions.h(20)),
                Text(
                  'Submit for Verification!',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: Dimensions.fs(18),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Dimensions.h(10)),
                Text(
                  'Are you sure you want to submit this product for authenticity verification? Once submitted, it will be reviewed by LegitGrails before it can be published on BestKits.',
                  style: AppTextStyles.body.copyWith(
                    fontSize: Dimensions.fs(13),
                    color: AppColors.greyColor,
                    height: 1.5,
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
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: Dimensions.w(12)),
                    Expanded(
                      child: AppButton(
                        label: 'Confirm',
                        onPressed: () async {
                          Get.back();
                          _ctrl.productName = _addCtrl.name.value;
                          final outcome = await _ctrl.submitVerification();
                          if (outcome != null) {
                            _showOutcomeToast(outcome);
                            Get.until((route) => route.isFirst);
                          } else {
                            ShowAppSnackBar.error(
                                'Verification submission failed. Please try again.');
                          }
                        },
                        backgroundColor: AppColors.blackColor,
                        textColor: AppColors.primaryColor,
                        borderRadius: 12,
                        height: 48,
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

  // ── Show outcome-specific toast ───────────────────────────────────────────
  void _showOutcomeToast(String outcome) {
    switch (outcome.toLowerCase()) {
      case 'authentic':
        ShowAppSnackBar.success(
          'Your product is Authentic! 🎉 It will be published after final review.',
          title: 'Authentic',
        );
        break;
      case 'fake':
        ShowAppSnackBar.error(
          'Your product was flagged as Fake. Please review and resubmit.',
          title: 'Not Authentic',
        );
        break;
      case 'utv':
        ShowAppSnackBar.info(
          'Unable to Verify (UTV) — our team needs additional photos. Please resubmit.',
          title: 'Unable to Verify',
        );
        break;
      default:
        ShowAppSnackBar.success(
          'Product submitted for verification! It will be reviewed by LegitGrails.',
        );
    }
  }

  // ── Validate and submit ────────────────────────────────────────────────────
  void _onSubmit() {
    if (_ctrl.selectedBrand.value == null) {
      ShowAppSnackBar.error('Please select a brand');
      return;
    }
    if (_ctrl.selectedCategory.value == null) {
      ShowAppSnackBar.error('Please select a category');
      return;
    }
    if (!_ctrl.allRequiredPhotosFilled) {
      ShowAppSnackBar.error(
          'Please upload at least one photo for each required section');
      return;
    }
    _showVerificationAlert();
  }

  // ── Mock outcome color helper ──────────────────────────────────────────────
  Color _outcomeColor(String outcome) {
    switch (outcome.toLowerCase()) {
      case 'authentic':
        return Colors.green;
      case 'fake':
        return Colors.red;
      case 'utv':
        return Colors.orange;
      default:
        return AppColors.primaryColor;
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(title: AppStrings.addProductTitle.tr),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(20),
                vertical: Dimensions.h(20),
              ),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Info banner ───────────────────────────────────────────
                  _InfoBanner(),
                  SizedBox(height: Dimensions.h(24)),

                  // ── Brand ─────────────────────────────────────────────────
                  _FieldLabel(label: 'Brand'),
                  SizedBox(height: Dimensions.h(8)),
                  Obx(() => _TappableField(
                        controller: _brandController,
                        hint: _ctrl.isLoadingBrands.value
                            ? 'Loading brands…'
                            : 'Select Brand',
                        enabled: !_ctrl.isLoadingBrands.value,
                        isLoading: _ctrl.isLoadingBrands.value,
                        onTap: _openBrandDropdown,
                      )),
                  SizedBox(height: Dimensions.h(18)),

                  // ── Category ──────────────────────────────────────────────
                  _FieldLabel(label: AppStrings.productCategoryLabel.tr),
                  SizedBox(height: Dimensions.h(8)),
                  Obx(() {
                    final hasCats = _ctrl.availableCategories.isNotEmpty;
                    return _TappableField(
                      controller: _categoryController,
                      hint:
                          hasCats ? 'Select Category' : 'Select a brand first',
                      enabled: hasCats,
                      onTap: _openCategoryDropdown,
                    );
                  }),
                  SizedBox(height: Dimensions.h(28)),

                  // ── Dynamic photo requirements ────────────────────────────
                  Obx(() {
                    if (_ctrl.isLoadingPhotoRequirements.value) {
                      return _LoadingPhotoRequirements();
                    }
                    if (_ctrl.photoRequirements.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FieldLabel(label: 'Photo Requirements'),
                        SizedBox(height: Dimensions.h(4)),
                        Text(
                          'Upload clear, well-lit photos for each category below.',
                          style: AppTextStyles.hint.copyWith(
                            fontSize: Dimensions.fs(12),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: Dimensions.h(14)),
                        ..._ctrl.photoRequirements.map(
                            (req) => PhotoRequirementWidget(requirement: req)),
                        SizedBox(height: Dimensions.h(24)),

                        // ── Mock outcome selector ─────────────────────────
                        _FieldLabel(label: 'Test Outcome (Mock)'),
                        SizedBox(height: Dimensions.h(4)),
                        Text(
                          'Select the simulated verification result for testing.',
                          style: AppTextStyles.hint.copyWith(
                            fontSize: Dimensions.fs(12),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: Dimensions.h(12)),
                        Obx(() => Row(
                              children: ProductVerificationController
                                  .mockOutcomeOptions
                                  .map((option) {
                                final isSelected =
                                    _ctrl.mockOutcome.value == option;
                                return Padding(
                                  padding:
                                      EdgeInsets.only(right: Dimensions.w(10)),
                                  child: GestureDetector(
                                    onTap: () =>
                                        _ctrl.mockOutcome.value = option,
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.w(16),
                                        vertical: Dimensions.h(10),
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? _outcomeColor(option)
                                                .withOpacity(0.12)
                                            : AppColors
                                                .textFieldBackgroundColor,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.r(10)),
                                        border: Border.all(
                                          color: isSelected
                                              ? _outcomeColor(option)
                                              : AppColors.greyColor
                                                  .withOpacity(0.25),
                                          width: isSelected ? 1.5 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isSelected
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_unchecked,
                                            size: Dimensions.icon(16),
                                            color: isSelected
                                                ? _outcomeColor(option)
                                                : AppColors.greyColor,
                                          ),
                                          SizedBox(width: Dimensions.w(6)),
                                          Text(
                                            option.toUpperCase(),
                                            style: AppTextStyles.body.copyWith(
                                              fontSize: Dimensions.fs(12),
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? _outcomeColor(option)
                                                  : AppColors.greyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )),
                        SizedBox(height: Dimensions.h(8)),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),

          // ── Bottom submit bar ─────────────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.w(20),
              vertical: Dimensions.h(16),
            ),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              border: Border(
                top: BorderSide(color: AppColors.greyColor.withOpacity(0.12)),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackColor.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Obx(() => AppButton(
                  label: 'Submit For Verification >>',
                  onPressed: _ctrl.isSubmitting.value ? null : _onSubmit,
                  isLoading: _ctrl.isSubmitting.value,
                  backgroundColor: AppColors.blackColor,
                  textColor: AppColors.primaryColor,
                  borderRadius: 14,
                  height: 52,
                )),
          ),
        ],
      ),
    );
  }
}

// ── Local private widgets ──────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.w(14)),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(Dimensions.r(12)),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            color: AppColors.primaryColor,
            size: Dimensions.icon(20),
          ),
          SizedBox(width: Dimensions.w(10)),
          Expanded(
            child: Text(
              'Select a brand and category to see exactly which photos LegitGrails needs to verify your item.',
              style: AppTextStyles.body.copyWith(
                fontSize: Dimensions.fs(12),
                color: AppColors.darkGreyColor,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
        color: AppColors.blackColor.withOpacity(0.85),
      ),
    );
  }
}

/// A read-only tappable field that looks like a dropdown.
class _TappableField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final VoidCallback? onTap;
  final bool enabled;
  final bool isLoading;

  const _TappableField({
    required this.controller,
    required this.hint,
    required this.onTap,
    this.enabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AbsorbPointer(
        child: AppTextField(
          controller: controller,
          hint: hint,
          readOnly: true,
          suffixIcon: isLoading
              ? Padding(
                  padding: EdgeInsets.all(Dimensions.w(12)),
                  child: SizedBox(
                    width: Dimensions.w(18),
                    height: Dimensions.h(18),
                    child: const CircularProgressIndicator(
                      strokeWidth: 1.8,
                      color: AppColors.greyColor,
                    ),
                  ),
                )
              : Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: enabled
                      ? AppColors.blackColor.withOpacity(0.5)
                      : AppColors.greyColor,
                  size: Dimensions.icon(22),
                ),
        ),
      ),
    );
  }
}

class _LoadingPhotoRequirements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.h(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: AppColors.blackColor,
              strokeWidth: 2,
            ),
            SizedBox(height: Dimensions.h(14)),
            Text(
              'Loading photo requirements…',
              style: AppTextStyles.hint.copyWith(
                fontSize: Dimensions.fs(13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Searchable dropdown bottom-sheet ──────────────────────────────────────────

class _SearchableDropdownSheet extends StatefulWidget {
  final String title;
  final List<String> items;
  final String selected;
  final void Function(String) onSelect;

  const _SearchableDropdownSheet({
    required this.title,
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  @override
  State<_SearchableDropdownSheet> createState() =>
      _SearchableDropdownSheetState();
}

class _SearchableDropdownSheetState extends State<_SearchableDropdownSheet> {
  late List<String> _filtered;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _searchCtrl.addListener(() {
      final q = _searchCtrl.text.toLowerCase();
      setState(() {
        _filtered = widget.items
            .where((item) => item.toLowerCase().contains(q))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

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
            // ── Drag handle ─────────────────────────────────────────────────
            SizedBox(height: Dimensions.h(12)),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(0.25),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: Dimensions.h(18)),
        
            // ── Title ───────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title,
                  style: AppTextStyles.h3,
                ),
              ),
            ),
            SizedBox(height: Dimensions.h(14)),
        
            // ── Search field ─────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
              child: AppTextField(
                controller: _searchCtrl,
                hint: 'Search…',
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.greyColor,
                  size: Dimensions.icon(20),
                ),
              ),
            ),
            SizedBox(height: Dimensions.h(4)),
        
            // ── List ─────────────────────────────────────────────────────────
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.45),
              child: _filtered.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: Dimensions.h(32)),
                      child: Text(
                        'No results found',
                        style: AppTextStyles.hint
                            .copyWith(fontSize: Dimensions.fs(13)),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.w(20),
                          vertical: Dimensions.h(8)),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => Divider(
                          height: 1, color: AppColors.greyColor.withOpacity(0.1)),
                      itemBuilder: (_, i) {
                        final item = _filtered[i];
                        final isChosen = item == widget.selected;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(
                            item,
                            style: AppTextStyles.body.copyWith(
                              fontSize: Dimensions.fs(14),
                              fontWeight:
                                  isChosen ? FontWeight.w700 : FontWeight.w400,
                              color: isChosen
                                  ? AppColors.blackColor
                                  : AppColors.darkGreyColor,
                            ),
                          ),
                          trailing: Icon(
                            isChosen
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: isChosen
                                ? AppColors.blackColor
                                : AppColors.greyColor,
                            size: Dimensions.icon(20),
                          ),
                          onTap: () => widget.onSelect(item),
                        );
                      },
                    ),
            ),
            SizedBox(height: Dimensions.h(32)),
          ],
        ),
      ),
    );
  }
}
