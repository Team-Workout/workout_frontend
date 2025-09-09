import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
  @override
  void initState() {
    super.initState();
    // 앱 시작 후 자동로그인 체크, 동기화 수행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryAutoLogin();
      _performInitialSync();
      _sendFCMTokenToBackend();
    });
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
      theme: AppTheme.light,
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
