import 'package:bestkits/data/model/product_model.dart';
import 'package:bestkits/service/api_url.dart';

class HomeModel {
  bool? success;
  int? statusCode;
  String? message;
  HomeData? data;

  HomeModel({this.success, this.statusCode, this.message, this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? HomeData.fromJson(json['data']) : null;
  }
}

class HomeData {
  List<CategoryData>? categories;
  List<ProductModel>? trending;
  List<PromotedData>? promoted;
  List<ProductModel>? newArrivals;
  List<TrustCardData>? trustCards;

  HomeData({this.categories, this.trending, this.promoted, this.newArrivals, this.trustCards});

  HomeData.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <CategoryData>[];
      json['categories'].forEach((v) {
        try {
          categories!.add(CategoryData.fromJson(v));
        } catch (e) {
          print("Error parsing category: \$e");
        }
      });
    }
    if (json['trending'] != null) {
      trending = <ProductModel>[];
      json['trending'].forEach((v) {
        try {
          trending!.add(ProductModel.fromJson(v));
        } catch (e) {
          print("Error parsing trending product: \$e");
        }
      });
    }
    if (json['promoted'] != null) {
      promoted = <PromotedData>[];
      json['promoted'].forEach((v) {
        try {
          promoted!.add(PromotedData.fromJson(v));
        } catch (e) {
          print("Error parsing promoted product: $e");
        }
      });
    }
    if (json['new_arrivals'] != null) {
      newArrivals = <ProductModel>[];
      json['new_arrivals'].forEach((v) {
        try {
          newArrivals!.add(ProductModel.fromJson(v));
        } catch (e) {
          print("Error parsing new arrival product: \$e");
        }
      });
    }
    if (json['trust_cards'] != null) {
      trustCards = <TrustCardData>[];
      json['trust_cards'].forEach((v) {
        try {
          trustCards!.add(TrustCardData.fromJson(v));
        } catch (e) {
          print("Error parsing trust card: \$e");
        }
      });
    }
  }
}

class CategoryData {
  int? id;
  String? name;
  String? description;
  String? imageUrl;
  int? productCount;
  List<SubCategoryData>? subCategories;

  CategoryData({this.id, this.name, this.description, this.imageUrl, this.productCount, this.subCategories});

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    productCount = json['product_count'];
    if (json['subCategories'] != null) {
      subCategories = <SubCategoryData>[];
      json['subCategories'].forEach((v) {
        subCategories!.add(SubCategoryData.fromJson(v));
      });
    }
  }
}

class SubCategoryData {
  int? id;
  String? name;

  SubCategoryData({this.id, this.name});

  SubCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}



class TrustCardData {
  String? key;
  String? title;
  String? tone;

  TrustCardData({this.key, this.title, this.tone});

  TrustCardData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    title = json['title'];
    tone = json['tone'];
  }
}

class PromotedData {
  int? id;
  String? name;
  num? originalPrice;
  num? discountedPrice;
  num? discountPercentage;
  List<String>? imageUrls;
  num? averageRating;
  int? totalReviews;
  String? condition;
  bool? isAuthenticated;
  num? effectivePrice;
  bool? isWishlisted;
  String? categoryName;

  PromotedData({
    this.id,
    this.name,
    this.originalPrice,
    this.discountedPrice,
    this.discountPercentage,
    this.imageUrls,
    this.averageRating,
    this.totalReviews,
    this.condition,
    this.isAuthenticated,
    this.effectivePrice,
    this.isWishlisted,
  });

  PromotedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    originalPrice = json['original_price'];
    discountedPrice = json['discounted_price'];
    discountPercentage = json['discount_percentage'];
    if (json['image_urls'] != null) {
      imageUrls = List<String>.from(json['image_urls']);
    }
    averageRating = json['average_rating'];
    totalReviews = json['total_reviews'];
    condition = json['condition'];
    isAuthenticated = json['is_authenticated'];
    effectivePrice = json['effective_price'];
    isWishlisted = json['is_wishlisted'];
    if (json['category'] != null) {
      categoryName = json['category']['name'];
    }
  }

  String get formattedPrice => '€${(effectivePrice ?? 0).toStringAsFixed(2)}';
  String get formattedOriginalPrice => '€${(originalPrice ?? 0).toStringAsFixed(2)}';
  String get primaryImageUrl {
    return (imageUrls != null && imageUrls!.isNotEmpty) ? ApiUrl.buildImageUrl(imageUrls!.first) : '';
  }
}
