/// success : true
/// statusCode : 200
/// message : "Request successful"
/// data : {"period":"TODAY","earnings":520,"payment_history":[{"order_id":41,"customer":{"id":22,"name":"Roberts Junior","avatar_url":"https://cdn.bestkid.test/avatars/buyer.png"},"paid_at":"2026-07-09T12:45:00.000Z","status":"DELIVERED","amount":520,"item_count":2}],"meta":{"total":1,"page":1,"limit":10,"pages":1}}

class ErningModel {
  ErningModel({
      bool? success, 
      num? statusCode, 
      String? message, 
      Data? data,}){
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  ErningModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  Data? _data;
ErningModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  Data? data,
}) => ErningModel(  success: success ?? _success,
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

/// period : "TODAY"
/// earnings : 520
/// payment_history : [{"order_id":41,"customer":{"id":22,"name":"Roberts Junior","avatar_url":"https://cdn.bestkid.test/avatars/buyer.png"},"paid_at":"2026-07-09T12:45:00.000Z","status":"DELIVERED","amount":520,"item_count":2}]
/// meta : {"total":1,"page":1,"limit":10,"pages":1}

class Data {
  Data({
      String? period, 
      num? earnings, 
      List<PaymentHistory>? paymentHistory, 
      Meta? meta,}){
    _period = period;
    _earnings = earnings;
    _paymentHistory = paymentHistory;
    _meta = meta;
}

  Data.fromJson(dynamic json) {
    _period = json['period'];
    _earnings = json['earnings'];
    if (json['payment_history'] != null) {
      _paymentHistory = [];
      json['payment_history'].forEach((v) {
        _paymentHistory?.add(PaymentHistory.fromJson(v));
      });
    }
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  String? _period;
  num? _earnings;
  List<PaymentHistory>? _paymentHistory;
  Meta? _meta;
Data copyWith({  String? period,
  num? earnings,
  List<PaymentHistory>? paymentHistory,
  Meta? meta,
}) => Data(  period: period ?? _period,
  earnings: earnings ?? _earnings,
  paymentHistory: paymentHistory ?? _paymentHistory,
  meta: meta ?? _meta,
);
  String? get period => _period;
  num? get earnings => _earnings;
  List<PaymentHistory>? get paymentHistory => _paymentHistory;
  Meta? get meta => _meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['period'] = _period;
    map['earnings'] = _earnings;
    if (_paymentHistory != null) {
      map['payment_history'] = _paymentHistory?.map((v) => v.toJson()).toList();
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

/// order_id : 41
/// customer : {"id":22,"name":"Roberts Junior","avatar_url":"https://cdn.bestkid.test/avatars/buyer.png"}
/// paid_at : "2026-07-09T12:45:00.000Z"
/// status : "DELIVERED"
/// amount : 520
/// item_count : 2

class PaymentHistory {
  PaymentHistory({
      num? orderId, 
      Customer? customer, 
      String? paidAt, 
      String? status, 
      num? amount, 
      num? itemCount,}){
    _orderId = orderId;
    _customer = customer;
    _paidAt = paidAt;
    _status = status;
    _amount = amount;
    _itemCount = itemCount;
}

  PaymentHistory.fromJson(dynamic json) {
    _orderId = json['order_id'];
    _customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    _paidAt = json['paid_at'];
    _status = json['status'];
    _amount = json['amount'];
    _itemCount = json['item_count'];
  }
  num? _orderId;
  Customer? _customer;
  String? _paidAt;
  String? _status;
  num? _amount;
  num? _itemCount;
PaymentHistory copyWith({  num? orderId,
  Customer? customer,
  String? paidAt,
  String? status,
  num? amount,
  num? itemCount,
}) => PaymentHistory(  orderId: orderId ?? _orderId,
  customer: customer ?? _customer,
  paidAt: paidAt ?? _paidAt,
  status: status ?? _status,
  amount: amount ?? _amount,
  itemCount: itemCount ?? _itemCount,
);
  num? get orderId => _orderId;
  Customer? get customer => _customer;
  String? get paidAt => _paidAt;
  String? get status => _status;
  num? get amount => _amount;
  num? get itemCount => _itemCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = _orderId;
    if (_customer != null) {
      map['customer'] = _customer?.toJson();
    }
    map['paid_at'] = _paidAt;
    map['status'] = _status;
    map['amount'] = _amount;
    map['item_count'] = _itemCount;
    return map;
  }

}

/// id : 22
/// name : "Roberts Junior"
/// avatar_url : "https://cdn.bestkid.test/avatars/buyer.png"

class Customer {
  Customer({
      num? id, 
      String? name, 
      String? avatarUrl,}){
    _id = id;
    _name = name;
    _avatarUrl = avatarUrl;
}

  Customer.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _avatarUrl = json['avatar_url'];
  }
  num? _id;
  String? _name;
  String? _avatarUrl;
Customer copyWith({  num? id,
  String? name,
  String? avatarUrl,
}) => Customer(  id: id ?? _id,
  name: name ?? _name,
  avatarUrl: avatarUrl ?? _avatarUrl,
);
  num? get id => _id;
  String? get name => _name;
  String? get avatarUrl => _avatarUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['avatar_url'] = _avatarUrl;
    return map;
  }

}