/// success : true
/// statusCode : 200
/// message : "Request successful"
/// data : [{"id":8,"userId":5,"title":"Order Cancelled","message":"Order #16 has been cancelled by the buyer.","type":"ORDER","isRead":false,"createdAt":"2026-07-23T05:08:33.281Z","updatedAt":"2026-07-23T05:08:33.281Z"},{"id":2,"userId":5,"title":"Welcome to BestKid","message":"Your seeded account is ready to use.","type":"OTHER","isRead":false,"createdAt":"2026-07-23T04:44:06.743Z","updatedAt":"2026-07-23T04:44:06.743Z"}]
/// meta : {"total":2,"page":1,"limit":10,"pages":1}

class NotificationModel {
  NotificationModel({
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

  NotificationModel.fromJson(dynamic json) {
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
NotificationModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  List<Data>? data,
  Meta? meta,
}) => NotificationModel(  success: success ?? _success,
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

/// total : 2
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

/// id : 8
/// userId : 5
/// title : "Order Cancelled"
/// message : "Order #16 has been cancelled by the buyer."
/// type : "ORDER"
/// isRead : false
/// createdAt : "2026-07-23T05:08:33.281Z"
/// updatedAt : "2026-07-23T05:08:33.281Z"

class Data {
  Data({
      num? id, 
      num? userId, 
      String? title, 
      String? message, 
      String? type, 
      bool? isRead, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _userId = userId;
    _title = title;
    _message = message;
    _type = type;
    _isRead = isRead;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _title = json['title'];
    _message = json['message'];
    _type = json['type'];
    _isRead = json['isRead'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _id;
  num? _userId;
  String? _title;
  String? _message;
  String? _type;
  bool? _isRead;
  String? _createdAt;
  String? _updatedAt;
Data copyWith({  num? id,
  num? userId,
  String? title,
  String? message,
  String? type,
  bool? isRead,
  String? createdAt,
  String? updatedAt,
}) => Data(  id: id ?? _id,
  userId: userId ?? _userId,
  title: title ?? _title,
  message: message ?? _message,
  type: type ?? _type,
  isRead: isRead ?? _isRead,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get userId => _userId;
  String? get title => _title;
  String? get message => _message;
  String? get type => _type;
  bool? get isRead => _isRead;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['title'] = _title;
    map['message'] = _message;
    map['type'] = _type;
    map['isRead'] = _isRead;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}