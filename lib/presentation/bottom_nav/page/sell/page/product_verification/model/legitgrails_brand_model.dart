class LegitgrailsBrandModel {
  bool? success;
  int? statusCode;
  String? message;
  BrandPaginationData? data;

  LegitgrailsBrandModel(
      {this.success, this.statusCode, this.message, this.data});

  LegitgrailsBrandModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null
        ? BrandPaginationData.fromJson(json['data'])
        : null;
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

class BrandPaginationData {
  List<BrandData>? data;
  int? page;
  int? limit;
  int? total;

  BrandPaginationData({this.data, this.page, this.limit, this.total});

  BrandPaginationData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BrandData>[];
      json['data'].forEach((v) {
        data!.add(BrandData.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['total'] = total;
    return data;
  }
}

class BrandData {
  String? code;
  String? name;
  String? nameLocale;
  List<BrandCategoryData>? categories;

  BrandData({this.code, this.name, this.nameLocale, this.categories});

  BrandData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    nameLocale = json['name_locale'];
    if (json['categories'] != null) {
      categories = <BrandCategoryData>[];
      json['categories'].forEach((v) {
        categories!.add(BrandCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['name_locale'] = nameLocale;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BrandCategoryData {
  String? code;
  String? name;
  String? nameLocale;
  String? iconUrl;

  BrandCategoryData({this.code, this.name, this.nameLocale, this.iconUrl});

  BrandCategoryData.fromJson(Map<String, dynamic> json) {
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
