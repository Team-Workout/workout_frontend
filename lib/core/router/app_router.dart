import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/screens/splash_screen.dart';
import 'package:pt_service/features/auth/view/login_view.dart';
import 'package:pt_service/features/auth/view/signup_view.dart';
import 'package:pt_service/features/dashboard/view/trainer_dashboard_view.dart';
import 'package:pt_service/features/dashboard/view/member_dashboard_view.dart';
import 'package:pt_service/features/dashboard/view/manager_dashboard_view.dart';
import '../../shared/widgets/app_scaffold_with_nav.dart';
import 'package:pt_service/features/workout/view/workout_record_view.dart';
import 'package:pt_service/features/report/view/analysis_report_view.dart';
import 'package:pt_service/features/schedule/view/pt_schedule_view.dart';
import 'package:pt_service/features/settings/view/settings_view.dart';
import 'package:pt_service/features/trainer_profile/view/trainer_profile_edit_view.dart';
import 'package:pt_service/features/trainer/view/gym_trainers_view.dart';
import 'package:pt_service/features/trainer/view/trainer_detail_view.dart';
import 'package:pt_service/features/trainer/view/trainers_view.dart';
import 'package:pt_service/features/trainer/model/trainer_model.dart';
import 'package:pt_service/core/providers/auth_provider.dart';
import 'package:pt_service/features/body_composition/view/body_composition_view.dart';
import 'package:pt_service/features/pt_offerings/view/pt_offering_create_view.dart';
import 'package:pt_service/features/pt_offerings/view/pt_offerings_list_view.dart';
import 'package:pt_service/features/pt_offerings/view/trainer_pt_offerings_view.dart';
import 'package:pt_service/features/pt_applications/view/pt_applications_list_view.dart';
import 'package:pt_service/features/workout/view/routine_list_view.dart';
import 'package:pt_service/features/workout/view/routine_detail_view.dart';
import 'package:pt_service/features/workout/view/workout_routine_create_view.dart';
import 'package:pt_service/features/pt_contract/view/pt_contract_list_view.dart';
import 'package:pt_service/features/pt_reservation/view/reservation_request_view.dart';
import 'package:pt_service/features/pt_reservation/view/reservation_recommendation_view.dart';
import 'package:pt_service/features/pt_reservation/view/appointment_confirmation_view.dart';
import 'package:pt_service/features/pt_reservation/view/my_appointment_requests_view.dart';
import 'package:pt_service/features/pt_reservation/view/reservation_history_view.dart';
import 'package:pt_service/features/pt/view/pt_main_view.dart';

import '../../features/auth/model/user_model.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authState,
    redirect: (context, state) {
      final isAuthenticated = authState.isLoggedIn;
      final isSplashRoute = state.matchedLocation == '/';
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      // 스플래시 화면은 그대로 둠
      if (isSplashRoute) {
        return null;
      }

      // 인증되지 않은 상태에서 로그인/회원가입 페이지가 아닌 곳에 접근하면 로그인 페이지로
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      // 인증된 상태에서 로그인/회원가입 페이지에 접근하면 대시보드로
      if (isAuthenticated && isAuthRoute) {
        final userType = authState.value!.userType;
        switch (userType) {
          case UserType.trainer:
            return '/trainer-dashboard';
          case UserType.member:
            return '/dashboard';
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
      // Member Shell Route with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) {
          final currentPath = state.matchedLocation;
          int currentIndex = 0;
          
          if (currentPath == '/dashboard') currentIndex = 0;
          else if (currentPath == '/workout-record') currentIndex = 1;
          else if (currentPath == '/body-composition') currentIndex = 2;
          else if (currentPath == '/pt-main') currentIndex = 3;
          else if (currentPath == '/settings') currentIndex = 4;
          
          return AppScaffoldWithNav(
            currentIndex: currentIndex,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const MemberDashboardView(),
          ),
          GoRoute(
            path: '/workout-record',
            builder: (context, state) => const WorkoutRecordView(),
          ),
          GoRoute(
            path: '/body-composition',
            builder: (context, state) => const BodyCompositionView(),
          ),
          GoRoute(
            path: '/pt-main',
            builder: (context, state) => const PTMainView(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsView(),
          ),
        ],
      ),
      GoRoute(
        path: '/manager-dashboard',
        builder: (context, state) => const ManagerDashboardView(),
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
        path: '/trainer-profile-edit',
        builder: (context, state) => const TrainerProfileEditView(),
      ),
      GoRoute(
        path: '/gym-trainers/:gymId',
        builder: (context, state) {
          final gymIdStr = state.pathParameters['gymId'];
          if (gymIdStr == null) {
            // 기본값으로 헬스장 ID 1 사용
            return const GymTrainersView(gymId: 1);
          }
          final gymId = int.tryParse(gymIdStr) ?? 1;
          return GymTrainersView(gymId: gymId);
        },
      ),
      GoRoute(
        path: '/trainer-detail/:trainerId',
        builder: (context, state) {
          final trainerIdStr = state.pathParameters['trainerId'];
          final trainer = state.extra as TrainerProfile?;
          
          if (trainerIdStr == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
              body: const Center(
                child: Text('Trainer ID not provided'),
              ),
            );
          }
          
          final trainerId = int.tryParse(trainerIdStr);
          if (trainerId == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
              body: const Center(
                child: Text('Invalid trainer ID'),
              ),
            );
          }
          
          return TrainerDetailView(
            trainerId: trainerId,
            trainer: trainer, // fallback data if available
          );
        },
      ),
      GoRoute(
        path: '/pt-offerings',
        builder: (context, state) => const PtOfferingsListView(),
      ),
      GoRoute(
        path: '/pt-offerings/create',
        builder: (context, state) => const PtOfferingCreateView(),
      ),
      GoRoute(
        path: '/trainer/:trainerId/pt-offerings',
        builder: (context, state) {
          final trainerIdStr = state.pathParameters['trainerId'];
          final trainer = state.extra as Trainer?;
          
          if (trainerIdStr == null || trainer == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(child: Text('Trainer information not provided')),
            );
          }
          
          return TrainerPtOfferingsView(trainer: trainer);
        },
      ),
      GoRoute(
        path: '/workout-routines',
        builder: (context, state) => const RoutineListView(),
      ),
      GoRoute(
        path: '/workout-routine/:routineId',
        builder: (context, state) {
          final routineIdStr = state.pathParameters['routineId'];
          if (routineIdStr == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(child: Text('루틴 ID가 제공되지 않았습니다')),
            );
          }
          
          final routineId = int.tryParse(routineIdStr);
          if (routineId == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(child: Text('잘못된 루틴 ID입니다')),
            );
          }
          
          return RoutineDetailView(routineId: routineId);
        },
      ),
      GoRoute(
        path: '/workout-routine-create',
        builder: (context, state) => const WorkoutRouteCreateView(),
      ),
      GoRoute(
        path: '/pt-contracts',
        builder: (context, state) => const PtContractListView(),
      ),
      GoRoute(
        path: '/reservation-requests',
        builder: (context, state) => const ReservationRequestView(),
      ),
      GoRoute(
        path: '/reservation-recommendations',
        builder: (context, state) => const ReservationRecommendationView(),
      ),
      GoRoute(
        path: '/reservation-history',
        builder: (context, state) => const PtContractListView(),
      ),
      GoRoute(
        path: '/appointment-confirmation',
        builder: (context, state) => const AppointmentConfirmationView(),
      ),
      GoRoute(
        path: '/my-appointment-requests',
        builder: (context, state) => const MyAppointmentRequestsView(),
      ),
      GoRoute(
        path: '/pt-applications',
        builder: (context, state) => const PtApplicationsListView(
          isTrainerView: true, // 트레이너용 뷰로 설정
        ),
      ),
      GoRoute(
        path: '/pt-offerings',
        builder: (context, state) => const PtOfferingsListView(),
      ),
      GoRoute(
        path: '/pt-schedule',
        builder: (context, state) => const PTScheduleView(
          isDirectAccess: true, // 직접 접근임을 표시
        ),
      ),
      GoRoute(
        path: '/trainer-settings',
        builder: (context, state) => const SettingsView(),
      ),
    ],
  );
});
