/// success : true
/// statusCode : 200
/// message : "Request successful"
/// data : [{"id":41,"display_id":"KDF143625879","status":"PENDING","status_label":"Order Placed","status_tone":"info","createdAt":"2026-07-09T12:45:00.000Z","total":520,"item_count":2,"seller":{"id":7,"name":"Roberts Junior","email":"seller@example.com","avatar_url":"https://cdn.bestkid.test/avatars/seller.png"},"preview_items":[{"id":31,"productId":1,"name":"Kolev and Kolev - Soft Fit","image_url":"https://cdn.bestkid.test/products/shoes-front.png","quantity":1,"price":260,"variant":{"id":10,"variantName":"S"}}],"actions":{"can_view_details":true,"can_update_status":true},"buyer":{"id":22,"name":"Roberts Junior","email":"buyer@example.com","avatar_url":"https://cdn.bestkid.test/avatars/buyer.png"},"cancellation":null,"timeline":{"confirmed_at":null,"processing_at":null,"shipped_at":null,"delivered_at":null,"cancelled_at":null},"matched_product_items":[{"id":31,"productId":1,"name":"Kolev and Kolev - Soft Fit","image_url":"https://cdn.bestkid.test/products/shoes-front.png","variant":{"id":10,"variantName":"S","price":260},"quantity":1,"price":260,"line_total":260}],"matched_quantity":1}]
/// meta : {"total":1,"page":1,"limit":10,"pages":1}

class ProductOrderModel {
  ProductOrderModel({
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

  ProductOrderModel.fromJson(dynamic json) {
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
ProductOrderModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  List<Data>? data,
  Meta? meta,
}) => ProductOrderModel(  success: success ?? _success,
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

/// id : 41
/// display_id : "KDF143625879"
/// status : "PENDING"
/// status_label : "Order Placed"
/// status_tone : "info"
/// createdAt : "2026-07-09T12:45:00.000Z"
/// total : 520
/// item_count : 2
/// seller : {"id":7,"name":"Roberts Junior","email":"seller@example.com","avatar_url":"https://cdn.bestkid.test/avatars/seller.png"}
/// preview_items : [{"id":31,"productId":1,"name":"Kolev and Kolev - Soft Fit","image_url":"https://cdn.bestkid.test/products/shoes-front.png","quantity":1,"price":260,"variant":{"id":10,"variantName":"S"}}]
/// actions : {"can_view_details":true,"can_update_status":true}
/// buyer : {"id":22,"name":"Roberts Junior","email":"buyer@example.com","avatar_url":"https://cdn.bestkid.test/avatars/buyer.png"}
/// cancellation : null
/// timeline : {"confirmed_at":null,"processing_at":null,"shipped_at":null,"delivered_at":null,"cancelled_at":null}
/// matched_product_items : [{"id":31,"productId":1,"name":"Kolev and Kolev - Soft Fit","image_url":"https://cdn.bestkid.test/products/shoes-front.png","variant":{"id":10,"variantName":"S","price":260},"quantity":1,"price":260,"line_total":260}]
/// matched_quantity : 1

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
      Seller? seller, 
      List<PreviewItems>? previewItems, 
      Actions? actions, 
      Buyer? buyer, 
      dynamic cancellation, 
      Timeline? timeline, 
      List<MatchedProductItems>? matchedProductItems, 
      num? matchedQuantity,}){
    _id = id;
    _displayId = displayId;
    _status = status;
    _statusLabel = statusLabel;
    _statusTone = statusTone;
    _createdAt = createdAt;
    _total = total;
    _itemCount = itemCount;
    _seller = seller;
    _previewItems = previewItems;
    _actions = actions;
    _buyer = buyer;
    _cancellation = cancellation;
    _timeline = timeline;
    _matchedProductItems = matchedProductItems;
    _matchedQuantity = matchedQuantity;
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
    _seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
    if (json['preview_items'] != null) {
      _previewItems = [];
      json['preview_items'].forEach((v) {
        _previewItems?.add(PreviewItems.fromJson(v));
      });
    }
    _actions = json['actions'] != null ? Actions.fromJson(json['actions']) : null;
    _buyer = json['buyer'] != null ? Buyer.fromJson(json['buyer']) : null;
    _cancellation = json['cancellation'];
    _timeline = json['timeline'] != null ? Timeline.fromJson(json['timeline']) : null;
    if (json['matched_product_items'] != null) {
      _matchedProductItems = [];
      json['matched_product_items'].forEach((v) {
        _matchedProductItems?.add(MatchedProductItems.fromJson(v));
      });
    }
    _matchedQuantity = json['matched_quantity'];
  }
  num? _id;
  String? _displayId;
  String? _status;
  String? _statusLabel;
  String? _statusTone;
  String? _createdAt;
  num? _total;
  num? _itemCount;
  Seller? _seller;
  List<PreviewItems>? _previewItems;
  Actions? _actions;
  Buyer? _buyer;
  dynamic _cancellation;
  Timeline? _timeline;
  List<MatchedProductItems>? _matchedProductItems;
  num? _matchedQuantity;
Data copyWith({  num? id,
  String? displayId,
  String? status,
  String? statusLabel,
  String? statusTone,
  String? createdAt,
  num? total,
  num? itemCount,
  Seller? seller,
  List<PreviewItems>? previewItems,
  Actions? actions,
  Buyer? buyer,
  dynamic cancellation,
  Timeline? timeline,
  List<MatchedProductItems>? matchedProductItems,
  num? matchedQuantity,
}) => Data(  id: id ?? _id,
  displayId: displayId ?? _displayId,
  status: status ?? _status,
  statusLabel: statusLabel ?? _statusLabel,
  statusTone: statusTone ?? _statusTone,
  createdAt: createdAt ?? _createdAt,
  total: total ?? _total,
  itemCount: itemCount ?? _itemCount,
  seller: seller ?? _seller,
  previewItems: previewItems ?? _previewItems,
  actions: actions ?? _actions,
  buyer: buyer ?? _buyer,
  cancellation: cancellation ?? _cancellation,
  timeline: timeline ?? _timeline,
  matchedProductItems: matchedProductItems ?? _matchedProductItems,
  matchedQuantity: matchedQuantity ?? _matchedQuantity,
);
  num? get id => _id;
  String? get displayId => _displayId;
  String? get status => _status;
  String? get statusLabel => _statusLabel;
  String? get statusTone => _statusTone;
  String? get createdAt => _createdAt;
  num? get total => _total;
  num? get itemCount => _itemCount;
  Seller? get seller => _seller;
  List<PreviewItems>? get previewItems => _previewItems;
  Actions? get actions => _actions;
  Buyer? get buyer => _buyer;
  dynamic get cancellation => _cancellation;
  Timeline? get timeline => _timeline;
  List<MatchedProductItems>? get matchedProductItems => _matchedProductItems;
  num? get matchedQuantity => _matchedQuantity;

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
    if (_seller != null) {
      map['seller'] = _seller?.toJson();
    }
    if (_previewItems != null) {
      map['preview_items'] = _previewItems?.map((v) => v.toJson()).toList();
    }
    if (_actions != null) {
      map['actions'] = _actions?.toJson();
    }
    if (_buyer != null) {
      map['buyer'] = _buyer?.toJson();
    }
    map['cancellation'] = _cancellation;
    if (_timeline != null) {
      map['timeline'] = _timeline?.toJson();
    }
    if (_matchedProductItems != null) {
      map['matched_product_items'] = _matchedProductItems?.map((v) => v.toJson()).toList();
    }
    map['matched_quantity'] = _matchedQuantity;
    return map;
  }

}

/// id : 31
/// productId : 1
/// name : "Kolev and Kolev - Soft Fit"
/// image_url : "https://cdn.bestkid.test/products/shoes-front.png"
/// variant : {"id":10,"variantName":"S","price":260}
/// quantity : 1
/// price : 260
/// line_total : 260

class MatchedProductItems {
  MatchedProductItems({
      num? id, 
      num? productId, 
      String? name, 
      String? imageUrl, 
      Variant? variant, 
      num? quantity, 
      num? price, 
      num? lineTotal,}){
    _id = id;
    _productId = productId;
    _name = name;
    _imageUrl = imageUrl;
    _variant = variant;
    _quantity = quantity;
    _price = price;
    _lineTotal = lineTotal;
}

  MatchedProductItems.fromJson(dynamic json) {
    _id = json['id'];
    _productId = json['productId'];
    _name = json['name'];
    _imageUrl = json['image_url'];
    _variant = json['variant'] != null ? Variant.fromJson(json['variant']) : null;
    _quantity = json['quantity'];
    _price = json['price'];
    _lineTotal = json['line_total'];
  }
  num? _id;
  num? _productId;
  String? _name;
  String? _imageUrl;
  Variant? _variant;
  num? _quantity;
  num? _price;
  num? _lineTotal;
MatchedProductItems copyWith({  num? id,
  num? productId,
  String? name,
  String? imageUrl,
  Variant? variant,
  num? quantity,
  num? price,
  num? lineTotal,
}) => MatchedProductItems(  id: id ?? _id,
  productId: productId ?? _productId,
  name: name ?? _name,
  imageUrl: imageUrl ?? _imageUrl,
  variant: variant ?? _variant,
  quantity: quantity ?? _quantity,
  price: price ?? _price,
  lineTotal: lineTotal ?? _lineTotal,
);
  num? get id => _id;
  num? get productId => _productId;
  String? get name => _name;
  String? get imageUrl => _imageUrl;
  Variant? get variant => _variant;
  num? get quantity => _quantity;
  num? get price => _price;
  num? get lineTotal => _lineTotal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['productId'] = _productId;
    map['name'] = _name;
    map['image_url'] = _imageUrl;
    if (_variant != null) {
      map['variant'] = _variant?.toJson();
    }
    map['quantity'] = _quantity;
    map['price'] = _price;
    map['line_total'] = _lineTotal;
    return map;
  }

}

/// id : 10
/// variantName : "S"
/// price : 260

class Variant {
  Variant({
      num? id, 
      String? variantName, 
      num? price,}){
    _id = id;
    _variantName = variantName;
    _price = price;
}

  Variant.fromJson(dynamic json) {
    _id = json['id'];
    _variantName = json['variantName'];
    _price = json['price'];
  }
  num? _id;
  String? _variantName;
  num? _price;
Variant copyWith({  num? id,
  String? variantName,
  num? price,
}) => Variant(  id: id ?? _id,
  variantName: variantName ?? _variantName,
  price: price ?? _price,
);
  num? get id => _id;
  String? get variantName => _variantName;
  num? get price => _price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['variantName'] = _variantName;
    map['price'] = _price;
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

/// id : 22
/// name : "Roberts Junior"
/// email : "buyer@example.com"
/// avatar_url : "https://cdn.bestkid.test/avatars/buyer.png"

class Buyer {
  Buyer({
      num? id, 
      String? name, 
      String? email, 
      String? avatarUrl,}){
    _id = id;
    _name = name;
    _email = email;
    _avatarUrl = avatarUrl;
}

  Buyer.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _avatarUrl = json['avatar_url'];
  }
  num? _id;
  String? _name;
  String? _email;
  String? _avatarUrl;
Buyer copyWith({  num? id,
  String? name,
  String? email,
  String? avatarUrl,
}) => Buyer(  id: id ?? _id,
  name: name ?? _name,
  email: email ?? _email,
  avatarUrl: avatarUrl ?? _avatarUrl,
);
  num? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get avatarUrl => _avatarUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['avatar_url'] = _avatarUrl;
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

/// id : 31
/// productId : 1
/// name : "Kolev and Kolev - Soft Fit"
/// image_url : "https://cdn.bestkid.test/products/shoes-front.png"
/// quantity : 1
/// price : 260
/// variant : {"id":10,"variantName":"S"}

class PreviewItems {
  PreviewItems({
      num? id, 
      num? productId, 
      String? name, 
      String? imageUrl, 
      num? quantity, 
      num? price, 
      Variant? variant,}){
    _id = id;
    _productId = productId;
    _name = name;
    _imageUrl = imageUrl;
    _quantity = quantity;
    _price = price;
    _variant = variant;
}

  PreviewItems.fromJson(dynamic json) {
    _id = json['id'];
    _productId = json['productId'];
    _name = json['name'];
    _imageUrl = json['image_url'];
    _quantity = json['quantity'];
    _price = json['price'];
    _variant = json['variant'] != null ? Variant.fromJson(json['variant']) : null;
  }
  num? _id;
  num? _productId;
  String? _name;
  String? _imageUrl;
  num? _quantity;
  num? _price;
  Variant? _variant;
PreviewItems copyWith({  num? id,
  num? productId,
  String? name,
  String? imageUrl,
  num? quantity,
  num? price,
  Variant? variant,
}) => PreviewItems(  id: id ?? _id,
  productId: productId ?? _productId,
  name: name ?? _name,
  imageUrl: imageUrl ?? _imageUrl,
  quantity: quantity ?? _quantity,
  price: price ?? _price,
  variant: variant ?? _variant,
);
  num? get id => _id;
  num? get productId => _productId;
  String? get name => _name;
  String? get imageUrl => _imageUrl;
  num? get quantity => _quantity;
  num? get price => _price;
  Variant? get variant => _variant;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['productId'] = _productId;
    map['name'] = _name;
    map['image_url'] = _imageUrl;
    map['quantity'] = _quantity;
    map['price'] = _price;
    if (_variant != null) {
      map['variant'] = _variant?.toJson();
    }
    return map;
  }

}


/// id : 7
/// name : "Roberts Junior"
/// email : "seller@example.com"
/// avatar_url : "https://cdn.bestkid.test/avatars/seller.png"

class Seller {
  Seller({
      num? id, 
      String? name, 
      String? email, 
      String? avatarUrl,}){
    _id = id;
    _name = name;
    _email = email;
    _avatarUrl = avatarUrl;
}

  Seller.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _avatarUrl = json['avatar_url'];
  }
  num? _id;
  String? _name;
  String? _email;
  String? _avatarUrl;
Seller copyWith({  num? id,
  String? name,
  String? email,
  String? avatarUrl,
}) => Seller(  id: id ?? _id,
  name: name ?? _name,
  email: email ?? _email,
  avatarUrl: avatarUrl ?? _avatarUrl,
);
  num? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get avatarUrl => _avatarUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['avatar_url'] = _avatarUrl;
    return map;
  }

}