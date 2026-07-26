import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../../../utils/static_strings/static_strings.dart';
import '../../../../../../../widget/app_alert.dart';
import '../../../../../../../widget/custom_appbar.dart';
import '../controller/product_order_controller.dart';
import '../model/ProductOrderModel.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  // The real order passed from ProductOrder screen
  late Data order;
  late ProductOrderController _controller;

  // Reactive local status (reflects API changes optimistically)
  late RxString orderStatus;

  // Tracks the current raw API status value for transition logic
  late RxString currentRawStatus;

  // All known statuses (label → API value)
  final List<Map<String, String>> allStatuses = [
    {'label': 'Pending', 'value': 'PENDING'},
    {'label': 'Confirmed', 'value': 'CONFIRMED'},
    {'label': 'Processing', 'value': 'PROCESSING'},
    {'label': 'Shipped', 'value': 'SHIPPED'},
    {'label': 'Delivered', 'value': 'DELIVERED'},
    {'label': 'Canceled', 'value': 'CANCELLED'},
  ];

  /// Seller transition rules: returns ONLY the valid next status(es)
  /// based on the current raw status value.
  List<Map<String, String>> _getValidNextStatuses(String rawStatus) {
    switch (rawStatus.toUpperCase()) {
      case 'PENDING':
        return [
          {'label': 'Confirmed', 'value': 'CONFIRMED'}
        ];
      case 'CONFIRMED':
        return [
          {'label': 'Processing', 'value': 'PROCESSING'}
        ];
      case 'PROCESSING':
        return [
          {'label': 'Shipped', 'value': 'SHIPPED'}
        ];
      case 'SHIPPED':
        return [
          {'label': 'Delivered', 'value': 'DELIVERED'}
        ];
      default:
        // DELIVERED / CANCELLED — no valid transitions
        return [];
    }
  }

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    order = args?['order'] as Data? ?? Data();
    currentRawStatus = (order.status ?? 'PENDING').obs;
    orderStatus = (order.statusLabel ?? order.status ?? 'PENDING').obs;
    _controller = Get.find<ProductOrderController>();
  }

  // ── helpers ────────────────────────────────────────────────────────────────

  Color _statusColor(String? statusTone) {
    switch (statusTone?.toLowerCase()) {
      case 'success':
        return const Color(0xFF4CAF50);
      case 'danger':
      case 'error':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      default:
        return const Color(0xFF2196F3);
    }
  }

  String _formatDate(String? raw) {
    if (raw == null) return '—';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      final hour = dt.hour > 12
          ? dt.hour - 12
          : dt.hour == 0
              ? 12
              : dt.hour;
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      final min = dt.minute.toString().padLeft(2, '0');
      return '${dt.day} ${months[dt.month - 1]} ${dt.year} - $hour:$min $ampm';
    } catch (_) {
      return raw;
    }
  }

  // ── bottom sheet ───────────────────────────────────────────────────────────

  void _showUpdateStatusBottomSheet() {
    final validNextStatuses = _getValidNextStatuses(currentRawStatus.value);

    // Nothing to transition to
    if (validNextStatuses.isEmpty) {
      Get.snackbar(
        'No transitions available',
        'This order has reached its final state.',
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    // Auto-select the only valid next status
    final tempSelected = validNextStatuses.first['value']!.obs;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(
          Dimensions.w(20),
          Dimensions.h(20),
          Dimensions.w(20),
          Dimensions.h(30),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.r(25)),
            topRight: Radius.circular(Dimensions.r(25)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.updateOrderStatusDash.tr,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: Dimensions.fs(16),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.close, size: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
            Dimensions.gapH(6),
            Text(
              AppStrings.updateOrderStatusSubtitleDash.tr,
              style: TextStyle(
                fontSize: Dimensions.fs(11),
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            Dimensions.gapH(16),

            // ── Label ───────────────────────────────────────────────────────
            Text(
              AppStrings.orderStatusSelect.tr,
              style: TextStyle(
                fontSize: Dimensions.fs(12),
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            Dimensions.gapH(10),

            // ── Current status info ─────────────────────────────────────────
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(12), vertical: Dimensions.h(8)),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(Dimensions.r(8)),
                border: Border.all(color: Colors.grey.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 14, color: Colors.grey[500]),
                  Dimensions.gapW(8),
                  Text(
                    'Current: ',
                    style: TextStyle(
                        fontSize: Dimensions.fs(11), color: Colors.grey[500]),
                  ),
                  Text(
                    orderStatus.value,
                    style: TextStyle(
                      fontSize: Dimensions.fs(11),
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward, size: 14, color: Colors.grey[400]),
                  Dimensions.gapW(8),
                  Text(
                    validNextStatuses.first['label']!,
                    style: TextStyle(
                      fontSize: Dimensions.fs(11),
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Dimensions.gapH(16),

            // ── Radio list (only valid next statuses) ──────────────────────────
            Obx(() => Column(
                  children: validNextStatuses.map((statusMap) {
                    final isSelected = tempSelected.value == statusMap['value'];
                    return GestureDetector(
                      onTap: () => tempSelected.value = statusMap['value']!,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Dimensions.h(6)),
                        child: Row(
                          children: [
                            // Radio circle
                            Container(
                              width: Dimensions.w(20),
                              height: Dimensions.w(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade400,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        width: Dimensions.w(10),
                                        height: Dimensions.w(10),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            Dimensions.gapW(12),
                            Text(
                              statusMap['label']!.tr,
                              style: TextStyle(
                                fontSize: Dimensions.fs(13),
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )),

            Dimensions.gapH(20),

            // ── Update button ────────────────────────────────────────────────
            Obx(() => GestureDetector(
                  onTap: _controller.isUpdatingStatus.value
                      ? null
                      : () {
                          final chosen = tempSelected.value;
                          final chosenLabel = validNextStatuses.firstWhere(
                              (s) => s['value'] == chosen)['label']!;
                          Get.back(); // close bottom sheet
                          _showConfirmUpdateDialog(chosen, chosenLabel);
                        },
                  child: Container(
                    width: double.infinity,
                    height: Dimensions.h(50),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1B1B),
                      borderRadius: BorderRadius.circular(Dimensions.r(12)),
                    ),
                    alignment: Alignment.center,
                    child: _controller.isUpdatingStatus.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: AppColors.primaryColor, strokeWidth: 2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.updateBtn.tr,
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: Dimensions.fs(14),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Dimensions.gapW(6),
                              Icon(
                                Icons.double_arrow_rounded,
                                color: AppColors.primaryColor,
                                size: Dimensions.icon(16),
                              ),
                            ],
                          ),
                  ),
                )),
            Dimensions.gapH(15),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // ── confirm dialog ─────────────────────────────────────────────────────────

  void _showConfirmUpdateDialog(String newStatusValue, String newStatusLabel) {
    AppAlerts.warning(
      title: AppStrings.updateOrderStatusTitle.tr,
      message: AppStrings.updateOrderStatusConfirmMsg.tr,
      confirmLabel: AppStrings.confirm.tr,
      cancelLabel: AppStrings.cancel.tr,
      onConfirm: () async {
        Get.back(); // close alert
        final orderId = order.id?.toString() ?? '';
        final success = await _controller.updateOrderStatus(
          orderId: orderId,
          newStatus: newStatusValue,
        );
        if (success) {
          // Update both the display label and raw status for next transition
          orderStatus.value = newStatusLabel;
          currentRawStatus.value = newStatusValue;
          AppAlerts.success(message: AppStrings.orderStatusUpdatedSuccess.tr);
        }
      },
    );
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final buyer = order.buyer;
    final matchedItems = order.matchedProductItems ?? [];
    final timeline = order.timeline;
    final canUpdate = order.actions?.canUpdateStatus ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: CommonAppBar(
        title: AppStrings.ordersDetailsTitle.tr,
        backgroundColor: const Color(0xFFF4F4F4),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Dimensions.gapH(10),

                  // ── Main Order Details Card ──────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Dimensions.w(15)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Dimensions.r(15)),
                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order ID & Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${AppStrings.orderIdLabelWithDash.tr}${order.displayId ?? '—'}',
                                    style: TextStyle(
                                      fontSize: Dimensions.fs(13),
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Dimensions.gapH(4),
                                  Text(
                                    _formatDate(order.createdAt),
                                    style: TextStyle(
                                      fontSize: Dimensions.fs(10),
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Obx(() {
                              final statusTone =
                                  _statusToneFromLabel(orderStatus.value);
                              final badgeColor = _statusColor(statusTone);
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.w(8),
                                  vertical: Dimensions.h(4),
                                ),
                                decoration: BoxDecoration(
                                  color: badgeColor.withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(Dimensions.r(20)),
                                ),
                                child: Text(
                                  '• ${orderStatus.value}',
                                  style: TextStyle(
                                    color: badgeColor,
                                    fontSize: Dimensions.fs(9),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),

                        if (matchedItems.isNotEmpty) ...[
                          Dimensions.gapH(15),
                          const Divider(height: 1, color: Color(0xFFF5F5F5)),
                          Dimensions.gapH(12),
                          // Matched product items from API
                          ...matchedItems
                              .map((item) => _buildMatchedItem(item)),
                        ],

                        // Total row
                        Dimensions.gapH(12),
                        const Divider(height: 1, color: Color(0xFFF5F5F5)),
                        Dimensions.gapH(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order Total',
                              style: TextStyle(
                                fontSize: Dimensions.fs(12),
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              '\$${order.total ?? 0}',
                              style: TextStyle(
                                fontSize: Dimensions.fs(15),
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Dimensions.gapH(20),

                  // ── Order Timeline ──────────────────────────────────────
                  if (timeline != null) ...[
                    Text(
                      'Order Timeline',
                      style: TextStyle(
                        fontSize: Dimensions.fs(13),
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    Dimensions.gapH(10),
                    _buildTimeline(timeline),
                    Dimensions.gapH(20),
                  ],

                  // ── Ordered By ──────────────────────────────────────────
                  Text(
                    AppStrings.orderedBy.tr,
                    style: TextStyle(
                      fontSize: Dimensions.fs(13),
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  Dimensions.gapH(10),
                  _buildBuyerCard(buyer),

                  Dimensions.gapH(30),

                  // ── Update Order Status button ───────────────────────────
                  if (canUpdate)
                    Obx(() => GestureDetector(
                          onTap: _controller.isUpdatingStatus.value
                              ? null
                              : _showUpdateStatusBottomSheet,
                          child: Container(
                            width: double.infinity,
                            height: Dimensions.h(50),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B1B1B),
                              borderRadius:
                                  BorderRadius.circular(Dimensions.r(12)),
                            ),
                            alignment: Alignment.center,
                            child: _controller.isUpdatingStatus.value
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                        color: AppColors.primaryColor,
                                        strokeWidth: 2),
                                  )
                                : Text(
                                    AppStrings.updateOrderStatusBtn.tr,
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: Dimensions.fs(14),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        )),

                  Dimensions.gapH(40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper: matched product item row ──────────────────────────────────────

  Widget _buildMatchedItem(MatchedProductItems item) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.h(10)),
      child: Container(
        padding: EdgeInsets.all(Dimensions.w(10)),
        decoration: BoxDecoration(
          color: const Color(0xFFFBFBFB),
          borderRadius: BorderRadius.circular(Dimensions.r(12)),
          border: Border.all(color: Colors.grey.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            // Product image
            Container(
              width: Dimensions.w(60),
              height: Dimensions.w(60),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.r(10)),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.r(10)),
                child: item.imageUrl != null
                    ? Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                          size: 24,
                        ),
                      )
                    : Icon(Icons.image_not_supported,
                        color: Colors.grey[400], size: 24),
              ),
            ),
            Dimensions.gapW(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? '—',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Dimensions.fs(12),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Dimensions.gapH(4),
                  Text(
                    '${AppStrings.quantityPrefix.tr}${item.quantity ?? 1}  •  Size: ${item.variant?.variantName ?? '—'}',
                    style: TextStyle(
                      fontSize: Dimensions.fs(10),
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Dimensions.gapH(6),
                  Row(
                    children: [
                      Text(
                        '\$${item.price ?? 0}',
                        style: TextStyle(
                          fontSize: Dimensions.fs(13),
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      if (item.quantity != null && item.quantity! > 1) ...[
                        Dimensions.gapW(6),
                        Text(
                          '× ${item.quantity}  =  \$${item.lineTotal ?? 0}',
                          style: TextStyle(
                            fontSize: Dimensions.fs(10),
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helper: timeline card ─────────────────────────────────────────────────

  Widget _buildTimeline(Timeline timeline) {
    final steps = [
      {'label': 'Order Placed', 'time': order.createdAt},
      {'label': 'Confirmed', 'time': timeline.confirmedAt?.toString()},
      {'label': 'Processing', 'time': timeline.processingAt?.toString()},
      {'label': 'Shipped', 'time': timeline.shippedAt?.toString()},
      {'label': 'Delivered', 'time': timeline.deliveredAt?.toString()},
      if (timeline.cancelledAt != null)
        {'label': 'Cancelled', 'time': timeline.cancelledAt?.toString()},
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.w(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.r(15)),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: List.generate(steps.length, (i) {
          final step = steps[i];
          final isDone = step['time'] != null;
          final isLast = i == steps.length - 1;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: Dimensions.w(14),
                    height: Dimensions.w(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone ? AppColors.primaryColor : Colors.grey[300],
                      border: isDone
                          ? null
                          : Border.all(color: Colors.grey[400]!, width: 1.5),
                    ),
                    child: isDone
                        ? Icon(Icons.check,
                            size: Dimensions.icon(9), color: Colors.black)
                        : null,
                  ),
                  if (!isLast)
                    Container(
                      width: 1.5,
                      height: Dimensions.h(28),
                      color: isDone
                          ? AppColors.primaryColor.withOpacity(0.4)
                          : Colors.grey[300],
                    ),
                ],
              ),
              Dimensions.gapW(12),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: isLast ? 0 : Dimensions.h(14)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['label']!,
                        style: TextStyle(
                          fontSize: Dimensions.fs(12),
                          fontWeight:
                              isDone ? FontWeight.w700 : FontWeight.w500,
                          color: isDone ? Colors.black : Colors.grey[500],
                        ),
                      ),
                      if (isDone)
                        Text(
                          _formatDate(step['time']),
                          style: TextStyle(
                            fontSize: Dimensions.fs(10),
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ── Helper: buyer card ────────────────────────────────────────────────────

  Widget _buildBuyerCard(Buyer? buyer) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.w(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.r(15)),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: Dimensions.w(44),
            height: Dimensions.w(44),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: ClipOval(
              child: buyer?.avatarUrl != null
                  ? Image.network(
                      buyer!.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _defaultAvatar(buyer.name),
                    )
                  : _defaultAvatar(buyer?.name),
            ),
          ),
          Dimensions.gapW(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  buyer?.name ?? '—',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: Dimensions.fs(13),
                  ),
                ),
                Dimensions.gapH(3),
                Text(
                  buyer?.email ?? '—',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: Dimensions.fs(11),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.snackbar(
                AppStrings.chatInfo.tr,
                AppStrings.messageCustomerFeature.tr,
                backgroundColor: AppColors.primaryColor,
                colorText: Colors.black,
              );
            },
            child: Container(
              padding: EdgeInsets.all(Dimensions.w(8)),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(Dimensions.r(8)),
              ),
              child: const Icon(
                Icons.message_outlined,
                color: Colors.black,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar(String? name) {
    final initials = name != null && name.isNotEmpty
        ? name.trim().split(' ').take(2).map((w) => w[0]).join().toUpperCase()
        : '?';
    return Container(
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: Dimensions.fs(14),
          fontWeight: FontWeight.w700,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  String _statusToneFromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'delivered':
      case 'confirmed':
        return 'success';
      case 'cancelled':
      case 'canceled':
        return 'danger';
      case 'shipped':
        return 'info';
      default:
        return 'warning';
    }
  }
}
