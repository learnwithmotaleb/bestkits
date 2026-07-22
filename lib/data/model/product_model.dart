// lib/data/model/product_model.dart

import 'package:bestkits/service/api_url.dart';

class ProductModel {
  final int id;
  final String name;
  final String description;
  final num originalPrice;
  final num? discountedPrice;
  final num? discountPercentage;
  final List<String> imageUrls;
  final int categoryId;
  final int subCategoryId;
  final int userId;
  final String condition;
  final String status;
  final int views;
  final int totalReviews;
  final num averageRating;
  final bool isAuthenticated;
  final String authenticationStatus;
  final String? approvedAt;
  final String? rejectedAt;
  final String createdAt;
  final String updatedAt;
  final ProductCategory? category;
  final ProductSubCategory? subCategory;
  final List<ProductVariant> variants;
  final ProductUser? user;
  final num effectivePrice;
  final bool isWishlisted;
  final String? viewedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.originalPrice,
    this.discountedPrice,
    this.discountPercentage,
    required this.imageUrls,
    required this.categoryId,
    required this.subCategoryId,
    required this.userId,
    required this.condition,
    required this.status,
    required this.views,
    required this.totalReviews,
    required this.averageRating,
    required this.isAuthenticated,
    required this.authenticationStatus,
    this.approvedAt,
    this.rejectedAt,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.subCategory,
    required this.variants,
    this.user,
    required this.effectivePrice,
    required this.isWishlisted,
    this.viewedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      originalPrice: (json['original_price'] as num?) ?? 0,
      discountedPrice: json['discounted_price'] as num?,
      discountPercentage: json['discount_percentage'] as num?,
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      categoryId: (json['categoryId'] as num?)?.toInt() ?? 0,
      subCategoryId: (json['subCategoryId'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      condition: json['condition']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      views: (json['views'] as num?)?.toInt() ?? 0,
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      averageRating: (json['average_rating'] as num?) ?? 0,
      isAuthenticated: json['is_authenticated'] as bool? ?? false,
      authenticationStatus: json['authentication_status']?.toString() ?? '',
      approvedAt: json['approved_at']?.toString(),
      rejectedAt: json['rejected_at']?.toString(),
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      category: json['category'] != null
          ? ProductCategory.fromJson(json['category'])
          : null,
      subCategory: json['subCategory'] != null
          ? ProductSubCategory.fromJson(json['subCategory'])
          : null,
      variants: (json['variants'] as List<dynamic>?)
              ?.map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      user: json['user'] != null ? ProductUser.fromJson(json['user']) : null,
      effectivePrice: (json['effective_price'] as num?) ??
          (json['discounted_price'] as num?) ??
          (json['original_price'] as num?) ??
          0,
      isWishlisted: json['is_wishlisted'] as bool? ?? false,
      viewedAt: json['viewed_at']?.toString(),
    );
  }

  /// Returns a full URL for the first available image, or empty string.
  String get primaryImageUrl =>
      imageUrls.isNotEmpty ? ApiUrl.buildImageUrl(imageUrls.first) : '';

  /// Returns all image URLs as full URLs.
  List<String> get fullImageUrls =>
      imageUrls.map((url) => ApiUrl.buildImageUrl(url)).toList();

  /// Formatted effective price string.
  String get formattedPrice => '€${effectivePrice.toStringAsFixed(2)}';

  /// Formatted original price string (for strikethrough).
  String get formattedOriginalPrice => '€${originalPrice.toStringAsFixed(2)}';

  /// Discount label, e.g. "17%" or null if no discount.
  String? get discountLabel =>
      (discountPercentage != null && discountPercentage! > 0)
          ? '${discountPercentage!.toInt()}%'
          : null;

  /// Rating as a display string, e.g. "4.5/5.0".
  String get ratingDisplay => '${averageRating.toStringAsFixed(1)}/5.0';

  /// Category name for display.
  String get categoryName => category?.name ?? '';

  /// Sub-category name for display.
  String get subCategoryName => subCategory?.name ?? '';

  /// Seller's full name.
  String get sellerName => user?.profile?.fullName ?? '';

  /// Seller's avatar URL.
  String get sellerAvatarUrl => ApiUrl.buildImageUrl(user?.profile?.avatarUrl);

  /// Variant names as a list of strings for size selection.
  List<String> get variantNames => variants.map((v) => v.variantName).toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// ─── Supporting Models ───────────────────────────────────────────────────────

class ProductCategory {
  final int id;
  final String name;
  final String description;
  final String imageUrl;

  ProductCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
    );
  }
}

class ProductSubCategory {
  final int id;
  final String name;
  final String description;
  final int categoryId;

  ProductSubCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
  });

  factory ProductSubCategory.fromJson(Map<String, dynamic> json) {
    return ProductSubCategory(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      categoryId: (json['categoryId'] as num?)?.toInt() ?? 0,
    );
  }
}

class ProductVariant {
  final int id;
  final int productId;
  final String variantName;
  final num price;

  ProductVariant({
    required this.id,
    required this.productId,
    required this.variantName,
    required this.price,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: (json['id'] as num?)?.toInt() ?? 0,
      productId: (json['productId'] as num?)?.toInt() ?? 0,
      variantName: json['variantName']?.toString() ?? '',
      price: (json['price'] as num?) ?? 0,
    );
  }
}

class ProductUser {
  final int id;
  final ProductUserProfile? profile;

  ProductUser({required this.id, this.profile});

  factory ProductUser.fromJson(Map<String, dynamic> json) {
    return ProductUser(
      id: (json['id'] as num?)?.toInt() ?? 0,
      profile: json['profile'] != null
          ? ProductUserProfile.fromJson(json['profile'])
          : null,
    );
  }
}

class ProductUserProfile {
  final String fullName;
  final String? avatarUrl;
  final String? country;

  ProductUserProfile({
    required this.fullName,
    this.avatarUrl,
    this.country,
  });

  factory ProductUserProfile.fromJson(Map<String, dynamic> json) {
    return ProductUserProfile(
      fullName: json['full_name']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString(),
      country: json['country']?.toString(),
    );
  }
}
