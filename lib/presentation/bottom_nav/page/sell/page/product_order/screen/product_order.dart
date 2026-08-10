import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../utils/static_strings/static_strings.dart';
import '../../../../../../../widget/custom_appbar.dart';
import '../controller/product_order_controller.dart';
import '../model/ProductOrderModel.dart';
import 'order_details_screen.dart';

class ProductOrder extends StatefulWidget {
  const ProductOrder({super.key});

  @override
  State<ProductOrder> createState() => _ProductOrderState();
}

class _ProductOrderState extends State<ProductOrder>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ProductOrderController _controller;

  // Seller tab options (maps to API sellerTab param)
  final List<Map<String, String>> _tabs = [
    {'label': 'All', 'sellerTab': ''},
    {'label': 'Placed', 'sellerTab': 'ORDER_PLACED'},
    {'label': 'Confirmed', 'sellerTab': 'CONFIRMED'},
    {'label': 'Shipped', 'sellerTab': 'SHIPPED'},
    {'label': 'Delivered', 'sellerTab': 'DELIVERED'},
    {'label': 'Canceled', 'sellerTab': 'CANCELED'},
  ];

  String get _productId =>
      (Get.arguments as Map<String, dynamic>?)?['productId']?.toString() ?? '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _controller = Get.put(ProductOrderController());

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrders();
    });

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _fetchOrders();
      }
    });
  }

  void _fetchOrders() {
    final sellerTab = _tabs[_tabController.index]['sellerTab']!;
    _controller.getProductOrders(
      productId: _productId,
      sellerTab: sellerTab.isEmpty ? null : sellerTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _statusColor(String? statusTone) {
    switch (statusTone) {
      case 'success':
        return const Color(0xFF4CAF50);
      case 'danger':
      case 'error':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      default:
        return const Color(0xFF2196F3); // info / blue
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: CommonAppBar(
        title: AppStrings.productOrdersTitle.tr,
        backgroundColor: const Color(0xFFF4F4F4),
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primaryColor,
              labelStyle: TextStyle(
                fontSize: Dimensions.fs(12),
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: Dimensions.fs(12),
                fontWeight: FontWeight.w500,
              ),
              tabs: _tabs
                  .map((t) => Tab(text: t['label']!))
                  .toList(),
            ),
          ),

          // Content
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              if (_controller.ordersList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_outlined,
                          size: 56, color: Colors.grey[300]),
                      Dimensions.gapH(16),
                      Text(
                        'No orders found',
                        style: TextStyle(
                          fontSize: Dimensions.fs(14),
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: () async => _fetchOrders(),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.w(20),
                    vertical: Dimensions.h(15),
                  ),
                  itemCount: _controller.ordersList.length,
                  separatorBuilder: (_, __) => Dimensions.gapH(12),
                  itemBuilder: (context, index) {
                    final order = _controller.ordersList[index];
                    return _buildOrderCard(order);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Data order) {
    final statusColor = _statusColor(order.statusTone);
    final previewItem = order.previewItems?.isNotEmpty == true
        ? order.previewItems!.first
        : null;

    return Container(
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
          // Order ID & status row
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
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(8),
                  vertical: Dimensions.h(4),
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Dimensions.r(20)),
                ),
                child: Text(
                  '• ${order.statusLabel ?? order.status ?? '—'}',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: Dimensions.fs(9),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          Dimensions.gapH(14),

          // View Details Button
          GestureDetector(
            onTap: () {
              Get.to(() => const OrderDetailsScreen(),
                  arguments: {'order': order});
            },
            child: Container(
              height: Dimensions.h(44),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1B1B),
                borderRadius: BorderRadius.circular(Dimensions.r(10)),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.viewDetailsBtn.tr,
                    style: TextStyle(
                      color: const Color(0xFFFACC15), // Matches yellow from screenshot
                      fontSize: Dimensions.fs(13),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Dimensions.gapW(6),
                  Icon(
                    Icons.double_arrow_rounded,
                    color: const Color(0xFFFACC15),
                    size: Dimensions.icon(16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? raw) {
    if (raw == null) return '—';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      final min = dt.minute.toString().padLeft(2, '0');
      return '${dt.day} ${months[dt.month - 1]} ${dt.year} - $hour:$min $ampm';
    } catch (_) {
      return raw;
    }
  }
}
