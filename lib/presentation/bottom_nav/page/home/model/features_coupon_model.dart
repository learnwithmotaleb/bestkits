class FeatureCouponModel {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  FeatureCouponModel({this.success, this.statusCode, this.message, this.data});

  FeatureCouponModel.fromJson(Map<String, dynamic> json) {
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
  String? campaignReason;
  String? code;
  int? categoryId;
  int? subCategoryId;
  String? discountType;
  int? discountValue;
  String? usageType;
  Null? usageLimit;
  int? usedCount;
  String? startDate;
  String? endDate;
  bool? isActive;
  bool? featured;
  String? createdAt;
  String? updatedAt;
  Category? category;
  SubCategory? subCategory;
  String? status;
  SubCategory? discountCategory;

  Data(
      {this.id,
        this.campaignReason,
        this.code,
        this.categoryId,
        this.subCategoryId,
        this.discountType,
        this.discountValue,
        this.usageType,
        this.usageLimit,
        this.usedCount,
        this.startDate,
        this.endDate,
        this.isActive,
        this.featured,
        this.createdAt,
        this.updatedAt,
        this.category,
        this.subCategory,
        this.status,
        this.discountCategory});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    campaignReason = json['campaign_reason'];
    code = json['code'];
    categoryId = json['categoryId'];
    subCategoryId = json['subCategoryId'];
    discountType = json['discount_type'];
    discountValue = json['discount_value'];
    usageType = json['usage_type'];
    usageLimit = json['usage_limit'];
    usedCount = json['used_count'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    isActive = json['is_active'];
    featured = json['featured'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    subCategory = json['subCategory'] != null
        ? new SubCategory.fromJson(json['subCategory'])
        : null;
    status = json['status'];
    discountCategory = json['discount_category'] != null
        ? new SubCategory.fromJson(json['discount_category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['campaign_reason'] = this.campaignReason;
    data['code'] = this.code;
    data['categoryId'] = this.categoryId;
    data['subCategoryId'] = this.subCategoryId;
    data['discount_type'] = this.discountType;
    data['discount_value'] = this.discountValue;
    data['usage_type'] = this.usageType;
    data['usage_limit'] = this.usageLimit;
    data['used_count'] = this.usedCount;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['is_active'] = this.isActive;
    data['featured'] = this.featured;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.subCategory != null) {
      data['subCategory'] = this.subCategory!.toJson();
    }
    data['status'] = this.status;
    if (this.discountCategory != null) {
      data['discount_category'] = this.discountCategory!.toJson();
    }
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
