// lib/core/network/api_url.dart

class ApiUrl {
  ApiUrl._();

  // ── Domain ───────────────────────────────────────────────
  // 🔧 Switch domain here only — everything else updates automatically
  static const String _mainDomain =
      "https://helena-sedimentological-emily.ngrok-free.dev";
  static final String baseUrl = _mainDomain;

  static String buildImageUrl(String? relativePath) {
    if (relativePath == null || relativePath.isEmpty) return '';
    final path = relativePath.replaceAll(r'\', '/');
    if (path.startsWith('http')) return path; // Already a full URL
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$_mainDomain/$cleanPath';
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
  static final String uploadA = '$baseUrl/uploads';
  static final String getCategories = '$baseUrl/categories';

}
