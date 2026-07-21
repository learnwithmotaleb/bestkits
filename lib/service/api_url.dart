// lib/core/network/api_url.dart

class ApiUrl {
  ApiUrl._();

  //══════════════════════════════════════════════════════════
  // DOMAIN
  //══════════════════════════════════════════════════════════

  /// Change only this domain when switching servers.
  // static const String _mainDomain = "https://helena-sedimentological-emily.ngrok-free.dev";
  static const String _mainDomain = "https://hqwwvtcz-5050.inc1.devtunnels.ms";

  static const String baseUrl = _mainDomain;

  /// Builds a full image URL from a relative path.
  ///
  /// Examples:
  /// \uploads\shoes.jpg
  /// \\uploads\\shoes.jpg
  /// uploads/shoes.jpg
  /// /uploads/shoes.jpg
  ///
  /// =>
  /// https://helena-sedimentological-emily.ngrok-free.dev/uploads/shoes.jpg
  static String buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.trim().isEmpty) {
      return '';
    }

    // Already a complete URL
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // Convert Windows path separators to URL separators
    String path = imagePath.replaceAll('\\', '/');

    // Remove duplicate slashes
    path = path.replaceAll(RegExp(r'/+'), '/');

    // Remove leading slash
    if (path.startsWith('/')) {
      path = path.substring(1);
    }

    return '$_mainDomain/$path';
  }

  //══════════════════════════════════════════════════════════
  // AUTH
  //══════════════════════════════════════════════════════════

  static const String register = '$baseUrl/auth/register';
  static const String verifyEmail = '$baseUrl/auth/verify-email';
  static const String resendOtp = '$baseUrl/auth/resend-otp';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String verifyResetOtp = '$baseUrl/auth/verify-reset-otp';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String login = '$baseUrl/auth/login';
  static const String getMe = '$baseUrl/auth/me';

  //══════════════════════════════════════════════════════════
  // PROFILE
  //══════════════════════════════════════════════════════════

  static const String getProfile = '$baseUrl/profile';
  static const String updateProfile = '$baseUrl/profile';
  static const String changePassword = '$baseUrl/profile/update-password';

  //══════════════════════════════════════════════════════════
  // UPLOADS
  //══════════════════════════════════════════════════════════

  static const String upload = '$baseUrl/uploads';

  //══════════════════════════════════════════════════════════
  // CATEGORIES
  //══════════════════════════════════════════════════════════

  static const String getCategories = '$baseUrl/categories';
  static String detailsCategory(String id) => '$baseUrl/categories/$id';

  //══════════════════════════════════════════════════════════
  // PRODUCTS
  //══════════════════════════════════════════════════════════

  static const String createProduct = '$baseUrl/products';
  static const String getProducts = '$baseUrl/products';

  static String detailsProduct(String id) => '$baseUrl/products/$id';

  static String updateProduct(String id) => '$baseUrl/products/$id';

  static String deleteProduct(String id) => '$baseUrl/products/$id';

  ///===================Stripe===================
  static const String stripeCallBack = '$baseUrl/stripe/callback'; //get method
  static const String stripeStatus = '$baseUrl/stripe/status'; // get Method
  static const String stripeOnboard = '$baseUrl/stripe/onboard'; //post method
  static const String stripeCheckOutSession =
      '$baseUrl/stripe/checkout-session'; //post method
  static const String stripeWebHook = '$baseUrl/stripe/webhook'; //post method

//=================Delivery Options========================
  static const String deliveryMeInternation =
      '$baseUrl/delivery/me/international'; //put method
  static const String deliveryMeDomestic =
      '$baseUrl/delivery/me/domestic'; //put method
  static const String deliveryGetAll = '$baseUrl/delivery/me'; //get method

//==================Home=====================
  static const String home = '$baseUrl/home'; //get method
  static const String recentlyViewed =
      '$baseUrl/home/recently-viewed'; //get method

  static const String getAccountAddress =
      '$baseUrl/account/addresses'; //get method
  static const String createAccountAddress =
      '$baseUrl/account/addresses'; //post method
  static String updateAccountAddress(String id) =>
      '$baseUrl/account/addresses/$id'; //patch method
  static String deleteAccountAddress(String id) =>
      '$baseUrl/account/addresses/$id'; //delete method

  static String currency =
      '$baseUrl/account/preferences/currency'; //patch method
  static String language =
      '$baseUrl/account/preferences/language'; //patch method
  static String connectStripeAccountConnect =
      '$baseUrl/account/connected-account'; //get method
  static String accountSetting = '$baseUrl/account/settings'; //get method
  static String deleteAccount = '$baseUrl/account'; //delete method

//=================whitelist==================
  static String getWishlist = '$baseUrl/wishlist'; //get method
  static String saveWishlist(String productID) =>
      '$baseUrl/wishlist/$productID'; //Post method
  static String removeWishlist(String productID) =>
      '$baseUrl/wishlist/$productID'; //Delete method
  static String getWishlistCount = '$baseUrl/wishlist/count'; //get method

  static String legalCompanyInformation =
      '$baseUrl/content/company'; //get method
  static String helpAndSupport = '$baseUrl/content/contact'; //post method
  static String fag = '$baseUrl/content/faq'; //get method

  static String legal(String type) =>
      '$baseUrl/content/legal/$type'; //get method

static String sellerEarning = '$baseUrl/seller/earnings'; //get method
}
