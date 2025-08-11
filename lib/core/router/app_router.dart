import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/screens/splash_screen.dart';
import 'package:pt_service/features/auth/view/login_view.dart';
import 'package:pt_service/features/auth/view/signup_view.dart';
import 'package:pt_service/features/dashboard/view/trainer_dashboard_view.dart';
import 'package:pt_service/features/dashboard/view/member_dashboard_view.dart';
import 'package:pt_service/features/dashboard/view/manager_dashboard_view.dart';
import 'package:pt_service/features/workout/view/workout_record_view.dart';
import 'package:pt_service/features/profile/view/member_profile_view.dart';
import 'package:pt_service/features/report/view/analysis_report_view.dart';
import 'package:pt_service/features/schedule/view/pt_schedule_view.dart';
import 'package:pt_service/features/settings/view/settings_view.dart';
import 'package:pt_service/core/providers/auth_provider.dart';

import '../../features/auth/model/user_model.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authState,
    redirect: (context, state) {
      final isAuthenticated = authState.value != null;
      final isSplashRoute = state.matchedLocation == '/';
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (isSplashRoute) {
        return null;
      }

      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      if (isAuthenticated && isAuthRoute) {
        final userType = authState.value!.userType;
        switch (userType) {
          case UserType.trainer:
            return '/trainer-dashboard';
          case UserType.member:
            return '/member-dashboard';
          case UserType.manager:
            return '/manager-dashboard';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupView(),
      ),
      GoRoute(
        path: '/trainer-dashboard',
        builder: (context, state) => const TrainerDashboardView(),
      ),
      GoRoute(
        path: '/member-dashboard',
        builder: (context, state) => const MemberDashboardView(),
      ),
      GoRoute(
        path: '/manager-dashboard',
        builder: (context, state) => const ManagerDashboardView(),
      ),
      GoRoute(
        path: '/workout-record',
        builder: (context, state) => const WorkoutRecordView(),
      ),
      GoRoute(
        path: '/member-profile/:memberId',
        builder: (context, state) => MemberProfileView(
          memberId: state.pathParameters['memberId']!,
        ),
      ),
      GoRoute(
        path: '/analysis-report',
        builder: (context, state) => const AnalysisReportView(),
      ),
      GoRoute(
        path: '/pt-schedule',
        builder: (context, state) => const PTScheduleView(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsView(),
      ),
    ],
  );
});
