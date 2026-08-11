/// success : true
/// statusCode : 200
/// message : "Request successful"
/// data : {"seller_groups":[{"seller":{"id":7,"name":"Chris Brown","country":"Bulgaria"},"delivery":{"type":"international","partner":"FedEx","cost":18.99,"days_min":3,"days_max":6},"items":[{"id":15,"productId":12,"variantId":23,"quantity":6,"price":39,"product":{"id":12,"name":"Chris Brown Kids Item 4","image_urls":["/uploads/shoes.jpg"],"status":"ACTIVE"},"variant":{"id":23,"variantName":"Small","price":39}}],"subtotal":234,"delivery_cost":18.99,"group_total":252.99},{"seller":{"id":5,"name":"Emily Carter","country":"Bulgaria"},"delivery":{"type":"international","partner":"DHL Express","cost":12.99,"days_min":5,"days_max":10},"items":[{"id":16,"productId":1,"variantId":1,"quantity":2,"price":15,"product":{"id":1,"name":"Emily Carter Kids Item 1","image_urls":["/uploads/shoes.jpg"],"status":"ACTIVE"},"variant":{"id":1,"variantName":"Small","price":18}}],"subtotal":30,"delivery_cost":12.99,"group_total":42.99}],"grand_total":295.98}

class CartModel {
  CartModel({
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

  CartModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  Data? _data;
  CartModel copyWith({
    bool? success,
    num? statusCode,
    String? message,
    Data? data,
  }) =>
      CartModel(
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

/// seller_groups : [{"seller":{"id":7,"name":"Chris Brown","country":"Bulgaria"},"delivery":{"type":"international","partner":"FedEx","cost":18.99,"days_min":3,"days_max":6},"items":[{"id":15,"productId":12,"variantId":23,"quantity":6,"price":39,"product":{"id":12,"name":"Chris Brown Kids Item 4","image_urls":["/uploads/shoes.jpg"],"status":"ACTIVE"},"variant":{"id":23,"variantName":"Small","price":39}}],"subtotal":234,"delivery_cost":18.99,"group_total":252.99},{"seller":{"id":5,"name":"Emily Carter","country":"Bulgaria"},"delivery":{"type":"international","partner":"DHL Express","cost":12.99,"days_min":5,"days_max":10},"items":[{"id":16,"productId":1,"variantId":1,"quantity":2,"price":15,"product":{"id":1,"name":"Emily Carter Kids Item 1","image_urls":["/uploads/shoes.jpg"],"status":"ACTIVE"},"variant":{"id":1,"variantName":"Small","price":18}}],"subtotal":30,"delivery_cost":12.99,"group_total":42.99}]
/// grand_total : 295.98

class Data {
  Data({
    List<SellerGroups>? sellerGroups,
    num? grandTotal,
  }) {
    _sellerGroups = sellerGroups;
    _grandTotal = grandTotal;
  }

  Data.fromJson(dynamic json) {
    if (json['seller_groups'] != null) {
      _sellerGroups = [];
      json['seller_groups'].forEach((v) {
        _sellerGroups?.add(SellerGroups.fromJson(v));
      });
    }
    _grandTotal = json['grand_total'];
  }
  List<SellerGroups>? _sellerGroups;
  num? _grandTotal;
  Data copyWith({
    List<SellerGroups>? sellerGroups,
    num? grandTotal,
  }) =>
      Data(
        sellerGroups: sellerGroups ?? _sellerGroups,
        grandTotal: grandTotal ?? _grandTotal,
      );
  List<SellerGroups>? get sellerGroups => _sellerGroups;
  num? get grandTotal => _grandTotal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_sellerGroups != null) {
      map['seller_groups'] = _sellerGroups?.map((v) => v.toJson()).toList();
    }
    map['grand_total'] = _grandTotal;
    return map;
  }
}

/// seller : {"id":7,"name":"Chris Brown","country":"Bulgaria"}
/// delivery : {"type":"international","partner":"FedEx","cost":18.99,"days_min":3,"days_max":6}
/// items : [{"id":15,"productId":12,"variantId":23,"quantity":6,"price":39,"product":{"id":12,"name":"Chris Brown Kids Item 4","image_urls":["/uploads/shoes.jpg"],"status":"ACTIVE"},"variant":{"id":23,"variantName":"Small","price":39}}]
/// subtotal : 234
/// delivery_cost : 18.99
/// group_total : 252.99

class SellerGroups {
  SellerGroups({
    Seller? seller,
    Delivery? delivery,
    List<Items>? items,
    num? subtotal,
    num? deliveryCost,
    num? groupTotal,
  }) {
    _seller = seller;
    _delivery = delivery;
    _items = items;
    _subtotal = subtotal;
    _deliveryCost = deliveryCost;
    _groupTotal = groupTotal;
  }

  SellerGroups.fromJson(dynamic json) {
    _seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
    _delivery =
        json['delivery'] != null ? Delivery.fromJson(json['delivery']) : null;
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
    _subtotal = json['subtotal'];
    _deliveryCost = json['delivery_cost'];
    _groupTotal = json['group_total'];
  }
  Seller? _seller;
  Delivery? _delivery;
  List<Items>? _items;
  num? _subtotal;
  num? _deliveryCost;
  num? _groupTotal;
  SellerGroups copyWith({
    Seller? seller,
    Delivery? delivery,
    List<Items>? items,
    num? subtotal,
    num? deliveryCost,
    num? groupTotal,
  }) =>
      SellerGroups(
        seller: seller ?? _seller,
        delivery: delivery ?? _delivery,
        items: items ?? _items,
        subtotal: subtotal ?? _subtotal,
        deliveryCost: deliveryCost ?? _deliveryCost,
        groupTotal: groupTotal ?? _groupTotal,
      );
  Seller? get seller => _seller;
  Delivery? get delivery => _delivery;
  List<Items>? get items => _items;
  num? get subtotal => _subtotal;
  num? get deliveryCost => _deliveryCost;
  num? get groupTotal => _groupTotal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_seller != null) {
      map['seller'] = _seller?.toJson();
    }
    if (_delivery != null) {
      map['delivery'] = _delivery?.toJson();
    }
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    map['subtotal'] = _subtotal;
    map['delivery_cost'] = _deliveryCost;
    map['group_total'] = _groupTotal;
    return map;
  }
}

/// id : 15
/// productId : 12
/// variantId : 23
/// quantity : 6
/// price : 39
/// product : {"id":12,"name":"Chris Brown Kids Item 4","image_urls":["/uploads/shoes.jpg"],"status":"ACTIVE"}
/// variant : {"id":23,"variantName":"Small","price":39}

class Items {
  Items({
    num? id,
    num? productId,
    num? variantId,
    num? quantity,
    num? price,
    Product? product,
    Variant? variant,
  }) {
    _id = id;
    _productId = productId;
    _variantId = variantId;
    _quantity = quantity;
    _price = price;
    _product = product;
    _variant = variant;
  }

  Items.fromJson(dynamic json) {
    _id = json['id'];
    _productId = json['productId'];
    _variantId = json['variantId'];
    _quantity = json['quantity'];
    _price = json['price'];
    _product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    _variant =
        json['variant'] != null ? Variant.fromJson(json['variant']) : null;
  }
  num? _id;
  num? _productId;
  num? _variantId;
  num? _quantity;
  num? _price;
  Product? _product;
  Variant? _variant;
  Items copyWith({
    num? id,
    num? productId,
    num? variantId,
    num? quantity,
    num? price,
    Product? product,
    Variant? variant,
  }) =>
      Items(
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
  num? get variantId => _variantId;
  num? get quantity => _quantity;
  num? get price => _price;
  Product? get product => _product;
  Variant? get variant => _variant;

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
    if (_variant != null) {
      map['variant'] = _variant?.toJson();
    }
    return map;
  }
}

/// id : 23
/// variantName : "Small"
/// price : 39

class Variant {
  Variant({
    num? id,
    String? variantName,
    num? price,
  }) {
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
  Variant copyWith({
    num? id,
    String? variantName,
    num? price,
  }) =>
      Variant(
        id: id ?? _id,
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

/// id : 12
/// name : "Chris Brown Kids Item 4"
/// image_urls : ["/uploads/shoes.jpg"]
/// status : "ACTIVE"

class Product {
  Product({
    num? id,
    String? name,
    List<String>? imageUrls,
    String? status,
  }) {
    _id = id;
    _name = name;
    _imageUrls = imageUrls;
    _status = status;
  }

  Product.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _imageUrls =
        json['image_urls'] != null ? List<String>.from(json['image_urls']) : [];
    _status = json['status'];
  }
  num? _id;
  String? _name;
  List<String>? _imageUrls;
  String? _status;
  Product copyWith({
    num? id,
    String? name,
    List<String>? imageUrls,
    String? status,
  }) =>
      Product(
        id: id ?? _id,
        name: name ?? _name,
        imageUrls: imageUrls ?? _imageUrls,
        status: status ?? _status,
      );
  num? get id => _id;
  String? get name => _name;
  List<String>? get imageUrls => _imageUrls;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['image_urls'] = _imageUrls;
    map['status'] = _status;
    return map;
  }
}

/// type : "international"
/// partner : "FedEx"
/// cost : 18.99
/// days_min : 3
/// days_max : 6

class Delivery {
  Delivery({
    String? type,
    String? partner,
    num? cost,
    num? daysMin,
    num? daysMax,
  }) {
    _type = type;
    _partner = partner;
    _cost = cost;
    _daysMin = daysMin;
    _daysMax = daysMax;
  }

  Delivery.fromJson(dynamic json) {
    _type = json['type'];
    _partner = json['partner'];
    _cost = json['cost'];
    _daysMin = json['days_min'];
    _daysMax = json['days_max'];
  }
  String? _type;
  String? _partner;
  num? _cost;
  num? _daysMin;
  num? _daysMax;
  Delivery copyWith({
    String? type,
    String? partner,
    num? cost,
    num? daysMin,
    num? daysMax,
  }) =>
      Delivery(
        type: type ?? _type,
        partner: partner ?? _partner,
        cost: cost ?? _cost,
        daysMin: daysMin ?? _daysMin,
        daysMax: daysMax ?? _daysMax,
      );
  String? get type => _type;
  String? get partner => _partner;
  num? get cost => _cost;
  num? get daysMin => _daysMin;
  num? get daysMax => _daysMax;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['partner'] = _partner;
    map['cost'] = _cost;
    map['days_min'] = _daysMin;
    map['days_max'] = _daysMax;
    return map;
  }
}

/// id : 7
/// name : "Chris Brown"
/// country : "Bulgaria"

class Seller {
  Seller({
    num? id,
    String? name,
    String? country,
  }) {
    _id = id;
    _name = name;
    _country = country;
  }

  Seller.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _country = json['country'];
  }
  num? _id;
  String? _name;
  String? _country;
  Seller copyWith({
    num? id,
    String? name,
    String? country,
  }) =>
      Seller(
        id: id ?? _id,
        name: name ?? _name,
        country: country ?? _country,
      );
  num? get id => _id;
  String? get name => _name;
  String? get country => _country;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['country'] = _country;
    return map;
  }
}
