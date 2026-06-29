import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../widget/app_text_field.dart';
import '../../../../widget/app_validation.dart';
import '../../../../widget/app_button.dart';
import '../controller/checkout_controller.dart';

class CheckoutCouponSection extends StatefulWidget {
  final CheckoutController controller;

  const CheckoutCouponSection({super.key, required this.controller});

  @override
  State<CheckoutCouponSection> createState() => _CheckoutCouponSectionState();
}

class _CheckoutCouponSectionState extends State<CheckoutCouponSection> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Title Header
                const Text(
                  '- Apply Coupon',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 16),

                // TextField and Apply Button Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: widget.controller.couponController,
                        readOnly: widget.controller.isCouponApplied.value,
                        hint: 'Enter coupon code',
                        radius: 10,
                        validator: AppValidators.required(
                            message: 'Coupon code cannot be empty'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 48,
                      child: AppButton(
                        width: 90,
                        height: 48,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        borderRadius: 10,
                        backgroundColor: widget.controller.isCouponApplied.value
                            ? AppColors.blackColor
                            : AppColors.primaryColor,
                        textColor: widget.controller.isCouponApplied.value
                            ? AppColors.primaryColor
                            : AppColors.blackColor,
                        borderSideColor: widget.controller.isCouponApplied.value
                            ? AppColors.blackColor
                            : AppColors.primaryColor,
                        label: widget.controller.isCouponApplied.value
                            ? 'Remove'
                            : 'Apply',
                        onPressed: () {
                          if (widget.controller.isCouponApplied.value) {
                            widget.controller.removeCoupon();
                          } else {
                            if (_formKey.currentState?.validate() ?? false) {
                              widget.controller.applyCoupon();
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),

                // Feedback messages
                if (widget.controller.isCouponApplied.value &&
                    widget.controller.couponSuccess.value.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_offer_outlined,
                        color: AppColors.applyCouponCodeColor,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.controller.couponSuccess.value,
                          style: const TextStyle(
                            color: AppColors.applyCouponCodeColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (widget.controller.couponError.value.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.redColor,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.controller.couponError.value,
                          style: TextStyle(
                            color: AppColors.redColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ));
  }
}
