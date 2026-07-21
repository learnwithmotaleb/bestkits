/// success : true
/// statusCode : 200
/// message : "Request successful"
/// data : {"id":1,"company_name":"BestKid Shop","business_type":"Online Marketplace Platform","contact_email":"support@bestkid.com","contact_address":"To be confirmed - Bulgaria","website":"https://www.bestkid.com","jurisdiction":"Bulgaria / European Union","createdAt":"2026-07-07T08:18:35.935Z","updatedAt":"2026-07-11T01:39:25.042Z"}

class LegalCompanyInformationModel {
  LegalCompanyInformationModel({
      bool? success, 
      num? statusCode, 
      String? message, 
      Data? data,}){
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  LegalCompanyInformationModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  Data? _data;
LegalCompanyInformationModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  Data? data,
}) => LegalCompanyInformationModel(  success: success ?? _success,
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
/// company_name : "BestKid Shop"
/// business_type : "Online Marketplace Platform"
/// contact_email : "support@bestkid.com"
/// contact_address : "To be confirmed - Bulgaria"
/// website : "https://www.bestkid.com"
/// jurisdiction : "Bulgaria / European Union"
/// createdAt : "2026-07-07T08:18:35.935Z"
/// updatedAt : "2026-07-11T01:39:25.042Z"

class Data {
  Data({
      num? id, 
      String? companyName, 
      String? businessType, 
      String? contactEmail, 
      String? contactAddress, 
      String? website, 
      String? jurisdiction, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _companyName = companyName;
    _businessType = businessType;
    _contactEmail = contactEmail;
    _contactAddress = contactAddress;
    _website = website;
    _jurisdiction = jurisdiction;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _companyName = json['company_name'];
    _businessType = json['business_type'];
    _contactEmail = json['contact_email'];
    _contactAddress = json['contact_address'];
    _website = json['website'];
    _jurisdiction = json['jurisdiction'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _id;
  String? _companyName;
  String? _businessType;
  String? _contactEmail;
  String? _contactAddress;
  String? _website;
  String? _jurisdiction;
  String? _createdAt;
  String? _updatedAt;
Data copyWith({  num? id,
  String? companyName,
  String? businessType,
  String? contactEmail,
  String? contactAddress,
  String? website,
  String? jurisdiction,
  String? createdAt,
  String? updatedAt,
}) => Data(  id: id ?? _id,
  companyName: companyName ?? _companyName,
  businessType: businessType ?? _businessType,
  contactEmail: contactEmail ?? _contactEmail,
  contactAddress: contactAddress ?? _contactAddress,
  website: website ?? _website,
  jurisdiction: jurisdiction ?? _jurisdiction,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  String? get companyName => _companyName;
  String? get businessType => _businessType;
  String? get contactEmail => _contactEmail;
  String? get contactAddress => _contactAddress;
  String? get website => _website;
  String? get jurisdiction => _jurisdiction;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['company_name'] = _companyName;
    map['business_type'] = _businessType;
    map['contact_email'] = _contactEmail;
    map['contact_address'] = _contactAddress;
    map['website'] = _website;
    map['jurisdiction'] = _jurisdiction;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}