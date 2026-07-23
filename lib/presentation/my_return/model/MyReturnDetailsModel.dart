/// success : true
/// statusCode : 200
/// message : "Request successful"
/// data : {"id":2,"status":"APPROVED","status_label":"Accepted","status_tone":"success","submitted_on":"2026-07-23T04:44:06.497Z","resolved_at":null,"reason":"Item arrived damaged","message":null,"images":[],"seller_response":null,"seller_rejection_reason":null,"return_address":null,"completed_at":null,"refunded_at":null,"refund_amount":null,"chat_room_id":null,"order":{"id":2,"display_id":"KDF0000000002","status":"CONFIRMED","total":62.99,"createdAt":"2026-07-20T04:44:06.351Z","delivered_at":null,"seller":{"id":5,"email":"basic.seller@bestkid.test","profile":{"full_name":"Emily Carter","avatar_url":"https://i.pravatar.cc/150?u=basic.seller%40bestkid.test","country":"Bulgaria","phone":"+359 88 123 4567"}},"buyer":{"id":3,"email":"buyer.two@bestkid.test","profile":{"full_name":"Robert Davis","avatar_url":"https://i.pravatar.cc/150?u=buyer.two%40bestkid.test","country":"Romania","phone":"+359 77 234 5678"}},"delivery_address":{"address":"25 Ivan Vazov Street","city":"Plovdiv","postal_code":"4000","country":"Romania"},"items":[{"id":2,"productId":2,"variantId":null,"quantity":2,"price":25,"line_total":50,"product":{"id":2,"name":"Emily Carter Kids Item 2","image_urls":["/uploads/shoes.jpg"],"image_url":"/uploads/shoes.jpg"},"variant":null,"is_returned_item":true}]},"returned_item":{"id":2,"productId":2,"variantId":null,"quantity":2,"price":25,"product":{"id":2,"name":"Emily Carter Kids Item 2","image_urls":["/uploads/shoes.jpg"]},"variant":null},"actions":{"can_message_seller":true,"can_update_status":true,"can_send_return_instructions":true,"can_complete_refund":true,"can_reject":true}}

class MyReturnDetailsModel {
  MyReturnDetailsModel({
    bool? success,
    num? statusCode,
    String? message,
    Data? data,
  }) {
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
  }

  MyReturnDetailsModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  Data? _data;
  MyReturnDetailsModel copyWith({
    bool? success,
    num? statusCode,
    String? message,
    Data? data,
  }) =>
      MyReturnDetailsModel(
        success: success ?? _success,
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
/// status : "APPROVED"
/// status_label : "Accepted"
/// status_tone : "success"
/// submitted_on : "2026-07-23T04:44:06.497Z"
/// resolved_at : null
/// reason : "Item arrived damaged"
/// message : null
/// images : []
/// seller_response : null
/// seller_rejection_reason : null
/// return_address : null
/// completed_at : null
/// refunded_at : null
/// refund_amount : null
/// chat_room_id : null
/// order : {"id":2,"display_id":"KDF0000000002","status":"CONFIRMED","total":62.99,"createdAt":"2026-07-20T04:44:06.351Z","delivered_at":null,"seller":{"id":5,"email":"basic.seller@bestkid.test","profile":{"full_name":"Emily Carter","avatar_url":"https://i.pravatar.cc/150?u=basic.seller%40bestkid.test","country":"Bulgaria","phone":"+359 88 123 4567"}},"buyer":{"id":3,"email":"buyer.two@bestkid.test","profile":{"full_name":"Robert Davis","avatar_url":"https://i.pravatar.cc/150?u=buyer.two%40bestkid.test","country":"Romania","phone":"+359 77 234 5678"}},"delivery_address":{"address":"25 Ivan Vazov Street","city":"Plovdiv","postal_code":"4000","country":"Romania"},"items":[{"id":2,"productId":2,"variantId":null,"quantity":2,"price":25,"line_total":50,"product":{"id":2,"name":"Emily Carter Kids Item 2","image_urls":["/uploads/shoes.jpg"],"image_url":"/uploads/shoes.jpg"},"variant":null,"is_returned_item":true}]}
/// returned_item : {"id":2,"productId":2,"variantId":null,"quantity":2,"price":25,"product":{"id":2,"name":"Emily Carter Kids Item 2","image_urls":["/uploads/shoes.jpg"]},"variant":null}
/// actions : {"can_message_seller":true,"can_update_status":true,"can_send_return_instructions":true,"can_complete_refund":true,"can_reject":true}

class Data {
  Data({
    num? id,
    String? status,
    String? statusLabel,
    String? statusTone,
    String? submittedOn,
    dynamic resolvedAt,
    String? reason,
    dynamic message,
    List<String>? images,
    dynamic sellerResponse,
    dynamic sellerRejectionReason,
    dynamic returnAddress,
    dynamic completedAt,
    dynamic refundedAt,
    dynamic refundAmount,
    dynamic chatRoomId,
    Order? order,
    ReturnedItem? returnedItem,
    Actions? actions,
  }) {
    _id = id;
    _status = status;
    _statusLabel = statusLabel;
    _statusTone = statusTone;
    _submittedOn = submittedOn;
    _resolvedAt = resolvedAt;
    _reason = reason;
    _message = message;
    _images = images;
    _sellerResponse = sellerResponse;
    _sellerRejectionReason = sellerRejectionReason;
    _returnAddress = returnAddress;
    _completedAt = completedAt;
    _refundedAt = refundedAt;
    _refundAmount = refundAmount;
    _chatRoomId = chatRoomId;
    _order = order;
    _returnedItem = returnedItem;
    _actions = actions;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _status = json['status'];
    _statusLabel = json['status_label'];
    _statusTone = json['status_tone'];
    _submittedOn = json['submitted_on'];
    _resolvedAt = json['resolved_at'];
    _reason = json['reason'];
    _message = json['message'];
    _images = json['images'] != null ? List<String>.from(json['images']) : [];
    _sellerResponse = json['seller_response'];
    _sellerRejectionReason = json['seller_rejection_reason'];
    _returnAddress = json['return_address'];
    _completedAt = json['completed_at'];
    _refundedAt = json['refunded_at'];
    _refundAmount = json['refund_amount'];
    _chatRoomId = json['chat_room_id'];
    _order = json['order'] != null ? Order.fromJson(json['order']) : null;
    _returnedItem = json['returned_item'] != null
        ? ReturnedItem.fromJson(json['returned_item'])
        : null;
    _actions =
        json['actions'] != null ? Actions.fromJson(json['actions']) : null;
  }
  num? _id;
  String? _status;
  String? _statusLabel;
  String? _statusTone;
  String? _submittedOn;
  dynamic _resolvedAt;
  String? _reason;
  dynamic _message;
  List<String>? _images;
  dynamic _sellerResponse;
  dynamic _sellerRejectionReason;
  dynamic _returnAddress;
  dynamic _completedAt;
  dynamic _refundedAt;
  dynamic _refundAmount;
  dynamic _chatRoomId;
  Order? _order;
  ReturnedItem? _returnedItem;
  Actions? _actions;
  Data copyWith({
    num? id,
    String? status,
    String? statusLabel,
    String? statusTone,
    String? submittedOn,
    dynamic resolvedAt,
    String? reason,
    dynamic message,
    List<String>? images,
    dynamic sellerResponse,
    dynamic sellerRejectionReason,
    dynamic returnAddress,
    dynamic completedAt,
    dynamic refundedAt,
    dynamic refundAmount,
    dynamic chatRoomId,
    Order? order,
    ReturnedItem? returnedItem,
    Actions? actions,
  }) =>
      Data(
        id: id ?? _id,
        status: status ?? _status,
        statusLabel: statusLabel ?? _statusLabel,
        statusTone: statusTone ?? _statusTone,
        submittedOn: submittedOn ?? _submittedOn,
        resolvedAt: resolvedAt ?? _resolvedAt,
        reason: reason ?? _reason,
        message: message ?? _message,
        images: images ?? _images,
        sellerResponse: sellerResponse ?? _sellerResponse,
        sellerRejectionReason: sellerRejectionReason ?? _sellerRejectionReason,
        returnAddress: returnAddress ?? _returnAddress,
        completedAt: completedAt ?? _completedAt,
        refundedAt: refundedAt ?? _refundedAt,
        refundAmount: refundAmount ?? _refundAmount,
        chatRoomId: chatRoomId ?? _chatRoomId,
        order: order ?? _order,
        returnedItem: returnedItem ?? _returnedItem,
        actions: actions ?? _actions,
      );
  num? get id => _id;
  String? get status => _status;
  String? get statusLabel => _statusLabel;
  String? get statusTone => _statusTone;
  String? get submittedOn => _submittedOn;
  dynamic get resolvedAt => _resolvedAt;
  String? get reason => _reason;
  dynamic get message => _message;
  List<String>? get images => _images;
  dynamic get sellerResponse => _sellerResponse;
  dynamic get sellerRejectionReason => _sellerRejectionReason;
  dynamic get returnAddress => _returnAddress;
  dynamic get completedAt => _completedAt;
  dynamic get refundedAt => _refundedAt;
  dynamic get refundAmount => _refundAmount;
  dynamic get chatRoomId => _chatRoomId;
  Order? get order => _order;
  ReturnedItem? get returnedItem => _returnedItem;
  Actions? get actions => _actions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['status'] = _status;
    map['status_label'] = _statusLabel;
    map['status_tone'] = _statusTone;
    map['submitted_on'] = _submittedOn;
    map['resolved_at'] = _resolvedAt;
    map['reason'] = _reason;
    map['message'] = _message;
    map['images'] = _images;
    map['seller_response'] = _sellerResponse;
    map['seller_rejection_reason'] = _sellerRejectionReason;
    map['return_address'] = _returnAddress;
    map['completed_at'] = _completedAt;
    map['refunded_at'] = _refundedAt;
    map['refund_amount'] = _refundAmount;
    map['chat_room_id'] = _chatRoomId;
    if (_order != null) {
      map['order'] = _order?.toJson();
    }
    if (_returnedItem != null) {
      map['returned_item'] = _returnedItem?.toJson();
    }
    if (_actions != null) {
      map['actions'] = _actions?.toJson();
    }
    return map;
  }
}

/// can_message_seller : true
/// can_update_status : true
/// can_send_return_instructions : true
/// can_complete_refund : true
/// can_reject : true

class Actions {
  Actions({
    bool? canMessageSeller,
    bool? canUpdateStatus,
    bool? canSendReturnInstructions,
    bool? canCompleteRefund,
    bool? canReject,
  }) {
    _canMessageSeller = canMessageSeller;
    _canUpdateStatus = canUpdateStatus;
    _canSendReturnInstructions = canSendReturnInstructions;
    _canCompleteRefund = canCompleteRefund;
    _canReject = canReject;
  }

  Actions.fromJson(dynamic json) {
    _canMessageSeller = json['can_message_seller'];
    _canUpdateStatus = json['can_update_status'];
    _canSendReturnInstructions = json['can_send_return_instructions'];
    _canCompleteRefund = json['can_complete_refund'];
    _canReject = json['can_reject'];
  }
  bool? _canMessageSeller;
  bool? _canUpdateStatus;
  bool? _canSendReturnInstructions;
  bool? _canCompleteRefund;
  bool? _canReject;
  Actions copyWith({
    bool? canMessageSeller,
    bool? canUpdateStatus,
    bool? canSendReturnInstructions,
    bool? canCompleteRefund,
    bool? canReject,
  }) =>
      Actions(
        canMessageSeller: canMessageSeller ?? _canMessageSeller,
        canUpdateStatus: canUpdateStatus ?? _canUpdateStatus,
        canSendReturnInstructions:
            canSendReturnInstructions ?? _canSendReturnInstructions,
        canCompleteRefund: canCompleteRefund ?? _canCompleteRefund,
        canReject: canReject ?? _canReject,
      );
  bool? get canMessageSeller => _canMessageSeller;
  bool? get canUpdateStatus => _canUpdateStatus;
  bool? get canSendReturnInstructions => _canSendReturnInstructions;
  bool? get canCompleteRefund => _canCompleteRefund;
  bool? get canReject => _canReject;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['can_message_seller'] = _canMessageSeller;
    map['can_update_status'] = _canUpdateStatus;
    map['can_send_return_instructions'] = _canSendReturnInstructions;
    map['can_complete_refund'] = _canCompleteRefund;
    map['can_reject'] = _canReject;
    return map;
  }
}

/// id : 2
/// productId : 2
/// variantId : null
/// quantity : 2
/// price : 25
/// product : {"id":2,"name":"Emily Carter Kids Item 2","image_urls":["/uploads/shoes.jpg"]}
/// variant : null

class ReturnedItem {
  ReturnedItem({
    num? id,
    num? productId,
    dynamic variantId,
    num? quantity,
    num? price,
    Product? product,
    dynamic variant,
  }) {
    _id = id;
    _productId = productId;
    _variantId = variantId;
    _quantity = quantity;
    _price = price;
    _product = product;
    _variant = variant;
  }

  ReturnedItem.fromJson(dynamic json) {
    _id = json['id'];
    _productId = json['productId'];
    _variantId = json['variantId'];
    _quantity = json['quantity'];
    _price = json['price'];
    _product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    _variant = json['variant'];
  }
  num? _id;
  num? _productId;
  dynamic _variantId;
  num? _quantity;
  num? _price;
  Product? _product;
  dynamic _variant;
  ReturnedItem copyWith({
    num? id,
    num? productId,
    dynamic variantId,
    num? quantity,
    num? price,
    Product? product,
    dynamic variant,
  }) =>
      ReturnedItem(
        id: id ?? _id,
        productId: productId ?? _productId,
        variantId: variantId ?? _variantId,
        quantity: quantity ?? _quantity,
        price: price ?? _price,
        product: product ?? _product,
        variant: variant ?? _variant,
      );
  num? get id => _id;
  num? get productId => _productId;
  dynamic get variantId => _variantId;
  num? get quantity => _quantity;
  num? get price => _price;
  Product? get product => _product;
  dynamic get variant => _variant;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['productId'] = _productId;
    map['variantId'] = _variantId;
    map['quantity'] = _quantity;
    map['price'] = _price;
    if (_product != null) {
      map['product'] = _product?.toJson();
    }
    map['variant'] = _variant;
    return map;
  }
}

/// id : 2
/// name : "Emily Carter Kids Item 2"
/// image_urls : ["/uploads/shoes.jpg"]

class Product {
  Product({
    num? id,
    String? name,
    List<String>? imageUrls,
    String? imageUrl,
  }) {
    _id = id;
    _name = name;
    _imageUrls = imageUrls;
    _imageUrl = imageUrl;
  }

  Product.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _imageUrls =
        json['image_urls'] != null ? json['image_urls'].cast<String>() : [];
    _imageUrl = json['image_url'];
  }
  num? _id;
  String? _name;
  List<String>? _imageUrls;
  String? _imageUrl;

  Product copyWith(
          {num? id, String? name, List<String>? imageUrls, String? imageUrl}) =>
      Product(
        id: id ?? _id,
        name: name ?? _name,
        imageUrls: imageUrls ?? _imageUrls,
        imageUrl: imageUrl ?? _imageUrl,
      );
  num? get id => _id;
  String? get name => _name;
  List<String>? get imageUrls => _imageUrls;
  String? get imageUrl => _imageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['image_urls'] = _imageUrls;
    map['image_url'] = _imageUrl;
    return map;
  }
}

/// id : 2
/// display_id : "KDF0000000002"
/// status : "CONFIRMED"
/// total : 62.99
/// createdAt : "2026-07-20T04:44:06.351Z"
/// delivered_at : null
/// seller : {"id":5,"email":"basic.seller@bestkid.test","profile":{"full_name":"Emily Carter","avatar_url":"https://i.pravatar.cc/150?u=basic.seller%40bestkid.test","country":"Bulgaria","phone":"+359 88 123 4567"}}
/// buyer : {"id":3,"email":"buyer.two@bestkid.test","profile":{"full_name":"Robert Davis","avatar_url":"https://i.pravatar.cc/150?u=buyer.two%40bestkid.test","country":"Romania","phone":"+359 77 234 5678"}}
/// delivery_address : {"address":"25 Ivan Vazov Street","city":"Plovdiv","postal_code":"4000","country":"Romania"}
/// items : [{"id":2,"productId":2,"variantId":null,"quantity":2,"price":25,"line_total":50,"product":{"id":2,"name":"Emily Carter Kids Item 2","image_urls":["/uploads/shoes.jpg"],"image_url":"/uploads/shoes.jpg"},"variant":null,"is_returned_item":true}]

class Order {
  Order({
    num? id,
    String? displayId,
    String? status,
    num? total,
    String? createdAt,
    dynamic deliveredAt,
    Seller? seller,
    Buyer? buyer,
    DeliveryAddress? deliveryAddress,
    List<Items>? items,
  }) {
    _id = id;
    _displayId = displayId;
    _status = status;
    _total = total;
    _createdAt = createdAt;
    _deliveredAt = deliveredAt;
    _seller = seller;
    _buyer = buyer;
    _deliveryAddress = deliveryAddress;
    _items = items;
  }

  Order.fromJson(dynamic json) {
    _id = json['id'];
    _displayId = json['display_id'];
    _status = json['status'];
    _total = json['total'];
    _createdAt = json['createdAt'];
    _deliveredAt = json['delivered_at'];
    _seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
    _buyer = json['buyer'] != null ? Buyer.fromJson(json['buyer']) : null;
    _deliveryAddress = json['delivery_address'] != null
        ? DeliveryAddress.fromJson(json['delivery_address'])
        : null;
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
  }
  num? _id;
  String? _displayId;
  String? _status;
  num? _total;
  String? _createdAt;
  dynamic _deliveredAt;
  Seller? _seller;
  Buyer? _buyer;
  DeliveryAddress? _deliveryAddress;
  List<Items>? _items;
  Order copyWith({
    num? id,
    String? displayId,
    String? status,
    num? total,
    String? createdAt,
    dynamic deliveredAt,
    Seller? seller,
    Buyer? buyer,
    DeliveryAddress? deliveryAddress,
    List<Items>? items,
  }) =>
      Order(
        id: id ?? _id,
        displayId: displayId ?? _displayId,
        status: status ?? _status,
        total: total ?? _total,
        createdAt: createdAt ?? _createdAt,
        deliveredAt: deliveredAt ?? _deliveredAt,
        seller: seller ?? _seller,
        buyer: buyer ?? _buyer,
        deliveryAddress: deliveryAddress ?? _deliveryAddress,
        items: items ?? _items,
      );
  num? get id => _id;
  String? get displayId => _displayId;
  String? get status => _status;
  num? get total => _total;
  String? get createdAt => _createdAt;
  dynamic get deliveredAt => _deliveredAt;
  Seller? get seller => _seller;
  Buyer? get buyer => _buyer;
  DeliveryAddress? get deliveryAddress => _deliveryAddress;
  List<Items>? get items => _items;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['display_id'] = _displayId;
    map['status'] = _status;
    map['total'] = _total;
    map['createdAt'] = _createdAt;
    map['delivered_at'] = _deliveredAt;
    if (_seller != null) {
      map['seller'] = _seller?.toJson();
    }
    if (_buyer != null) {
      map['buyer'] = _buyer?.toJson();
    }
    if (_deliveryAddress != null) {
      map['delivery_address'] = _deliveryAddress?.toJson();
    }
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 2
/// productId : 2
/// variantId : null
/// quantity : 2
/// price : 25
/// line_total : 50
/// product : {"id":2,"name":"Emily Carter Kids Item 2","image_urls":["/uploads/shoes.jpg"],"image_url":"/uploads/shoes.jpg"}
/// variant : null
/// is_returned_item : true

class Items {
  Items({
    num? id,
    num? productId,
    dynamic variantId,
    num? quantity,
    num? price,
    num? lineTotal,
    Product? product,
    dynamic variant,
    bool? isReturnedItem,
  }) {
    _id = id;
    _productId = productId;
    _variantId = variantId;
    _quantity = quantity;
    _price = price;
    _lineTotal = lineTotal;
    _product = product;
    _variant = variant;
    _isReturnedItem = isReturnedItem;
  }

  Items.fromJson(dynamic json) {
    _id = json['id'];
    _productId = json['productId'];
    _variantId = json['variantId'];
    _quantity = json['quantity'];
    _price = json['price'];
    _lineTotal = json['line_total'];
    _product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    _variant = json['variant'];
    _isReturnedItem = json['is_returned_item'];
  }
  num? _id;
  num? _productId;
  dynamic _variantId;
  num? _quantity;
  num? _price;
  num? _lineTotal;
  Product? _product;
  dynamic _variant;
  bool? _isReturnedItem;
  Items copyWith({
    num? id,
    num? productId,
    dynamic variantId,
    num? quantity,
    num? price,
    num? lineTotal,
    Product? product,
    dynamic variant,
    bool? isReturnedItem,
  }) =>
      Items(
        id: id ?? _id,
        productId: productId ?? _productId,
        variantId: variantId ?? _variantId,
        quantity: quantity ?? _quantity,
        price: price ?? _price,
        lineTotal: lineTotal ?? _lineTotal,
        product: product ?? _product,
        variant: variant ?? _variant,
        isReturnedItem: isReturnedItem ?? _isReturnedItem,
      );
  num? get id => _id;
  num? get productId => _productId;
  dynamic get variantId => _variantId;
  num? get quantity => _quantity;
  num? get price => _price;
  num? get lineTotal => _lineTotal;
  Product? get product => _product;
  dynamic get variant => _variant;
  bool? get isReturnedItem => _isReturnedItem;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['productId'] = _productId;
    map['variantId'] = _variantId;
    map['quantity'] = _quantity;
    map['price'] = _price;
    map['line_total'] = _lineTotal;
    if (_product != null) {
      map['product'] = _product?.toJson();
    }
    map['variant'] = _variant;
    map['is_returned_item'] = _isReturnedItem;
    return map;
  }
}

// Product class is defined above (shared between ReturnedItem and Items)

/// address : "25 Ivan Vazov Street"
/// city : "Plovdiv"
/// postal_code : "4000"
/// country : "Romania"

class DeliveryAddress {
  DeliveryAddress({
    String? address,
    String? city,
    String? postalCode,
    String? country,
  }) {
    _address = address;
    _city = city;
    _postalCode = postalCode;
    _country = country;
  }

  DeliveryAddress.fromJson(dynamic json) {
    _address = json['address'];
    _city = json['city'];
    _postalCode = json['postal_code'];
    _country = json['country'];
  }
  String? _address;
  String? _city;
  String? _postalCode;
  String? _country;
  DeliveryAddress copyWith({
    String? address,
    String? city,
    String? postalCode,
    String? country,
  }) =>
      DeliveryAddress(
        address: address ?? _address,
        city: city ?? _city,
        postalCode: postalCode ?? _postalCode,
        country: country ?? _country,
      );
  String? get address => _address;
  String? get city => _city;
  String? get postalCode => _postalCode;
  String? get country => _country;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = _address;
    map['city'] = _city;
    map['postal_code'] = _postalCode;
    map['country'] = _country;
    return map;
  }
}

/// id : 3
/// email : "buyer.two@bestkid.test"
/// profile : {"full_name":"Robert Davis","avatar_url":"https://i.pravatar.cc/150?u=buyer.two%40bestkid.test","country":"Romania","phone":"+359 77 234 5678"}

class Buyer {
  Buyer({
    num? id,
    String? email,
    Profile? profile,
  }) {
    _id = id;
    _email = email;
    _profile = profile;
  }

  Buyer.fromJson(dynamic json) {
    _id = json['id'];
    _email = json['email'];
    _profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }
  num? _id;
  String? _email;
  Profile? _profile;
  Buyer copyWith({
    num? id,
    String? email,
    Profile? profile,
  }) =>
      Buyer(
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

/// full_name : "Robert Davis"
/// avatar_url : "https://i.pravatar.cc/150?u=buyer.two%40bestkid.test"
/// country : "Romania"
/// phone : "+359 77 234 5678"

class Profile {
  Profile({
    String? fullName,
    String? avatarUrl,
    String? country,
    String? phone,
  }) {
    _fullName = fullName;
    _avatarUrl = avatarUrl;
    _country = country;
    _phone = phone;
  }

  Profile.fromJson(dynamic json) {
    _fullName = json['full_name'];
    _avatarUrl = json['avatar_url'];
    _country = json['country'];
    _phone = json['phone'];
  }
  String? _fullName;
  String? _avatarUrl;
  String? _country;
  String? _phone;
  Profile copyWith({
    String? fullName,
    String? avatarUrl,
    String? country,
    String? phone,
  }) =>
      Profile(
        fullName: fullName ?? _fullName,
        avatarUrl: avatarUrl ?? _avatarUrl,
        country: country ?? _country,
        phone: phone ?? _phone,
      );
  String? get fullName => _fullName;
  String? get avatarUrl => _avatarUrl;
  String? get country => _country;
  String? get phone => _phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['full_name'] = _fullName;
    map['avatar_url'] = _avatarUrl;
    map['country'] = _country;
    map['phone'] = _phone;
    return map;
  }
}

/// id : 5
/// email : "basic.seller@bestkid.test"
/// profile : {"full_name":"Emily Carter","avatar_url":"https://i.pravatar.cc/150?u=basic.seller%40bestkid.test","country":"Bulgaria","phone":"+359 88 123 4567"}

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

// Profile class is defined above (shared between Buyer and Seller)
