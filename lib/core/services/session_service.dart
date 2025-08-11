import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class SessionService {
  final SharedPreferences _prefs;
  late final PersistCookieJar _cookieJar;
  String? _sessionId;
  String? _sessionToken;

  SessionService(this._prefs);

  Future<void> init() async {
    // Initialize persistent cookie storage
    final appDocDir = await getApplicationDocumentsDirectory();
    final cookiePath = '${appDocDir.path}/.cookies/';
    _cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(cookiePath),
    );

    // Load saved session from SharedPreferences
    _sessionId = _prefs.getString('session_id');
    _sessionToken = _prefs.getString('session_token');
  }

  PersistCookieJar get cookieJar => _cookieJar;

  // Save session from response headers or cookies
  Future<void> saveSession(Response response) async {
    // Check for session in headers
    final headers = response.headers;

    // Common session header names
    final sessionHeader = headers['x-session-id']?.first ??
        headers['session-id']?.first ??
        headers['x-auth-token']?.first ??
        headers['authorization']?.first;

    if (sessionHeader != null) {
      _sessionToken = sessionHeader;
      await _prefs.setString('session_token', sessionHeader);
    }

    // Check for session ID in cookies (handled automatically by CookieManager)
    // The cookies are automatically saved by PersistCookieJar

    // Also check response body for session info
    if (response.data is Map) {
      final data = response.data as Map;
      if (data['sessionId'] != null) {
        _sessionId = data['sessionId'].toString();
        await _prefs.setString('session_id', _sessionId!);
      }
      if (data['token'] != null) {
        _sessionToken = data['token'].toString();
        await _prefs.setString('session_token', _sessionToken!);
      }
    }
  }

  // Get session for requests
  Map<String, String> getSessionHeaders() {
    final headers = <String, String>{};

    if (_sessionToken != null) {
      headers['Authorization'] = 'Bearer $_sessionToken';
      headers['X-Session-Token'] = _sessionToken!;
    }

    if (_sessionId != null) {
      headers['X-Session-Id'] = _sessionId!;
    }

    return headers;
  }

  // Clear session on logout
  Future<void> clearSession() async {
    _sessionId = null;
    _sessionToken = null;
    await _prefs.remove('session_id');
    await _prefs.remove('session_token');
    await _cookieJar.deleteAll(); // Clear all cookies
  }

  bool get hasSession => _sessionId != null || _sessionToken != null;
  String? get sessionId => _sessionId;
  String? get sessionToken => _sessionToken;
}

final sessionServiceProvider = Provider<SessionService>((ref) {
  throw UnimplementedError('SessionService must be overridden in main.dart');
});
