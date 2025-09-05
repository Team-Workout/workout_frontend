import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/workout_record_viewmodel.dart';
import '../service/workout_api_service.dart';
import '../service/local_storage_service.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/notion_colors.dart';
import '../widget/calendar_view.dart';
import '../widget/workout_record_tab.dart';
import '../widget/workout_routine_tab.dart';
import 'routine_list_view.dart';

class WorkoutRecordView extends ConsumerStatefulWidget {
  const WorkoutRecordView({super.key});

  @override
  ConsumerState<WorkoutRecordView> createState() => _WorkoutRecordViewState();
}

class _WorkoutRecordViewState extends ConsumerState<WorkoutRecordView> {
  late WorkoutRecordViewmodel _viewModel;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Provider를 통해 서비스들을 주입받아 ViewModel 생성
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workoutApiService = ref.read(workoutApiServiceProvider);
      final localStorageService = ref.read(localStorageServiceProvider);
      final authState = ref.read(authStateProvider);
      _viewModel = WorkoutRecordViewmodel(workoutApiService, localStorageService, authState);
      _initializeViewModel();
    });
  }

  Future<void> _initializeViewModel() async {
    await _viewModel.initializeLocale();
    // SQLite에서 오늘 날짜의 운동 기록 불러오기
    _viewModel.loadWorkoutForDate(_viewModel.selectedDate);
    _viewModel.initializeListeners();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: NotionColors.gray50,
        appBar: AppBar(
          backgroundColor: NotionColors.white,
          elevation: 0,
          title: const Text(
            '운동 관리',
            style: TextStyle(
              color: NotionColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: NotionColors.black),
          bottom: const TabBar(
            labelColor: NotionColors.black,
            unselectedLabelColor: NotionColors.textSecondary,
            indicatorColor: NotionColors.black,
            tabs: [
              Tab(text: '운동 기록'),
              Tab(text: '달력 보기'),
              Tab(text: '루틴 만들기'),
              Tab(text: '내 루틴'),
            ],
          ),
        ),
        body: _isInitialized
            ? ListenableBuilder(
                listenable: _viewModel,
                builder: (context, child) {
                  return TabBarView(
                    children: [
                      WorkoutRecordTab(viewModel: _viewModel),
                      CalendarView(viewModel: _viewModel),
                      WorkoutRoutineTab(viewModel: _viewModel),
                      const RoutineListView(),
                    ],
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
