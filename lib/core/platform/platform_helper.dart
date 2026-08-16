import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformHelper {
  // ============================================================
  // ANDROID
  // ============================================================

  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  // ============================================================
  // IOS
  // ============================================================

  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  // ============================================================
  // MOBILE
  // ============================================================

  static bool get isMobile => isAndroid || isIOS;

  // ============================================================
  // WEB
  // ============================================================

  static bool get isWeb => kIsWeb;

  // ============================================================
  // DESKTOP
  // ============================================================

  static bool get isDesktop =>
      !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.macOS ||
              defaultTargetPlatform == TargetPlatform.windows ||
              defaultTargetPlatform == TargetPlatform.linux);

  // ============================================================
  // PLATFORM NAME
  // ============================================================

  /// Returns the platform name for API requests.
  ///
  /// Android -> android
  /// iOS     -> ios
  /// Web     -> web
  /// macOS   -> macos
  /// Windows -> windows
  /// Linux   -> linux
  static String get platform {
    if (isAndroid) {
      return 'android';
    }

    if (isIOS) {
      return 'ios';
    }

    if (isWeb) {
      return 'web';
    }

    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return 'macos';
    }

    if (defaultTargetPlatform == TargetPlatform.windows) {
      return 'windows';
    }

    if (defaultTargetPlatform == TargetPlatform.linux) {
      return 'linux';
    }

    return 'unknown';
  }

  // ============================================================
  // MOBILE PLATFORM
  // ============================================================

  /// Returns only Android/iOS.
  ///
  /// Android -> android
  /// iOS     -> ios
  /// Others  -> null
  static String? get mobilePlatform {
    if (isAndroid) {
      return 'android';
    }

    if (isIOS) {
      return 'ios';
    }

    return null;
  }

  // ============================================================
  // TABLET
  // ============================================================

  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;

    return shortestSide >= 600 && !isDesktop;
  }
}