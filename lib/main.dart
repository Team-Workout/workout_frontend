import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app_links/app_links.dart';
import 'package:pt_service/core/router/app_router.dart';
import 'package:pt_service/core/theme/app_theme.dart';
import 'package:pt_service/core/services/session_service.dart';
import 'package:pt_service/core/services/fcm_service.dart';
import 'package:pt_service/core/services/notification_service.dart';
import 'package:pt_service/core/services/storage_service.dart';
import 'package:pt_service/features/auth/repository/api_auth_repository.dart';
import 'package:pt_service/core/providers/auth_provider.dart';
import 'package:pt_service/features/sync/viewmodel/sync_viewmodel.dart';
import 'package:pt_service/features/fcm/service/fcm_api_service.dart';
import 'package:pt_service/features/auth/viewmodel/auth_viewmodel.dart';
import 'dart:async';

import 'firebase_options.dart';

// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Setup FCM background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // Initialize date formatting for Korean locale
  await initializeDateFormatting('ko_KR', null);

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize SessionService
  final sessionService = SessionService(sharedPreferences);
  await sessionService.init();
  
  // Initialize Notification Service
  final notificationService = NotificationService();
  
  // Initialize FCM Service
  final fcmService = FCMService(notificationService);
  await fcmService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        sessionServiceProvider.overrideWithValue(sessionService),
        notificationServiceProvider.overrideWithValue(notificationService),
        fcmServiceProvider.overrideWithValue(fcmService),
      ],
      child: const WorkoutApp(),
    ),
  );
}

class WorkoutApp extends ConsumerStatefulWidget {
  const WorkoutApp({super.key});

  @override
  ConsumerState<WorkoutApp> createState() => _WorkoutAppState();
}

class _WorkoutAppState extends ConsumerState<WorkoutApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
    // 앱 시작 후 자동로그인 체크, 동기화 수행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryAutoLogin();
      _performInitialSync();
      _sendFCMTokenToBackend();
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initDeepLinks() async {
    try {
      _appLinks = AppLinks();

      // 앱이 종료된 상태에서 deep link로 열렸을 때 처리
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }

      // 앱이 실행 중일 때 deep link 처리
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (uri) {
          _handleDeepLink(uri);
        },
        onError: (err) {
          print('Deep link error: $err');
        },
      );
    } catch (e) {
      // iOS 시뮬레이터나 플러그인이 없는 환경에서 발생하는 에러 무시
      print('Deep links initialization failed (this is normal in iOS simulator): $e');
    }
  }

  void _handleDeepLink(Uri uri) {
    print('Received deep link: $uri');

    // workoutapp://oauth/callback?sessionId=XYZ987...&isNewUser=false
    if (uri.scheme == 'workoutapp' &&
        uri.host == 'oauth' &&
        uri.path == '/callback') {

      final sessionId = uri.queryParameters['sessionId'];
      final isNewUserStr = uri.queryParameters['isNewUser'];

      if (sessionId != null && isNewUserStr != null) {
        final isNewUser = isNewUserStr.toLowerCase() == 'true';

        print('Google OAuth callback - sessionId: $sessionId, isNewUser: $isNewUser');

        // AuthViewModel의 handleGoogleCallback 호출
        ref.read(authViewModelProvider.notifier)
            .handleGoogleCallback(sessionId, isNewUser);
      } else {
        print('Invalid OAuth callback parameters');
      }
    }
  }

  Future<void> _tryAutoLogin() async {
    try {
      final authViewModel = ref.read(authViewModelProvider.notifier);
      final success = await authViewModel.tryAutoLogin();
      if (success) {
        print('Auto login successful');
      } else {
        print('Auto login not available');
      }
    } catch (e) {
      print('Auto login failed: $e');
    }
  }

  Future<void> _performInitialSync() async {
    try {
      print('Starting master data sync...');
      await ref.read(syncNotifierProvider.notifier).performSync();
      print('Master data sync completed');
    } catch (e) {
      print('Master data sync failed: $e');
    }
  }
  
  Future<void> _sendFCMTokenToBackend() async {
    try {
      // 로그인 상태를 확인
      final authState = ref.read(authStateProvider);
      if (authState.isLoggedIn) {
        // FCM 토큰을 백엔드로 전송
        await ref.read(fcmApiServiceProvider).updateFCMToken();
        print('FCM token sent to backend successfully');
      }
    } catch (e) {
      print('Failed to send FCM token to backend: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    // ScaffoldMessenger key 설정
    final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    NotificationService.setScaffoldMessengerKey(scaffoldMessengerKey);

    return MaterialApp.router(
      title: 'Workout - PT 관리 플랫폼',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light.copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Color(0x33000000), // Black with 20% opacity
          selectionHandleColor: Colors.black,
        ),
      ),
      routerConfig: router,
      scaffoldMessengerKey: scaffoldMessengerKey,
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
