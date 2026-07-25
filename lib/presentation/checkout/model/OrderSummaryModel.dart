/// success : true
/// statusCode : 200
/// message : "Request successful"
/// data : {"selected_seller_ids":[5],"selected_cart_item_ids":[22],"cart_item_count":12,"seller_groups":[{"seller":{"id":5,"email":"basic.seller@bestkid.test","name":"Emily Carter","avatar_url":"https://i.pravatar.cc/150?u=basic.seller%40bestkid.test","country":"Bulgaria"},"delivery":{"type":"domestic","partner":"Bulgarian Post","cost":4.99,"days_min":2,"days_max":4},"items":[{"id":22,"productId":4,"variantId":7,"quantity":12,"price":39,"line_total":468,"product":{"id":4,"name":"Emily Carter Kids Item 4","image_urls":["/uploads/shoes.jpg"],"image_url":"/uploads/shoes.jpg","categoryId":1,"subCategoryId":1},"variant":{"id":7,"variantName":"Small","price":39}}],"subtotal":468,"delivery_cost":4.99,"discount_amount":0,"total":472.99}],"addresses":[{"id":1,"userId":5,"address_name":"Store","address":"25 Ivan Vazov Street","city":"Plovdiv","postal_code":"4000","country":"Bulgaria","is_default":true,"createdAt":"2026-07-23T04:44:06.100Z","updatedAt":"2026-07-23T04:44:06.100Z"}],"selected_address":{"id":1,"userId":5,"address_name":"Store","address":"25 Ivan Vazov Street","city":"Plovdiv","postal_code":"4000","country":"Bulgaria","is_default":true,"createdAt":"2026-07-23T04:44:06.100Z","updatedAt":"2026-07-23T04:44:06.100Z"},"coupon":null,"price_details":{"subtotal":468,"shipping_fee":4.99,"discount":0,"total":472.99},"terms_required":true,"payment":{"provider":"stripe","next_action":"create_checkout_session"}}

class OrderSummaryModel {
  OrderSummaryModel({
      bool? success, 
      num? statusCode, 
      String? message, 
      Data? data,}){
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  OrderSummaryModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  Data? _data;
OrderSummaryModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  Data? data,
}) => OrderSummaryModel(  success: success ?? _success,
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

/// selected_seller_ids : [5]
/// selected_cart_item_ids : [22]
/// cart_item_count : 12
/// seller_groups : [{"seller":{"id":5,"email":"basic.seller@bestkid.test","name":"Emily Carter","avatar_url":"https://i.pravatar.cc/150?u=basic.seller%40bestkid.test","country":"Bulgaria"},"delivery":{"type":"domestic","partner":"Bulgarian Post","cost":4.99,"days_min":2,"days_max":4},"items":[{"id":22,"productId":4,"variantId":7,"quantity":12,"price":39,"line_total":468,"product":{"id":4,"name":"Emily Carter Kids Item 4","image_urls":["/uploads/shoes.jpg"],"image_url":"/uploads/shoes.jpg","categoryId":1,"subCategoryId":1},"variant":{"id":7,"variantName":"Small","price":39}}],"subtotal":468,"delivery_cost":4.99,"discount_amount":0,"total":472.99}]
/// addresses : [{"id":1,"userId":5,"address_name":"Store","address":"25 Ivan Vazov Street","city":"Plovdiv","postal_code":"4000","country":"Bulgaria","is_default":true,"createdAt":"2026-07-23T04:44:06.100Z","updatedAt":"2026-07-23T04:44:06.100Z"}]
/// selected_address : {"id":1,"userId":5,"address_name":"Store","address":"25 Ivan Vazov Street","city":"Plovdiv","postal_code":"4000","country":"Bulgaria","is_default":true,"createdAt":"2026-07-23T04:44:06.100Z","updatedAt":"2026-07-23T04:44:06.100Z"}
/// coupon : null
/// price_details : {"subtotal":468,"shipping_fee":4.99,"discount":0,"total":472.99}
/// terms_required : true
/// payment : {"provider":"stripe","next_action":"create_checkout_session"}

class Data {
  Data({
      List<num>? selectedSellerIds, 
      List<num>? selectedCartItemIds, 
      num? cartItemCount, 
      List<SellerGroups>? sellerGroups, 
      List<Addresses>? addresses, 
      SelectedAddress? selectedAddress, 
      dynamic coupon, 
      PriceDetails? priceDetails, 
      bool? termsRequired, 
      Payment? payment,}){
    _selectedSellerIds = selectedSellerIds;
    _selectedCartItemIds = selectedCartItemIds;
    _cartItemCount = cartItemCount;
    _sellerGroups = sellerGroups;
    _addresses = addresses;
    _selectedAddress = selectedAddress;
    _coupon = coupon;
    _priceDetails = priceDetails;
    _termsRequired = termsRequired;
    _payment = payment;
}

  Data.fromJson(dynamic json) {
    _selectedSellerIds = json['selected_seller_ids'] != null ? json['selected_seller_ids'].cast<num>() : [];
    _selectedCartItemIds = json['selected_cart_item_ids'] != null ? json['selected_cart_item_ids'].cast<num>() : [];
    _cartItemCount = json['cart_item_count'];
    if (json['seller_groups'] != null) {
      _sellerGroups = [];
      json['seller_groups'].forEach((v) {
        _sellerGroups?.add(SellerGroups.fromJson(v));
      });
    }
    if (json['addresses'] != null) {
      _addresses = [];
      json['addresses'].forEach((v) {
        _addresses?.add(Addresses.fromJson(v));
      });
    }
    _selectedAddress = json['selected_address'] != null ? SelectedAddress.fromJson(json['selected_address']) : null;
    _coupon = json['coupon'];
    _priceDetails = json['price_details'] != null ? PriceDetails.fromJson(json['price_details']) : null;
    _termsRequired = json['terms_required'];
    _payment = json['payment'] != null ? Payment.fromJson(json['payment']) : null;
  }
  List<num>? _selectedSellerIds;
  List<num>? _selectedCartItemIds;
  num? _cartItemCount;
  List<SellerGroups>? _sellerGroups;
  List<Addresses>? _addresses;
  SelectedAddress? _selectedAddress;
  dynamic _coupon;
  PriceDetails? _priceDetails;
  bool? _termsRequired;
  Payment? _payment;
Data copyWith({  List<num>? selectedSellerIds,
  List<num>? selectedCartItemIds,
  num? cartItemCount,
  List<SellerGroups>? sellerGroups,
  List<Addresses>? addresses,
  SelectedAddress? selectedAddress,
  dynamic coupon,
  PriceDetails? priceDetails,
  bool? termsRequired,
  Payment? payment,
}) => Data(  selectedSellerIds: selectedSellerIds ?? _selectedSellerIds,
  selectedCartItemIds: selectedCartItemIds ?? _selectedCartItemIds,
  cartItemCount: cartItemCount ?? _cartItemCount,
  sellerGroups: sellerGroups ?? _sellerGroups,
  addresses: addresses ?? _addresses,
  selectedAddress: selectedAddress ?? _selectedAddress,
  coupon: coupon ?? _coupon,
  priceDetails: priceDetails ?? _priceDetails,
  termsRequired: termsRequired ?? _termsRequired,
  payment: payment ?? _payment,
);
  List<num>? get selectedSellerIds => _selectedSellerIds;
  List<num>? get selectedCartItemIds => _selectedCartItemIds;
  num? get cartItemCount => _cartItemCount;
  List<SellerGroups>? get sellerGroups => _sellerGroups;
  List<Addresses>? get addresses => _addresses;
  SelectedAddress? get selectedAddress => _selectedAddress;
  dynamic get coupon => _coupon;
  PriceDetails? get priceDetails => _priceDetails;
  bool? get termsRequired => _termsRequired;
  Payment? get payment => _payment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['selected_seller_ids'] = _selectedSellerIds;
    map['selected_cart_item_ids'] = _selectedCartItemIds;
    map['cart_item_count'] = _cartItemCount;
    if (_sellerGroups != null) {
      map['seller_groups'] = _sellerGroups?.map((v) => v.toJson()).toList();
    }
    if (_addresses != null) {
      map['addresses'] = _addresses?.map((v) => v.toJson()).toList();
    }
    if (_selectedAddress != null) {
      map['selected_address'] = _selectedAddress?.toJson();
    }
    map['coupon'] = _coupon;
    if (_priceDetails != null) {
      map['price_details'] = _priceDetails?.toJson();
    }
    map['terms_required'] = _termsRequired;
    if (_payment != null) {
      map['payment'] = _payment?.toJson();
    }
    return map;
  }

}

/// provider : "stripe"
/// next_action : "create_checkout_session"

class Payment {
  Payment({
      String? provider, 
      String? nextAction,}){
    _provider = provider;
    _nextAction = nextAction;
}

  Payment.fromJson(dynamic json) {
    _provider = json['provider'];
    _nextAction = json['next_action'];
  }
  String? _provider;
  String? _nextAction;
Payment copyWith({  String? provider,
  String? nextAction,
}) => Payment(  provider: provider ?? _provider,
  nextAction: nextAction ?? _nextAction,
);
  String? get provider => _provider;
  String? get nextAction => _nextAction;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['provider'] = _provider;
    map['next_action'] = _nextAction;
    return map;
  }

}

/// subtotal : 468
/// shipping_fee : 4.99
/// discount : 0
/// total : 472.99

class PriceDetails {
  PriceDetails({
      num? subtotal, 
      num? shippingFee, 
      num? discount, 
      num? total,}){
    _subtotal = subtotal;
    _shippingFee = shippingFee;
    _discount = discount;
    _total = total;
}

  PriceDetails.fromJson(dynamic json) {
    _subtotal = json['subtotal'];
    _shippingFee = json['shipping_fee'];
    _discount = json['discount'];
    _total = json['total'];
  }
  num? _subtotal;
  num? _shippingFee;
  num? _discount;
  num? _total;
PriceDetails copyWith({  num? subtotal,
  num? shippingFee,
  num? discount,
  num? total,
}) => PriceDetails(  subtotal: subtotal ?? _subtotal,
  shippingFee: shippingFee ?? _shippingFee,
  discount: discount ?? _discount,
  total: total ?? _total,
);
  num? get subtotal => _subtotal;
  num? get shippingFee => _shippingFee;
  num? get discount => _discount;
  num? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['subtotal'] = _subtotal;
    map['shipping_fee'] = _shippingFee;
    map['discount'] = _discount;
    map['total'] = _total;
    return map;
  }

}

/// id : 1
/// userId : 5
/// address_name : "Store"
/// address : "25 Ivan Vazov Street"
/// city : "Plovdiv"
/// postal_code : "4000"
/// country : "Bulgaria"
/// is_default : true
/// createdAt : "2026-07-23T04:44:06.100Z"
/// updatedAt : "2026-07-23T04:44:06.100Z"

class SelectedAddress {
  SelectedAddress({
      num? id, 
      num? userId, 
      String? addressName, 
      String? address, 
      String? city, 
      String? postalCode, 
      String? country, 
      bool? isDefault, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _userId = userId;
    _addressName = addressName;
    _address = address;
    _city = city;
    _postalCode = postalCode;
    _country = country;
    _isDefault = isDefault;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  SelectedAddress.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _addressName = json['address_name'];
    _address = json['address'];
    _city = json['city'];
    _postalCode = json['postal_code'];
    _country = json['country'];
    _isDefault = json['is_default'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _id;
  num? _userId;
  String? _addressName;
  String? _address;
  String? _city;
  String? _postalCode;
  String? _country;
  bool? _isDefault;
  String? _createdAt;
  String? _updatedAt;
SelectedAddress copyWith({  num? id,
  num? userId,
  String? addressName,
  String? address,
  String? city,
  String? postalCode,
  String? country,
  bool? isDefault,
  String? createdAt,
  String? updatedAt,
}) => SelectedAddress(  id: id ?? _id,
  userId: userId ?? _userId,
  addressName: addressName ?? _addressName,
  address: address ?? _address,
  city: city ?? _city,
  postalCode: postalCode ?? _postalCode,
  country: country ?? _country,
  isDefault: isDefault ?? _isDefault,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get userId => _userId;
  String? get addressName => _addressName;
  String? get address => _address;
  String? get city => _city;
  String? get postalCode => _postalCode;
  String? get country => _country;
  bool? get isDefault => _isDefault;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['address_name'] = _addressName;
    map['address'] = _address;
    map['city'] = _city;
    map['postal_code'] = _postalCode;
    map['country'] = _country;
    map['is_default'] = _isDefault;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}

/// id : 1
/// userId : 5
/// address_name : "Store"
/// address : "25 Ivan Vazov Street"
/// city : "Plovdiv"
/// postal_code : "4000"
/// country : "Bulgaria"
/// is_default : true
/// createdAt : "2026-07-23T04:44:06.100Z"
/// updatedAt : "2026-07-23T04:44:06.100Z"

class Addresses {
  Addresses({
      num? id, 
      num? userId, 
      String? addressName, 
      String? address, 
      String? city, 
      String? postalCode, 
      String? country, 
      bool? isDefault, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _userId = userId;
    _addressName = addressName;
    _address = address;
    _city = city;
    _postalCode = postalCode;
    _country = country;
    _isDefault = isDefault;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Addresses.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _addressName = json['address_name'];
    _address = json['address'];
    _city = json['city'];
    _postalCode = json['postal_code'];
    _country = json['country'];
    _isDefault = json['is_default'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _id;
  num? _userId;
  String? _addressName;
  String? _address;
  String? _city;
  String? _postalCode;
  String? _country;
  bool? _isDefault;
  String? _createdAt;
  String? _updatedAt;
Addresses copyWith({  num? id,
  num? userId,
  String? addressName,
  String? address,
  String? city,
  String? postalCode,
  String? country,
  bool? isDefault,
  String? createdAt,
  String? updatedAt,
}) => Addresses(  id: id ?? _id,
  userId: userId ?? _userId,
  addressName: addressName ?? _addressName,
  address: address ?? _address,
  city: city ?? _city,
  postalCode: postalCode ?? _postalCode,
  country: country ?? _country,
  isDefault: isDefault ?? _isDefault,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get userId => _userId;
  String? get addressName => _addressName;
  String? get address => _address;
  String? get city => _city;
  String? get postalCode => _postalCode;
  String? get country => _country;
  bool? get isDefault => _isDefault;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['address_name'] = _addressName;
    map['address'] = _address;
    map['city'] = _city;
    map['postal_code'] = _postalCode;
    map['country'] = _country;
    map['is_default'] = _isDefault;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}

/// seller : {"id":5,"email":"basic.seller@bestkid.test","name":"Emily Carter","avatar_url":"https://i.pravatar.cc/150?u=basic.seller%40bestkid.test","country":"Bulgaria"}
/// delivery : {"type":"domestic","partner":"Bulgarian Post","cost":4.99,"days_min":2,"days_max":4}
/// items : [{"id":22,"productId":4,"variantId":7,"quantity":12,"price":39,"line_total":468,"product":{"id":4,"name":"Emily Carter Kids Item 4","image_urls":["/uploads/shoes.jpg"],"image_url":"/uploads/shoes.jpg","categoryId":1,"subCategoryId":1},"variant":{"id":7,"variantName":"Small","price":39}}]
/// subtotal : 468
/// delivery_cost : 4.99
/// discount_amount : 0
/// total : 472.99

class SellerGroups {
  SellerGroups({
      Seller? seller, 
      Delivery? delivery, 
      List<Items>? items, 
      num? subtotal, 
      num? deliveryCost, 
      num? discountAmount, 
      num? total,}){
    _seller = seller;
    _delivery = delivery;
    _items = items;
    _subtotal = subtotal;
    _deliveryCost = deliveryCost;
    _discountAmount = discountAmount;
    _total = total;
}

  SellerGroups.fromJson(dynamic json) {
    _seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
    _delivery = json['delivery'] != null ? Delivery.fromJson(json['delivery']) : null;
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
    _subtotal = json['subtotal'];
    _deliveryCost = json['delivery_cost'];
    _discountAmount = json['discount_amount'];
    _total = json['total'];
  }
  Seller? _seller;
  Delivery? _delivery;
  List<Items>? _items;
  num? _subtotal;
  num? _deliveryCost;
  num? _discountAmount;
  num? _total;
SellerGroups copyWith({  Seller? seller,
  Delivery? delivery,
  List<Items>? items,
  num? subtotal,
  num? deliveryCost,
  num? discountAmount,
  num? total,
}) => SellerGroups(  seller: seller ?? _seller,
  delivery: delivery ?? _delivery,
  items: items ?? _items,
  subtotal: subtotal ?? _subtotal,
  deliveryCost: deliveryCost ?? _deliveryCost,
  discountAmount: discountAmount ?? _discountAmount,
  total: total ?? _total,
);
  Seller? get seller => _seller;
  Delivery? get delivery => _delivery;
  List<Items>? get items => _items;
  num? get subtotal => _subtotal;
  num? get deliveryCost => _deliveryCost;
  num? get discountAmount => _discountAmount;
  num? get total => _total;

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
    map['discount_amount'] = _discountAmount;
    map['total'] = _total;
    return map;
  }

}

/// id : 22
/// productId : 4
/// variantId : 7
/// quantity : 12
/// price : 39
/// line_total : 468
/// product : {"id":4,"name":"Emily Carter Kids Item 4","image_urls":["/uploads/shoes.jpg"],"image_url":"/uploads/shoes.jpg","categoryId":1,"subCategoryId":1}
/// variant : {"id":7,"variantName":"Small","price":39}

class Items {
  Items({
      num? id, 
      num? productId, 
      num? variantId, 
      num? quantity, 
      num? price, 
      num? lineTotal, 
      Product? product, 
      Variant? variant,}){
    _id = id;
    _productId = productId;
    _variantId = variantId;
    _quantity = quantity;
    _price = price;
    _lineTotal = lineTotal;
    _product = product;
    _variant = variant;
}

  Items.fromJson(dynamic json) {
    _id = json['id'];
    _productId = json['productId'];
    _variantId = json['variantId'];
    _quantity = json['quantity'];
    _price = json['price'];
    _lineTotal = json['line_total'];
    _product = json['product'] != null ? Product.fromJson(json['product']) : null;
    _variant = json['variant'] != null ? Variant.fromJson(json['variant']) : null;
  }
  num? _id;
  num? _productId;
  num? _variantId;
  num? _quantity;
  num? _price;
  num? _lineTotal;
  Product? _product;
  Variant? _variant;
Items copyWith({  num? id,
  num? productId,
  num? variantId,
  num? quantity,
  num? price,
  num? lineTotal,
  Product? product,
  Variant? variant,
}) => Items(  id: id ?? _id,
  productId: productId ?? _productId,
  variantId: variantId ?? _variantId,
  quantity: quantity ?? _quantity,
  price: price ?? _price,
  lineTotal: lineTotal ?? _lineTotal,
  product: product ?? _product,
  variant: variant ?? _variant,
);
  num? get id => _id;
  num? get productId => _productId;
  num? get variantId => _variantId;
  num? get quantity => _quantity;
  num? get price => _price;
  num? get lineTotal => _lineTotal;
  Product? get product => _product;
  Variant? get variant => _variant;

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
    if (_variant != null) {
      map['variant'] = _variant?.toJson();
    }
    return map;
  }

}

/// id : 7
/// variantName : "Small"
/// price : 39

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

/// id : 4
/// name : "Emily Carter Kids Item 4"
/// image_urls : ["/uploads/shoes.jpg"]
/// image_url : "/uploads/shoes.jpg"
/// categoryId : 1
/// subCategoryId : 1

class Product {
  Product({
      num? id, 
      String? name, 
      List<String>? imageUrls, 
      String? imageUrl, 
      num? categoryId, 
      num? subCategoryId,}){
    _id = id;
    _name = name;
    _imageUrls = imageUrls;
    _imageUrl = imageUrl;
    _categoryId = categoryId;
    _subCategoryId = subCategoryId;
}

  Product.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _imageUrls = json['image_urls'] != null ? json['image_urls'].cast<String>() : [];
    _imageUrl = json['image_url'];
    _categoryId = json['categoryId'];
    _subCategoryId = json['subCategoryId'];
  }
  num? _id;
  String? _name;
  List<String>? _imageUrls;
  String? _imageUrl;
  num? _categoryId;
  num? _subCategoryId;
Product copyWith({  num? id,
  String? name,
  List<String>? imageUrls,
  String? imageUrl,
  num? categoryId,
  num? subCategoryId,
}) => Product(  id: id ?? _id,
  name: name ?? _name,
  imageUrls: imageUrls ?? _imageUrls,
  imageUrl: imageUrl ?? _imageUrl,
  categoryId: categoryId ?? _categoryId,
  subCategoryId: subCategoryId ?? _subCategoryId,
);
  num? get id => _id;
  String? get name => _name;
  List<String>? get imageUrls => _imageUrls;
  String? get imageUrl => _imageUrl;
  num? get categoryId => _categoryId;
  num? get subCategoryId => _subCategoryId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['image_urls'] = _imageUrls;
    map['image_url'] = _imageUrl;
    map['categoryId'] = _categoryId;
    map['subCategoryId'] = _subCategoryId;
    return map;
  }

}

/// type : "domestic"
/// partner : "Bulgarian Post"
/// cost : 4.99
/// days_min : 2
/// days_max : 4

class Delivery {
  Delivery({
      String? type, 
      String? partner, 
      num? cost, 
      num? daysMin, 
      num? daysMax,}){
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
Delivery copyWith({  String? type,
  String? partner,
  num? cost,
  num? daysMin,
  num? daysMax,
}) => Delivery(  type: type ?? _type,
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

/// id : 5
/// email : "basic.seller@bestkid.test"
/// name : "Emily Carter"
/// avatar_url : "https://i.pravatar.cc/150?u=basic.seller%40bestkid.test"
/// country : "Bulgaria"

class Seller {
  Seller({
      num? id, 
      String? email, 
      String? name, 
      String? avatarUrl, 
      String? country,}){
    _id = id;
    _email = email;
    _name = name;
    _avatarUrl = avatarUrl;
    _country = country;
}

  Seller.fromJson(dynamic json) {
    _id = json['id'];
    _email = json['email'];
    _name = json['name'];
    _avatarUrl = json['avatar_url'];
    _country = json['country'];
  }
  num? _id;
  String? _email;
  String? _name;
  String? _avatarUrl;
  String? _country;
Seller copyWith({  num? id,
  String? email,
  String? name,
  String? avatarUrl,
  String? country,
}) => Seller(  id: id ?? _id,
  email: email ?? _email,
  name: name ?? _name,
  avatarUrl: avatarUrl ?? _avatarUrl,
  country: country ?? _country,
);
  num? get id => _id;
  String? get email => _email;
  String? get name => _name;
  String? get avatarUrl => _avatarUrl;
  String? get country => _country;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['email'] = _email;
    map['name'] = _name;
    map['avatar_url'] = _avatarUrl;
    map['country'] = _country;
    return map;
  }

}