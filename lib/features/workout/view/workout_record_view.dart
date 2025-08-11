import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/workout_record_viewmodel.dart';
import '../widget/calendar_view.dart';
import '../widget/workout_record_tab.dart';

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
    _viewModel = WorkoutRecordViewmodel();
    _initializeViewModel();
  }

  Future<void> _initializeViewModel() async {
    await _viewModel.initializeLocale();
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
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            '운동 일지',
            style: TextStyle(
              color: Color(0xFF2C3E50),
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
          bottom: const TabBar(
            labelColor: Color(0xFF2C3E50),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF2C3E50),
            tabs: [
              Tab(text: '달력 보기'),
              Tab(text: '운동 기록'),
            ],
          ),
        ),
        body: _isInitialized 
          ? ListenableBuilder(
              listenable: _viewModel,
              builder: (context, child) {
                return TabBarView(
                  children: [
                    CalendarView(viewModel: _viewModel),
                    WorkoutRecordTab(viewModel: _viewModel),
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