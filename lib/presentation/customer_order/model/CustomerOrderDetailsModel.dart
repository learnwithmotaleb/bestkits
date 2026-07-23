class CustomerOrderDetailsModel {
  bool? success;
  num? statusCode;
  String? message;
  Data? data;

  CustomerOrderDetailsModel(
      {this.success, this.statusCode, this.message, this.data});

  CustomerOrderDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? displayId;
  String? status;
  String? statusLabel;
  String? statusTone;
  String? createdAt;
  String? updatedAt;
  num? total;
  Delivery? delivery;
  DeliveryAddress? deliveryAddress;
  Buyer? buyer;
  Seller? seller;
  dynamic cancellation;
  Timeline? timeline;
  Actions? actions;
  List<Items>? items;
  dynamic chatRoomId;
  OrderedBy? orderedBy;
  List<String>? statusOptions;

  Data(
      {this.id,
        this.displayId,
        this.status,
        this.statusLabel,
        this.statusTone,
        this.createdAt,
        this.updatedAt,
        this.total,
        this.delivery,
        this.deliveryAddress,
        this.buyer,
        this.seller,
        this.cancellation,
        this.timeline,
        this.actions,
        this.items,
        this.chatRoomId,
        this.orderedBy,
        this.statusOptions});

  Data copyWith({
    num? id,
    String? displayId,
    String? status,
    String? statusLabel,
    String? statusTone,
    String? createdAt,
    String? updatedAt,
    num? total,
    Delivery? delivery,
    DeliveryAddress? deliveryAddress,
    Buyer? buyer,
    Seller? seller,
    dynamic cancellation,
    Timeline? timeline,
    Actions? actions,
    List<Items>? items,
    dynamic chatRoomId,
    OrderedBy? orderedBy,
    List<String>? statusOptions,
  }) {
    return Data(
      id: id ?? this.id,
      displayId: displayId ?? this.displayId,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      statusTone: statusTone ?? this.statusTone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      total: total ?? this.total,
      delivery: delivery ?? this.delivery,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      buyer: buyer ?? this.buyer,
      seller: seller ?? this.seller,
      cancellation: cancellation ?? this.cancellation,
      timeline: timeline ?? this.timeline,
      actions: actions ?? this.actions,
      items: items ?? this.items,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      orderedBy: orderedBy ?? this.orderedBy,
      statusOptions: statusOptions ?? this.statusOptions,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayId = json['display_id'];
    status = json['status'];
    statusLabel = json['status_label'];
    statusTone = json['status_tone'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    total = json['total'];
    delivery =
    json['delivery'] != null ? Delivery.fromJson(json['delivery']) : null;
    deliveryAddress = json['delivery_address'] != null
        ? DeliveryAddress.fromJson(json['delivery_address'])
        : null;
    buyer = json['buyer'] != null ? Buyer.fromJson(json['buyer']) : null;
    seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
    cancellation = json['cancellation'];
    timeline =
    json['timeline'] != null ? Timeline.fromJson(json['timeline']) : null;
    actions =
    json['actions'] != null ? Actions.fromJson(json['actions']) : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    chatRoomId = json['chat_room_id'];
    orderedBy = json['ordered_by'] != null
        ? OrderedBy.fromJson(json['ordered_by'])
        : null;
    if (json['status_options'] != null) {
      statusOptions = json['status_options'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['display_id'] = displayId;
    data['status'] = status;
    data['status_label'] = statusLabel;
    data['status_tone'] = statusTone;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['total'] = total;
    if (delivery != null) {
      data['delivery'] = delivery!.toJson();
    }
    if (deliveryAddress != null) {
      data['delivery_address'] = deliveryAddress!.toJson();
    }
    if (buyer != null) {
      data['buyer'] = buyer!.toJson();
    }
    if (seller != null) {
      data['seller'] = seller!.toJson();
    }
    data['cancellation'] = cancellation;
    if (timeline != null) {
      data['timeline'] = timeline!.toJson();
    }
    if (actions != null) {
      data['actions'] = actions!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['chat_room_id'] = chatRoomId;
    if (orderedBy != null) {
      data['ordered_by'] = orderedBy!.toJson();
    }
    data['status_options'] = statusOptions;
    return data;
  }
}

class Delivery {
  String? partner;
  num? cost;
  num? daysMin;
  num? daysMax;

  Delivery({this.partner, this.cost, this.daysMin, this.daysMax});

  Delivery.fromJson(Map<String, dynamic> json) {
    partner = json['partner'];
    cost = json['cost'];
    daysMin = json['days_min'];
    daysMax = json['days_max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['partner'] = partner;
    data['cost'] = cost;
    data['days_min'] = daysMin;
    data['days_max'] = daysMax;
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

class OrderedBy {
  num? id;
  String? email;
  Profile? profile;

  OrderedBy({this.id, this.email, this.profile});

  OrderedBy.fromJson(Map<String, dynamic> json) {
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
  String? phone;
  String? country;

  Profile({this.fullName, this.avatarUrl, this.phone, this.country});

  Profile.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    avatarUrl = json['avatar_url'];
    phone = json['phone'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['avatar_url'] = avatarUrl;
    data['phone'] = phone;
    data['country'] = country;
    return data;
  }
}

class Timeline {
  dynamic confirmedAt;
  dynamic processingAt;
  dynamic shippedAt;
  dynamic deliveredAt;
  dynamic cancelledAt;

  Timeline(
      {this.confirmedAt,
        this.processingAt,
        this.shippedAt,
        this.deliveredAt,
        this.cancelledAt});

  Timeline.fromJson(Map<String, dynamic> json) {
    confirmedAt = json['confirmed_at'];
    processingAt = json['processing_at'];
    shippedAt = json['shipped_at'];
    deliveredAt = json['delivered_at'];
    cancelledAt = json['cancelled_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['confirmed_at'] = confirmedAt;
    data['processing_at'] = processingAt;
    data['shipped_at'] = shippedAt;
    data['delivered_at'] = deliveredAt;
    data['cancelled_at'] = cancelledAt;
    return data;
  }
}

class Actions {
  bool? canUpdateStatus;
  bool? canMessageBuyer;
  bool? canReview;
  bool? reviewed;
  bool? canReturn;
  bool? returnRequested;

  Actions(
      {this.canUpdateStatus,
        this.canMessageBuyer,
        this.canReview,
        this.reviewed,
        this.canReturn,
        this.returnRequested});

  Actions.fromJson(Map<String, dynamic> json) {
    canUpdateStatus = json['can_update_status'];
    canMessageBuyer = json['can_message_buyer'];
    canReview = json['can_review'];
    reviewed = json['reviewed'];
    canReturn = json['can_return'];
    returnRequested = json['return_requested'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['can_update_status'] = canUpdateStatus;
    data['can_message_buyer'] = canMessageBuyer;
    data['can_review'] = canReview;
    data['reviewed'] = reviewed;
    data['can_return'] = canReturn;
    data['return_requested'] = returnRequested;
    return data;
  }
}

class Items {
  num? id;
  num? productId;
  dynamic variantId;
  num? quantity;
  num? price;
  num? lineTotal;
  Product? product;
  dynamic variant;
  dynamic review;
  ReturnRequest? returnRequest;
  Actions? actions;

  Items(
      {this.id,
        this.productId,
        this.variantId,
        this.quantity,
        this.price,
        this.lineTotal,
        this.product,
        this.variant,
        this.review,
        this.returnRequest,
        this.actions});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    variantId = json['variantId'];
    quantity = json['quantity'];
    price = json['price'];
    lineTotal = json['line_total'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
    variant = json['variant'];
    review = json['review'];
    returnRequest = json['return_request'] != null
        ? ReturnRequest.fromJson(json['return_request'])
        : null;
    actions =
    json['actions'] != null ? Actions.fromJson(json['actions']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productId'] = productId;
    data['variantId'] = variantId;
    data['quantity'] = quantity;
    data['price'] = price;
    data['line_total'] = lineTotal;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['variant'] = variant;
    data['review'] = review;
    if (returnRequest != null) {
      data['return_request'] = returnRequest!.toJson();
    }
    if (actions != null) {
      data['actions'] = actions!.toJson();
    }
    return data;
  }
}

class Product {
  num? id;
  String? name;
  List<String>? imageUrls;
  String? imageUrl;
  num? averageRating;
  num? totalReviews;

  Product(
      {this.id,
        this.name,
        this.imageUrls,
        this.imageUrl,
        this.averageRating,
        this.totalReviews});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['image_urls'] != null) {
      imageUrls = json['image_urls'].cast<String>();
    }
    imageUrl = json['image_url'];
    averageRating = json['average_rating'];
    totalReviews = json['total_reviews'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image_urls'] = imageUrls;
    data['image_url'] = imageUrl;
    data['average_rating'] = averageRating;
    data['total_reviews'] = totalReviews;
    return data;
  }
}

class ReturnRequest {
  num? id;
  num? orderItemId;
  num? userId;
  String? reason;
  dynamic message;
  List<dynamic>? images;
  String? status;
  dynamic sellerResponse;
  dynamic sellerRejectionReason;
  dynamic returnAddress;
  dynamic resolvedAt;
  dynamic completedAt;
  dynamic refundedAt;
  dynamic refundAmount;
  String? createdAt;
  String? updatedAt;

  ReturnRequest(
      {this.id,
        this.orderItemId,
        this.userId,
        this.reason,
        this.message,
        this.images,
        this.status,
        this.sellerResponse,
        this.sellerRejectionReason,
        this.returnAddress,
        this.resolvedAt,
        this.completedAt,
        this.refundedAt,
        this.refundAmount,
        this.createdAt,
        this.updatedAt});

  ReturnRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderItemId = json['orderItemId'];
    userId = json['userId'];
    reason = json['reason'];
    message = json['message'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images!.add(v);
      });
    }
    status = json['status'];
    sellerResponse = json['seller_response'];
    sellerRejectionReason = json['seller_rejection_reason'];
    returnAddress = json['return_address'];
    resolvedAt = json['resolved_at'];
    completedAt = json['completed_at'];
    refundedAt = json['refunded_at'];
    refundAmount = json['refund_amount'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['orderItemId'] = orderItemId;
    data['userId'] = userId;
    data['reason'] = reason;
    data['message'] = message;
    if (images != null) {
      data['images'] = images;
    }
    data['status'] = status;
    data['seller_response'] = sellerResponse;
    data['seller_rejection_reason'] = sellerRejectionReason;
    data['return_address'] = returnAddress;
    data['resolved_at'] = resolvedAt;
    data['completed_at'] = completedAt;
    data['refunded_at'] = refundedAt;
    data['refund_amount'] = refundAmount;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
