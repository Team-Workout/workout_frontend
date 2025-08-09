import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/core/router/app_router.dart';
import 'package:pt_service/core/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: WorkoutApp(),
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