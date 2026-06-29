
import 'package:hive/hive.dart';

class HiveService {
  static const String _boxName = 'appBox';

  static const String _userIdKey = 'userId';
  static const String _profileInfoKey = 'profileInfo';
  static const String _tokenKey = 'token';
  static const String _roleKey = 'role';

  // Open the Hive box
  static Future<Box> _openBox() async {
    return await Hive.openBox(_boxName);
  }

  // Set User ID
  static Future<void> setUserId(String userId) async {
    final box = await _openBox();
    await box.put(_userIdKey, userId);
  }

  // Get User ID
  static Future<String?> getUserId() async {
    final box = await _openBox();
    return box.get(_userIdKey);
  }

  // Set Profile Information
  static Future<void> setProfileInfo(Map<String, dynamic> profileInfo) async {
    final box = await _openBox();
    await box.put(_profileInfoKey, profileInfo);
  }

  // Get Profile Information
  static Future<Map<String, dynamic>?> getProfileInfo() async {
    final box = await _openBox();
    final data = box.get(_profileInfoKey);
    if (data != null) {
      return Map<String, dynamic>.from(data as Map);
    }
    return null;
  }

  // Set Token
  static Future<void> setToken(String token) async {
    final box = await _openBox();
    await box.put(_tokenKey, token);
  }

  // Get Token
  static Future<String?> getToken() async {
    final box = await _openBox();
    return box.get(_tokenKey);
  }

  // Set Role
  static Future<void> setRole(String role) async {
    final box = await _openBox();
    await box.put(_roleKey, role);
  }

  // Get Role
  static Future<String?> getRole() async {
    final box = await _openBox();
    return box.get(_roleKey);
  }

  // Clear Database
  static Future<void> clearDatabase() async {
    final box = await _openBox();
    await box.clear();
  }
}
