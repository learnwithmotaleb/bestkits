/// success : true
/// statusCode : 200
/// message : "Request successful"
/// data : {"id":2,"type":"PRIVACY_POLICY","content":"<p>Privacy Policy</p><br><p>Last Updated: 14 March 2026</p><br><p>Your privacy is important to us. This policy explains how we collect, use, and protect your information.</p><br><p>Information We Collect</p><br><p>• We may collect:</p><br><p>Name, email, and account details</p><br><p>Profile and seller information</p><br><p>Order and transaction data</p><br><p>Basic usage and device information</p><br><p>Users may browse without creating an account, but purchases require necessary information.</p><br><p>• Use of Information</p><br><p>We use collected data to:</p><br><p>Enable buying and selling</p><br><p>Process payments</p><br><p>Manage accounts and orders</p><br><p>Improve platform performance</p><br><p>Ensure security and prevent fraud</p><br><p>Data Storage and Security</p><br><p>We apply appropriate technical and organizational measures to protect your data.</p><br><p>However, no system can guarantee complete security.</p><br><p>• Sharing of Information</p><br><p>We do not sell personal data.</p><br><p>• Information may be shared with:</p><br><p>Payment providers</p><br><p>Technical service providers</p><br><p>Legal authorities when required</p><br><p>Payments</p><br><p>Payments are processed by third-party providers.</p><br><p>We do not store full payment card details.</p><br><p>• Data Retention</p><br><p>We retain data only as long as necessary for:</p><br><p>Platform operation</p><br><p>Legal compliance</p><br><p>Dispute resolution</p><br><p>Your Rights</p><br><p>• You may request:</p><br><p>Access to your data</p><br><p>Correction of inaccurate data</p><br><p>Deletion of your account and information</p><br><p>Children's Data</p><br><p>This platform is intended for adults (parents/guardians).</p><br><p>We do not knowingly collect personal data directly from children.</p><br><p>• Third-Party Services</p><br><p>We use third-party tools for payments and infrastructure, which follow their own privacy policies.</p><br><p>• Changes to This Policy</p><br><p>We may update this policy periodically. Continued use indicates acceptance of updates.</p><br><p>• Contact</p><br><p>For privacy-related questions, please contact us through the platform.</p>","createdAt":"2026-07-07T08:18:35.928Z","updatedAt":"2026-07-13T08:22:00.954Z"}

class PrivacyPolicyModel {
  PrivacyPolicyModel({
      bool? success, 
      num? statusCode, 
      String? message, 
      Data? data,}){
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  PrivacyPolicyModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  Data? _data;
PrivacyPolicyModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  Data? data,
}) => PrivacyPolicyModel(  success: success ?? _success,
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

/// id : 2
/// type : "PRIVACY_POLICY"
/// content : "<p>Privacy Policy</p><br><p>Last Updated: 14 March 2026</p><br><p>Your privacy is important to us. This policy explains how we collect, use, and protect your information.</p><br><p>Information We Collect</p><br><p>• We may collect:</p><br><p>Name, email, and account details</p><br><p>Profile and seller information</p><br><p>Order and transaction data</p><br><p>Basic usage and device information</p><br><p>Users may browse without creating an account, but purchases require necessary information.</p><br><p>• Use of Information</p><br><p>We use collected data to:</p><br><p>Enable buying and selling</p><br><p>Process payments</p><br><p>Manage accounts and orders</p><br><p>Improve platform performance</p><br><p>Ensure security and prevent fraud</p><br><p>Data Storage and Security</p><br><p>We apply appropriate technical and organizational measures to protect your data.</p><br><p>However, no system can guarantee complete security.</p><br><p>• Sharing of Information</p><br><p>We do not sell personal data.</p><br><p>• Information may be shared with:</p><br><p>Payment providers</p><br><p>Technical service providers</p><br><p>Legal authorities when required</p><br><p>Payments</p><br><p>Payments are processed by third-party providers.</p><br><p>We do not store full payment card details.</p><br><p>• Data Retention</p><br><p>We retain data only as long as necessary for:</p><br><p>Platform operation</p><br><p>Legal compliance</p><br><p>Dispute resolution</p><br><p>Your Rights</p><br><p>• You may request:</p><br><p>Access to your data</p><br><p>Correction of inaccurate data</p><br><p>Deletion of your account and information</p><br><p>Children's Data</p><br><p>This platform is intended for adults (parents/guardians).</p><br><p>We do not knowingly collect personal data directly from children.</p><br><p>• Third-Party Services</p><br><p>We use third-party tools for payments and infrastructure, which follow their own privacy policies.</p><br><p>• Changes to This Policy</p><br><p>We may update this policy periodically. Continued use indicates acceptance of updates.</p><br><p>• Contact</p><br><p>For privacy-related questions, please contact us through the platform.</p>"
/// createdAt : "2026-07-07T08:18:35.928Z"
/// updatedAt : "2026-07-13T08:22:00.954Z"

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