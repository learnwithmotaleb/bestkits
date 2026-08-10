class MyOrderDetailsModel {
  bool? success;
  num? statusCode;
  String? message;
  OrderDetail? data;

  MyOrderDetailsModel({this.success, this.statusCode, this.message, this.data});

  MyOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? OrderDetail.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['success'] = success;
    map['statusCode'] = statusCode;
    map['message'] = message;
    if (data != null) map['data'] = data!.toJson();
    return map;
  }
}

class OrderDetail {
  num? id;
  String? displayId;
  String? status;
  String? statusLabel;
  String? statusTone;
  String? createdAt;
  String? updatedAt;
  num? total;
  OrderDelivery? delivery;
  OrderDeliveryAddress? deliveryAddress;
  OrderPerson? buyer;
  OrderPerson? seller;
  dynamic cancellation;
  OrderTimeline? timeline;
  OrderDetailActions? actions;
  List<OrderItem>? items;

  OrderDetail(
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
      this.items});

  OrderDetail copyWith({
    num? id,
    String? displayId,
    String? status,
    String? statusLabel,
    String? statusTone,
    String? createdAt,
    String? updatedAt,
    num? total,
    OrderDelivery? delivery,
    OrderDeliveryAddress? deliveryAddress,
    OrderPerson? buyer,
    OrderPerson? seller,
    dynamic cancellation,
    OrderTimeline? timeline,
    OrderDetailActions? actions,
    List<OrderItem>? items,
  }) {
    return OrderDetail(
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
    );
  }

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayId = json['display_id'];
    status = json['status'];
    statusLabel = json['status_label'];
    statusTone = json['status_tone'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    total = json['total'];
    delivery = json['delivery'] != null
        ? OrderDelivery.fromJson(json['delivery'])
        : null;
    deliveryAddress = json['delivery_address'] != null
        ? OrderDeliveryAddress.fromJson(json['delivery_address'])
        : null;
    buyer = json['buyer'] != null ? OrderPerson.fromJson(json['buyer']) : null;
    seller =
        json['seller'] != null ? OrderPerson.fromJson(json['seller']) : null;
    cancellation = json['cancellation'];
    timeline = json['timeline'] != null
        ? OrderTimeline.fromJson(json['timeline'])
        : null;
    actions = json['actions'] != null
        ? OrderDetailActions.fromJson(json['actions'])
        : null;
    if (json['items'] != null) {
      items = <OrderItem>[];
      json['items'].forEach((v) => items!.add(OrderItem.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['display_id'] = displayId;
    map['status'] = status;
    map['status_label'] = statusLabel;
    map['status_tone'] = statusTone;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['total'] = total;
    if (delivery != null) map['delivery'] = delivery!.toJson();
    if (deliveryAddress != null)
      map['delivery_address'] = deliveryAddress!.toJson();
    if (buyer != null) map['buyer'] = buyer!.toJson();
    if (seller != null) map['seller'] = seller!.toJson();
    map['cancellation'] = cancellation;
    if (timeline != null) map['timeline'] = timeline!.toJson();
    if (actions != null) map['actions'] = actions!.toJson();
    if (items != null) map['items'] = items!.map((v) => v.toJson()).toList();
    return map;
  }
}

class OrderDelivery {
  String? partner;
  num? cost;
  num? daysMin;
  num? daysMax;

  OrderDelivery({this.partner, this.cost, this.daysMin, this.daysMax});

  OrderDelivery.fromJson(Map<String, dynamic> json) {
    partner = json['partner'];
    cost = json['cost'];
    daysMin = json['days_min'];
    daysMax = json['days_max'];
  }

  Map<String, dynamic> toJson() => {
        'partner': partner,
        'cost': cost,
        'days_min': daysMin,
        'days_max': daysMax,
      };
}

class OrderDeliveryAddress {
  String? address;
  String? city;
  String? postalCode;
  String? country;

  OrderDeliveryAddress(
      {this.address, this.city, this.postalCode, this.country});

  OrderDeliveryAddress.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    city = json['city'];
    postalCode = json['postal_code'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() => {
        'address': address,
        'city': city,
        'postal_code': postalCode,
        'country': country,
      };

  String get formatted => [address, city, postalCode, country]
      .where((e) => e != null && e.isNotEmpty)
      .join(', ');
}

class OrderPerson {
  num? id;
  String? email;
  OrderPersonProfile? profile;

  OrderPerson({this.id, this.email, this.profile});

  OrderPerson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    profile = json['profile'] != null
        ? OrderPersonProfile.fromJson(json['profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'id': id, 'email': email};
    if (profile != null) map['profile'] = profile!.toJson();
    return map;
  }
}

class OrderPersonProfile {
  String? fullName;
  String? avatarUrl;
  String? phone;
  String? country;

  OrderPersonProfile({this.fullName, this.avatarUrl, this.phone, this.country});

  OrderPersonProfile.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    avatarUrl = json['avatar_url'];
    phone = json['phone'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'avatar_url': avatarUrl,
        'phone': phone,
        'country': country,
      };
}

class OrderTimeline {
  dynamic confirmedAt;
  dynamic processingAt;
  dynamic shippedAt;
  dynamic deliveredAt;
  dynamic cancelledAt;

  OrderTimeline(
      {this.confirmedAt,
      this.processingAt,
      this.shippedAt,
      this.deliveredAt,
      this.cancelledAt});

  OrderTimeline.fromJson(Map<String, dynamic> json) {
    confirmedAt = json['confirmed_at'];
    processingAt = json['processing_at'];
    shippedAt = json['shipped_at'];
    deliveredAt = json['delivered_at'];
    cancelledAt = json['cancelled_at'];
  }

  Map<String, dynamic> toJson() => {
        'confirmed_at': confirmedAt,
        'processing_at': processingAt,
        'shipped_at': shippedAt,
        'delivered_at': deliveredAt,
        'cancelled_at': cancelledAt,
      };
}

class OrderDetailActions {
  bool? canCancel;

  OrderDetailActions({this.canCancel});

  OrderDetailActions.fromJson(Map<String, dynamic> json) {
    canCancel = json['can_cancel'];
  }

  Map<String, dynamic> toJson() => {'can_cancel': canCancel};
}

class OrderItem {
  num? id;
  num? productId;
  dynamic variantId;
  num? quantity;
  num? price;
  num? lineTotal;
  OrderProduct? product;
  dynamic variant;
  ItemReview? review;
  dynamic returnRequest;
  OrderItemActions? actions;

  OrderItem(
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

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    variantId = json['variantId'];
    quantity = json['quantity'];
    price = json['price'];
    lineTotal = json['line_total'];
    product =
        json['product'] != null ? OrderProduct.fromJson(json['product']) : null;
    variant = json['variant'];
    review =
        json['review'] != null ? ItemReview.fromJson(json['review']) : null;
    returnRequest = json['return_request'];
    actions = json['actions'] != null
        ? OrderItemActions.fromJson(json['actions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'productId': productId,
      'variantId': variantId,
      'quantity': quantity,
      'price': price,
      'line_total': lineTotal,
      'variant': variant,
      'return_request': returnRequest,
    };
    if (product != null) map['product'] = product!.toJson();
    if (review != null) map['review'] = review!.toJson();
    if (actions != null) map['actions'] = actions!.toJson();
    return map;
  }
}

class OrderProduct {
  num? id;
  String? name;
  List<String>? imageUrls;
  String? imageUrl;
  num? averageRating;
  num? totalReviews;

  OrderProduct(
      {this.id,
      this.name,
      this.imageUrls,
      this.imageUrl,
      this.averageRating,
      this.totalReviews});

  OrderProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['image_urls'] != null) {
      imageUrls = json['image_urls'].cast<String>();
    }
    imageUrl = json['image_url'];
    averageRating = json['average_rating'];
    totalReviews = json['total_reviews'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image_urls': imageUrls,
        'image_url': imageUrl,
        'average_rating': averageRating,
        'total_reviews': totalReviews,
      };
}

class ItemReview {
  num? id;
  num? productId;
  num? userId;
  num? orderItemId;
  num? rating;
  String? review;
  String? createdAt;
  String? updatedAt;
  ReviewUser? user;

  ItemReview(
      {this.id,
      this.productId,
      this.userId,
      this.orderItemId,
      this.rating,
      this.review,
      this.createdAt,
      this.updatedAt,
      this.user});

  ItemReview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    userId = json['userId'];
    orderItemId = json['orderItemId'];
    rating = json['rating'];
    review = json['review'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? ReviewUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'productId': productId,
      'userId': userId,
      'orderItemId': orderItemId,
      'rating': rating,
      'review': review,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
    if (user != null) map['user'] = user!.toJson();
    return map;
  }
}

class ReviewUser {
  num? id;
  ReviewUserProfile? profile;

  ReviewUser({this.id, this.profile});

  ReviewUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profile = json['profile'] != null
        ? ReviewUserProfile.fromJson(json['profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'id': id};
    if (profile != null) map['profile'] = profile!.toJson();
    return map;
  }
}

class ReviewUserProfile {
  String? fullName;
  String? avatarUrl;

  ReviewUserProfile({this.fullName, this.avatarUrl});

  ReviewUserProfile.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    avatarUrl = json['avatar_url'];
  }

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'avatar_url': avatarUrl,
      };
}

class OrderItemActions {
  bool? canReview;
  bool? reviewed;
  bool? canReturn;
  bool? returnRequested;

  OrderItemActions(
      {this.canReview, this.reviewed, this.canReturn, this.returnRequested});

  OrderItemActions.fromJson(Map<String, dynamic> json) {
    canReview = json['can_review'];
    reviewed = json['reviewed'];
    canReturn = json['can_return'];
    returnRequested = json['return_requested'];
  }

  Map<String, dynamic> toJson() => {
        'can_review': canReview,
        'reviewed': reviewed,
        'can_return': canReturn,
        'return_requested': returnRequested,
      };
}
