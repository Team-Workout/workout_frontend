import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notification_service.dart';

final fcmServiceProvider = Provider<FCMService>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  return FCMService(notificationService);
});

class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final NotificationService _notificationService;
  String? _token;

  FCMService(this._notificationService);

  String? get token => _token;

  Future<void> initialize() async {
    try {
      await _requestPermission();
      await _getToken();
      _setupTokenRefreshListener();
      _setupMessageHandlers();
    } catch (e) {
      debugPrint('FCM initialization error: $e');
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> _getToken() async {
    try {
      _token = await _messaging.getToken();
      debugPrint('FCM Token: $_token');
    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
    }
  }

  void _setupTokenRefreshListener() {
    _messaging.onTokenRefresh.listen((newToken) {
      _token = newToken;
      debugPrint('FCM Token refreshed: $newToken');
      // 토큰이 갱신되면 백엔드에 새 토큰을 전송해야 함
      _updateTokenOnBackend(newToken);
    });
  }

  void _setupMessageHandlers() {
    // 앱이 foreground에 있을 때 메시지 처리
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
        debugPrint('Title: ${message.notification!.title}');
        debugPrint('Body: ${message.notification!.body}');
        
        // Foreground에서 SnackBar로 알림 표시
        _notificationService.showForegroundNotification(
          title: message.notification!.title ?? '새 알림',
          body: message.notification!.body ?? '',
        );
      }
    });

    // 앱이 background에서 메시지를 탭했을 때 처리
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      // 메시지를 탭했을 때의 동작을 여기에 구현
    });
  }

  Future<void> _updateTokenOnBackend(String token) async {
    // FCM API 서비스를 통해 토큰을 백엔드로 전송
    // 이 부분은 FCM API 서비스가 생성된 후 구현됩니다
  }

  Future<String?> getTokenForBackend() async {
    if (_token == null) {
      await _getToken();
    }
    return _token;
  }
}