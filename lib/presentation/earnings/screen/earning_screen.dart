import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_text_style/app_text_style.dart';
import '../../../../widget/custom_appbar.dart';
import '../controller/earning_controller.dart';
import '../widget/earing_card_widget.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  final _ctrl = Get.put(EarningController());

  void _openFilterSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(Dimensions.r(20))),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.h(12)),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.greyColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.h(20)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
                child: Text(
                  'Service Type',
                  style: AppTextStyles.body.copyWith(
                    fontSize: Dimensions.fs(16),
                    color: AppColors.greyColor,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.h(16)),
              ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _ctrl.filterOptions.length,
                    separatorBuilder: (_, __) => Divider(
                        height: 1, color: AppColors.greyColor.withOpacity(0.1)),
                    itemBuilder: (_, i) {
                      final item = _ctrl.filterOptions[i];
                      final isChosen = item == _ctrl.selectedFilter.value;
                      return ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
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
                        onTap: () {
                          _ctrl.setFilter(item);
                          Get.back();
                        },
                      );
                    },
                  ),
              SizedBox(height: Dimensions.h(30)),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CommonAppBar(title: "Earnings"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.w(20), vertical: Dimensions.h(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Earnings Card ──────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(Dimensions.r(16)),
                border:
                    Border.all(color: AppColors.greyColor.withOpacity(0.15)),
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.w(16),
                        vertical: Dimensions.h(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Text(
                              _ctrl.filterTextForDisplay,
                              style: AppTextStyles.body.copyWith(
                                fontSize: Dimensions.fs(14),
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                              ),
                            )),
                        GestureDetector(
                          onTap: _openFilterSheet,
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.w(8)),
                            decoration: BoxDecoration(
                              color: AppColors.blackColor,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.r(8)),
                            ),
                            child: Icon(Icons.tune,
                                color: AppColors.primaryColor,
                                size: Dimensions.icon(16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                      height: 1, color: AppColors.greyColor.withOpacity(0.15)),
                  // Body
                  Padding(
                    padding: EdgeInsets.all(Dimensions.w(16)),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(Dimensions.w(12)),
                          decoration: BoxDecoration(
                            color: AppColors.blackColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.r(12)),
                          ),
                          child: Icon(Icons.account_balance_wallet_outlined,
                              color: AppColors.primaryColor,
                              size: Dimensions.icon(24)),
                        ),
                        SizedBox(width: Dimensions.w(16)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Text(
                                  'Showing ${_ctrl.filterTextForDisplay}',
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: Dimensions.fs(12),
                                    color: AppColors.greyColor,
                                    fontStyle: FontStyle.italic,
                                  ),
                                )),
                            SizedBox(height: Dimensions.h(4)),
                            Obx(() => Text(
                                  '\$ ${_ctrl.totalEarnings}',
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: Dimensions.fs(18),
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryColor,
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Dimensions.h(24)),

            // ── Payment History ────────────────────────────────────────────
            Text(
              'Payment history',
              style: AppTextStyles.body.copyWith(
                fontSize: Dimensions.fs(15),
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: Dimensions.h(16)),

            Obx(() {
              final list = _ctrl.filteredHistory;
              if (list.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: Dimensions.h(40)),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(Dimensions.r(16)),
                    border: Border.all(
                        color: AppColors.greyColor.withOpacity(0.15)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined,
                          size: Dimensions.icon(48),
                          color: AppColors.greyColor.withOpacity(0.3)),
                      SizedBox(height: Dimensions.h(12)),
                      Text(
                        "Your Payment History List Is Empty",
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.greyColor,
                          fontSize: Dimensions.fs(13),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (_, __) => SizedBox(height: Dimensions.h(12)),
                itemBuilder: (_, i) {
                  return EaringCardWidget(data: list[i]);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
