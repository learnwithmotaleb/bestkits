/// success : true
/// statusCode : 200
/// message : "Request successful"
/// data : {"id":1,"name":"Clothing for Girls","description":"Girl clothing","image_url":"/uploads/1789294644871-fd955ae088f75396fd70dc9776552ab0 (1).jpg","createdAt":"2026-08-25T10:21:59.411Z","updatedAt":"2026-09-13T10:17:26.529Z","subCategories":[{"id":1,"name":"Dresses","description":"Dresses for girls","categoryId":1,"createdAt":"2026-08-25T10:21:59.411Z","updatedAt":"2026-09-13T09:46:49.828Z","product_count":6},{"id":3,"name":"Jackets & Coats","description":"Jackets and coats","categoryId":1,"createdAt":"2026-08-25T10:21:59.411Z","updatedAt":"2026-09-13T09:47:06.236Z","product_count":0},{"id":2,"name":"Knitwear","description":"Knitwear","categoryId":1,"createdAt":"2026-08-25T10:21:59.411Z","updatedAt":"2026-09-13T09:47:25.289Z","product_count":0},{"id":10,"name":"Shorts","description":"Shorts","categoryId":1,"createdAt":"2026-09-13T09:47:50.717Z","updatedAt":"2026-09-13T09:47:50.717Z","product_count":0},{"id":11,"name":"Skirts","description":"Skirts","categoryId":1,"createdAt":"2026-09-13T09:47:58.312Z","updatedAt":"2026-09-13T09:47:58.312Z","product_count":0},{"id":12,"name":"Tops","description":"Tops","categoryId":1,"createdAt":"2026-09-13T09:48:13.395Z","updatedAt":"2026-09-13T09:48:13.395Z","product_count":0},{"id":13,"name":"Trousers","description":"Trousers","categoryId":1,"createdAt":"2026-09-13T09:48:23.796Z","updatedAt":"2026-09-13T09:48:23.796Z","product_count":0},{"id":14,"name":"Pyjamas & Bodysuits","description":"Pyjamas & Bodysuits","categoryId":1,"createdAt":"2026-09-13T09:49:29.842Z","updatedAt":"2026-09-13T09:49:29.842Z","product_count":0}],"product_count":6}

class CategorieModel {
  CategorieModel({
      bool? success, 
      num? statusCode, 
      String? message, 
      Data? data,}){
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  CategorieModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  Data? _data;
CategorieModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  Data? data,
}) => CategorieModel(  success: success ?? _success,
  statusCode: statusCode ?? _statusCode,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['statusCode'] = _statusCode;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// id : 1
/// name : "Clothing for Girls"
/// description : "Girl clothing"
/// image_url : "/uploads/1789294644871-fd955ae088f75396fd70dc9776552ab0 (1).jpg"
/// createdAt : "2026-08-25T10:21:59.411Z"
/// updatedAt : "2026-09-13T10:17:26.529Z"
/// subCategories : [{"id":1,"name":"Dresses","description":"Dresses for girls","categoryId":1,"createdAt":"2026-08-25T10:21:59.411Z","updatedAt":"2026-09-13T09:46:49.828Z","product_count":6},{"id":3,"name":"Jackets & Coats","description":"Jackets and coats","categoryId":1,"createdAt":"2026-08-25T10:21:59.411Z","updatedAt":"2026-09-13T09:47:06.236Z","product_count":0},{"id":2,"name":"Knitwear","description":"Knitwear","categoryId":1,"createdAt":"2026-08-25T10:21:59.411Z","updatedAt":"2026-09-13T09:47:25.289Z","product_count":0},{"id":10,"name":"Shorts","description":"Shorts","categoryId":1,"createdAt":"2026-09-13T09:47:50.717Z","updatedAt":"2026-09-13T09:47:50.717Z","product_count":0},{"id":11,"name":"Skirts","description":"Skirts","categoryId":1,"createdAt":"2026-09-13T09:47:58.312Z","updatedAt":"2026-09-13T09:47:58.312Z","product_count":0},{"id":12,"name":"Tops","description":"Tops","categoryId":1,"createdAt":"2026-09-13T09:48:13.395Z","updatedAt":"2026-09-13T09:48:13.395Z","product_count":0},{"id":13,"name":"Trousers","description":"Trousers","categoryId":1,"createdAt":"2026-09-13T09:48:23.796Z","updatedAt":"2026-09-13T09:48:23.796Z","product_count":0},{"id":14,"name":"Pyjamas & Bodysuits","description":"Pyjamas & Bodysuits","categoryId":1,"createdAt":"2026-09-13T09:49:29.842Z","updatedAt":"2026-09-13T09:49:29.842Z","product_count":0}]
/// product_count : 6

class Data {
  Data({
      num? id, 
      String? name, 
      String? description, 
      String? imageUrl, 
      String? createdAt, 
      String? updatedAt, 
      List<SubCategories>? subCategories, 
      num? productCount,}){
    _id = id;
    _name = name;
    _description = description;
    _imageUrl = imageUrl;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _subCategories = subCategories;
    _productCount = productCount;
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
    _productCount = json['product_count'];
  }
  num? _id;
  String? _name;
  String? _description;
  String? _imageUrl;
  String? _createdAt;
  String? _updatedAt;
  List<SubCategories>? _subCategories;
  num? _productCount;
Data copyWith({  num? id,
  String? name,
  String? description,
  String? imageUrl,
  String? createdAt,
  String? updatedAt,
  List<SubCategories>? subCategories,
  num? productCount,
}) => Data(  id: id ?? _id,
  name: name ?? _name,
  description: description ?? _description,
  imageUrl: imageUrl ?? _imageUrl,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  subCategories: subCategories ?? _subCategories,
  productCount: productCount ?? _productCount,
);
  num? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get imageUrl => _imageUrl;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<SubCategories>? get subCategories => _subCategories;
  num? get productCount => _productCount;

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
    map['product_count'] = _productCount;
    return map;
  }

}

/// id : 1
/// name : "Dresses"
/// description : "Dresses for girls"
/// categoryId : 1
/// createdAt : "2026-08-25T10:21:59.411Z"
/// updatedAt : "2026-09-13T09:46:49.828Z"
/// product_count : 6

class SubCategories {
  SubCategories({
      num? id, 
      String? name, 
      String? description, 
      num? categoryId, 
      String? createdAt, 
      String? updatedAt, 
      num? productCount,}){
    _id = id;
    _name = name;
    _description = description;
    _categoryId = categoryId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _productCount = productCount;
}

  SubCategories.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _categoryId = json['categoryId'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _productCount = json['product_count'];
  }
  num? _id;
  String? _name;
  String? _description;
  num? _categoryId;
  String? _createdAt;
  String? _updatedAt;
  num? _productCount;
SubCategories copyWith({  num? id,
  String? name,
  String? description,
  num? categoryId,
  String? createdAt,
  String? updatedAt,
  num? productCount,
}) => SubCategories(  id: id ?? _id,
  name: name ?? _name,
  description: description ?? _description,
  categoryId: categoryId ?? _categoryId,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  productCount: productCount ?? _productCount,
);
  num? get id => _id;
  String? get name => _name;
  String? get description => _description;
  num? get categoryId => _categoryId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get productCount => _productCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['categoryId'] = _categoryId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['product_count'] = _productCount;
    return map;
  }

}