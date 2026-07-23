class MyOrderModel {
  bool? success;
  num? statusCode;
  String? message;
  List<Data>? data;
  Meta? meta;

  MyOrderModel(
      {this.success, this.statusCode, this.message, this.data, this.meta});

  MyOrderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['success'] = success;
    map['statusCode'] = statusCode;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    if (meta != null) {
      map['meta'] = meta!.toJson();
    }
    return map;
  }
}

class Meta {
  num? total;
  num? page;
  num? limit;
  num? pages;

  Meta({this.total, this.page, this.limit, this.pages});

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    pages = json['pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['total'] = total;
    map['page'] = page;
    map['limit'] = limit;
    map['pages'] = pages;
    return map;
  }
}

class Data {
  num? id;
  String? displayId;
  String? status;
  String? statusLabel;
  String? statusTone;
  String? createdAt;
  num? total;
  num? itemCount;
  Seller? seller;
  List<PreviewItems>? previewItems;
  Actions? actions;

  Data(
      {this.id,
      this.displayId,
      this.status,
      this.statusLabel,
      this.statusTone,
      this.createdAt,
      this.total,
      this.itemCount,
      this.seller,
      this.previewItems,
      this.actions});

  Data copyWith({
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
  }) {
    return Data(
      id: id ?? this.id,
      displayId: displayId ?? this.displayId,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      statusTone: statusTone ?? this.statusTone,
      createdAt: createdAt ?? this.createdAt,
      total: total ?? this.total,
      itemCount: itemCount ?? this.itemCount,
      seller: seller ?? this.seller,
      previewItems: previewItems ?? this.previewItems,
      actions: actions ?? this.actions,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayId = json['display_id'];
    status = json['status'];
    statusLabel = json['status_label'];
    statusTone = json['status_tone'];
    createdAt = json['createdAt'];
    total = json['total'];
    itemCount = json['item_count'];
    seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
    if (json['preview_items'] != null) {
      previewItems = <PreviewItems>[];
      json['preview_items'].forEach((v) {
        previewItems!.add(PreviewItems.fromJson(v));
      });
    }
    actions =
        json['actions'] != null ? Actions.fromJson(json['actions']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['display_id'] = displayId;
    map['status'] = status;
    map['status_label'] = statusLabel;
    map['status_tone'] = statusTone;
    map['createdAt'] = createdAt;
    map['total'] = total;
    map['item_count'] = itemCount;
    if (seller != null) {
      map['seller'] = seller!.toJson();
    }
    if (previewItems != null) {
      map['preview_items'] = previewItems!.map((v) => v.toJson()).toList();
    }
    if (actions != null) {
      map['actions'] = actions!.toJson();
    }
    return map;
  }
}

class Seller {
  num? id;
  String? email;
  SellerProfile? profile;

  Seller({this.id, this.email, this.profile});

  Seller.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    profile = json['profile'] != null
        ? SellerProfile.fromJson(json['profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['email'] = email;
    if (profile != null) {
      map['profile'] = profile!.toJson();
    }
    return map;
  }
}

class SellerProfile {
  String? fullName;
  String? avatarUrl;
  String? country;

  SellerProfile({this.fullName, this.avatarUrl, this.country});

  SellerProfile.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    avatarUrl = json['avatar_url'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['full_name'] = fullName;
    map['avatar_url'] = avatarUrl;
    map['country'] = country;
    return map;
  }
}

class PreviewItems {
  num? id;
  num? productId;
  String? name;
  String? imageUrl;
  num? quantity;
  num? price;

  PreviewItems(
      {this.id,
      this.productId,
      this.name,
      this.imageUrl,
      this.quantity,
      this.price});

  PreviewItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    name = json['name'];
    imageUrl = json['image_url'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['productId'] = productId;
    map['name'] = name;
    map['image_url'] = imageUrl;
    map['quantity'] = quantity;
    map['price'] = price;
    return map;
  }
}

class Actions {
  bool? canViewDetails;
  bool? canCancel;

  Actions({this.canViewDetails, this.canCancel});

  Actions.fromJson(Map<String, dynamic> json) {
    canViewDetails = json['can_view_details'];
    canCancel = json['can_cancel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['can_view_details'] = canViewDetails;
    map['can_cancel'] = canCancel;
    return map;
  }
}
