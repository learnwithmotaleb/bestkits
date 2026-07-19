import 'package:bestkits/data/model/product_model.dart';

class RecentlyViewModel {
  bool? success;
  int? statusCode;
  String? message;
  List<ProductModel>? data;
  Meta? meta;

  RecentlyViewModel(
      {this.success, this.statusCode, this.message, this.data, this.meta});

  RecentlyViewModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductModel>[];
      json['data'].forEach((v) {
        data!.add(ProductModel.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
}

class Meta {
  int? total;
  int? page;
  int? limit;
  int? pages;

  Meta({this.total, this.page, this.limit, this.pages});

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    pages = json['pages'];
  }
}
