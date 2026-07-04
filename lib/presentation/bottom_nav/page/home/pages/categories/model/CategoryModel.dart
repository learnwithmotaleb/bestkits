/// success : true
/// statusCode : 200
/// data : [{"id":2,"name":"Category 1","description":"A category","image_url":null,"createdAt":"2026-07-04T14:01:22.632Z","updatedAt":"2026-07-04T14:01:22.632Z","subCategories":[{"id":1,"name":"Sub Category 1","description":"Sub category 1","categoryId":2,"createdAt":"2026-07-04T08:12:42.059Z","updatedAt":"2026-07-04T08:12:42.059Z"},{"id":2,"name":"Sub Category 2","description":"Sub category 2","categoryId":2,"createdAt":"2026-07-04T08:12:50.340Z","updatedAt":"2026-07-04T08:12:50.340Z"}]},{"id":3,"name":"Shoes","description":"Shoe category","image_url":null,"createdAt":"2026-07-04T08:13:59.249Z","updatedAt":"2026-07-04T08:13:59.249Z","subCategories":[{"id":3,"name":"Kids Show","description":"Kids Shoe","categoryId":3,"createdAt":"2026-07-04T08:14:23.101Z","updatedAt":"2026-07-04T08:14:23.101Z"},{"id":4,"name":"Ladies Shoes","description":"Ladies Shoes","categoryId":3,"createdAt":"2026-07-04T08:14:40.931Z","updatedAt":"2026-07-04T08:14:40.931Z"}]}]

class CategoryModel {
  CategoryModel({
      bool? success, 
      num? statusCode, 
      List<Data>? data,}){
    _success = success;
    _statusCode = statusCode;
    _data = data;
}

  CategoryModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _success;
  num? _statusCode;
  List<Data>? _data;
CategoryModel copyWith({  bool? success,
  num? statusCode,
  List<Data>? data,
}) => CategoryModel(  success: success ?? _success,
  statusCode: statusCode ?? _statusCode,
  data: data ?? _data,
);
  bool? get success => _success;
  num? get statusCode => _statusCode;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['statusCode'] = _statusCode;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 2
/// name : "Category 1"
/// description : "A category"
/// image_url : null
/// createdAt : "2026-07-04T14:01:22.632Z"
/// updatedAt : "2026-07-04T14:01:22.632Z"
/// subCategories : [{"id":1,"name":"Sub Category 1","description":"Sub category 1","categoryId":2,"createdAt":"2026-07-04T08:12:42.059Z","updatedAt":"2026-07-04T08:12:42.059Z"},{"id":2,"name":"Sub Category 2","description":"Sub category 2","categoryId":2,"createdAt":"2026-07-04T08:12:50.340Z","updatedAt":"2026-07-04T08:12:50.340Z"}]

class Data {
  Data({
      num? id, 
      String? name, 
      String? description, 
      dynamic imageUrl, 
      String? createdAt, 
      String? updatedAt, 
      List<SubCategories>? subCategories,}){
    _id = id;
    _name = name;
    _description = description;
    _imageUrl = imageUrl;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _subCategories = subCategories;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _imageUrl = json['image_url'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    if (json['subCategories'] != null) {
      _subCategories = [];
      json['subCategories'].forEach((v) {
        _subCategories?.add(SubCategories.fromJson(v));
      });
    }
  }
  num? _id;
  String? _name;
  String? _description;
  dynamic _imageUrl;
  String? _createdAt;
  String? _updatedAt;
  List<SubCategories>? _subCategories;
Data copyWith({  num? id,
  String? name,
  String? description,
  dynamic imageUrl,
  String? createdAt,
  String? updatedAt,
  List<SubCategories>? subCategories,
}) => Data(  id: id ?? _id,
  name: name ?? _name,
  description: description ?? _description,
  imageUrl: imageUrl ?? _imageUrl,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  subCategories: subCategories ?? _subCategories,
);
  num? get id => _id;
  String? get name => _name;
  String? get description => _description;
  dynamic get imageUrl => _imageUrl;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<SubCategories>? get subCategories => _subCategories;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['image_url'] = _imageUrl;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_subCategories != null) {
      map['subCategories'] = _subCategories?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// name : "Sub Category 1"
/// description : "Sub category 1"
/// categoryId : 2
/// createdAt : "2026-07-04T08:12:42.059Z"
/// updatedAt : "2026-07-04T08:12:42.059Z"

class SubCategories {
  SubCategories({
      num? id, 
      String? name, 
      String? description, 
      num? categoryId, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _name = name;
    _description = description;
    _categoryId = categoryId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  SubCategories.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _categoryId = json['categoryId'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _id;
  String? _name;
  String? _description;
  num? _categoryId;
  String? _createdAt;
  String? _updatedAt;
SubCategories copyWith({  num? id,
  String? name,
  String? description,
  num? categoryId,
  String? createdAt,
  String? updatedAt,
}) => SubCategories(  id: id ?? _id,
  name: name ?? _name,
  description: description ?? _description,
  categoryId: categoryId ?? _categoryId,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  String? get name => _name;
  String? get description => _description;
  num? get categoryId => _categoryId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['categoryId'] = _categoryId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}