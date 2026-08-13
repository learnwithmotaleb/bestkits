class LegitgrailsCategoryModel {
  bool? success;
  int? statusCode;
  String? message;
  CategoryListWrapper? data;

  LegitgrailsCategoryModel(
      {this.success, this.statusCode, this.message, this.data});

  LegitgrailsCategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? CategoryListWrapper.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CategoryListWrapper {
  List<CategoryData>? data;

  CategoryListWrapper({this.data});

  CategoryListWrapper.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryData {
  String? code;
  String? name;
  String? nameLocale;
  String? iconUrl;

  CategoryData({this.code, this.name, this.nameLocale, this.iconUrl});

  CategoryData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    nameLocale = json['name_locale'];
    iconUrl = json['icon_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['name_locale'] = nameLocale;
    data['icon_url'] = iconUrl;
    return data;
  }
}
