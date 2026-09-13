import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:bestkits/presentation/currency_preference/widget/currency_helper.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_icons/app_icons.dart';
import '../../../../utils/static_strings/static_strings.dart';
import '../../../../widget/app_button.dart';
import '../controller/checkout_controller.dart';

/// "Pay in Full" / "Installment Plan" section shown right above the final
/// Proceed To Pay button on the checkout screen.
///
/// Installment options are loaded from the calculations GET API.
class CheckoutPaymentPlanSection extends StatelessWidget {
  final CheckoutController controller;

  const CheckoutPaymentPlanSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PlanTypeToggle(controller: controller),
        const SizedBox(height: 14),
        Obx(() {
          return controller.paymentPlanType.value == PaymentPlanType.full
              ? _PayInFullCard(controller: controller)
              : _InstallmentPlanList(controller: controller);
        }),
        const SizedBox(height: 16),
        const _PaymentMethodsRow(),
        const SizedBox(height: 20),
        Obx(() => AppButton(
              label: AppStrings.proceedToPay.tr,
              isLoading: controller.isSubmittingOrder.value,
              onPressed: controller.termsAgreed.value
                  ? () {
                      if (controller.paymentPlanType.value ==
                          PaymentPlanType.full) {
                        controller.placeOrder();
                      } else {
                        controller.placeInstallmentOrder();
                      }
                    }
                  : null,
              backgroundColor: AppColors.darkColor,
              textColor: AppColors.primaryColor,
              borderSideColor: AppColors.darkColor,
              leadingIcon:
                  Icon(Icons.sell, color: AppColors.primaryColor, size: 18),
              borderRadius: 12,
              height: 52,
            )),
      ],
    );
  }
}

class _PlanTypeToggle extends StatelessWidget {
  final CheckoutController controller;

  const _PlanTypeToggle({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isFull = controller.paymentPlanType.value == PaymentPlanType.full;
      return Row(
        children: [
          Expanded(
            child: _ToggleChip(
              label: AppStrings.payInFull.tr,
              selected: isFull,
              onTap: () =>
                  controller.selectPaymentPlanType(PaymentPlanType.full),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ToggleChip(
              label: AppStrings.installmentPlan.tr,
              selected: !isFull,
              onTap: () =>
                  controller.selectPaymentPlanType(PaymentPlanType.installment),
            ),
          ),
        ],
      );
    });
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.darkColor : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? AppColors.darkColor
                : AppColors.greyColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primaryColor : Colors.transparent,
                border: Border.all(
                  color:
                      selected ? AppColors.primaryColor : AppColors.greyColor,
                  width: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: selected ? AppColors.primaryColor : AppColors.greyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PayInFullCard extends StatelessWidget {
  final CheckoutController controller;

  const _PayInFullCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.creamHighlightColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryColor, width: 2),
                ),
                child: Center(
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                AppStrings.payInFull.tr,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Obx(() => Text(
                CurrencyHelper.formatPrice(controller.total),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              )),
          const SizedBox(height: 2),
          Text(
            AppStrings.oneTimePayment.tr,
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: AppColors.greyColor,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatInstallmentAmount(double amount, String currency) {
  final symbol = CurrencyHelper.currencies.firstWhere(
    (entry) => entry['name'] == currency,
    orElse: () => {'symbol': '$currency '},
  )['symbol']!;
  return '$symbol${amount.toStringAsFixed(2)}';
}

class _InstallmentPlanList extends StatelessWidget {
  final CheckoutController controller;

  const _InstallmentPlanList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final options = controller.installmentPlanOptions;
      final selectedIndex = controller.selectedInstallmentIndex.value;
      if (controller.isLoadingInstallmentPlans.value && options.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      if (options.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text('No installment plans available.'),
        );
      }
      return Column(
        children: List.generate(options.length, (index) {
          final option = options[index];
          final selected = index == selectedIndex;
          return Semantics(
            selected: selected,
            button: true,
            child: GestureDetector(
              onTap: () => controller.selectInstallmentOption(index),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: index == options.length - 1 ? 0 : 12),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFFAF8EE) : const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: selected ? AppColors.primaryColor : Colors.transparent,
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            margin: const EdgeInsets.only(top: 1),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: selected ? AppColors.primaryColor : AppColors.greyColor),
                            ),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selected ? AppColors.primaryColor : Colors.transparent,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 76),
                                  child: Text('${option.months} ${AppStrings.monthsUnit.tr}',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${_formatInstallmentAmount(option.monthlyAmount, option.currency)} ${AppStrings.perMonthSuffix.tr}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, fontStyle: FontStyle.italic),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${AppStrings.total.tr} ${_formatInstallmentAmount(option.totalAmount, option.currency)}',
                                  style: TextStyle(fontSize: 12, color: AppColors.greyColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFDFF1ED),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12)),
                        ),
                        child: Text(
                          '${AppStrings.aprLabel.tr} ${option.aprPercent}%',
                          style: TextStyle(fontSize: 10, color: AppColors.discountGreenColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    });
  }
}
class _PaymentMethodsCard extends StatelessWidget {
  const _PaymentMethodsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBorderColor, width: 1),
      ),
      child: const _PaymentMethodsRow(),
    );
  }
}

class _PaymentMethodsRow extends StatelessWidget {
  const _PaymentMethodsRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(width: 1, color: AppColors.greyColor.withOpacity(0.5)),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _CardBadge(imagePath: AppIcons.visa),
              _CardBadge(imagePath: AppIcons.amex),
              _CardBadge(imagePath: AppIcons.mastercard),
              _CardBadge(imagePath: AppIcons.tbi),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.supportedPaymentCountries.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.blackColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardBadge extends StatelessWidget {
  final String imagePath;

  const _CardBadge({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 31,
      alignment: Alignment.center,
      child: Image.asset(imagePath, fit: BoxFit.cover),
    );
  }
}
