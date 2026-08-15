class ReturnOrderDetailsModel {
  bool? success;
  num? statusCode;
  String? message;
  Data? data;

  ReturnOrderDetailsModel({this.success, this.statusCode, this.message, this.data});

  ReturnOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  num? id;
  String? status;
  String? statusLabel;
  String? statusTone;
  String? submittedOn;
  String? resolvedAt;
  String? reason;
  String? message;
  List<String>? images;
  String? sellerResponse;
  String? sellerRejectionReason;
  dynamic returnAddress;
  String? completedAt;
  String? refundedAt;
  num? refundAmount;
  dynamic chatRoomId;
  Order? order;
  ReturnedItem? returnedItem;
  Actions? actions;

  Data({
    this.id,
    this.status,
    this.statusLabel,
    this.statusTone,
    this.submittedOn,
    this.resolvedAt,
    this.reason,
    this.message,
    this.images,
    this.sellerResponse,
    this.sellerRejectionReason,
    this.returnAddress,
    this.completedAt,
    this.refundedAt,
    this.refundAmount,
    this.chatRoomId,
    this.order,
    this.returnedItem,
    this.actions,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    statusLabel = json['status_label'];
    statusTone = json['status_tone'];
    submittedOn = json['submitted_on'];
    resolvedAt = json['resolved_at'];
    reason = json['reason'];
    message = json['message'];
    if (json['images'] != null) {
      images = List<String>.from(json['images']);
    }
    sellerResponse = json['seller_response'];
    sellerRejectionReason = json['seller_rejection_reason'];
    returnAddress = json['return_address'];
    completedAt = json['completed_at'];
    refundedAt = json['refunded_at'];
    refundAmount = json['refund_amount'];
    chatRoomId = json['chat_room_id'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
    returnedItem = json['returned_item'] != null
        ? ReturnedItem.fromJson(json['returned_item'])
        : null;
    actions =
        json['actions'] != null ? Actions.fromJson(json['actions']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['status_label'] = statusLabel;
    data['status_tone'] = statusTone;
    data['submitted_on'] = submittedOn;
    data['resolved_at'] = resolvedAt;
    data['reason'] = reason;
    data['message'] = message;
    if (images != null) {
      data['images'] = images;
    }
    data['seller_response'] = sellerResponse;
    data['seller_rejection_reason'] = sellerRejectionReason;
    data['return_address'] = returnAddress;
    data['completed_at'] = completedAt;
    data['refunded_at'] = refundedAt;
    data['refund_amount'] = refundAmount;
    data['chat_room_id'] = chatRoomId;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    if (returnedItem != null) {
      data['returned_item'] = returnedItem!.toJson();
    }
    if (actions != null) {
      data['actions'] = actions!.toJson();
    }
    return data;
  }
}

class Order {
  num? id;
  String? displayId;
  String? status;
  num? total;
  String? createdAt;
  String? deliveredAt;
  Seller? seller;
  Buyer? buyer;
  DeliveryAddress? deliveryAddress;
  List<Items>? items;

  Order({
    this.id,
    this.displayId,
    this.status,
    this.total,
    this.createdAt,
    this.deliveredAt,
    this.seller,
    this.buyer,
    this.deliveryAddress,
    this.items,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayId = json['display_id'];
    status = json['status'];
    total = json['total'];
    createdAt = json['createdAt'];
    deliveredAt = json['delivered_at'];
    seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
    buyer = json['buyer'] != null ? Buyer.fromJson(json['buyer']) : null;
    deliveryAddress = json['delivery_address'] != null
        ? DeliveryAddress.fromJson(json['delivery_address'])
        : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['display_id'] = displayId;
    data['status'] = status;
    data['total'] = total;
    data['createdAt'] = createdAt;
    data['delivered_at'] = deliveredAt;
    if (seller != null) {
      data['seller'] = seller!.toJson();
    }
    if (buyer != null) {
      data['buyer'] = buyer!.toJson();
    }
    if (deliveryAddress != null) {
      data['delivery_address'] = deliveryAddress!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Seller {
  num? id;
  String? email;
  Profile? profile;

  Seller({this.id, this.email, this.profile});

  Seller.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? fullName;
  String? avatarUrl;
  String? country;
  String? phone;

  Profile({this.fullName, this.avatarUrl, this.country, this.phone});

  Profile.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    avatarUrl = json['avatar_url'];
    country = json['country'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['avatar_url'] = avatarUrl;
    data['country'] = country;
    data['phone'] = phone;
    return data;
  }
}

class Buyer {
  num? id;
  String? email;
  Profile? profile;

  Buyer({this.id, this.email, this.profile});

  Buyer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class DeliveryAddress {
  String? address;
  String? city;
  String? postalCode;
  String? country;

  DeliveryAddress({this.address, this.city, this.postalCode, this.country});

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    city = json['city'];
    postalCode = json['postal_code'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['city'] = city;
    data['postal_code'] = postalCode;
    data['country'] = country;
    return data;
  }
}

class Items {
  num? id;
  num? productId;
  num? price;
  num? lineTotal;
  Product? product;
  bool? isReturnedItem;

  Items({
    this.id,
    this.productId,
    this.price,
    this.lineTotal,
    this.product,
    this.isReturnedItem,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    price = json['price'];
    lineTotal = json['line_total'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    isReturnedItem = json['is_returned_item'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productId'] = productId;
    data['price'] = price;
    data['line_total'] = lineTotal;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['is_returned_item'] = isReturnedItem;
    return data;
  }
}

class Product {
  num? id;
  String? name;
  List<String>? imageUrls;
  String? imageUrl;

  Product({this.id, this.name, this.imageUrls, this.imageUrl});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['image_urls'] != null) {
      imageUrls = List<String>.from(json['image_urls']);
    }
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (imageUrls != null) {
      data['image_urls'] = imageUrls;
    }
    data['image_url'] = imageUrl;
    return data;
  }
}

class ReturnedItem {
  num? id;
  num? productId;
  num? price;
  Product? product;

  ReturnedItem({this.id, this.productId, this.price, this.product});

  ReturnedItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    price = json['price'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productId'] = productId;
    data['price'] = price;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Actions {
  bool? canMessageSeller;
  bool? canUpdateStatus;
  bool? canSendReturnInstructions;
  bool? canCompleteRefund;
  bool? canReject;

  Actions({
    this.canMessageSeller,
    this.canUpdateStatus,
    this.canSendReturnInstructions,
    this.canCompleteRefund,
    this.canReject,
  });

  Actions.fromJson(Map<String, dynamic> json) {
    canMessageSeller = json['can_message_seller'];
    canUpdateStatus = json['can_update_status'];
    canSendReturnInstructions = json['can_send_return_instructions'];
    canCompleteRefund = json['can_complete_refund'];
    canReject = json['can_reject'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['can_message_seller'] = canMessageSeller;
    data['can_update_status'] = canUpdateStatus;
    data['can_send_return_instructions'] = canSendReturnInstructions;
    data['can_complete_refund'] = canCompleteRefund;
    data['can_reject'] = canReject;
    return data;
  }
}
