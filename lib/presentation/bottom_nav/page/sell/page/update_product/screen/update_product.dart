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
import '../controller/update_product_controller.dart';

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({super.key});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final _formKey = GlobalKey<FormState>();
  late final UpdateProductController _ctrl;

  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  final _categoryController = TextEditingController();
  final _subCategoryController = TextEditingController();

  final _priceController = TextEditingController();
  final _discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Reuse existing controller if already put, otherwise create one
    _ctrl = Get.isRegistered<UpdateProductController>()
        ? Get.find<UpdateProductController>()
        : Get.put(UpdateProductController());

    // Load actual product data
    final product = _ctrl.product;
    _nameController.text = product['name']?.toString() ?? '';
    _descController.text = product['description']?.toString() ?? '';
    _priceController.text = product['original_price']?.toString() ?? '';
    _discountController.text = product['discounted_price']?.toString() ?? '';
    _selectedCondition = product['condition']?.toString() == 'USED' ? 'Used' : 'New';
    
    // Set category
    final category = product['category'];
    if (category is Map) {
      _categoryController.text = category['name']?.toString() ?? '';
    } else if (category != null) {
      _categoryController.text = category.toString();
    }
    
    // Set sub-category
    final subCat = product['sub_category'];
    if (subCat != null) {
      _subCategoryController.text = subCat.toString();
    }
    
    // Condition toggle will be initialized
  }

  // Condition toggle
  final List<String> _conditions = ['New', 'Used'];
  String _selectedCondition = 'New';

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



  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    _subCategoryController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _toggleCondition(String condition) {
    setState(() {
      _selectedCondition = condition;
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
    _ctrl.price.value = _priceController.text;
    _ctrl.discount.value = _discountController.text;
    _ctrl.condition.value = _selectedCondition;

    _ctrl.updateProductApi(
      price: double.tryParse(_priceController.text) ?? 0.0,
      discountPrice: double.tryParse(_discountController.text) ?? 0.0,
      status: 'ACTIVE',
    ).then((error) {
      if (error == null) {
        AppAlerts.success(message: 'Product updated successfully!');
        Get.until((route) => route.isFirst);
      } else {
        AppAlerts.error(message: error);
      }
    });
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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(20),
                  vertical: Dimensions.h(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Upload Product Images ──────────────────────────────
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
                      hint: 'Kids Soft Fit Sneakers',
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
                        hint: 'Kids Shoes',
                        onTap: () => _openDropdown(
                            AppStrings.productCategoryLabel.tr,
                            cats,
                            _categoryController),
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
                        hint: 'Kids Sneakers',
                        onTap: () => _openDropdown(
                          AppStrings.productSubcategoryLabel.tr,
                          subs,
                          _subCategoryController,
                        ),
                      );
                    }),
                    SizedBox(height: Dimensions.h(16)),

                    // ── Price ────────────────────────────────────────────
                    _SectionLabel(label: AppStrings.priceLabel.tr),
                    SizedBox(height: Dimensions.h(8)),
                    AppTextField(
                      controller: _priceController,
                      hint: 'Enter product Price',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? AppStrings.priceRequired.tr
                          : null,
                    ),
                    SizedBox(height: Dimensions.h(16)),

                    // ── Discount ─────────────────────────────────────────
                    _SectionLabel(label: 'Discount (%) (Optional)'),
                    SizedBox(height: Dimensions.h(8)),
                    AppTextField(
                      controller: _discountController,
                      hint: 'Enter product Discount %',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: Dimensions.h(16)),

                    // ── Condition ────────────────────────────────────────
                    _SectionLabel(label: 'Product Condition'),
                    SizedBox(height: Dimensions.h(8)),
                    Row(
                      children: [
                        Expanded(
                          child: _ConditionChip(
                            label: 'New',
                            icon: Icons.new_releases_rounded,
                            isSelected: _selectedCondition == 'New',
                            onTap: () => _toggleCondition('New'),
                            selectedColor: AppColors.greenColor,
                            selectedBgColor: AppColors.greenColor.withOpacity(0.15),
                          ),
                        ),
                        SizedBox(width: Dimensions.w(12)),
                        Expanded(
                          child: _ConditionChip(
                            label: 'Used',
                            icon: Icons.history_rounded,
                            isSelected: _selectedCondition == 'Used',
                            onTap: () => _toggleCondition('Used'),
                            selectedColor: AppColors.primaryColor,
                            selectedBgColor: AppColors.primaryColor.withOpacity(0.15),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.h(16)),

                    // ── Description ───────────────────────────────────────
                    _SectionLabel(label: AppStrings.descriptionLabel.tr),
                    SizedBox(height: Dimensions.h(8)),
                    AppTextField(
                      controller: _descController,
                      hint: AppStrings.enterProductDescription.tr,
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
              child: Obx(() => AppButton(
                label: 'Save Changes >>',
                onPressed: _ctrl.isLoading.value ? null : _onContinue,
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

// ─────────────────────────────────────────────────────────────────────────────
// Helper widgets
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
        // ── Upload tap area ──────────────────────────────────────────────────
        GestureDetector(
          onTap: onPick,
          child: Container(
            height: Dimensions.h(50),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.textFieldBackgroundColor,
              borderRadius: BorderRadius.circular(Dimensions.r(12)),
              border: Border.all(
                color: AppColors.greyColor.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  color: AppColors.greyColor,
                  size: Dimensions.icon(20),
                ),
                SizedBox(width: Dimensions.w(8)),
                Text(
                  AppStrings.uploadImagesHere.tr,
                  style:
                      AppTextStyles.hint.copyWith(fontSize: Dimensions.fs(13)),
                ),
              ],
            ),
          ),
        ),

        // ── Image preview list (reactive) ────────────────────────────────────
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
          child: Image.file(
            file,
            width: Dimensions.w(80),
            height: Dimensions.h(80),
            fit: BoxFit.cover,
          ),
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
                color: AppColors.blackColor,
                shape: BoxShape.circle,
              ),
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

  const _DropdownField({
    required this.controller,
    required this.hint,
    required this.onTap,
  });

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
            hintText: hint,
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

// ─── Condition Chip ─────────────────────────────────────────────────────────────
class _ConditionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color selectedBgColor;

  const _ConditionChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.selectedBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.h(14)),
        decoration: BoxDecoration(
          color: isSelected ? selectedBgColor : AppColors.textFieldBackgroundColor,
          borderRadius: BorderRadius.circular(Dimensions.r(12)),
          border: Border.all(
            color: isSelected ? selectedColor : AppColors.greyColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? selectedColor : AppColors.greyColor,
              size: 18,
            ),
            SizedBox(width: Dimensions.w(8)),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                fontSize: Dimensions.fs(14),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? selectedColor : AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
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
                  fontSize: Dimensions.fs(18),
                  fontWeight: FontWeight.w700,
                ),
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
                horizontal: Dimensions.w(20),
                vertical: Dimensions.h(8),
              ),
              itemCount: items.length,
              separatorBuilder: (_, __) => Divider(
                  height: 1, color: AppColors.greyColor.withOpacity(0.1)),
              itemBuilder: (_, i) {
                final item = items[i];
                final isChosen = item == selected;
                return Material(
                  color: Colors.transparent,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      item,
                      style: AppTextStyles.body.copyWith(
                        fontSize: Dimensions.fs(14),
                        fontStyle: FontStyle.italic,
                        fontWeight: isChosen ? FontWeight.w600 : FontWeight.w400,
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
                  ),
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
