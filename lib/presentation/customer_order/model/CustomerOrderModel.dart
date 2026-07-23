/// success : true
/// statusCode : 200
/// message : "Request successful"
/// data : [{"id":1,"display_id":"KDF0000000001","status":"PENDING","status_label":"Order Placed","status_tone":"info","createdAt":"2026-07-07T05:02:58.230Z","total":19.990000000000002,"item_count":1,"buyer":{"id":20,"email":"buyer.one@bestkid.test","profile":{"full_name":"Thomas Baker","avatar_url":"https://i.pravatar.cc/150?u=buyer.one%40bestkid.test","phone":"+359 77 123 4567"}},"preview_items":[{"id":1,"productId":33,"name":"Emily Carter Kids Item 1","image_url":"/uploads/shoes.jpg","variant":null,"quantity":1,"price":15}],"cancellation":null,"timeline":{"confirmed_at":null,"processing_at":null,"shipped_at":null,"delivered_at":null,"cancelled_at":null},"actions":{"can_view_details":true,"can_update_status":true}},{"id":2,"display_id":"KDF0000000002","status":"CONFIRMED","status_label":"Confirmed","status_tone":"primary","createdAt":"2026-07-04T05:02:58.240Z","total":62.99,"item_count":2,"buyer":{"id":21,"email":"buyer.two@bestkid.test","profile":{"full_name":"Robert Davis","avatar_url":"https://i.pravatar.cc/150?u=buyer.two%40bestkid.test","phone":"+359 77 234 5678"}},"preview_items":[{"id":2,"productId":34,"name":"Emily Carter Kids Item 2","image_url":"/uploads/shoes.jpg","variant":null,"quantity":2,"price":25}],"cancellation":null,"timeline":{"confirmed_at":null,"processing_at":null,"shipped_at":null,"delivered_at":null,"cancelled_at":null},"actions":{"can_view_details":true,"can_update_status":true}},{"id":3,"display_id":"KDF0000000003","status":"PROCESSING","status_label":"Shipped","status_tone":"warning","createdAt":"2026-07-01T05:02:58.246Z","total":33.99,"item_count":1,"buyer":{"id":22,"email":"buyer.three@bestkid.test","profile":{"full_name":"Amelia Wilson","avatar_url":"https://i.pravatar.cc/150?u=buyer.three%40bestkid.test","phone":"+359 77 345 6789"}},"preview_items":[{"id":3,"productId":35,"name":"Emily Carter Kids Item 3","image_url":"/uploads/shoes.jpg","variant":null,"quantity":1,"price":29}],"cancellation":null,"timeline":{"confirmed_at":null,"processing_at":null,"shipped_at":null,"delivered_at":null,"cancelled_at":null},"actions":{"can_view_details":true,"can_update_status":true}},{"id":4,"display_id":"KDF0000000004","status":"SHIPPED","status_label":"Shipped","status_tone":"warning","createdAt":"2026-06-28T05:02:58.252Z","total":90.99,"item_count":2,"buyer":{"id":20,"email":"buyer.one@bestkid.test","profile":{"full_name":"Thomas Baker","avatar_url":"https://i.pravatar.cc/150?u=buyer.one%40bestkid.test","phone":"+359 77 123 4567"}},"preview_items":[{"id":4,"productId":36,"name":"Emily Carter Kids Item 4","image_url":"/uploads/shoes.jpg","variant":null,"quantity":2,"price":39}],"cancellation":null,"timeline":{"confirmed_at":null,"processing_at":null,"shipped_at":null,"delivered_at":null,"cancelled_at":null},"actions":{"can_view_details":true,"can_update_status":true}},{"id":5,"display_id":"KDF0000000005","status":"DELIVERED","status_label":"Delivered","status_tone":"success","createdAt":"2026-06-25T05:02:58.259Z","total":19.990000000000002,"item_count":1,"buyer":{"id":21,"email":"buyer.two@bestkid.test","profile":{"full_name":"Robert Davis","avatar_url":"https://i.pravatar.cc/150?u=buyer.two%40bestkid.test","phone":"+359 77 234 5678"}},"preview_items":[{"id":5,"productId":33,"name":"Emily Carter Kids Item 1","image_url":"/uploads/shoes.jpg","variant":null,"quantity":1,"price":15}],"cancellation":null,"timeline":{"confirmed_at":null,"processing_at":null,"shipped_at":null,"delivered_at":null,"cancelled_at":null},"actions":{"can_view_details":true,"can_update_status":false}}]
/// meta : {"total":5,"page":1,"limit":10,"pages":1}

class CustomerOrderModel {
  CustomerOrderModel({
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

  CustomerOrderModel.fromJson(dynamic json) {
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
CustomerOrderModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  List<Data>? data,
  Meta? meta,
}) => CustomerOrderModel(  success: success ?? _success,
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

/// total : 5
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

/// id : 1
/// display_id : "KDF0000000001"
/// status : "PENDING"
/// status_label : "Order Placed"
/// status_tone : "info"
/// createdAt : "2026-07-07T05:02:58.230Z"
/// total : 19.990000000000002
/// item_count : 1
/// buyer : {"id":20,"email":"buyer.one@bestkid.test","profile":{"full_name":"Thomas Baker","avatar_url":"https://i.pravatar.cc/150?u=buyer.one%40bestkid.test","phone":"+359 77 123 4567"}}
/// preview_items : [{"id":1,"productId":33,"name":"Emily Carter Kids Item 1","image_url":"/uploads/shoes.jpg","variant":null,"quantity":1,"price":15}]
/// cancellation : null
/// timeline : {"confirmed_at":null,"processing_at":null,"shipped_at":null,"delivered_at":null,"cancelled_at":null}
/// actions : {"can_view_details":true,"can_update_status":true}

class Data {
  Data({
      num? id, 
      String? displayId, 
      String? status, 
      String? statusLabel, 
      String? statusTone, 
      String? createdAt, 
      num? total, 
      num? itemCount, 
      Buyer? buyer, 
      List<PreviewItems>? previewItems, 
      dynamic cancellation, 
      Timeline? timeline, 
      Actions? actions,}){
    _id = id;
    _displayId = displayId;
    _status = status;
    _statusLabel = statusLabel;
    _statusTone = statusTone;
    _createdAt = createdAt;
    _total = total;
    _itemCount = itemCount;
    _buyer = buyer;
    _previewItems = previewItems;
    _cancellation = cancellation;
    _timeline = timeline;
    _actions = actions;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _displayId = json['display_id'];
    _status = json['status'];
    _statusLabel = json['status_label'];
    _statusTone = json['status_tone'];
    _createdAt = json['createdAt'];
    _total = json['total'];
    _itemCount = json['item_count'];
    _buyer = json['buyer'] != null ? Buyer.fromJson(json['buyer']) : null;
    if (json['preview_items'] != null) {
      _previewItems = [];
      json['preview_items'].forEach((v) {
        _previewItems?.add(PreviewItems.fromJson(v));
      });
    }
    _cancellation = json['cancellation'];
    _timeline = json['timeline'] != null ? Timeline.fromJson(json['timeline']) : null;
    _actions = json['actions'] != null ? Actions.fromJson(json['actions']) : null;
  }
  num? _id;
  String? _displayId;
  String? _status;
  String? _statusLabel;
  String? _statusTone;
  String? _createdAt;
  num? _total;
  num? _itemCount;
  Buyer? _buyer;
  List<PreviewItems>? _previewItems;
  dynamic _cancellation;
  Timeline? _timeline;
  Actions? _actions;
Data copyWith({  num? id,
  String? displayId,
  String? status,
  String? statusLabel,
  String? statusTone,
  String? createdAt,
  num? total,
  num? itemCount,
  Buyer? buyer,
  List<PreviewItems>? previewItems,
  dynamic cancellation,
  Timeline? timeline,
  Actions? actions,
}) => Data(  id: id ?? _id,
  displayId: displayId ?? _displayId,
  status: status ?? _status,
  statusLabel: statusLabel ?? _statusLabel,
  statusTone: statusTone ?? _statusTone,
  createdAt: createdAt ?? _createdAt,
  total: total ?? _total,
  itemCount: itemCount ?? _itemCount,
  buyer: buyer ?? _buyer,
  previewItems: previewItems ?? _previewItems,
  cancellation: cancellation ?? _cancellation,
  timeline: timeline ?? _timeline,
  actions: actions ?? _actions,
);
  num? get id => _id;
  String? get displayId => _displayId;
  String? get status => _status;
  String? get statusLabel => _statusLabel;
  String? get statusTone => _statusTone;
  String? get createdAt => _createdAt;
  num? get total => _total;
  num? get itemCount => _itemCount;
  Buyer? get buyer => _buyer;
  List<PreviewItems>? get previewItems => _previewItems;
  dynamic get cancellation => _cancellation;
  Timeline? get timeline => _timeline;
  Actions? get actions => _actions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['display_id'] = _displayId;
    map['status'] = _status;
    map['status_label'] = _statusLabel;
    map['status_tone'] = _statusTone;
    map['createdAt'] = _createdAt;
    map['total'] = _total;
    map['item_count'] = _itemCount;
    if (_buyer != null) {
      map['buyer'] = _buyer?.toJson();
    }
    if (_previewItems != null) {
      map['preview_items'] = _previewItems?.map((v) => v.toJson()).toList();
    }
    map['cancellation'] = _cancellation;
    if (_timeline != null) {
      map['timeline'] = _timeline?.toJson();
    }
    if (_actions != null) {
      map['actions'] = _actions?.toJson();
    }
    return map;
  }

}

/// can_view_details : true
/// can_update_status : true

class Actions {
  Actions({
      bool? canViewDetails, 
      bool? canUpdateStatus,}){
    _canViewDetails = canViewDetails;
    _canUpdateStatus = canUpdateStatus;
}

  Actions.fromJson(dynamic json) {
    _canViewDetails = json['can_view_details'];
    _canUpdateStatus = json['can_update_status'];
  }
  bool? _canViewDetails;
  bool? _canUpdateStatus;
Actions copyWith({  bool? canViewDetails,
  bool? canUpdateStatus,
}) => Actions(  canViewDetails: canViewDetails ?? _canViewDetails,
  canUpdateStatus: canUpdateStatus ?? _canUpdateStatus,
);
  bool? get canViewDetails => _canViewDetails;
  bool? get canUpdateStatus => _canUpdateStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['can_view_details'] = _canViewDetails;
    map['can_update_status'] = _canUpdateStatus;
    return map;
  }

}

/// confirmed_at : null
/// processing_at : null
/// shipped_at : null
/// delivered_at : null
/// cancelled_at : null

class Timeline {
  Timeline({
      dynamic confirmedAt, 
      dynamic processingAt, 
      dynamic shippedAt, 
      dynamic deliveredAt, 
      dynamic cancelledAt,}){
    _confirmedAt = confirmedAt;
    _processingAt = processingAt;
    _shippedAt = shippedAt;
    _deliveredAt = deliveredAt;
    _cancelledAt = cancelledAt;
}

  Timeline.fromJson(dynamic json) {
    _confirmedAt = json['confirmed_at'];
    _processingAt = json['processing_at'];
    _shippedAt = json['shipped_at'];
    _deliveredAt = json['delivered_at'];
    _cancelledAt = json['cancelled_at'];
  }
  dynamic _confirmedAt;
  dynamic _processingAt;
  dynamic _shippedAt;
  dynamic _deliveredAt;
  dynamic _cancelledAt;
Timeline copyWith({  dynamic confirmedAt,
  dynamic processingAt,
  dynamic shippedAt,
  dynamic deliveredAt,
  dynamic cancelledAt,
}) => Timeline(  confirmedAt: confirmedAt ?? _confirmedAt,
  processingAt: processingAt ?? _processingAt,
  shippedAt: shippedAt ?? _shippedAt,
  deliveredAt: deliveredAt ?? _deliveredAt,
  cancelledAt: cancelledAt ?? _cancelledAt,
);
  dynamic get confirmedAt => _confirmedAt;
  dynamic get processingAt => _processingAt;
  dynamic get shippedAt => _shippedAt;
  dynamic get deliveredAt => _deliveredAt;
  dynamic get cancelledAt => _cancelledAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['confirmed_at'] = _confirmedAt;
    map['processing_at'] = _processingAt;
    map['shipped_at'] = _shippedAt;
    map['delivered_at'] = _deliveredAt;
    map['cancelled_at'] = _cancelledAt;
    return map;
  }

}

/// id : 1
/// productId : 33
/// name : "Emily Carter Kids Item 1"
/// image_url : "/uploads/shoes.jpg"
/// variant : null
/// quantity : 1
/// price : 15

class PreviewItems {
  PreviewItems({
      num? id, 
      num? productId, 
      String? name, 
      String? imageUrl, 
      dynamic variant, 
      num? quantity, 
      num? price,}){
    _id = id;
    _productId = productId;
    _name = name;
    _imageUrl = imageUrl;
    _variant = variant;
    _quantity = quantity;
    _price = price;
}

  PreviewItems.fromJson(dynamic json) {
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
PreviewItems copyWith({  num? id,
  num? productId,
  String? name,
  String? imageUrl,
  dynamic variant,
  num? quantity,
  num? price,
}) => PreviewItems(  id: id ?? _id,
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

/// id : 20
/// email : "buyer.one@bestkid.test"
/// profile : {"full_name":"Thomas Baker","avatar_url":"https://i.pravatar.cc/150?u=buyer.one%40bestkid.test","phone":"+359 77 123 4567"}

class Buyer {
  Buyer({
      num? id, 
      String? email, 
      Profile? profile,}){
    _id = id;
    _email = email;
    _profile = profile;
}

  Buyer.fromJson(dynamic json) {
    _id = json['id'];
    _email = json['email'];
    _profile = json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }
  num? _id;
  String? _email;
  Profile? _profile;
Buyer copyWith({  num? id,
  String? email,
  Profile? profile,
}) => Buyer(  id: id ?? _id,
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

/// full_name : "Thomas Baker"
/// avatar_url : "https://i.pravatar.cc/150?u=buyer.one%40bestkid.test"
/// phone : "+359 77 123 4567"

class Profile {
  Profile({
      String? fullName, 
      String? avatarUrl, 
      String? phone,}){
    _fullName = fullName;
    _avatarUrl = avatarUrl;
    _phone = phone;
}

  Profile.fromJson(dynamic json) {
    _fullName = json['full_name'];
    _avatarUrl = json['avatar_url'];
    _phone = json['phone'];
  }
  String? _fullName;
  String? _avatarUrl;
  String? _phone;
Profile copyWith({  String? fullName,
  String? avatarUrl,
  String? phone,
}) => Profile(  fullName: fullName ?? _fullName,
  avatarUrl: avatarUrl ?? _avatarUrl,
  phone: phone ?? _phone,
);
  String? get fullName => _fullName;
  String? get avatarUrl => _avatarUrl;
  String? get phone => _phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['full_name'] = _fullName;
    map['avatar_url'] = _avatarUrl;
    map['phone'] = _phone;
    return map;
  }

}