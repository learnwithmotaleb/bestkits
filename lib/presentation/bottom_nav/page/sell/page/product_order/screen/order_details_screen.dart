import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../utils/app_text_style/app_text_style.dart';
import '../../../../../../../utils/static_strings/static_strings.dart';
import '../../../../../../../widget/app_alert.dart';
import '../../../../../../../widget/custom_appbar.dart';
import 'package:bestkits/presentation/currency_preference/widget/currency_helper.dart';
import '../controller/product_order_controller.dart';
import '../model/ProductOrderModel.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Data order;
  late ProductOrderController _controller;
  late RxString orderStatus;
  late RxString currentRawStatus;

  final List<Map<String, String>> allStatuses = [
    {'label': 'Pending', 'value': 'PENDING'},
    {'label': 'Confirmed', 'value': 'CONFIRMED'},
    {'label': 'Shipped', 'value': 'SHIPPED'},
    {'label': 'Delivered', 'value': 'DELIVERED'},
    {'label': 'Canceled', 'value': 'CANCELLED'},
  ];

  List<Map<String, String>> _getValidNextStatuses(String rawStatus) {
    switch (rawStatus.toUpperCase()) {
      case 'PENDING':
        return [
          {'label': 'Confirmed', 'value': 'CONFIRMED'}
        ];
      case 'CONFIRMED':
        return [
          {'label': 'Shipped', 'value': 'SHIPPED'}
        ];
      case 'SHIPPED':
        return [
          {'label': 'Delivered', 'value': 'DELIVERED'}
        ];
      default:
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

  // ── Helpers ────────────────────────────────────────────────────────────────

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

  String _formatDate(String? raw) {
    if (raw == null) return '—';
    try {
      final dt = DateTime.parse(raw).toLocal();
      const months = [
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

  // ── Update Status Bottom Sheet ─────────────────────────────────────────────

  void _showUpdateStatusBottomSheet() {
    final validNextStatuses = _getValidNextStatuses(currentRawStatus.value);

    if (validNextStatuses.isEmpty) {
      Get.snackbar(
        'No transitions available',
        'This order has reached its final state.',
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    final tempSelected = ''.obs;

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
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '- Update Order Status',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: Dimensions.fs(15),
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
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
              'Update the current order status to keep the customer informed about the delivery progress.',
              style: TextStyle(
                fontSize: Dimensions.fs(11),
                color: Colors.grey[500],
                height: 1.5,
              ),
            ),
            Dimensions.gapH(16),

            // Label
            Text(
              'Order Status (Select)',
              style: TextStyle(
                fontSize: Dimensions.fs(12),
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Dimensions.gapH(8),

            // Dropdown field
            Obx(() {
              final selected = allStatuses.firstWhereOrNull(
                (s) => s['value'] == tempSelected.value,
              );
              return GestureDetector(
                onTap: () => _showServiceTypePicker(tempSelected),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.w(14),
                    vertical: Dimensions.h(13),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimensions.r(8)),
                    border: Border.all(color: Colors.grey.withOpacity(0.25)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selected != null
                            ? selected['label']!
                            : 'Select Order Status',
                        style: TextStyle(
                          fontSize: Dimensions.fs(13),
                          color: selected != null
                              ? Colors.grey[800]
                              : Colors.grey[400],
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down,
                          color: Colors.grey[400], size: 20),
                    ],
                  ),
                ),
              );
            }),

            Dimensions.gapH(20),

            // Update button
            Obx(() => GestureDetector(
                  onTap: tempSelected.value.isEmpty ||
                          _controller.isUpdatingStatus.value
                      ? null
                      : () {
                          final chosen = tempSelected.value;
                          final chosenLabel = allStatuses.firstWhere(
                              (s) => s['value'] == chosen)['label']!;
                          Get.back();
                          _showConfirmUpdateDialog(chosen, chosenLabel);
                        },
                  child: Opacity(
                    opacity: tempSelected.value.isEmpty ? 0.5 : 1.0,
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
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Color(0xFFFACC15),
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Update',
                                  style: TextStyle(
                                    color: const Color(0xFFFACC15),
                                    fontSize: Dimensions.fs(14),
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                Dimensions.gapW(6),
                                const Icon(
                                  Icons.double_arrow_rounded,
                                  color: Color(0xFFFACC15),
                                  size: 16,
                                ),
                              ],
                            ),
                    ),
                  ),
                )),

            Dimensions.gapH(10),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // ── Service Type Picker (nested sheet) ─────────────────────────────────────

  void _showServiceTypePicker(RxString tempSelected) {
    Get.bottomSheet(
      Obx(() => Container(
            padding: EdgeInsets.fromLTRB(
              Dimensions.w(20),
              Dimensions.h(20),
              Dimensions.w(20),
              Dimensions.h(30),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.r(20)),
                topRight: Radius.circular(Dimensions.r(20)),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Type',
                  style: TextStyle(
                    fontSize: Dimensions.fs(13),
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                  ),
                ),
                Dimensions.gapH(14),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimensions.r(14)),
                  ),
                  child: Column(
                    children: allStatuses.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final statusMap = entry.value;
                      final isSelected =
                          tempSelected.value == statusMap['value'];
                      final isLast = idx == allStatuses.length - 1;

                      return GestureDetector(
                        onTap: () {
                          tempSelected.value = statusMap['value']!;
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.w(16),
                            vertical: Dimensions.h(14),
                          ),
                          decoration: BoxDecoration(
                            border: isLast
                                ? null
                                : Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.withOpacity(0.12),
                                    ),
                                  ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                statusMap['label']!,
                                style: TextStyle(
                                  fontSize: Dimensions.fs(13),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              // Custom radio dot
                              Container(
                                width: Dimensions.w(20),
                                height: Dimensions.w(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.grey[350]!,
                                    width: 1.5,
                                  ),
                                ),
                                child: isSelected
                                    ? Center(
                                        child: Container(
                                          width: Dimensions.w(10),
                                          height: Dimensions.w(10),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          )),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // ── Confirm Update Dialog ──────────────────────────────────────────────────

  void _showConfirmUpdateDialog(String newStatusValue, String newStatusLabel) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.r(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(Dimensions.w(22)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: Dimensions.w(60),
                height: Dimensions.w(60),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(Dimensions.r(14)),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFE63946),
                  size: 32,
                ),
              ),
              Dimensions.gapH(16),
              Text(
                'Update Order Status !',
                style: TextStyle(
                  fontSize: Dimensions.fs(14),
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              Dimensions.gapH(8),
              Text(
                'Are you sure you want to update this order status? The customer will be notified immediately.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.fs(11),
                  color: Colors.grey[500],
                  height: 1.55,
                ),
              ),
              Dimensions.gapH(22),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: Dimensions.h(46),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Dimensions.r(10)),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: Dimensions.fs(13),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Dimensions.gapW(12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Get.back();
                        final orderId = order.id?.toString() ?? '';
                        final success = await _controller.updateOrderStatus(
                          orderId: orderId,
                          newStatus: newStatusValue,
                        );
                        if (success) {
                          orderStatus.value = newStatusLabel;
                          currentRawStatus.value = newStatusValue;
                          AppAlerts.success(
                              message: AppStrings.orderStatusUpdatedSuccess.tr);
                        }
                      },
                      child: Container(
                        height: Dimensions.h(46),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1B1B),
                          borderRadius: BorderRadius.circular(Dimensions.r(10)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            color: const Color(0xFFFACC15),
                            fontSize: Dimensions.fs(13),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final buyer = order.buyer;
    final matchedItems = order.matchedProductItems ?? [];
    final canUpdate = order.actions?.canUpdateStatus ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: CommonAppBar(
        title: "Order's Details",
        backgroundColor: const Color(0xFFF4F4F4),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.w(20),
          vertical: Dimensions.h(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Order Card ─────────────────────────────────────────────────
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
                  // Order ID & Status badge row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '- Order ID: ${order.displayId ?? '—'}',
                              style: TextStyle(
                                fontSize: Dimensions.fs(13),
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
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
                            color: badgeColor.withOpacity(0.12),
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

                  // Matched product items
                  if (matchedItems.isNotEmpty) ...[
                    Dimensions.gapH(14),
                    const Divider(height: 1, color: Color(0xFFF5F5F5)),
                    Dimensions.gapH(12),
                    ...matchedItems.map((item) => _buildMatchedItem(item)),
                  ],
                ],
              ),
            ),

            Dimensions.gapH(20),

            // ── Ordered By ─────────────────────────────────────────────────
            Text(
              '- Ordered By',
              style: TextStyle(
                fontSize: Dimensions.fs(13),
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
            Dimensions.gapH(10),
            _buildBuyerCard(buyer),

            Dimensions.gapH(20),

            // ── Delivery Address ────────────────────────────────────────────
            Text(
              '- Delivery Address',
              style: TextStyle(
                fontSize: Dimensions.fs(13),
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
            Dimensions.gapH(10),
            _buildDeliveryAddressCard(),

            Dimensions.gapH(28),

            // ── Update Order Status button ──────────────────────────────────
            if (canUpdate)
              Obx(() => GestureDetector(
                    onTap: _controller.isUpdatingStatus.value
                        ? null
                        : _showUpdateStatusBottomSheet,
                    child: Container(
                      width: double.infinity,
                      height: Dimensions.h(52),
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
                                color: Color(0xFFFACC15),
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Update Order Status',
                              style: TextStyle(
                                color: const Color(0xFFFACC15),
                                fontSize: Dimensions.fs(14),
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                    ),
                  )),

            Dimensions.gapH(40),
          ],
        ),
      ),
    );
  }

  // ── Matched Item ───────────────────────────────────────────────────────────

  Widget _buildMatchedItem(MatchedProductItems item) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.h(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with yellow border
          Container(
            width: Dimensions.w(64),
            height: Dimensions.w(64),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.r(10)),
              border: Border.all(color: const Color(0xFFFACC15), width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.r(9)),
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
                    fontSize: Dimensions.fs(13),
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Dimensions.gapH(3),
                Text(
                  'Quantity :- ${(item.quantity ?? 1).toString().padLeft(2, '0')}  •  Size / Variant :- ${item.variant?.variantName ?? '—'}',
                  style: TextStyle(
                    fontSize: Dimensions.fs(10),
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Dimensions.gapH(5),
                Text(
                  CurrencyHelper.formatPrice(item.price ?? 0),
                  style: TextStyle(
                    fontSize: Dimensions.fs(13),
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Buyer Card ─────────────────────────────────────────────────────────────

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
            decoration: const BoxDecoration(shape: BoxShape.circle),
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
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Dimensions.gapH(2),
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
            onTap: () => Get.snackbar(
              'Chat',
              'Message customer feature coming soon.',
              backgroundColor: const Color(0xFFFACC15),
              colorText: Colors.black,
            ),
            child: Container(
              padding: EdgeInsets.all(Dimensions.w(8)),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1B1B),
                borderRadius: BorderRadius.circular(Dimensions.r(8)),
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Color(0xFFFACC15),
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

  // ── Delivery Address Card ──────────────────────────────────────────────────

  Widget _buildDeliveryAddressCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.w(14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.r(15)),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.buyer?.name ?? 'Roberts Junior',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: Dimensions.fs(13),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(8),
                  vertical: Dimensions.h(4),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(Dimensions.r(20)),
                ),
                child: Text(
                  '• Home',
                  style: TextStyle(
                    color: const Color(0xFFFACC15),
                    fontSize: Dimensions.fs(9),
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          Dimensions.gapH(8),
          Text(
            '+359 77 123 4567',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: Dimensions.fs(12),
              fontStyle: FontStyle.italic,
            ),
          ),
          Dimensions.gapH(4),
          Text(
            '25 "Ivan Vazov" Street, Plovdiv 4000, Bulgaria',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: Dimensions.fs(12),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
