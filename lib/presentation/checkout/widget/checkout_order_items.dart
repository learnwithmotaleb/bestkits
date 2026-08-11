import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../service/api_url.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/static_strings/static_strings.dart';
import '../controller/checkout_controller.dart';

class CheckoutOrderItems extends StatelessWidget {
  final CheckoutController controller;

  const CheckoutOrderItems({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final groups = controller.orderSummary.value?.data?.sellerGroups ?? [];

      if (groups.isEmpty) return const SizedBox();

      return Column(
        children: groups.map((group) {
          final sellerName = group.seller?.name ?? 'Unknown Seller';
          final items = group.items ?? [];
          final subtotal = group.subtotal?.toDouble() ?? 0.0;
          final delivery = group.delivery;

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seller row
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '- $sellerName',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        '${AppStrings.totalAmount.tr} : €${subtotal.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.blackColor),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 2,
                  thickness: 0.2,
                ),

                // Products
                ...items.map((item) {
                  final imageUrl = ApiUrl.buildImageUrl(
                      item.product?.imageUrls != null &&
                              item.product!.imageUrls!.isNotEmpty
                          ? item.product!.imageUrls!.first
                          : null);
                  final quantity = item.quantity ?? 1;
                  final price = item.price ?? 0;
                  final size = item.variant?.variantName ?? 'N/A';

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.greyColor.withOpacity(0.5),
                            width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppColors.primaryColor, width: 1)),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: imageUrl.isNotEmpty
                                  ? Image.network(imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) =>
                                          const Icon(Icons.broken_image))
                                  : const Icon(Icons.image_not_supported),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product?.name ?? 'Unknown Product',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${AppStrings.quantity.tr} :- $quantity • ${AppStrings.size.tr} / ${AppStrings.variant.tr} :- $size',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey[500]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Unit Price: €${price.toStringAsFixed(2)}\nTotal: €${(price * quantity).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                // Delivery info
                if (delivery != null)
                  Container(
                    margin: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: AppColors.primaryColor, width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.primaryColor, width: 2),
                          ),
                          child: Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.end,
                                      children: [
                                        Text(
                                          (delivery.type ?? '').toLowerCase() ==
                                                  'international'
                                              ? 'International Delivery'
                                              : 'Domestic Delivery',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 1.0),
                                          child: Text(
                                            (delivery.type ?? '')
                                                        .toLowerCase() ==
                                                    'international'
                                                ? '(Outside Country)'
                                                : '(Inside Country)',
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.grey[400],
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '€${delivery.cost?.toStringAsFixed(2) ?? '0.00'}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[400],
                                    fontStyle: FontStyle.italic,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Delivery Partner - '),
                                    TextSpan(
                                      text: delivery.partner ?? '',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 2),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[400],
                                    fontStyle: FontStyle.italic,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Estimated Time - '),
                                    TextSpan(
                                      text:
                                          '${delivery.daysMin}-${delivery.daysMax} Business Days',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}
