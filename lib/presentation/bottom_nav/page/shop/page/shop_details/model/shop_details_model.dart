import 'package:bestkits/data/model/product_model.dart';

import 'package:bestkits/data/model/product_model.dart';

class ShopDetailsProductModel {
  bool? success;
  int? statusCode;
  String? message;
  ShopDetailsData? data;

  ShopDetailsProductModel(
      {this.success, this.statusCode, this.message, this.data});

  ShopDetailsProductModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? ShopDetailsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ShopDetailsData {
  int? id;
  String? name;
  String? description;
  dynamic brand;
  num? originalPrice;
  num? discountedPrice;
  int? discountPercentage;
  List<String>? imageUrls;
  int? categoryId;
  int? subCategoryId;
  int? userId;
  String? condition;
  String? status;
  int? views;
  int? totalReviews;
  int? averageRating;
  bool? isAuthenticated;
  String? authenticationStatus;
  String? approvedAt;
  dynamic rejectedAt;
  dynamic soldAt;
  String? createdAt;
  String? updatedAt;
  ShopDetailsUser? user;
  ShopDetailsCategory? category;
  ShopDetailsSubCategory? subCategory;
  List<ShopDetailsReview>? reviews;
  num? effectivePrice;
  bool? isWishlisted;
  ShopDetailsSellerOverview? sellerOverview;
  List<ShopDetailsRelatedProduct>? relatedProducts;

  ShopDetailsData({
    this.id,
    this.name,
    this.description,
    this.brand,
    this.originalPrice,
    this.discountedPrice,
    this.discountPercentage,
    this.imageUrls,
    this.categoryId,
    this.subCategoryId,
    this.userId,
    this.condition,
    this.status,
    this.views,
    this.totalReviews,
    this.averageRating,
    this.isAuthenticated,
    this.authenticationStatus,
    this.approvedAt,
    this.rejectedAt,
    this.soldAt,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.category,
    this.subCategory,
    this.reviews,
    this.effectivePrice,
    this.isWishlisted,
    this.sellerOverview,
    this.relatedProducts,
  });

  /// Seed [ShopDetailsData] from a [ProductModel] that came from the list API.
  /// Extra fields like reviews / sellerOverview will be null until the detail
  /// API call completes (or if it fails, we keep this data).
  factory ShopDetailsData.fromProductModel(ProductModel p) {
    return ShopDetailsData(
      id: p.id,
      name: p.name,
      description: p.description,
      brand: null,
      originalPrice: p.originalPrice,
      discountedPrice: p.discountedPrice,
      discountPercentage: p.discountPercentage?.toInt(),
      imageUrls: p.imageUrls,
      categoryId: p.categoryId,
      subCategoryId: p.subCategoryId,
      userId: p.userId,
      condition: p.condition,
      status: p.status,
      views: p.views,
      totalReviews: p.totalReviews,
      averageRating: p.averageRating.toInt(),
      isAuthenticated: p.isAuthenticated,
      authenticationStatus: p.authenticationStatus,
      approvedAt: p.approvedAt,
      rejectedAt: p.rejectedAt,
      soldAt: null,
      createdAt: p.createdAt,
      updatedAt: p.updatedAt,
      user: p.user != null
          ? ShopDetailsUser(
              id: p.user!.id,
              profile: p.user!.profile != null
                  ? ShopDetailsProfile(
                      fullName: p.user!.profile!.fullName,
                      avatarUrl: p.user!.profile!.avatarUrl,
                      country: p.user!.profile!.country,
                    )
                  : null,
            )
          : null,
      category: p.category != null
          ? ShopDetailsCategory(
              id: p.category!.id,
              name: p.category!.name,
              description: p.category!.description,
              imageUrl: p.category!.imageUrl,
            )
          : null,
      subCategory: p.subCategory != null
          ? ShopDetailsSubCategory(
              id: p.subCategory!.id,
              name: p.subCategory!.name,
              description: p.subCategory!.description,
              categoryId: p.subCategory!.categoryId,
            )
          : null,
      effectivePrice: p.effectivePrice,
      isWishlisted: p.isWishlisted,
      reviews: null,
      sellerOverview: null,
      relatedProducts: null,
    );
  }

  ShopDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    brand = json['brand'];
    originalPrice = json['original_price'] as num?;
    discountedPrice = json['discounted_price'] as num?;
    discountPercentage = (json['discount_percentage'] as num?)?.toInt();
    imageUrls = (json['image_urls'] as List?)?.cast<String>();
    categoryId = (json['categoryId'] as num?)?.toInt();
    subCategoryId = (json['subCategoryId'] as num?)?.toInt();
    userId = (json['userId'] as num?)?.toInt();
    condition = json['condition'];
    status = json['status'];
    views = (json['views'] as num?)?.toInt();
    totalReviews = (json['total_reviews'] as num?)?.toInt();
    averageRating = (json['average_rating'] as num?)?.toInt();
    isAuthenticated = json['is_authenticated'];
    authenticationStatus = json['authentication_status'];
    approvedAt = json['approved_at'];
    rejectedAt = json['rejected_at'];
    soldAt = json['sold_at'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? ShopDetailsUser.fromJson(json['user']) : null;
    category = json['category'] != null
        ? ShopDetailsCategory.fromJson(json['category'])
        : null;
    subCategory = json['subCategory'] != null
        ? ShopDetailsSubCategory.fromJson(json['subCategory'])
        : null;
    if (json['reviews'] != null) {
      reviews = <ShopDetailsReview>[];
      json['reviews'].forEach((v) {
        reviews!.add(ShopDetailsReview.fromJson(v));
      });
    }
    effectivePrice = json['effective_price'] as num?;
    isWishlisted = json['is_wishlisted'];
    sellerOverview = json['seller_overview'] != null
        ? ShopDetailsSellerOverview.fromJson(json['seller_overview'])
        : null;
    if (json['related_products'] != null) {
      relatedProducts = <ShopDetailsRelatedProduct>[];
      json['related_products'].forEach((v) {
        relatedProducts!.add(ShopDetailsRelatedProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['brand'] = brand;
    data['original_price'] = originalPrice;
    data['discounted_price'] = discountedPrice;
    data['discount_percentage'] = discountPercentage;
    data['image_urls'] = imageUrls;
    data['categoryId'] = categoryId;
    data['subCategoryId'] = subCategoryId;
    data['userId'] = userId;
    data['condition'] = condition;
    data['status'] = status;
    data['views'] = views;
    data['total_reviews'] = totalReviews;
    data['average_rating'] = averageRating;
    data['is_authenticated'] = isAuthenticated;
    data['authentication_status'] = authenticationStatus;
    data['approved_at'] = approvedAt;
    data['rejected_at'] = rejectedAt;
    data['sold_at'] = soldAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (user != null) data['user'] = user!.toJson();
    if (category != null) data['category'] = category!.toJson();
    if (subCategory != null) data['subCategory'] = subCategory!.toJson();
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    data['effective_price'] = effectivePrice;
    data['is_wishlisted'] = isWishlisted;
    if (sellerOverview != null) {
      data['seller_overview'] = sellerOverview!.toJson();
    }
    if (relatedProducts != null) {
      data['related_products'] =
          relatedProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/// Seller user (on the product) — has full fields including delivery_option
class ShopDetailsUser {
  int? id;
  String? email;
  String? sellerTier;
  bool? stripeOnboardingComplete;
  ShopDetailsProfile? profile;
  ShopDetailsDeliveryOption? deliveryOption;

  ShopDetailsUser({
    this.id,
    this.email,
    this.sellerTier,
    this.stripeOnboardingComplete,
    this.profile,
    this.deliveryOption,
  });

  ShopDetailsUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    sellerTier = json['seller_tier'];
    stripeOnboardingComplete = json['stripe_onboarding_complete'];
    profile = json['profile'] != null
        ? ShopDetailsProfile.fromJson(json['profile'])
        : null;
    deliveryOption = json['delivery_option'] != null
        ? ShopDetailsDeliveryOption.fromJson(json['delivery_option'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['email'] = email;
    data['seller_tier'] = sellerTier;
    data['stripe_onboarding_complete'] = stripeOnboardingComplete;
    if (profile != null) data['profile'] = profile!.toJson();
    if (deliveryOption != null) {
      data['delivery_option'] = deliveryOption!.toJson();
    }
    return data;
  }
}

/// Reviewer user (inside reviews list) — only id + profile
class ShopDetailsReviewUser {
  int? id;
  ShopDetailsProfile? profile;

  ShopDetailsReviewUser({this.id, this.profile});

  ShopDetailsReviewUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profile = json['profile'] != null
        ? ShopDetailsProfile.fromJson(json['profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    if (profile != null) data['profile'] = profile!.toJson();
    return data;
  }
}

class ShopDetailsProfile {
  String? fullName;
  String? avatarUrl;
  String? country;

  ShopDetailsProfile({this.fullName, this.avatarUrl, this.country});

  ShopDetailsProfile.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    avatarUrl = json['avatar_url'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['full_name'] = fullName;
    data['avatar_url'] = avatarUrl;
    data['country'] = country;
    return data;
  }
}

class ShopDetailsDeliveryOption {
  int? id;
  int? sellerId;
  String? domesticPartner;
  double? domesticCost;
  int? domesticDaysMin;
  int? domesticDaysMax;
  String? internationalPartner;
  double? internationalCost;
  int? internationalDaysMin;
  int? internationalDaysMax;
  String? createdAt;
  String? updatedAt;

  ShopDetailsDeliveryOption({
    this.id,
    this.sellerId,
    this.domesticPartner,
    this.domesticCost,
    this.domesticDaysMin,
    this.domesticDaysMax,
    this.internationalPartner,
    this.internationalCost,
    this.internationalDaysMin,
    this.internationalDaysMax,
    this.createdAt,
    this.updatedAt,
  });

  ShopDetailsDeliveryOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellerId = json['sellerId'];
    domesticPartner = json['domestic_partner'];
    domesticCost = (json['domestic_cost'] as num?)?.toDouble();
    domesticDaysMin = json['domestic_days_min'];
    domesticDaysMax = json['domestic_days_max'];
    internationalPartner = json['international_partner'];
    internationalCost = (json['international_cost'] as num?)?.toDouble();
    internationalDaysMin = json['international_days_min'];
    internationalDaysMax = json['international_days_max'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['sellerId'] = sellerId;
    data['domestic_partner'] = domesticPartner;
    data['domestic_cost'] = domesticCost;
    data['domestic_days_min'] = domesticDaysMin;
    data['domestic_days_max'] = domesticDaysMax;
    data['international_partner'] = internationalPartner;
    data['international_cost'] = internationalCost;
    data['international_days_min'] = internationalDaysMin;
    data['international_days_max'] = internationalDaysMax;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class ShopDetailsCategory {
  int? id;
  String? name;
  String? description;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  ShopDetailsCategory({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  ShopDetailsCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image_url'] = imageUrl;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class ShopDetailsSubCategory {
  int? id;
  String? name;
  String? description;
  int? categoryId;
  String? createdAt;
  String? updatedAt;

  ShopDetailsSubCategory({
    this.id,
    this.name,
    this.description,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  ShopDetailsSubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    categoryId = json['categoryId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['categoryId'] = categoryId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class ShopDetailsReview {
  int? id;
  int? productId;
  int? userId;
  int? orderItemId;
  int? rating;
  String? review;
  String? createdAt;
  String? updatedAt;
  ShopDetailsReviewUser? user;

  ShopDetailsReview({
    this.id,
    this.productId,
    this.userId,
    this.orderItemId,
    this.rating,
    this.review,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  ShopDetailsReview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    userId = json['userId'];
    orderItemId = json['orderItemId'];
    rating = json['rating'];
    review = json['review'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null
        ? ShopDetailsReviewUser.fromJson(json['user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['productId'] = productId;
    data['userId'] = userId;
    data['orderItemId'] = orderItemId;
    data['rating'] = rating;
    data['review'] = review;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (user != null) data['user'] = user!.toJson();
    return data;
  }
}

class ShopDetailsSellerOverview {
  int? activeProducts;
  int? itemsSold;
  int? averageRating;
  int? totalReviews;

  ShopDetailsSellerOverview({
    this.activeProducts,
    this.itemsSold,
    this.averageRating,
    this.totalReviews,
  });

  ShopDetailsSellerOverview.fromJson(Map<String, dynamic> json) {
    activeProducts = (json['active_products'] as num?)?.toInt();
    itemsSold = (json['items_sold'] as num?)?.toInt();
    averageRating = (json['average_rating'] as num?)?.toInt();
    totalReviews = (json['total_reviews'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['active_products'] = activeProducts;
    data['items_sold'] = itemsSold;
    data['average_rating'] = averageRating;
    data['total_reviews'] = totalReviews;
    return data;
  }
}

class ShopDetailsRelatedProduct {
  int? id;
  String? name;
  String? description;
  dynamic brand;
  num? originalPrice;
  num? discountedPrice;
  int? discountPercentage;
  List<String>? imageUrls;
  int? categoryId;
  int? subCategoryId;
  int? userId;
  String? condition;
  String? status;
  int? views;
  int? totalReviews;
  int? averageRating;
  bool? isAuthenticated;
  String? authenticationStatus;
  String? approvedAt;
  dynamic rejectedAt;
  dynamic soldAt;
  String? createdAt;
  String? updatedAt;
  ShopDetailsCategory? category;
  ShopDetailsSubCategory? subCategory;
  num? effectivePrice;
  bool? isWishlisted;

  ShopDetailsRelatedProduct({
    this.id,
    this.name,
    this.description,
    this.brand,
    this.originalPrice,
    this.discountedPrice,
    this.discountPercentage,
    this.imageUrls,
    this.categoryId,
    this.subCategoryId,
    this.userId,
    this.condition,
    this.status,
    this.views,
    this.totalReviews,
    this.averageRating,
    this.isAuthenticated,
    this.authenticationStatus,
    this.approvedAt,
    this.rejectedAt,
    this.soldAt,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.subCategory,
    this.effectivePrice,
    this.isWishlisted,
  });

  ShopDetailsRelatedProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    brand = json['brand'];
    originalPrice = json['original_price'] as num?;
    discountedPrice = json['discounted_price'] as num?;
    discountPercentage = (json['discount_percentage'] as num?)?.toInt();
    imageUrls = (json['image_urls'] as List?)?.cast<String>();
    categoryId = (json['categoryId'] as num?)?.toInt();
    subCategoryId = (json['subCategoryId'] as num?)?.toInt();
    userId = (json['userId'] as num?)?.toInt();
    condition = json['condition'];
    status = json['status'];
    views = (json['views'] as num?)?.toInt();
    totalReviews = (json['total_reviews'] as num?)?.toInt();
    averageRating = (json['average_rating'] as num?)?.toInt();
    isAuthenticated = json['is_authenticated'];
    authenticationStatus = json['authentication_status'];
    approvedAt = json['approved_at'];
    rejectedAt = json['rejected_at'];
    soldAt = json['sold_at'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    category = json['category'] != null
        ? ShopDetailsCategory.fromJson(json['category'])
        : null;
    subCategory = json['subCategory'] != null
        ? ShopDetailsSubCategory.fromJson(json['subCategory'])
        : null;
    effectivePrice = json['effective_price'] as num?;
    isWishlisted = json['is_wishlisted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['brand'] = brand;
    data['original_price'] = originalPrice;
    data['discounted_price'] = discountedPrice;
    data['discount_percentage'] = discountPercentage;
    data['image_urls'] = imageUrls;
    data['categoryId'] = categoryId;
    data['subCategoryId'] = subCategoryId;
    data['userId'] = userId;
    data['condition'] = condition;
    data['status'] = status;
    data['views'] = views;
    data['total_reviews'] = totalReviews;
    data['average_rating'] = averageRating;
    data['is_authenticated'] = isAuthenticated;
    data['authentication_status'] = authenticationStatus;
    data['approved_at'] = approvedAt;
    data['rejected_at'] = rejectedAt;
    data['sold_at'] = soldAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (category != null) data['category'] = category!.toJson();
    if (subCategory != null) data['subCategory'] = subCategory!.toJson();
    data['effective_price'] = effectivePrice;
    data['is_wishlisted'] = isWishlisted;
    return data;
  }
}
