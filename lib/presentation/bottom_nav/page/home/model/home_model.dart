import 'package:bestkits/data/model/product_model.dart';

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
  List<ProductModel>? promoted;
  List<ProductModel>? newArrivals;
  List<TrustCardData>? trustCards;

  HomeData({this.categories, this.trending, this.promoted, this.newArrivals, this.trustCards});

  HomeData.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <CategoryData>[];
      json['categories'].forEach((v) {
        categories!.add(CategoryData.fromJson(v));
      });
    }
    if (json['trending'] != null) {
      trending = <ProductModel>[];
      json['trending'].forEach((v) {
        trending!.add(ProductModel.fromJson(v));
      });
    }
    if (json['promoted'] != null) {
      promoted = <ProductModel>[];
      json['promoted'].forEach((v) {
        promoted!.add(ProductModel.fromJson(v));
      });
    }
    if (json['new_arrivals'] != null) {
      newArrivals = <ProductModel>[];
      json['new_arrivals'].forEach((v) {
        newArrivals!.add(ProductModel.fromJson(v));
      });
    }
    if (json['trust_cards'] != null) {
      trustCards = <TrustCardData>[];
      json['trust_cards'].forEach((v) {
        trustCards!.add(TrustCardData.fromJson(v));
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
