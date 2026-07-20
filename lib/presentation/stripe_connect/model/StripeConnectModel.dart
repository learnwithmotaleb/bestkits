/// success : true
/// statusCode : 200
/// message : "Request successful"
/// data : {"provider":"stripe","connected":true,"account_id":"acct_1TsFrPCL3rxBlaXu","onboarding_complete":true}

class StripeConnectModel {
  StripeConnectModel({
      bool? success, 
      num? statusCode, 
      String? message, 
      Data? data,}){
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  StripeConnectModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  Data? _data;
StripeConnectModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  Data? data,
}) => StripeConnectModel(  success: success ?? _success,
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

/// provider : "stripe"
/// connected : true
/// account_id : "acct_1TsFrPCL3rxBlaXu"
/// onboarding_complete : true

class Data {
  Data({
      String? provider, 
      bool? connected, 
      String? accountId, 
      bool? onboardingComplete,}){
    _provider = provider;
    _connected = connected;
    _accountId = accountId;
    _onboardingComplete = onboardingComplete;
}

  Data.fromJson(dynamic json) {
    _provider = json['provider'];
    _connected = json['connected'];
    _accountId = json['account_id'];
    _onboardingComplete = json['onboarding_complete'];
  }
  String? _provider;
  bool? _connected;
  String? _accountId;
  bool? _onboardingComplete;
Data copyWith({  String? provider,
  bool? connected,
  String? accountId,
  bool? onboardingComplete,
}) => Data(  provider: provider ?? _provider,
  connected: connected ?? _connected,
  accountId: accountId ?? _accountId,
  onboardingComplete: onboardingComplete ?? _onboardingComplete,
);
  String? get provider => _provider;
  bool? get connected => _connected;
  String? get accountId => _accountId;
  bool? get onboardingComplete => _onboardingComplete;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['provider'] = _provider;
    map['connected'] = _connected;
    map['account_id'] = _accountId;
    map['onboarding_complete'] = _onboardingComplete;
    return map;
  }

}