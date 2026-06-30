// lib/core/network/api_url.dart

class ApiUrl {
  ApiUrl._();

  // ── Domain ───────────────────────────────────────────────
  // 🔧 Switch domain here only — everything else updates automatically
  static const String _mainDomain =
      "https://helena-sedimentological-emily.ngrok-free.dev";
  static final String baseUrl = _mainDomain;

  /// Convert relative images path → full URL
  /// e.g. "uploads\images.png" → "https://domain.com/uploads/image.png"
  static String buildImageUrl(String relativePath) {
    final path = relativePath.replaceAll(r'\', '/');
    return '$_mainDomain/$path';
  }

  // ════════════════════════════════════════════════════════
  //  AUTH
  // ════════════════════════════════════════════════════════

  static final String register = '$baseUrl/auth/register';
  static final String verifyEmail = '$baseUrl/auth/verify-email';
  static final String resendOtp = '$baseUrl/auth/resend-otp';
  static final String forgotPassword = '$baseUrl/auth/forgot-password';
  static final String verifyResetOtp = '$baseUrl/auth/verify-reset-otp';
  static final String resetPassword = '$baseUrl/auth/reset-password';
  static final String login = '$baseUrl/auth/login';
  static final String getMe = '$baseUrl/auth/me';

  //=================================
  static final String getProfile = '$baseUrl/profile';
  static final String updateProfile = '$baseUrl/profile';
  static final String changePassword = '$baseUrl/profile/update-password';




  static final String accountActive = '$baseUrl/auth/activate-account';
  static final String accountActiveCodeResend =
      '$baseUrl/auth/activation-code-resend';

  static final String forgetPasswordOtpVerify =
      '$baseUrl/auth/forget-pass-otp-verify';

  static final String socialLogin = '$baseUrl/auth/social-login';

  static final String getUserProfile = '$baseUrl/user/user-profile';

  static final String becomeDriver = '$baseUrl/user/become-driver';
}
