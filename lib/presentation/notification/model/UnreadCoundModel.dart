/// success : true
/// statusCode : 200
/// message : "Request successful"
/// data : {"count":2}

class UnreadCoundModel {
  UnreadCoundModel({
      bool? success, 
      num? statusCode, 
      String? message, 
      Data? data,}){
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  UnreadCoundModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  Data? _data;
UnreadCoundModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  Data? data,
}) => UnreadCoundModel(  success: success ?? _success,
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

/// count : 2

class Data {
  Data({
      num? count,}){
    _count = count;
}

  Data.fromJson(dynamic json) {
    _count = json['count'];
  }
  num? _count;
Data copyWith({  num? count,
}) => Data(  count: count ?? _count,
);
  num? get count => _count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    return map;
  }

}