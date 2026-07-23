/// success : true
/// statusCode : 200
/// message : "Request successful"
/// data : [{"id":2,"order_id":2,"display_order_id":"KDF0000000002","status":"APPROVED","status_label":"Accepted","status_tone":"success","submitted_on":"2026-07-23T04:44:06.497Z","seller":{"id":5,"email":"basic.seller@bestkid.test","profile":{"full_name":"Emily Carter","avatar_url":"https://i.pravatar.cc/150?u=basic.seller%40bestkid.test","country":"Bulgaria"}},"preview_item":{"id":2,"productId":2,"name":"Emily Carter Kids Item 2","image_url":"/uploads/shoes.jpg","variant":null,"quantity":2,"price":25}}]
/// meta : {"total":1,"page":1,"limit":10,"pages":1}

class MyReturnModel {
  MyReturnModel({
    bool? success,
    num? statusCode,
    String? message,
    List<Data>? data,
    Meta? meta,
  }) {
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
    _meta = meta;
  }

  MyReturnModel.fromJson(dynamic json) {
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
  MyReturnModel copyWith({
    bool? success,
    num? statusCode,
    String? message,
    List<Data>? data,
    Meta? meta,
  }) =>
      MyReturnModel(
        success: success ?? _success,
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
    num? pages,
  }) {
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
  Meta copyWith({
    num? total,
    num? page,
    num? limit,
    num? pages,
  }) =>
      Meta(
        total: total ?? _total,
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

/// id : 2
/// order_id : 2
/// display_order_id : "KDF0000000002"
/// status : "APPROVED"
/// status_label : "Accepted"
/// status_tone : "success"
/// submitted_on : "2026-07-23T04:44:06.497Z"
/// seller : {"id":5,"email":"basic.seller@bestkid.test","profile":{"full_name":"Emily Carter","avatar_url":"https://i.pravatar.cc/150?u=basic.seller%40bestkid.test","country":"Bulgaria"}}
/// preview_item : {"id":2,"productId":2,"name":"Emily Carter Kids Item 2","image_url":"/uploads/shoes.jpg","variant":null,"quantity":2,"price":25}

class Data {
  Data({
    num? id,
    num? orderId,
    String? displayOrderId,
    String? status,
    String? statusLabel,
    String? statusTone,
    String? submittedOn,
    Seller? seller,
    PreviewItem? previewItem,
  }) {
    _id = id;
    _orderId = orderId;
    _displayOrderId = displayOrderId;
    _status = status;
    _statusLabel = statusLabel;
    _statusTone = statusTone;
    _submittedOn = submittedOn;
    _seller = seller;
    _previewItem = previewItem;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _orderId = json['order_id'];
    _displayOrderId = json['display_order_id'];
    _status = json['status'];
    _statusLabel = json['status_label'];
    _statusTone = json['status_tone'];
    _submittedOn = json['submitted_on'];
    _seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
    _previewItem = json['preview_item'] != null
        ? PreviewItem.fromJson(json['preview_item'])
        : null;
  }
  num? _id;
  num? _orderId;
  String? _displayOrderId;
  String? _status;
  String? _statusLabel;
  String? _statusTone;
  String? _submittedOn;
  Seller? _seller;
  PreviewItem? _previewItem;
  Data copyWith({
    num? id,
    num? orderId,
    String? displayOrderId,
    String? status,
    String? statusLabel,
    String? statusTone,
    String? submittedOn,
    Seller? seller,
    PreviewItem? previewItem,
  }) =>
      Data(
        id: id ?? _id,
        orderId: orderId ?? _orderId,
        displayOrderId: displayOrderId ?? _displayOrderId,
        status: status ?? _status,
        statusLabel: statusLabel ?? _statusLabel,
        statusTone: statusTone ?? _statusTone,
        submittedOn: submittedOn ?? _submittedOn,
        seller: seller ?? _seller,
        previewItem: previewItem ?? _previewItem,
      );
  num? get id => _id;
  num? get orderId => _orderId;
  String? get displayOrderId => _displayOrderId;
  String? get status => _status;
  String? get statusLabel => _statusLabel;
  String? get statusTone => _statusTone;
  String? get submittedOn => _submittedOn;
  Seller? get seller => _seller;
  PreviewItem? get previewItem => _previewItem;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['order_id'] = _orderId;
    map['display_order_id'] = _displayOrderId;
    map['status'] = _status;
    map['status_label'] = _statusLabel;
    map['status_tone'] = _statusTone;
    map['submitted_on'] = _submittedOn;
    if (_seller != null) {
      map['seller'] = _seller?.toJson();
    }
    if (_previewItem != null) {
      map['preview_item'] = _previewItem?.toJson();
    }
    return map;
  }
}

/// id : 2
/// productId : 2
/// name : "Emily Carter Kids Item 2"
/// image_url : "/uploads/shoes.jpg"
/// variant : null
/// quantity : 2
/// price : 25

class PreviewItem {
  PreviewItem({
    num? id,
    num? productId,
    String? name,
    String? imageUrl,
    dynamic variant,
    num? quantity,
    num? price,
  }) {
    _id = id;
    _productId = productId;
    _name = name;
    _imageUrl = imageUrl;
    _variant = variant;
    _quantity = quantity;
    _price = price;
  }

  PreviewItem.fromJson(dynamic json) {
    _id = json['id'];
    _productId = json['productId'];
    _name = json['name'];
    _imageUrl = json['image_url'];
    _variant = json['variant'];
    _quantity = json['quantity'];
    _price = json['price'];
  }
  num? _id;
  num? _productId;
  String? _name;
  String? _imageUrl;
  dynamic _variant;
  num? _quantity;
  num? _price;
  PreviewItem copyWith({
    num? id,
    num? productId,
    String? name,
    String? imageUrl,
    dynamic variant,
    num? quantity,
    num? price,
  }) =>
      PreviewItem(
        id: id ?? _id,
        productId: productId ?? _productId,
        name: name ?? _name,
        imageUrl: imageUrl ?? _imageUrl,
        variant: variant ?? _variant,
        quantity: quantity ?? _quantity,
        price: price ?? _price,
      );
  num? get id => _id;
  num? get productId => _productId;
  String? get name => _name;
  String? get imageUrl => _imageUrl;
  dynamic get variant => _variant;
  num? get quantity => _quantity;
  num? get price => _price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['productId'] = _productId;
    map['name'] = _name;
    map['image_url'] = _imageUrl;
    map['variant'] = _variant;
    map['quantity'] = _quantity;
    map['price'] = _price;
    return map;
  }
}

/// id : 5
/// email : "basic.seller@bestkid.test"
/// profile : {"full_name":"Emily Carter","avatar_url":"https://i.pravatar.cc/150?u=basic.seller%40bestkid.test","country":"Bulgaria"}

class Seller {
  Seller({
    num? id,
    String? email,
    Profile? profile,
  }) {
    _id = id;
    _email = email;
    _profile = profile;
  }

  Seller.fromJson(dynamic json) {
    _id = json['id'];
    _email = json['email'];
    _profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }
  num? _id;
  String? _email;
  Profile? _profile;
  Seller copyWith({
    num? id,
    String? email,
    Profile? profile,
  }) =>
      Seller(
        id: id ?? _id,
        email: email ?? _email,
        profile: profile ?? _profile,
      );
  num? get id => _id;
  String? get email => _email;
  Profile? get profile => _profile;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['email'] = _email;
    if (_profile != null) {
      map['profile'] = _profile?.toJson();
    }
    return map;
  }
}

/// full_name : "Emily Carter"
/// avatar_url : "https://i.pravatar.cc/150?u=basic.seller%40bestkid.test"
/// country : "Bulgaria"

class Profile {
  Profile({
    String? fullName,
    String? avatarUrl,
    String? country,
  }) {
    _fullName = fullName;
    _avatarUrl = avatarUrl;
    _country = country;
  }

  Profile.fromJson(dynamic json) {
    _fullName = json['full_name'];
    _avatarUrl = json['avatar_url'];
    _country = json['country'];
  }
  String? _fullName;
  String? _avatarUrl;
  String? _country;
  Profile copyWith({
    String? fullName,
    String? avatarUrl,
    String? country,
  }) =>
      Profile(
        fullName: fullName ?? _fullName,
        avatarUrl: avatarUrl ?? _avatarUrl,
        country: country ?? _country,
      );
  String? get fullName => _fullName;
  String? get avatarUrl => _avatarUrl;
  String? get country => _country;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['full_name'] = _fullName;
    map['avatar_url'] = _avatarUrl;
    map['country'] = _country;
    return map;
  }
}
