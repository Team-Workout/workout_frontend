import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pt_service/core/router/app_router.dart';
import 'package:pt_service/core/theme/app_theme.dart';
import 'package:pt_service/core/services/session_service.dart';
import 'package:pt_service/features/auth/repository/api_auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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

class WorkoutApp extends ConsumerWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: 'Workout - PT 관리 플랫폼',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}