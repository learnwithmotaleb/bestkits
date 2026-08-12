/// success : true
/// statusCode : 200
/// message : "Request successful"
/// data : [{"id":5,"userId":22,"address_name":"Home","address":"25 Ivan Vazov Street","city":"Plovdiv","postal_code":"4000","country":"Bulgaria","is_default":true,"createdAt":"2026-07-09T09:10:00.000Z","updatedAt":"2026-07-09T09:10:00.000Z"}]

class AccountAddressModel {
  AccountAddressModel({
      bool? success, 
      num? statusCode, 
      String? message, 
      List<Data>? data,}){
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  AccountAddressModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  List<Data>? _data;
AccountAddressModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  List<Data>? data,
}) => AccountAddressModel(  success: success ?? _success,
  statusCode: statusCode ?? _statusCode,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['statusCode'] = _statusCode;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 5
/// userId : 22
/// address_name : "Home"
/// address : "25 Ivan Vazov Street"
/// city : "Plovdiv"
/// postal_code : "4000"
/// country : "Bulgaria"
/// is_default : true
/// createdAt : "2026-07-09T09:10:00.000Z"
/// updatedAt : "2026-07-09T09:10:00.000Z"

class Data {
  Data({
      num? id, 
      num? userId, 
      String? addressName, 
      String? address, 
      String? city, 
      String? postalCode, 
      String? country, 
      bool? isDefault, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _userId = userId;
    _addressName = addressName;
    _address = address;
    _city = city;
    _postalCode = postalCode;
    _country = country;
    _isDefault = isDefault;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _addressName = json['address_name'];
    _address = json['address'];
    _city = json['city'];
    _postalCode = json['postal_code'];
    _country = json['country'];
    _isDefault = json['is_default'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _id;
  num? _userId;
  String? _addressName;
  String? _address;
  String? _city;
  String? _postalCode;
  String? _country;
  bool? _isDefault;
  String? _createdAt;
  String? _updatedAt;
Data copyWith({  num? id,
  num? userId,
  String? addressName,
  String? address,
  String? city,
  String? postalCode,
  String? country,
  bool? isDefault,
  String? createdAt,
  String? updatedAt,
}) => Data(  id: id ?? _id,
  userId: userId ?? _userId,
  addressName: addressName ?? _addressName,
  address: address ?? _address,
  city: city ?? _city,
  postalCode: postalCode ?? _postalCode,
  country: country ?? _country,
  isDefault: isDefault ?? _isDefault,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get userId => _userId;
  String? get addressName => _addressName;
  String? get address => _address;
  String? get city => _city;
  String? get postalCode => _postalCode;
  String? get country => _country;
  bool? get isDefault => _isDefault;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['address_name'] = _addressName;
    map['address'] = _address;
    map['city'] = _city;
    map['postal_code'] = _postalCode;
    map['country'] = _country;
    map['is_default'] = _isDefault;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}