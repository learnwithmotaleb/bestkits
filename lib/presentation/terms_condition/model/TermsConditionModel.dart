/// success : true
/// statusCode : 200
/// message : "Request successful"
/// data : {"id":1,"type":"TERMS_AND_CONDITIONS","content":"Terms & Conditions\n\nLast Updated: 14 March 2026\n\nBestKid is a marketplace for buying and selling kids fashion and related items.\n\nUsers must provide accurate product information, follow platform policies, and use secure payment methods.","createdAt":"2026-07-07T08:18:35.917Z","updatedAt":"2026-07-07T08:18:35.917Z"}

class TermsConditionModel {
  TermsConditionModel({
      bool? success, 
      num? statusCode, 
      String? message, 
      Data? data,}){
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  TermsConditionModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  Data? _data;
TermsConditionModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  Data? data,
}) => TermsConditionModel(  success: success ?? _success,
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
/// type : "TERMS_AND_CONDITIONS"
/// content : "Terms & Conditions\n\nLast Updated: 14 March 2026\n\nBestKid is a marketplace for buying and selling kids fashion and related items.\n\nUsers must provide accurate product information, follow platform policies, and use secure payment methods."
/// createdAt : "2026-07-07T08:18:35.917Z"
/// updatedAt : "2026-07-07T08:18:35.917Z"

class Data {
  Data({
      num? id, 
      String? type, 
      String? content, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _type = type;
    _content = content;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['type'];
    _content = json['content'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _id;
  String? _type;
  String? _content;
  String? _createdAt;
  String? _updatedAt;
Data copyWith({  num? id,
  String? type,
  String? content,
  String? createdAt,
  String? updatedAt,
}) => Data(  id: id ?? _id,
  type: type ?? _type,
  content: content ?? _content,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  String? get type => _type;
  String? get content => _content;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['type'] = _type;
    map['content'] = _content;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}