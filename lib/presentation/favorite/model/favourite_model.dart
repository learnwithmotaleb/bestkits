import 'package:bestkits/data/model/product_model.dart';

class WishlistResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<WishlistItemModel> data;
  final WishlistMeta? meta;

  WishlistResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    this.meta,
  });

  factory WishlistResponseModel.fromJson(Map<String, dynamic> json) {
    return WishlistResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: (json['statusCode'] as num?)?.toInt() ?? 0,
      message: json['message']?.toString() ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map(
                  (e) => WishlistItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      meta: json['meta'] != null ? WishlistMeta.fromJson(json['meta']) : null,
    );
  }
}

class WishlistItemModel {
  final int wishlistEntryId; // wishlist_item_id
  final String savedAt; // saved_at
  final ProductModel product;

  WishlistItemModel({
    required this.wishlistEntryId,
    required this.savedAt,
    required this.product,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      wishlistEntryId: (json['wishlist_item_id'] as num?)?.toInt() ?? 0,
      savedAt: json['saved_at']?.toString() ?? '',
      product: ProductModel.fromJson(
          json['product'] as Map<String, dynamic>? ?? json),
    );
  }
}

class WishlistMeta {
  final int total;
  final int page;
  final int limit;
  final int pages;

  WishlistMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.pages,
  });

  factory WishlistMeta.fromJson(Map<String, dynamic> json) {
    return WishlistMeta(
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
      pages: (json['pages'] as num?)?.toInt() ?? 0,
    );
  }
}
