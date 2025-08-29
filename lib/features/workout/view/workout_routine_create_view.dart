import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widget/workout_routine_tab.dart';
import '../viewmodel/workout_record_viewmodel.dart';
import '../service/workout_api_service.dart';
import '../service/local_storage_service.dart';
import '../../../core/providers/auth_provider.dart';

// Provider for WorkoutRecordViewmodel
final workoutRecordViewModelProvider = ChangeNotifierProvider<WorkoutRecordViewmodel>((ref) {
  final apiService = ref.watch(workoutApiServiceProvider);
  final localStorageService = ref.watch(localStorageServiceProvider);
  final authState = ref.watch(authStateProvider);
  
  return WorkoutRecordViewmodel(apiService, localStorageService, authState);
});

class WorkoutRouteCreateView extends ConsumerWidget {
  const WorkoutRouteCreateView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('루틴 만들기'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: WorkoutRoutineTab(
        viewModel: ref.read(workoutRecordViewModelProvider),
      ),
    );
  }
}