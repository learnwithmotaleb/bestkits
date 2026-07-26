// Model for GET /products/:id
// Response: { success, statusCode, message, data: { ...product } }

class ProductDetailsModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final ProductData? data;

  ProductDetailsModel({this.success, this.statusCode, this.message, this.data});

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? ProductData.fromJson(json['data']) : null,
    );
  }
}

class ProductData {
  final int? id;
  final String? name;
  final String? description;
  final num? originalPrice;
  final num? discountedPrice;
  final num? discountPercentage;
  final num? effectivePrice;
  final List<String>? imageUrls;
  final int? categoryId;
  final int? subCategoryId;
  final int? userId;
  final String? condition;
  final String? status;
  final int? views;
  final int? totalReviews;
  final num? averageRating;
  final bool? isAuthenticated;
  final String? authenticationStatus;
  final bool? isWishlisted;
  final String? approvedAt;
  final String? rejectedAt;
  final String? createdAt;
  final String? updatedAt;
  final ProductCategory? category;
  final ProductSubCategory? subCategory;
  final ProductUser? user;
  final List<ProductVariant>? variants;
  final List<ProductReview>? reviews;
  final SellerOverview? sellerOverview;
  final List<ProductData>? relatedProducts;

  ProductData({
    this.id, this.name, this.description, this.originalPrice,
    this.discountedPrice, this.discountPercentage, this.effectivePrice,
    this.imageUrls, this.categoryId, this.subCategoryId, this.userId,
    this.condition, this.status, this.views, this.totalReviews,
    this.averageRating, this.isAuthenticated, this.authenticationStatus,
    this.isWishlisted, this.approvedAt, this.rejectedAt,
    this.createdAt, this.updatedAt, this.category, this.subCategory,
    this.user, this.variants, this.reviews, this.sellerOverview, this.relatedProducts,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      originalPrice: json['original_price'],
      discountedPrice: json['discounted_price'],
      discountPercentage: json['discount_percentage'],
      effectivePrice: json['effective_price'],
      imageUrls: json['image_urls'] != null ? List<String>.from(json['image_urls']) : [],
      categoryId: json['categoryId'],
      subCategoryId: json['subCategoryId'],
      userId: json['userId'],
      condition: json['condition'],
      status: json['status'],
      views: json['views'],
      totalReviews: json['total_reviews'],
      averageRating: json['average_rating'],
      isAuthenticated: json['is_authenticated'],
      authenticationStatus: json['authentication_status'],
      isWishlisted: json['is_wishlisted'],
      approvedAt: json['approved_at'],
      rejectedAt: json['rejected_at'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      category: json['category'] != null ? ProductCategory.fromJson(json['category']) : null,
      subCategory: json['subCategory'] != null ? ProductSubCategory.fromJson(json['subCategory']) : null,
      user: json['user'] != null ? ProductUser.fromJson(json['user']) : null,
      variants: json['variants'] != null
          ? List<ProductVariant>.from(json['variants'].map((v) => ProductVariant.fromJson(v)))
          : [],
      reviews: json['reviews'] != null
          ? List<ProductReview>.from(json['reviews'].map((r) => ProductReview.fromJson(r)))
          : [],
      sellerOverview: json['seller_overview'] != null ? SellerOverview.fromJson(json['seller_overview']) : null,
      relatedProducts: json['related_products'] != null
          ? List<ProductData>.from(json['related_products'].map((p) => ProductData.fromJson(p)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'description': description,
    'original_price': originalPrice, 'discounted_price': discountedPrice,
    'discount_percentage': discountPercentage, 'effective_price': effectivePrice,
    'image_urls': imageUrls, 'categoryId': categoryId, 'subCategoryId': subCategoryId,
    'userId': userId, 'condition': condition, 'status': status, 'views': views,
    'total_reviews': totalReviews, 'average_rating': averageRating,
    'is_authenticated': isAuthenticated, 'authentication_status': authenticationStatus,
    'is_wishlisted': isWishlisted, 'approved_at': approvedAt, 'rejected_at': rejectedAt,
    'createdAt': createdAt, 'updatedAt': updatedAt,
    'category': category?.toJson(), 'subCategory': subCategory?.toJson(),
    'user': user?.toJson(),
    'variants': variants?.map((v) => v.toJson()).toList(),
    'reviews': reviews?.map((r) => r.toJson()).toList(),
    'seller_overview': sellerOverview?.toJson(),
    'related_products': relatedProducts?.map((p) => p.toJson()).toList(),
  };
}

class ProductCategory {
  final int? id;
  final String? name;
  final String? description;
  final String? imageUrl;
  final String? createdAt;
  final String? updatedAt;

  ProductCategory({this.id, this.name, this.description, this.imageUrl, this.createdAt, this.updatedAt});

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
    id: json['id'], name: json['name'], description: json['description'],
    imageUrl: json['image_url'], createdAt: json['createdAt'], updatedAt: json['updatedAt'],
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'description': description,
    'image_url': imageUrl, 'createdAt': createdAt, 'updatedAt': updatedAt,
  };
}

class ProductSubCategory {
  final int? id;
  final String? name;
  final String? description;
  final int? categoryId;
  final String? createdAt;
  final String? updatedAt;

  ProductSubCategory({this.id, this.name, this.description, this.categoryId, this.createdAt, this.updatedAt});

  factory ProductSubCategory.fromJson(Map<String, dynamic> json) => ProductSubCategory(
    id: json['id'], name: json['name'], description: json['description'],
    categoryId: json['categoryId'], createdAt: json['createdAt'], updatedAt: json['updatedAt'],
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'description': description,
    'categoryId': categoryId, 'createdAt': createdAt, 'updatedAt': updatedAt,
  };
}

class ProductVariant {
  final int? id;
  final int? productId;
  final String? variantName;
  final num? price;
  final String? createdAt;
  final String? updatedAt;

  ProductVariant({this.id, this.productId, this.variantName, this.price, this.createdAt, this.updatedAt});

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
    id: json['id'], productId: json['productId'], variantName: json['variantName'],
    price: json['price'], createdAt: json['createdAt'], updatedAt: json['updatedAt'],
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'productId': productId, 'variantName': variantName,
    'price': price, 'createdAt': createdAt, 'updatedAt': updatedAt,
  };
}

class ProductReview {
  final int? id;
  final int? productId;
  final int? userId;
  final int? orderItemId;
  final num? rating;
  final String? review;
  final String? createdAt;
  final String? updatedAt;
  final ReviewUser? user;

  ProductReview({this.id, this.productId, this.userId, this.orderItemId,
    this.rating, this.review, this.createdAt, this.updatedAt, this.user});

  factory ProductReview.fromJson(Map<String, dynamic> json) => ProductReview(
    id: json['id'], productId: json['productId'], userId: json['userId'],
    orderItemId: json['orderItemId'], rating: json['rating'], review: json['review'],
    createdAt: json['createdAt'], updatedAt: json['updatedAt'],
    user: json['user'] != null ? ReviewUser.fromJson(json['user']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'productId': productId, 'userId': userId, 'orderItemId': orderItemId,
    'rating': rating, 'review': review, 'createdAt': createdAt, 'updatedAt': updatedAt,
    'user': user?.toJson(),
  };
}

class ReviewUser {
  final int? id;
  final ReviewProfile? profile;

  ReviewUser({this.id, this.profile});

  factory ReviewUser.fromJson(Map<String, dynamic> json) => ReviewUser(
    id: json['id'],
    profile: json['profile'] != null ? ReviewProfile.fromJson(json['profile']) : null,
  );

  Map<String, dynamic> toJson() => {'id': id, 'profile': profile?.toJson()};
}

class ReviewProfile {
  final String? fullName;
  final String? avatarUrl;

  ReviewProfile({this.fullName, this.avatarUrl});

  factory ReviewProfile.fromJson(Map<String, dynamic> json) => ReviewProfile(
    fullName: json['full_name'], avatarUrl: json['avatar_url'],
  );

  Map<String, dynamic> toJson() => {'full_name': fullName, 'avatar_url': avatarUrl};
}

class ProductUser {
  final int? id;
  final String? email;
  final String? sellerTier;
  final bool? stripeOnboardingComplete;
  final UserProfile? profile;
  final DeliveryOption? deliveryOption;

  ProductUser({this.id, this.email, this.sellerTier, this.stripeOnboardingComplete, this.profile, this.deliveryOption});

  factory ProductUser.fromJson(Map<String, dynamic> json) => ProductUser(
    id: json['id'], email: json['email'], sellerTier: json['seller_tier'],
    stripeOnboardingComplete: json['stripe_onboarding_complete'],
    profile: json['profile'] != null ? UserProfile.fromJson(json['profile']) : null,
    deliveryOption: json['delivery_option'] != null ? DeliveryOption.fromJson(json['delivery_option']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'email': email, 'seller_tier': sellerTier,
    'stripe_onboarding_complete': stripeOnboardingComplete,
    'profile': profile?.toJson(), 'delivery_option': deliveryOption?.toJson(),
  };
}

class UserProfile {
  final String? fullName;
  final String? avatarUrl;
  final String? country;

  UserProfile({this.fullName, this.avatarUrl, this.country});

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    fullName: json['full_name'], avatarUrl: json['avatar_url'], country: json['country'],
  );

  Map<String, dynamic> toJson() => {
    'full_name': fullName, 'avatar_url': avatarUrl, 'country': country,
  };
}

class DeliveryOption {
  final int? id;
  final int? sellerId;
  final String? domesticPartner;
  final num? domesticCost;
  final int? domesticDaysMin;
  final int? domesticDaysMax;
  final String? internationalPartner;
  final num? internationalCost;
  final int? internationalDaysMin;
  final int? internationalDaysMax;
  final String? createdAt;
  final String? updatedAt;

  DeliveryOption({
    this.id, this.sellerId, this.domesticPartner, this.domesticCost,
    this.domesticDaysMin, this.domesticDaysMax, this.internationalPartner,
    this.internationalCost, this.internationalDaysMin, this.internationalDaysMax,
    this.createdAt, this.updatedAt,
  });

  factory DeliveryOption.fromJson(Map<String, dynamic> json) => DeliveryOption(
    id: json['id'], sellerId: json['sellerId'],
    domesticPartner: json['domestic_partner'], domesticCost: json['domestic_cost'],
    domesticDaysMin: json['domestic_days_min'], domesticDaysMax: json['domestic_days_max'],
    internationalPartner: json['international_partner'], internationalCost: json['international_cost'],
    internationalDaysMin: json['international_days_min'], internationalDaysMax: json['international_days_max'],
    createdAt: json['createdAt'], updatedAt: json['updatedAt'],
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'sellerId': sellerId, 'domestic_partner': domesticPartner,
    'domestic_cost': domesticCost, 'domestic_days_min': domesticDaysMin,
    'domestic_days_max': domesticDaysMax, 'international_partner': internationalPartner,
    'international_cost': internationalCost, 'international_days_min': internationalDaysMin,
    'international_days_max': internationalDaysMax,
    'createdAt': createdAt, 'updatedAt': updatedAt,
  };
}

class SellerOverview {
  final int? activeProducts;
  final int? itemsSold;
  final num? averageRating;
  final int? totalReviews;

  SellerOverview({this.activeProducts, this.itemsSold, this.averageRating, this.totalReviews});

  factory SellerOverview.fromJson(Map<String, dynamic> json) => SellerOverview(
    activeProducts: json['active_products'], itemsSold: json['items_sold'],
    averageRating: json['average_rating'], totalReviews: json['total_reviews'],
  );

  Map<String, dynamic> toJson() => {
    'active_products': activeProducts, 'items_sold': itemsSold,
    'average_rating': averageRating, 'total_reviews': totalReviews,
  };
}

// /// statusCode : 200
// /// data : [{"id":32,"name":"Modern Gold Chips","description":"Discover the punctual new Towels with an exciting mix of Plastic ingredients","original_price":184.99,"discounted_price":172.04,"discount_percentage":7,"image_urls":["https://picsum.photos/seed/18-7-0/600/600","https://picsum.photos/seed/18-7-1/600/600"],"categoryId":5,"subCategoryId":8,"userId":18,"condition":"REFURBISHED","status":"ACTIVE","views":0,"total_reviews":0,"average_rating":0,"is_authenticated":false,"authentication_status":"PENDING","createdAt":"2026-07-05T03:45:11.096Z","updatedAt":"2026-07-05T03:45:11.096Z","category":{"id":5,"name":"Books & Education","description":"Our tangy-inspired Cheese brings a taste of luxury to your busy lifestyle","image_url":"https://picsum.photos/seed/Books%20%26%20Education/400/300","createdAt":"2026-07-05T03:44:26.675Z","updatedAt":"2026-07-05T03:44:26.675Z"},"subCategory":{"id":8,"name":"Picture Books","description":"Stylish Fish designed to make you stand out with weekly looks","categoryId":5,"createdAt":"2026-07-05T03:44:26.675Z","updatedAt":"2026-07-05T03:44:26.675Z"},"variants":[]},{"id":31,"name":"Sleek Bamboo Tuna","description":"Professional-grade Sausages perfect for diligent training and recreational use","original_price":137.89,"discounted_price":null,"discount_percentage":null,"image_urls":["https://picsum.photos/seed/18-6-0/600/600"],"categoryId":7,"subCategoryId":14,"userId":18,"condition":"REFURBISHED","status":"ACTIVE","views":0,"total_reviews":0,"average_rating":0,"is_authenticated":true,"authentication_status":"VERIFIED","createdAt":"2026-07-05T03:45:11.083Z","updatedAt":"2026-07-05T03:45:11.083Z","category":{"id":7,"name":"Baby & Toddler","description":"Discover the insidious new Shoes with an exciting mix of Aluminum ingredients","image_url":"https://picsum.photos/seed/Baby%20%26%20Toddler/400/300","createdAt":"2026-07-05T03:44:26.691Z","updatedAt":"2026-07-05T03:44:26.691Z"},"subCategory":{"id":14,"name":"Feeding","description":"Savor the fresh essence in our Towels, designed for ragged culinary adventures","categoryId":7,"createdAt":"2026-07-05T03:44:26.691Z","updatedAt":"2026-07-05T03:44:26.691Z"},"variants":[{"id":33,"productId":31,"variantName":"Small","price":37.69,"createdAt":"2026-07-05T03:45:11.083Z","updatedAt":"2026-07-05T03:45:11.083Z"},{"id":34,"productId":31,"variantName":"Large","price":145.99,"createdAt":"2026-07-05T03:45:11.083Z","updatedAt":"2026-07-05T03:45:11.083Z"}]},{"id":30,"name":"Bespoke Metal Shirt","description":"Our tender-inspired Ball brings a taste of luxury to your reflecting lifestyle","original_price":61.3,"discounted_price":56.78,"discount_percentage":7.38,"image_urls":["https://picsum.photos/seed/18-5-0/600/600","https://picsum.photos/seed/18-5-1/600/600","https://picsum.photos/seed/18-5-2/600/600"],"categoryId":6,"subCategoryId":12,"userId":18,"condition":"REFURBISHED","status":"ACTIVE","views":0,"total_reviews":0,"average_rating":0,"is_authenticated":true,"authentication_status":"VERIFIED","createdAt":"2026-07-05T03:45:11.073Z","updatedAt":"2026-07-05T03:45:11.073Z","category":{"id":6,"name":"Clothing & Accessories","description":"Discover the speedy new Table with an exciting mix of Marble ingredients","image_url":"https://picsum.photos/seed/Clothing%20%26%20Accessories/400/300","createdAt":"2026-07-05T03:44:26.684Z","updatedAt":"2026-07-05T03:44:26.684Z"},"subCategory":{"id":12,"name":"Girls Clothing","description":"The Camren Chips is the latest in a series of pretty products from Stoltenberg LLC","categoryId":6,"createdAt":"2026-07-05T03:44:26.684Z","updatedAt":"2026-07-05T03:44:26.684Z"},"variants":[]},{"id":29,"name":"Oriental Bamboo Salad","description":"Experience the azure brilliance of our Ball, perfect for low environments","original_price":159.75,"discounted_price":150.96,"discount_percentage":5.5,"image_urls":["https://picsum.photos/seed/18-4-0/600/600"],"categoryId":4,"subCategoryId":5,"userId":18,"condition":"USED","status":"ACTIVE","views":0,"total_reviews":0,"average_rating":0,"is_authenticated":true,"authentication_status":"PENDING","createdAt":"2026-07-05T03:45:11.064Z","updatedAt":"2026-07-05T03:45:11.064Z","category":{"id":4,"name":"Toys & Games","description":"Discover the whale-like agility of our Soap, perfect for blushing users","image_url":"https://picsum.photos/seed/Toys%20%26%20Games/400/300","createdAt":"2026-07-05T03:44:26.607Z","updatedAt":"2026-07-05T03:44:26.607Z"},"subCategory":{"id":5,"name":"Action Figures","description":"Crist, Spinka and Hoppe's most advanced Table technology increases humiliating capabilities","categoryId":4,"createdAt":"2026-07-05T03:44:26.607Z","updatedAt":"2026-07-05T03:44:26.607Z"},"variants":[]},{"id":28,"name":"Luxurious Concrete Pizza","description":"Our moist-inspired Shoes brings a taste of luxury to your unfit lifestyle","original_price":57.65,"discounted_price":null,"discount_percentage":null,"image_urls":["https://picsum.photos/seed/18-3-0/600/600","https://picsum.photos/seed/18-3-1/600/600","https://picsum.photos/seed/18-3-2/600/600","https://picsum.photos/seed/18-3-3/600/600"],"categoryId":4,"subCategoryId":6,"userId":18,"condition":"REFURBISHED","status":"ACTIVE","views":0,"total_reviews":0,"average_rating":0,"is_authenticated":true,"authentication_status":"PENDING","createdAt":"2026-07-05T03:45:11.055Z","updatedAt":"2026-07-05T03:45:11.055Z","category":{"id":4,"name":"Toys & Games","description":"Discover the whale-like agility of our Soap, perfect for blushing users","image_url":"https://picsum.photos/seed/Toys%20%26%20Games/400/300","createdAt":"2026-07-05T03:44:26.607Z","updatedAt":"2026-07-05T03:44:26.607Z"},"subCategory":{"id":6,"name":"Board Games","description":"Discover the polar bear-like agility of our Gloves, perfect for general users","categoryId":4,"createdAt":"2026-07-05T03:44:26.607Z","updatedAt":"2026-07-05T03:44:26.607Z"},"variants":[]},{"id":27,"name":"Awesome Granite Keyboard","description":"Discover the horse-like agility of our Hat, perfect for accurate users","original_price":18.66,"discounted_price":null,"discount_percentage":null,"image_urls":["https://picsum.photos/seed/18-2-0/600/600","https://picsum.photos/seed/18-2-1/600/600"],"categoryId":7,"subCategoryId":14,"userId":18,"condition":"NEW","status":"ACTIVE","views":0,"total_reviews":0,"average_rating":0,"is_authenticated":true,"authentication_status":"NOT_VERIFIED","createdAt":"2026-07-05T03:45:11.046Z","updatedAt":"2026-07-05T03:45:11.046Z","category":{"id":7,"name":"Baby & Toddler","description":"Discover the insidious new Shoes with an exciting mix of Aluminum ingredients","image_url":"https://picsum.photos/seed/Baby%20%26%20Toddler/400/300","createdAt":"2026-07-05T03:44:26.691Z","updatedAt":"2026-07-05T03:44:26.691Z"},"subCategory":{"id":14,"name":"Feeding","description":"Savor the fresh essence in our Towels, designed for ragged culinary adventures","categoryId":7,"createdAt":"2026-07-05T03:44:26.691Z","updatedAt":"2026-07-05T03:44:26.691Z"},"variants":[]},{"id":26,"name":"Intelligent Steel Chicken","description":"Experience the olive brilliance of our Gloves, perfect for boring environments","original_price":38.69,"discounted_price":24.9,"discount_percentage":35.65,"image_urls":["https://picsum.photos/seed/18-1-0/600/600"],"categoryId":4,"subCategoryId":5,"userId":18,"condition":"USED","status":"ACTIVE","views":0,"total_reviews":0,"average_rating":0,"is_authenticated":true,"authentication_status":"NOT_VERIFIED","createdAt":"2026-07-05T03:45:11.035Z","updatedAt":"2026-07-05T03:45:11.035Z","category":{"id":4,"name":"Toys & Games","description":"Discover the whale-like agility of our Soap, perfect for blushing users","image_url":"https://picsum.photos/seed/Toys%20%26%20Games/400/300","createdAt":"2026-07-05T03:44:26.607Z","updatedAt":"2026-07-05T03:44:26.607Z"},"subCategory":{"id":5,"name":"Action Figures","description":"Crist, Spinka and Hoppe's most advanced Table technology increases humiliating capabilities","categoryId":4,"createdAt":"2026-07-05T03:44:26.607Z","updatedAt":"2026-07-05T03:44:26.607Z"},"variants":[]},{"id":25,"name":"Awesome Steel Chips","description":"New Car model with 84 GB RAM, 549 GB storage, and steel features","original_price":30.09,"discounted_price":null,"discount_percentage":null,"image_urls":["https://picsum.photos/seed/18-0-0/600/600","https://picsum.photos/seed/18-0-1/600/600"],"categoryId":4,"subCategoryId":5,"userId":18,"condition":"NEW","status":"ACTIVE","views":0,"total_reviews":0,"average_rating":0,"is_authenticated":true,"authentication_status":"VERIFIED","createdAt":"2026-07-05T03:45:11.027Z","updatedAt":"2026-07-05T03:45:11.027Z","category":{"id":4,"name":"Toys & Games","description":"Discover the whale-like agility of our Soap, perfect for blushing users","image_url":"https://picsum.photos/seed/Toys%20%26%20Games/400/300","createdAt":"2026-07-05T03:44:26.607Z","updatedAt":"2026-07-05T03:44:26.607Z"},"subCategory":{"id":5,"name":"Action Figures","description":"Crist, Spinka and Hoppe's most advanced Table technology increases humiliating capabilities","categoryId":4,"createdAt":"2026-07-05T03:44:26.607Z","updatedAt":"2026-07-05T03:44:26.607Z"},"variants":[{"id":31,"productId":25,"variantName":"Small","price":23.49,"createdAt":"2026-07-05T03:45:11.027Z","updatedAt":"2026-07-05T03:45:11.027Z"},{"id":32,"productId":25,"variantName":"Large","price":34.75,"createdAt":"2026-07-05T03:45:11.027Z","updatedAt":"2026-07-05T03:45:11.027Z"}]},{"id":24,"name":"Tasty Steel Bacon","description":"Discover the eagle-like agility of our Mouse, perfect for vivid users","original_price":182.05,"discounted_price":null,"discount_percentage":null,"image_urls":["https://picsum.photos/seed/17-7-0/600/600","https://picsum.photos/seed/17-7-1/600/600"],"categoryId":6,"subCategoryId":12,"userId":17,"condition":"USED","status":"ACTIVE","views":0,"total_reviews":0,"average_rating":0,"is_authenticated":false,"authentication_status":"PENDING","createdAt":"2026-07-05T03:45:11.005Z","updatedAt":"2026-07-05T03:45:11.005Z","category":{"id":6,"name":"Clothing & Accessories","description":"Discover the speedy new Table with an exciting mix of Marble ingredients","image_url":"https://picsum.photos/seed/Clothing%20%26%20Accessories/400/300","createdAt":"2026-07-05T03:44:26.684Z","updatedAt":"2026-07-05T03:44:26.684Z"},"subCategory":{"id":12,"name":"Girls Clothing","description":"The Camren Chips is the latest in a series of pretty products from Stoltenberg LLC","categoryId":6,"createdAt":"2026-07-05T03:44:26.684Z","updatedAt":"2026-07-05T03:44:26.684Z"},"variants":[{"id":29,"productId":24,"variantName":"Small","price":173.69,"createdAt":"2026-07-05T03:45:11.005Z","updatedAt":"2026-07-05T03:45:11.005Z"},{"id":30,"productId":24,"variantName":"Large","price":235.65,"createdAt":"2026-07-05T03:45:11.005Z","updatedAt":"2026-07-05T03:45:11.005Z"}]},{"id":23,"name":"Modern Granite Pizza","description":"Introducing the Vietnam-inspired Table, blending wavy style with local craftsmanship","original_price":183.3,"discounted_price":null,"discount_percentage":null,"image_urls":["https://picsum.photos/seed/17-6-0/600/600"],"categoryId":5,"subCategoryId":8,"userId":17,"condition":"NEW","status":"ACTIVE","views":0,"total_reviews":0,"average_rating":0,"is_authenticated":false,"authentication_status":"VERIFIED","createdAt":"2026-07-05T03:45:10.994Z","updatedAt":"2026-07-05T03:45:10.994Z","category":{"id":5,"name":"Books & Education","description":"Our tangy-inspired Cheese brings a taste of luxury to your busy lifestyle","image_url":"https://picsum.photos/seed/Books%20%26%20Education/400/300","createdAt":"2026-07-05T03:44:26.675Z","updatedAt":"2026-07-05T03:44:26.675Z"},"subCategory":{"id":8,"name":"Picture Books","description":"Stylish Fish designed to make you stand out with weekly looks","categoryId":5,"createdAt":"2026-07-05T03:44:26.675Z","updatedAt":"2026-07-05T03:44:26.675Z"},"variants":[]}]
// /// meta : {"total":32,"page":1,"limit":10,"pages":4}

// class ProductDetailsModel {
//   ProductDetailsModel({
//       bool? success, 
//       num? statusCode, 
//       List<Data>? data, 
//       Meta? meta,}){
//     _success = success;
//     _statusCode = statusCode;
//     _data = data;
//     _meta = meta;
// }

//   ProductDetailsModel.fromJson(dynamic json) {
//     _success = json['success'];
//     _statusCode = json['statusCode'];
//     if (json['data'] != null) {
//       _data = [];
//       json['data'].forEach((v) {
//         _data?.add(Data.fromJson(v));
//       });
//     }
//     _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
//   }
//   bool? _success;
//   num? _statusCode;
//   List<Data>? _data;
//   Meta? _meta;
// ProductDetailsModel copyWith({  bool? success,
//   num? statusCode,
//   List<Data>? data,
//   Meta? meta,
// }) => ProductDetailsModel(  success: success ?? _success,
//   statusCode: statusCode ?? _statusCode,
//   data: data ?? _data,
//   meta: meta ?? _meta,
// );
//   bool? get success => _success;
//   num? get statusCode => _statusCode;
//   List<Data>? get data => _data;
//   Meta? get meta => _meta;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['success'] = _success;
//     map['statusCode'] = _statusCode;
//     if (_data != null) {
//       map['data'] = _data?.map((v) => v.toJson()).toList();
//     }
//     if (_meta != null) {
//       map['meta'] = _meta?.toJson();
//     }
//     return map;
//   }

// }

// /// total : 32
// /// page : 1
// /// limit : 10
// /// pages : 4

// class Meta {
//   Meta({
//       num? total, 
//       num? page, 
//       num? limit, 
//       num? pages,}){
//     _total = total;
//     _page = page;
//     _limit = limit;
//     _pages = pages;
// }

//   Meta.fromJson(dynamic json) {
//     _total = json['total'];
//     _page = json['page'];
//     _limit = json['limit'];
//     _pages = json['pages'];
//   }
//   num? _total;
//   num? _page;
//   num? _limit;
//   num? _pages;
// Meta copyWith({  num? total,
//   num? page,
//   num? limit,
//   num? pages,
// }) => Meta(  total: total ?? _total,
//   page: page ?? _page,
//   limit: limit ?? _limit,
//   pages: pages ?? _pages,
// );
//   num? get total => _total;
//   num? get page => _page;
//   num? get limit => _limit;
//   num? get pages => _pages;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['total'] = _total;
//     map['page'] = _page;
//     map['limit'] = _limit;
//     map['pages'] = _pages;
//     return map;
//   }

// }

// /// id : 32
// /// name : "Modern Gold Chips"
// /// description : "Discover the punctual new Towels with an exciting mix of Plastic ingredients"
// /// original_price : 184.99
// /// discounted_price : 172.04
// /// discount_percentage : 7
// /// image_urls : ["https://picsum.photos/seed/18-7-0/600/600","https://picsum.photos/seed/18-7-1/600/600"]
// /// categoryId : 5
// /// subCategoryId : 8
// /// userId : 18
// /// condition : "REFURBISHED"
// /// status : "ACTIVE"
// /// views : 0
// /// total_reviews : 0
// /// average_rating : 0
// /// is_authenticated : false
// /// authentication_status : "PENDING"
// /// createdAt : "2026-07-05T03:45:11.096Z"
// /// updatedAt : "2026-07-05T03:45:11.096Z"
// /// category : {"id":5,"name":"Books & Education","description":"Our tangy-inspired Cheese brings a taste of luxury to your busy lifestyle","image_url":"https://picsum.photos/seed/Books%20%26%20Education/400/300","createdAt":"2026-07-05T03:44:26.675Z","updatedAt":"2026-07-05T03:44:26.675Z"}
// /// subCategory : {"id":8,"name":"Picture Books","description":"Stylish Fish designed to make you stand out with weekly looks","categoryId":5,"createdAt":"2026-07-05T03:44:26.675Z","updatedAt":"2026-07-05T03:44:26.675Z"}
// /// variants : []

// class Data {
//   Data({
//       num? id, 
//       String? name, 
//       String? description, 
//       num? originalPrice, 
//       num? discountedPrice, 
//       num? discountPercentage, 
//       List<String>? imageUrls, 
//       num? categoryId, 
//       num? subCategoryId, 
//       num? userId, 
//       String? condition, 
//       String? status, 
//       num? views, 
//       num? totalReviews, 
//       num? averageRating, 
//       bool? isAuthenticated, 
//       String? authenticationStatus, 
//       String? createdAt, 
//       String? updatedAt, 
//       Category? category, 
//       SubCategory? subCategory, 
//       List<dynamic>? variants,}){
//     _id = id;
//     _name = name;
//     _description = description;
//     _originalPrice = originalPrice;
//     _discountedPrice = discountedPrice;
//     _discountPercentage = discountPercentage;
//     _imageUrls = imageUrls;
//     _categoryId = categoryId;
//     _subCategoryId = subCategoryId;
//     _userId = userId;
//     _condition = condition;
//     _status = status;
//     _views = views;
//     _totalReviews = totalReviews;
//     _averageRating = averageRating;
//     _isAuthenticated = isAuthenticated;
//     _authenticationStatus = authenticationStatus;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//     _category = category;
//     _subCategory = subCategory;
//     _variants = variants;
// }

//   Data.fromJson(dynamic json) {
//     _id = json['id'];
//     _name = json['name'];
//     _description = json['description'];
//     _originalPrice = json['original_price'];
//     _discountedPrice = json['discounted_price'];
//     _discountPercentage = json['discount_percentage'];
//     _imageUrls = json['image_urls'] != null ? json['image_urls'].cast<String>() : [];
//     _categoryId = json['categoryId'];
//     _subCategoryId = json['subCategoryId'];
//     _userId = json['userId'];
//     _condition = json['condition'];
//     _status = json['status'];
//     _views = json['views'];
//     _totalReviews = json['total_reviews'];
//     _averageRating = json['average_rating'];
//     _isAuthenticated = json['is_authenticated'];
//     _authenticationStatus = json['authentication_status'];
//     _createdAt = json['createdAt'];
//     _updatedAt = json['updatedAt'];
//     _category = json['category'] != null ? Category.fromJson(json['category']) : null;
//     _subCategory = json['subCategory'] != null ? SubCategory.fromJson(json['subCategory']) : null;
//     if (json['variants'] != null) {
//       _variants = [];
//       json['variants'].forEach((v) {
//         _variants?.add(Dynamic.fromJson(v));
//       });
//     }
//   }
//   num? _id;
//   String? _name;
//   String? _description;
//   num? _originalPrice;
//   num? _discountedPrice;
//   num? _discountPercentage;
//   List<String>? _imageUrls;
//   num? _categoryId;
//   num? _subCategoryId;
//   num? _userId;
//   String? _condition;
//   String? _status;
//   num? _views;
//   num? _totalReviews;
//   num? _averageRating;
//   bool? _isAuthenticated;
//   String? _authenticationStatus;
//   String? _createdAt;
//   String? _updatedAt;
//   Category? _category;
//   SubCategory? _subCategory;
//   List<dynamic>? _variants;
// Data copyWith({  num? id,
//   String? name,
//   String? description,
//   num? originalPrice,
//   num? discountedPrice,
//   num? discountPercentage,
//   List<String>? imageUrls,
//   num? categoryId,
//   num? subCategoryId,
//   num? userId,
//   String? condition,
//   String? status,
//   num? views,
//   num? totalReviews,
//   num? averageRating,
//   bool? isAuthenticated,
//   String? authenticationStatus,
//   String? createdAt,
//   String? updatedAt,
//   Category? category,
//   SubCategory? subCategory,
//   List<dynamic>? variants,
// }) => Data(  id: id ?? _id,
//   name: name ?? _name,
//   description: description ?? _description,
//   originalPrice: originalPrice ?? _originalPrice,
//   discountedPrice: discountedPrice ?? _discountedPrice,
//   discountPercentage: discountPercentage ?? _discountPercentage,
//   imageUrls: imageUrls ?? _imageUrls,
//   categoryId: categoryId ?? _categoryId,
//   subCategoryId: subCategoryId ?? _subCategoryId,
//   userId: userId ?? _userId,
//   condition: condition ?? _condition,
//   status: status ?? _status,
//   views: views ?? _views,
//   totalReviews: totalReviews ?? _totalReviews,
//   averageRating: averageRating ?? _averageRating,
//   isAuthenticated: isAuthenticated ?? _isAuthenticated,
//   authenticationStatus: authenticationStatus ?? _authenticationStatus,
//   createdAt: createdAt ?? _createdAt,
//   updatedAt: updatedAt ?? _updatedAt,
//   category: category ?? _category,
//   subCategory: subCategory ?? _subCategory,
//   variants: variants ?? _variants,
// );
//   num? get id => _id;
//   String? get name => _name;
//   String? get description => _description;
//   num? get originalPrice => _originalPrice;
//   num? get discountedPrice => _discountedPrice;
//   num? get discountPercentage => _discountPercentage;
//   List<String>? get imageUrls => _imageUrls;
//   num? get categoryId => _categoryId;
//   num? get subCategoryId => _subCategoryId;
//   num? get userId => _userId;
//   String? get condition => _condition;
//   String? get status => _status;
//   num? get views => _views;
//   num? get totalReviews => _totalReviews;
//   num? get averageRating => _averageRating;
//   bool? get isAuthenticated => _isAuthenticated;
//   String? get authenticationStatus => _authenticationStatus;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//   Category? get category => _category;
//   SubCategory? get subCategory => _subCategory;
//   List<dynamic>? get variants => _variants;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['name'] = _name;
//     map['description'] = _description;
//     map['original_price'] = _originalPrice;
//     map['discounted_price'] = _discountedPrice;
//     map['discount_percentage'] = _discountPercentage;
//     map['image_urls'] = _imageUrls;
//     map['categoryId'] = _categoryId;
//     map['subCategoryId'] = _subCategoryId;
//     map['userId'] = _userId;
//     map['condition'] = _condition;
//     map['status'] = _status;
//     map['views'] = _views;
//     map['total_reviews'] = _totalReviews;
//     map['average_rating'] = _averageRating;
//     map['is_authenticated'] = _isAuthenticated;
//     map['authentication_status'] = _authenticationStatus;
//     map['createdAt'] = _createdAt;
//     map['updatedAt'] = _updatedAt;
//     if (_category != null) {
//       map['category'] = _category?.toJson();
//     }
//     if (_subCategory != null) {
//       map['subCategory'] = _subCategory?.toJson();
//     }
//     if (_variants != null) {
//       map['variants'] = _variants?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }

// }

// /// id : 8
// /// name : "Picture Books"
// /// description : "Stylish Fish designed to make you stand out with weekly looks"
// /// categoryId : 5
// /// createdAt : "2026-07-05T03:44:26.675Z"
// /// updatedAt : "2026-07-05T03:44:26.675Z"

// class SubCategory {
//   SubCategory({
//       num? id, 
//       String? name, 
//       String? description, 
//       num? categoryId, 
//       String? createdAt, 
//       String? updatedAt,}){
//     _id = id;
//     _name = name;
//     _description = description;
//     _categoryId = categoryId;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
// }

//   SubCategory.fromJson(dynamic json) {
//     _id = json['id'];
//     _name = json['name'];
//     _description = json['description'];
//     _categoryId = json['categoryId'];
//     _createdAt = json['createdAt'];
//     _updatedAt = json['updatedAt'];
//   }
//   num? _id;
//   String? _name;
//   String? _description;
//   num? _categoryId;
//   String? _createdAt;
//   String? _updatedAt;
// SubCategory copyWith({  num? id,
//   String? name,
//   String? description,
//   num? categoryId,
//   String? createdAt,
//   String? updatedAt,
// }) => SubCategory(  id: id ?? _id,
//   name: name ?? _name,
//   description: description ?? _description,
//   categoryId: categoryId ?? _categoryId,
//   createdAt: createdAt ?? _createdAt,
//   updatedAt: updatedAt ?? _updatedAt,
// );
//   num? get id => _id;
//   String? get name => _name;
//   String? get description => _description;
//   num? get categoryId => _categoryId;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['name'] = _name;
//     map['description'] = _description;
//     map['categoryId'] = _categoryId;
//     map['createdAt'] = _createdAt;
//     map['updatedAt'] = _updatedAt;
//     return map;
//   }

// }

// /// id : 5
// /// name : "Books & Education"
// /// description : "Our tangy-inspired Cheese brings a taste of luxury to your busy lifestyle"
// /// image_url : "https://picsum.photos/seed/Books%20%26%20Education/400/300"
// /// createdAt : "2026-07-05T03:44:26.675Z"
// /// updatedAt : "2026-07-05T03:44:26.675Z"

// class Category {
//   Category({
//       num? id, 
//       String? name, 
//       String? description, 
//       String? imageUrl, 
//       String? createdAt, 
//       String? updatedAt,}){
//     _id = id;
//     _name = name;
//     _description = description;
//     _imageUrl = imageUrl;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
// }

//   Category.fromJson(dynamic json) {
//     _id = json['id'];
//     _name = json['name'];
//     _description = json['description'];
//     _imageUrl = json['image_url'];
//     _createdAt = json['createdAt'];
//     _updatedAt = json['updatedAt'];
//   }
//   num? _id;
//   String? _name;
//   String? _description;
//   String? _imageUrl;
//   String? _createdAt;
//   String? _updatedAt;
// Category copyWith({  num? id,
//   String? name,
//   String? description,
//   String? imageUrl,
//   String? createdAt,
//   String? updatedAt,
// }) => Category(  id: id ?? _id,
//   name: name ?? _name,
//   description: description ?? _description,
//   imageUrl: imageUrl ?? _imageUrl,
//   createdAt: createdAt ?? _createdAt,
//   updatedAt: updatedAt ?? _updatedAt,
// );
//   num? get id => _id;
//   String? get name => _name;
//   String? get description => _description;
//   String? get imageUrl => _imageUrl;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['name'] = _name;
//     map['description'] = _description;
//     map['image_url'] = _imageUrl;
//     map['createdAt'] = _createdAt;
//     map['updatedAt'] = _updatedAt;
//     return map;
//   }

// }