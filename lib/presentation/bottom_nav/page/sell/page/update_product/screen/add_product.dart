import 'dart:io';

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
import 'add_product_price.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  late final AddProductController _ctrl;

  final _nameController = TextEditingController();
  final _sizeController = TextEditingController();
  final _descController = TextEditingController();
  final _categoryController = TextEditingController();
  final _subCategoryController = TextEditingController();

  // ── Category → Sub-category map ──────────────────────────────────────────
  static const Map<String, List<String>> _categoryMap = {
    'Tops & Shirts': [
      'T-Shirts',
      'Casual Shirts',
      'Flannel Shirts',
      'Polo Shirts',
      'Tank Tops',
      'Blouses',
    ],
    'Bottoms': [
      'Denim & Jeans',
      'Trousers & Chinos',
      'Leggings',
      'Shorts',
      'Skirts',
      'Joggers',
    ],
    'Outerwear': [
      'Jackets & Coats',
      'Trench Coats',
      'Hoodies & Sweatshirts',
      'Blazers',
      'Cardigans & Sweaters',
      'Raincoats',
    ],
    'Swimwear': [
      'One-Piece Swimsuits',
      'Bikinis',
      'Swim Shorts',
      'Rash Guards',
      'Cover-Ups',
    ],
    'Accessories': [
      'Beanies & Hats',
      'Baseball Caps',
      'Scarves & Wraps',
      'Belts',
      'Bags & Backpacks',
      'Sunglasses',
    ],
    'Kids Clothing': [
      'Kids Sneakers',
      'Kids Boots',
      'Kids Sandals',
      'Kids Tops',
      'Kids Bottoms',
      'Kids Outerwear',
    ],
    'Footwear': [
      'Sneakers',
      'Boots',
      'Sandals & Slides',
      'Loafers',
      'Heels',
      'Sports Shoes',
    ],
    'Underwear & Socks': [
      'Briefs & Boxers',
      'Bras & Lingerie',
      'Thermal Underwear',
      'Ankle Socks',
      'Knee-High Socks',
      'Tights & Stockings',
    ],
  };

  List<String> get _categories => _categoryMap.keys.toList();

  List<String> get _subCategories {
    final selected = _categoryController.text;
    return _categoryMap[selected] ?? [];
  }

  final List<String> _allSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final List<String> _selectedSizes = [];

  @override
  void initState() {
    super.initState();
    _ctrl = Get.isRegistered<AddProductController>()
        ? Get.find<AddProductController>()
        : Get.put(AddProductController());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sizeController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    _subCategoryController.dispose();
    super.dispose();
  }

  void _toggleSize(String size) {
    setState(() {
      if (_selectedSizes.contains(size)) {
        _selectedSizes.remove(size);
      } else {
        _selectedSizes.add(size);
      }
    });
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
            // Clear sub-category if category changes
            if (title == AppStrings.productCategoryLabel.tr) {
              _subCategoryController.clear();
              _ctrl.updateSubCategories(val);
            }
          });
          Get.back();
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    
    _ctrl.name.value = _nameController.text;
    _ctrl.description.value = _descController.text;
    _ctrl.selectedCategory.value = _categoryController.text;
    _ctrl.selectedSubCategory.value = _subCategoryController.text;
    _ctrl.selectedSizes.assignAll(_selectedSizes);

    Get.to(() => const AddProductPrice());
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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(20),
                  vertical: Dimensions.h(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Upload Product Images ─────────────────────────────
                    _SectionLabel(label: AppStrings.uploadProductImages.tr),
                    SizedBox(height: Dimensions.h(10)),
                    _ImagePickerBox(
                      images: _ctrl.pickedImages,
                      onPick: _ctrl.pickImages,
                      onRemove: _ctrl.removePickedImage,
                    ),
                    SizedBox(height: Dimensions.h(20)),

                    // ── Product Name ──────────────────────────────────────
                    _SectionLabel(label: AppStrings.productNameLabel.tr),
                    SizedBox(height: Dimensions.h(8)),
                    AppTextField(
                      controller: _nameController,
                      hint: AppStrings.enterProductName.tr,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? AppStrings.productNameRequired.tr
                          : null,
                    ),
                    SizedBox(height: Dimensions.h(16)),

                    // ── Product Category ──────────────────────────────────
                    _SectionLabel(label: AppStrings.productCategoryLabel.tr),
                    SizedBox(height: Dimensions.h(8)),
                    Obx(() {
                      final cats = _ctrl.categoryNames.toList();
                      return _DropdownField(
                        controller: _categoryController,
                        hint: AppStrings.selectCategory.tr,
                        onTap: () => _openDropdown(
                            AppStrings.productCategoryLabel.tr, cats, _categoryController),
                      );
                    }),
                    SizedBox(height: Dimensions.h(16)),

                    // ── Product Sub-category ──────────────────────────────
                    _SectionLabel(label: AppStrings.productSubcategoryLabel.tr),
                    SizedBox(height: Dimensions.h(8)),
                    Obx(() {
                      final subs = _ctrl.subCategoryNames.toList();
                      return _DropdownField(
                        controller: _subCategoryController,
                        hint: AppStrings.selectSubcategory.tr,
                        onTap: () => _openDropdown(AppStrings.productSubcategoryLabel.tr,
                            subs, _subCategoryController),
                      );
                    }),
                    SizedBox(height: Dimensions.h(16)),

                    // ── Size / Variant ────────────────────────────────────
                    _SectionLabel(label: AppStrings.sizeVariantLabel.tr),
                    SizedBox(height: Dimensions.h(8)),
                    AppTextField(
                      controller: _sizeController,
                      hint: AppStrings.enterSizesCommas.tr,
                    ),
                    SizedBox(height: Dimensions.h(10)),
                    if (_allSizes.isNotEmpty)
                      _SizeChips(
                        allSizes: _allSizes,
                        selected: _selectedSizes,
                        onToggle: _toggleSize,
                      ),
                    SizedBox(height: Dimensions.h(16)),

                    // ── Description ───────────────────────────────────────
                    _SectionLabel(label: AppStrings.descriptionLabel.tr),
                    SizedBox(height: Dimensions.h(8)),
                    AppTextField(
                      controller: _descController,
                      hint: AppStrings.describeProductDetails.tr,
                      maxLines: 5,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? AppStrings.descriptionRequired.tr
                          : null,
                    ),
                    SizedBox(height: Dimensions.h(24)),
                  ],
                ),
              ),
            ),

            // ── Continue Button ───────────────────────────────────────────
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
              child: AppButton(
                label: AppStrings.continueBtn.tr,
                onPressed: _onContinue,
                backgroundColor: AppColors.secondaryColor,
                textColor: AppColors.primaryColor,
                trailingIcon: const Icon(
                  Icons.double_arrow_rounded,
                  color: AppColors.primaryColor,
                  size: 18,
                ),
                borderRadius: 14,
                height: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared helper widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

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

// ─── Image Picker Box ─────────────────────────────────────────────────────────
class _ImagePickerBox extends StatelessWidget {
  final RxList<File> images;
  final Future<void> Function() onPick;
  final void Function(int) onRemove;

  const _ImagePickerBox({
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
            height: Dimensions.h(50),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.textFieldBackgroundColor,
              borderRadius: BorderRadius.circular(Dimensions.r(12)),
              border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate_outlined,
                    color: AppColors.greyColor, size: Dimensions.icon(20)),
                SizedBox(width: Dimensions.w(8)),
                Text(AppStrings.uploadImagesHere.tr,
                    style: AppTextStyles.hint
                        .copyWith(fontSize: Dimensions.fs(13))),
              ],
            ),
          ),
        ),
        Obx(() {
          if (images.isEmpty) return const SizedBox.shrink();
          return Column(
            children: [
              SizedBox(height: Dimensions.h(10)),
              SizedBox(
                height: Dimensions.h(90),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  separatorBuilder: (_, __) => SizedBox(width: Dimensions.w(8)),
                  itemBuilder: (_, i) =>
                      _ImageThumb(file: images[i], onRemove: () => onRemove(i)),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _ImageThumb extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;
  const _ImageThumb({required this.file, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.r(10)),
          child: Image.file(file,
              width: Dimensions.w(80),
              height: Dimensions.h(80),
              fit: BoxFit.cover),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                  color: AppColors.blackColor, shape: BoxShape.circle),
              child: const Icon(Icons.close,
                  color: AppColors.whiteColor, size: 12),
            ),
          ),
        ),
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

// ─── Size Chips ───────────────────────────────────────────────────────────────
class _SizeChips extends StatelessWidget {
  final List<String> allSizes;
  final List<String> selected;
  final void Function(String) onToggle;

  const _SizeChips(
      {required this.allSizes, required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Dimensions.w(8),
      runSpacing: Dimensions.h(8),
      children: allSizes.map((size) {
        final isSelected = selected.contains(size);
        return GestureDetector(
          onTap: () => onToggle(size),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(12), vertical: Dimensions.h(6)),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.blackColor
                  : AppColors.textFieldBackgroundColor,
              borderRadius: BorderRadius.circular(Dimensions.r(8)),
              border: Border.all(
                color: isSelected
                    ? AppColors.blackColor
                    : AppColors.greyColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  size,
                  style: AppTextStyles.body.copyWith(
                    fontSize: Dimensions.fs(12),
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.blackColor,
                  ),
                ),
                if (isSelected) ...[
                  SizedBox(width: Dimensions.w(4)),
                  Icon(Icons.close, size: 12, color: AppColors.primaryColor),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Dropdown Bottom Sheet ────────────────────────────────────────────────────
class _DropdownSheet extends StatelessWidget {
  final String title;
  final List<String> items;
  final String selected;
  final void Function(String) onSelect;

  const _DropdownSheet({
    required this.title,
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
                child: Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                      fontSize: Dimensions.fs(18), fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(height: Dimensions.h(12)),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5),
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
                    title: Text(
                      item,
                      style: AppTextStyles.body.copyWith(
                        fontSize: Dimensions.fs(14),
                        fontStyle: FontStyle.italic,
                        fontWeight:
                            isChosen ? FontWeight.w600 : FontWeight.w400,
                        color: AppColors.blackColor,
                      ),
                    ),
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
