import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pt_service/core/router/app_router.dart';
import 'package:pt_service/core/theme/app_theme.dart';
import 'package:pt_service/core/services/session_service.dart';
import 'package:pt_service/features/auth/repository/api_auth_repository.dart';
import 'package:pt_service/features/sync/viewmodel/sync_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize date formatting for Korean locale
  await initializeDateFormatting('ko_KR', null);
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // Initialize SessionService
  final sessionService = SessionService(sharedPreferences);
  await sessionService.init();
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        sessionServiceProvider.overrideWithValue(sessionService),
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
    // 앱 시작 후 동기화 수행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performInitialSync();
    });
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

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: 'Workout - PT 관리 플랫폼',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}