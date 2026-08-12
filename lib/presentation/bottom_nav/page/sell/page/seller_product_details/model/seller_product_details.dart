class SellerProductDetails {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  SellerProductDetails(
      {this.success, this.statusCode, this.message, this.data});

  SellerProductDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? status;
  String? sellerStatus;
  Category? category;
  SubCategory? subCategory;
  List<String>? imageUrls;
  String? imageUrl;
  num? originalPrice;
  num? discountedPrice;
  num? effectivePrice;
  num? discountPercentage;
  num? averageRating;
  num? totalReviews;
  String? createdAt;
  String? updatedAt;
  Actions? actions;
  String? description;
  String? condition;
  dynamic brand;
  bool? isAuthenticated;
  String? authenticationStatus;
  String? approvedAt;
  String? rejectedAt;
  String? soldAt;
  Seller? seller;
  dynamic latestRequest;
  List<dynamic>? reviews;
  int? ordersCount;

  Data(
      {this.id,
        this.name,
        this.status,
        this.sellerStatus,
        this.category,
        this.subCategory,
        this.imageUrls,
        this.imageUrl,
        this.originalPrice,
        this.discountedPrice,
        this.effectivePrice,
        this.discountPercentage,
        this.averageRating,
        this.totalReviews,
        this.createdAt,
        this.updatedAt,
        this.actions,
        this.description,
        this.condition,
        this.brand,
        this.isAuthenticated,
        this.authenticationStatus,
        this.approvedAt,
        this.rejectedAt,
        this.soldAt,
        this.seller,
        this.latestRequest,
        this.reviews,
        this.ordersCount});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    sellerStatus = json['seller_status'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    subCategory = json['subCategory'] != null
        ? new SubCategory.fromJson(json['subCategory'])
        : null;
    imageUrls = json['image_urls'] != null ? json['image_urls'].cast<String>() : null;
    imageUrl = json['image_url'];
    originalPrice = (json['original_price'] as num?);
    discountedPrice = (json['discounted_price'] as num?);
    effectivePrice = (json['effective_price'] as num?);
    discountPercentage = (json['discount_percentage'] as num?);
    averageRating = (json['average_rating'] as num?);
    totalReviews = (json['total_reviews'] as num?);
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    actions =
    json['actions'] != null ? new Actions.fromJson(json['actions']) : null;
    description = json['description'];
    condition = json['condition'];
    brand = json['brand'];
    isAuthenticated = json['is_authenticated'];
    authenticationStatus = json['authentication_status'];
    approvedAt = json['approved_at'];
    rejectedAt = json['rejected_at'];
    soldAt = json['sold_at'];
    seller =
    json['seller'] != null ? new Seller.fromJson(json['seller']) : null;
    latestRequest = json['latest_request'];
    if (json['reviews'] != null) {
      reviews = <dynamic>[];
      json['reviews'].forEach((v) {
        reviews!.add(v);
      });
    }
    ordersCount = json['orders_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['seller_status'] = this.sellerStatus;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.subCategory != null) {
      data['subCategory'] = this.subCategory!.toJson();
    }
    data['image_urls'] = this.imageUrls;
    data['image_url'] = this.imageUrl;
    data['original_price'] = this.originalPrice;
    data['discounted_price'] = this.discountedPrice;
    data['effective_price'] = this.effectivePrice;
    data['discount_percentage'] = this.discountPercentage;
    data['average_rating'] = this.averageRating;
    data['total_reviews'] = this.totalReviews;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.actions != null) {
      data['actions'] = this.actions!.toJson();
    }
    data['description'] = this.description;
    data['condition'] = this.condition;
    data['brand'] = this.brand;
    data['is_authenticated'] = this.isAuthenticated;
    data['authentication_status'] = this.authenticationStatus;
    data['approved_at'] = this.approvedAt;
    data['rejected_at'] = this.rejectedAt;
    data['sold_at'] = this.soldAt;
    if (this.seller != null) {
      data['seller'] = this.seller!.toJson();
    }
    data['latest_request'] = this.latestRequest;
    if (this.reviews != null) {
      data['reviews'] = this.reviews;
    }
    data['orders_count'] = this.ordersCount;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? description;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  Category(
      {this.id,
        this.name,
        this.description,
        this.imageUrl,
        this.createdAt,
        this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image_url'] = this.imageUrl;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class SubCategory {
  int? id;
  String? name;
  String? description;
  int? categoryId;
  String? createdAt;
  String? updatedAt;

  SubCategory(
      {this.id,
        this.name,
        this.description,
        this.categoryId,
        this.createdAt,
        this.updatedAt});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    categoryId = json['categoryId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['categoryId'] = this.categoryId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Actions {
  bool? canUpdate;
  bool? canViewOrders;
  bool? canMarkActive;
  bool? canMarkInactive;
  bool? canDelete;

  Actions(
      {this.canUpdate,
        this.canViewOrders,
        this.canMarkActive,
        this.canMarkInactive,
        this.canDelete});

  Actions.fromJson(Map<String, dynamic> json) {
    canUpdate = json['can_update'];
    canViewOrders = json['can_view_orders'];
    canMarkActive = json['can_mark_active'];
    canMarkInactive = json['can_mark_inactive'];
    canDelete = json['can_delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['can_update'] = this.canUpdate;
    data['can_view_orders'] = this.canViewOrders;
    data['can_mark_active'] = this.canMarkActive;
    data['can_mark_inactive'] = this.canMarkInactive;
    data['can_delete'] = this.canDelete;
    return data;
  }
}

class Seller {
  int? id;
  String? email;
  String? sellerTier;
  bool? stripeOnboardingComplete;
  Profile? profile;

  Seller(
      {this.id,
        this.email,
        this.sellerTier,
        this.stripeOnboardingComplete,
        this.profile});

  Seller.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    sellerTier = json['seller_tier'];
    stripeOnboardingComplete = json['stripe_onboarding_complete'];
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['seller_tier'] = this.sellerTier;
    data['stripe_onboarding_complete'] = this.stripeOnboardingComplete;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? fullName;
  String? avatarUrl;
  String? country;

  Profile({this.fullName, this.avatarUrl, this.country});

  Profile.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    avatarUrl = json['avatar_url'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['avatar_url'] = this.avatarUrl;
    data['country'] = this.country;
    return data;
  }
}
