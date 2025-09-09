import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _autoLoginKey = 'auto_login_enabled';
  static const String _userEmailKey = 'user_email';
  static const String _userPasswordKey = 'user_password';
  static const String _authTokenKey = 'auth_token';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Auto Login Settings
  static Future<bool> setAutoLoginEnabled(bool enabled) async {
    await init();
    return await _prefs!.setBool(_autoLoginKey, enabled);
  }

  static Future<bool> getAutoLoginEnabled() async {
    await init();
    return _prefs!.getBool(_autoLoginKey) ?? false;
  }

  // User Credentials (for auto login)
  static Future<bool> saveUserCredentials(String email, String password) async {
    await init();
    final emailSaved = await _prefs!.setString(_userEmailKey, email);
    final passwordSaved = await _prefs!.setString(_userPasswordKey, password);
    return emailSaved && passwordSaved;
  }

  static Future<Map<String, String?>> getUserCredentials() async {
    await init();
    return {
      'email': _prefs!.getString(_userEmailKey),
      'password': _prefs!.getString(_userPasswordKey),
    };
  }

  // Auth Token
  static Future<bool> saveAuthToken(String token) async {
    await init();
    return await _prefs!.setString(_authTokenKey, token);
  }

  static Future<String?> getAuthToken() async {
    await init();
    return _prefs!.getString(_authTokenKey);
  }

  // Clear all stored data
  static Future<bool> clearAllData() async {
    await init();
    return await _prefs!.clear();
  }

  // Clear auto login data only
  static Future<bool> clearAutoLoginData() async {
    await init();
    final results = await Future.wait([
      _prefs!.remove(_autoLoginKey),
      _prefs!.remove(_userEmailKey),
      _prefs!.remove(_userPasswordKey),
    ]);
    return results.every((result) => result);
  }
}