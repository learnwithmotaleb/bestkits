/// success : true
/// statusCode : 200
/// message : "Request successful"
/// data : [{"id":7,"categoryId":2,"question":"How does the payment system work?","answer":"Payments are processed securely through the platform checkout.","createdAt":"2026-07-09T08:10:00.000Z","updatedAt":"2026-07-09T08:10:00.000Z","category":{"id":2,"name":"Payments","createdAt":"2026-07-09T08:00:00.000Z","updatedAt":"2026-07-09T08:00:00.000Z"}}]
/// meta : {"total":1,"page":1,"limit":10,"pages":1}

class FaqModel {
  FaqModel({
      bool? success, 
      num? statusCode, 
      String? message, 
      List<Data>? data, 
      Meta? meta,}){
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
    _meta = meta;
}

  FaqModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  List<Data>? _data;
  Meta? _meta;
FaqModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  List<Data>? data,
  Meta? meta,
}) => FaqModel(  success: success ?? _success,
  statusCode: statusCode ?? _statusCode,
  message: message ?? _message,
  data: data ?? _data,
  meta: meta ?? _meta,
);
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;
  List<Data>? get data => _data;
  Meta? get meta => _meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['statusCode'] = _statusCode;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_meta != null) {
      map['meta'] = _meta?.toJson();
    }
    return map;
  }

}

/// total : 1
/// page : 1
/// limit : 10
/// pages : 1

class Meta {
  Meta({
      num? total, 
      num? page, 
      num? limit, 
      num? pages,}){
    _total = total;
    _page = page;
    _limit = limit;
    _pages = pages;
}

  Meta.fromJson(dynamic json) {
    _total = json['total'];
    _page = json['page'];
    _limit = json['limit'];
    _pages = json['pages'];
  }
  num? _total;
  num? _page;
  num? _limit;
  num? _pages;
Meta copyWith({  num? total,
  num? page,
  num? limit,
  num? pages,
}) => Meta(  total: total ?? _total,
  page: page ?? _page,
  limit: limit ?? _limit,
  pages: pages ?? _pages,
);
  num? get total => _total;
  num? get page => _page;
  num? get limit => _limit;
  num? get pages => _pages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = _total;
    map['page'] = _page;
    map['limit'] = _limit;
    map['pages'] = _pages;
    return map;
  }

}

/// id : 7
/// categoryId : 2
/// question : "How does the payment system work?"
/// answer : "Payments are processed securely through the platform checkout."
/// createdAt : "2026-07-09T08:10:00.000Z"
/// updatedAt : "2026-07-09T08:10:00.000Z"
/// category : {"id":2,"name":"Payments","createdAt":"2026-07-09T08:00:00.000Z","updatedAt":"2026-07-09T08:00:00.000Z"}

class Data {
  Data({
      num? id, 
      num? categoryId, 
      String? question, 
      String? answer, 
      String? createdAt, 
      String? updatedAt, 
      Category? category,}){
    _id = id;
    _categoryId = categoryId;
    _question = question;
    _answer = answer;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _category = category;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _categoryId = json['categoryId'];
    _question = json['question'];
    _answer = json['answer'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _category = json['category'] != null ? Category.fromJson(json['category']) : null;
  }
  num? _id;
  num? _categoryId;
  String? _question;
  String? _answer;
  String? _createdAt;
  String? _updatedAt;
  Category? _category;
Data copyWith({  num? id,
  num? categoryId,
  String? question,
  String? answer,
  String? createdAt,
  String? updatedAt,
  Category? category,
}) => Data(  id: id ?? _id,
  categoryId: categoryId ?? _categoryId,
  question: question ?? _question,
  answer: answer ?? _answer,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  category: category ?? _category,
);
  num? get id => _id;
  num? get categoryId => _categoryId;
  String? get question => _question;
  String? get answer => _answer;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Category? get category => _category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['categoryId'] = _categoryId;
    map['question'] = _question;
    map['answer'] = _answer;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_category != null) {
      map['category'] = _category?.toJson();
    }
    return map;
  }

}

/// id : 2
/// name : "Payments"
/// createdAt : "2026-07-09T08:00:00.000Z"
/// updatedAt : "2026-07-09T08:00:00.000Z"

class Category {
  Category({
      num? id, 
      String? name, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _name = name;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Category.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _id;
  String? _name;
  String? _createdAt;
  String? _updatedAt;
Category copyWith({  num? id,
  String? name,
  String? createdAt,
  String? updatedAt,
}) => Category(  id: id ?? _id,
  name: name ?? _name,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  String? get name => _name;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}