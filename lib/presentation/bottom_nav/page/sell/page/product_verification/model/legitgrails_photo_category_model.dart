class LegitgrailsPhotoCategoryModel {
  bool? success;
  int? statusCode;
  String? message;
  PhotoCategoryListWrapper? data;

  LegitgrailsPhotoCategoryModel(
      {this.success, this.statusCode, this.message, this.data});

  LegitgrailsPhotoCategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? PhotoCategoryListWrapper.fromJson(json['data']) : null;
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

class PhotoCategoryListWrapper {
  List<PhotoRequirementData>? data;

  PhotoCategoryListWrapper({this.data});

  PhotoCategoryListWrapper.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PhotoRequirementData>[];
      json['data'].forEach((v) {
        data!.add(PhotoRequirementData.fromJson(v));
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

class PhotoRequirementData {
  String? code;
  String? name;
  String? nameLocale;
  bool? required;
  int? photoLimit;
  String? iconUrl;
  List<String>? exampleUrls;

  PhotoRequirementData(
      {this.code,
      this.name,
      this.nameLocale,
      this.required,
      this.photoLimit,
      this.iconUrl,
      this.exampleUrls});

  PhotoRequirementData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    nameLocale = json['name_locale'];
    required = json['required'];
    photoLimit = json['photo_limit'];
    iconUrl = json['icon_url'];
    if (json['example_urls'] != null) {
      exampleUrls = json['example_urls'].cast<String>();
    } else {
      exampleUrls = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['name_locale'] = nameLocale;
    data['required'] = required;
    data['photo_limit'] = photoLimit;
    data['icon_url'] = iconUrl;
    data['example_urls'] = exampleUrls;
    return data;
  }
}
