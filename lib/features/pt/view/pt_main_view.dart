import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../trainer/view/trainers_view.dart';
import '../../schedule/view/pt_schedule_view.dart';
import '../../pt_contract/repository/pt_contract_repository.dart';
import '../../pt_contract/model/pt_contract_models.dart';
import '../../pt_contract/viewmodel/pt_contract_viewmodel.dart';
import '../../dashboard/widgets/notion_button.dart';

class PTMainView extends ConsumerStatefulWidget {
  const PTMainView({super.key});

  @override
  ConsumerState<PTMainView> createState() => _PTMainViewState();
}

class _PTMainViewState extends ConsumerState<PTMainView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'IBMPlexSansKR',
            ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Column(
            children: [
              // 탭바 (운동탭과 동일한 스타일)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF10B981),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFF10B981),
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                  tabs: const [
                    Tab(text: '트레이너'),
                    Tab(text: '시간표'),
                    Tab(text: 'PT'),
                  ],
                ),
              ),
              // 탭 뷰 콘텐츠
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    _TrainersViewWrapper(),
                    _ScheduleViewWrapper(),
                    _LessonRequestViewWrapper(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 트레이너 목록을 AppBar 없이 표시하는 래퍼
class _TrainersViewWrapper extends StatelessWidget {
  const _TrainersViewWrapper();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: const TrainersView(),
    );
  }
}

// 시간표를 AppBar 없이 표시하는 래퍼
class _ScheduleViewWrapper extends StatelessWidget {
  const _ScheduleViewWrapper();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: const PTScheduleView(),
    );
  }
}

// PT 수업 예약 요청을 AppBar 없이 표시하는 래퍼
class _LessonRequestViewWrapper extends StatelessWidget {
  const _LessonRequestViewWrapper();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FA),
      child: const _LessonRequestContent(),
    );
  }
}

// PT 수업 예약 요청 내용만 표시하는 위젯 (AppBar 제외)
class _LessonRequestContent extends ConsumerStatefulWidget {
  const _LessonRequestContent();

  @override
  ConsumerState<_LessonRequestContent> createState() =>
      _LessonRequestContentState();
}

class _LessonRequestContentState extends ConsumerState<_LessonRequestContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 내 PT 계약 목록 로드
      if (mounted) {
        ref.read(ptContractViewModelProvider.notifier).loadMyContracts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final contractsState = ref.watch(ptContractViewModelProvider);

    return Container(
      color: const Color(0xFFF8F9FA),
      child: Column(
        children: [
          // 헤더 영역
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Text(
                'PT 수업 예약',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IBMPlexSansKR',
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
          ),
          // 컨텐츠 영역
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: contractsState.when(
                  data: (contractResponse) =>
                      _buildContractsList(contractResponse),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                    ),
                  ),
                  error: (error, stack) => _buildErrorState(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildContractsList(PtContractResponse? contractResponse) {
    if (contractResponse == null || contractResponse.data.isEmpty) {
      return _buildEmptyState();
    }

    final contracts = contractResponse.data;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: contracts.length,
      itemBuilder: (context, index) {
        final contract = contracts[index];
        return _buildContractCard(contract);
      },
    );
  }

  Widget _buildContractCard(PtContract contract) {
    final bool isDisabled = contract.remainingSessions <= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDisabled ? Colors.grey[100] : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDisabled ? Colors.grey[300]! : Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: contract.remainingSessions > 0
            ? () => _showLessonRequestDialog(contract)
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 트레이너 프로필 이미지 (기본)
              CircleAvatar(
                radius: 30,
                backgroundColor: isDisabled
                    ? Colors.grey.withOpacity(0.2)
                    : const Color(0xFF10B981).withValues(alpha: 0.1),
                child: Icon(
                  Icons.person,
                  color:
                      isDisabled ? Colors.grey[400] : const Color(0xFF10B981),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              // 트레이너 및 계약 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${contract.trainerName} 트레이너',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBMPlexSansKR',
                        color: isDisabled ? Colors.grey[600] : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '잔여 수업: ${contract.remainingSessions}회 / ${contract.totalSessions}회',
                      style: TextStyle(
                        fontSize: 12,
                        color: contract.remainingSessions > 0
                            ? const Color(0xFF1F2937)
                            : Colors.grey[600],
                        fontFamily: 'IBMPlexSansKR',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // 화살표 아이콘
              Icon(
                isDisabled ? Icons.block : Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLessonRequestDialog(PtContract contract) {
    if (contract.remainingSessions <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  '잔여 수업이 없습니다. 추가 계약이 필요합니다.',
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansKR',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange[600],
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LessonRequestBottomSheet(contract: contract),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.assignment_outlined,
              size: 48,
              color: const Color(0xFF10B981).withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'PT 계약이 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              fontFamily: 'IBMPlexSansKR',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'PT 계약을 먼저 체결한 후 수업을 예약해주세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'PT 계약 목록을 불러올 수 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              fontFamily: 'IBMPlexSansKR',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '네트워크 연결을 확인해주세요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ],
      ),
    );
  }
}

// 수업 예약 요청 바텀시트
class _LessonRequestBottomSheet extends ConsumerStatefulWidget {
  final PtContract contract;

  const _LessonRequestBottomSheet({required this.contract});

  @override
  ConsumerState<_LessonRequestBottomSheet> createState() =>
      _LessonRequestBottomSheetState();
}

class _LessonRequestBottomSheetState
    extends ConsumerState<_LessonRequestBottomSheet> {
  bool _isRequesting = false;
  DateTime? _selectedDate = DateTime.now(); // 오늘 날짜로 기본 설정
  DateTime _focusedDate = DateTime.now(); // 오늘 날짜로 포커스
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  List<TimeOfDay> _selectedTimeSlots = []; // 연속 선택된 시간들

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR', null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 핸들
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 헤더
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor:
                      const Color(0xFF10B981).withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF10B981),
                    size: 25,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.contract.trainerName} 트레이너',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '수업 시간을 선택해주세요 (잔여: ${widget.contract.remainingSessions}회)',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          // 날짜/시간 선택 폼
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateSelector(),
                  const SizedBox(height: 24),
                  _buildTimeSelectors(),
                  const SizedBox(height: 32),
                  _buildRequestButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '날짜 선택',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDate,
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            calendarFormat: CalendarFormat.month,
            locale: 'ko_KR',
            availableGestures: AvailableGestures.all,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'IBMPlexSansKR',
              ),
              leftChevronIcon:
                  Icon(Icons.chevron_left, color: Color(0xFF10B981)),
              rightChevronIcon:
                  Icon(Icons.chevron_right, color: Color(0xFF10B981)),
              headerPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
                fontFamily: 'IBMPlexSansKR',
                fontSize: 12,
              ),
              weekdayStyle: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontFamily: 'IBMPlexSansKR',
                fontSize: 12,
              ),
            ),
            calendarStyle: CalendarStyle(
              cellMargin: const EdgeInsets.all(2),
              cellPadding: const EdgeInsets.all(0),
              todayDecoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.3),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 1),
              ),
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
              weekendTextStyle: const TextStyle(
                color: Colors.red,
                fontFamily: 'IBMPlexSansKR',
                fontSize: 13,
              ),
              defaultTextStyle: const TextStyle(
                fontFamily: 'IBMPlexSansKR',
                fontSize: 13,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'IBMPlexSansKR',
                fontSize: 13,
              ),
              todayTextStyle: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontFamily: 'IBMPlexSansKR',
                fontSize: 13,
              ),
              disabledTextStyle: TextStyle(
                color: Colors.grey[300],
                fontFamily: 'IBMPlexSansKR',
                fontSize: 13,
              ),
              outsideDaysVisible: false,
            ),
            enabledDayPredicate: (day) {
              // 오늘 이후의 날짜만 선택 가능
              return day
                  .isAfter(DateTime.now().subtract(const Duration(days: 1)));
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (selectedDay
                  .isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDate = focusedDay;
                });
              }
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDate = focusedDay;
              });
            },
          ),
        ),
        if (_selectedDate != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.grey.shade700,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  '선택된 날짜: ${DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(_selectedDate!)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTimeSelectors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '시간 선택',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        const SizedBox(height: 12),
        _buildTimeChips(),
        if (_selectedStartTime != null) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.grey.shade700,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  _selectedEndTime != null
                      ? '선택된 시간: ${_formatTime(_selectedStartTime!)} - ${_formatTime(_selectedEndTime!)}'
                      : '선택된 시간: ${_formatTime(_selectedStartTime!)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTimeChips() {
    // 6:00 AM부터 11:30 PM까지 30분 간격으로 시간 생성
    final morningTimes = <TimeOfDay>[];
    final afternoonTimes = <TimeOfDay>[];

    for (int hour = 6; hour <= 23; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        // 23:30 이후는 제외
        if (hour == 23 && minute > 30) break;

        final time = TimeOfDay(hour: hour, minute: minute);
        if (hour < 12) {
          morningTimes.add(time);
        } else {
          afternoonTimes.add(time);
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 오전 시간
        const Text(
          '오전',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: morningTimes.map((time) => _buildTimeChip(time)).toList(),
        ),
        const SizedBox(height: 16),
        // 오후 시간
        const Text(
          '오후',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: afternoonTimes.map((time) => _buildTimeChip(time)).toList(),
        ),
        const SizedBox(height: 32), // 바텀 패딩 추가
      ],
    );
  }

  Widget _buildTimeChip(TimeOfDay time) {
    final isInSelectedRange = _isTimeInSelectedRange(time);
    final isStartTime = _selectedStartTime != null &&
        _selectedStartTime!.hour == time.hour &&
        _selectedStartTime!.minute == time.minute;
    final isEndTime = _selectedEndTime != null &&
        _selectedEndTime!.hour == time.hour &&
        _selectedEndTime!.minute == time.minute;

    // 하나만 선택된 경우도 선택된 것으로 표시
    final isSelected = isInSelectedRange || isStartTime;

    return GestureDetector(
      onTap: () => _onTimeChipTap(time),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.transparent, // 투명하게 해서 움찔거림 방지
            width: 2, // 고정 width로 크기 변화 방지
          ),
        ),
        child: Text(
          _formatTime(time),
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
      ),
    );
  }

  bool _isTimeInSelectedRange(TimeOfDay time) {
    if (_selectedStartTime == null || _selectedEndTime == null) {
      return false;
    }

    final timeMinutes = time.hour * 60 + time.minute;
    final startMinutes =
        _selectedStartTime!.hour * 60 + _selectedStartTime!.minute;
    final endMinutes = _selectedEndTime!.hour * 60 + _selectedEndTime!.minute;

    return timeMinutes >= startMinutes && timeMinutes < endMinutes;
  }

  void _onTimeChipTap(TimeOfDay time) {
    setState(() {
      if (_selectedStartTime == null) {
        // 첫 번째 선택: 시작 시간만 설정
        _selectedStartTime = time;
        _selectedEndTime = null;
      } else if (_selectedEndTime == null) {
        // 두 번째 선택: 종료 시간 설정
        final timeMinutes = time.hour * 60 + time.minute;
        final startMinutes =
            _selectedStartTime!.hour * 60 + _selectedStartTime!.minute;

        if (timeMinutes <= startMinutes) {
          // 시작 시간보다 이르거나 같으면 새로운 시작 시간으로 설정
          _selectedStartTime = time;
          _selectedEndTime = null;
        } else {
          // 종료 시간 설정: 선택한 시간 + 30분을 종료 시간으로
          final endMinutes = timeMinutes + 30;
          final endHour = endMinutes ~/ 60;
          final endMin = endMinutes % 60;

          if (endHour <= 23 && !(endHour == 23 && endMin > 30)) {
            _selectedEndTime = TimeOfDay(hour: endHour, minute: endMin);
          } else {
            _selectedEndTime = const TimeOfDay(hour: 23, minute: 30);
          }
        }
      } else {
        // 이미 범위가 선택된 상태: 새로운 시작 시간으로 재설정
        _selectedStartTime = time;
        _selectedEndTime = null;
      }
    });
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    return '${displayHour}:${minute}';
  }

  Widget _buildTimeButton({
    required String label,
    TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          color: time != null
              ? const Color(0xFF10B981).withValues(alpha: 0.05)
              : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time != null ? time.format(context) : '--:--',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'IBMPlexSansKR',
                color:
                    time != null ? const Color(0xFF10B981) : Colors.grey[600],
                fontWeight: time != null ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: NotionButton(
        text: _isRequesting ? '요청 중...' : 'PT 수업 요청하기',
        onPressed: _isRequesting ? null : _requestLesson, // 로딩중이 아니면 항상 활성화
        isLoading: _isRequesting,
      ),
    );
  }

  void _selectStartTime() {
    _showTimeDropdown(
      title: '시작 시간 선택',
      selectedTime: _selectedStartTime,
      onTimeSelected: (time) {
        setState(() {
          _selectedStartTime = time;
          // 시작 시간이 변경되면 종료 시간 초기화 (종료 시간이 시작 시간보다 이르면)
          if (_selectedEndTime != null) {
            final startMinutes = time.hour * 60 + time.minute;
            final endMinutes =
                _selectedEndTime!.hour * 60 + _selectedEndTime!.minute;
            if (endMinutes <= startMinutes) {
              _selectedEndTime = null;
            }
          }
        });
      },
    );
  }

  void _selectEndTime() {
    if (_selectedStartTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            '시작 시간을 먼저 선택해주세요',
            style: TextStyle(fontFamily: 'IBMPlexSansKR'),
          ),
          backgroundColor: Colors.orange[600],
        ),
      );
      return;
    }

    _showTimeDropdown(
      title: '종료 시간 선택',
      selectedTime: _selectedEndTime,
      startTime: _selectedStartTime,
      onTimeSelected: (time) {
        // 종료 시간이 시작 시간보다 이후인지 확인
        final startMinutes =
            _selectedStartTime!.hour * 60 + _selectedStartTime!.minute;
        final endMinutes = time.hour * 60 + time.minute;

        if (endMinutes <= startMinutes) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                '종료 시간은 시작 시간보다 늦어야 합니다',
                style: TextStyle(fontFamily: 'IBMPlexSansKR'),
              ),
              backgroundColor: Colors.red[600],
            ),
          );
          return;
        }

        setState(() {
          _selectedEndTime = time;
        });
      },
    );
  }

  void _showTimeDropdown({
    required String title,
    required TimeOfDay? selectedTime,
    TimeOfDay? startTime,
    required Function(TimeOfDay) onTimeSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _TimeDropdownSheet(
        title: title,
        selectedTime: selectedTime,
        startTime: startTime,
        onTimeSelected: onTimeSelected,
      ),
    );
  }

  void _showWarningDialog() {
    String message = '';
    if (_selectedDate == null && _selectedStartTime == null) {
      message = '날짜와 시간을 선택해주세요.';
    } else if (_selectedDate == null) {
      message = '날짜를 선택해주세요.';
    } else if (_selectedStartTime == null) {
      message = '시간을 선택해주세요.';
    }

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_rounded,
                        color: Colors.orange.shade600,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '선택 필요',
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                        fontFamily: 'IBMPlexSansKR',
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // OK 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade600,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '확인',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestLesson() async {
    // 필수 선택사항 확인
    if (_selectedDate == null || _selectedStartTime == null) {
      _showWarningDialog();
      return;
    }

    setState(() {
      _isRequesting = true;
    });

    try {
      final startDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedStartTime!.hour,
        _selectedStartTime!.minute,
      );

      // 종료 시간이 없으면 시작 시간 + 1시간으로 설정
      final endTime = _selectedEndTime ??
          TimeOfDay(
            hour: (_selectedStartTime!.hour + 1) % 24,
            minute: _selectedStartTime!.minute,
          );

      final endDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        endTime.hour,
        endTime.minute,
      );

      await ref.read(ptContractViewModelProvider.notifier).proposeAppointment(
            contractId: widget.contract.contractId,
            startTime: startDateTime.toIso8601String(),
            endTime: endDateTime.toIso8601String(),
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'PT 수업 요청이 완료되었습니다!\n${widget.contract.trainerName} 트레이너가 확인 후 연락드릴 예정입니다.',
                    style: const TextStyle(
                      fontFamily: 'IBMPlexSansKR',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'PT 수업 요청에 실패했습니다: ${e.toString().replaceAll('Exception: ', '')}',
                    style: const TextStyle(
                      fontFamily: 'IBMPlexSansKR',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red[600],
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRequesting = false;
        });
      }
    }
  }
}

// 시간 드롭다운 선택 시트
class _TimeDropdownSheet extends StatefulWidget {
  final String title;
  final TimeOfDay? selectedTime;
  final TimeOfDay? startTime;
  final Function(TimeOfDay) onTimeSelected;

  const _TimeDropdownSheet({
    required this.title,
    required this.selectedTime,
    this.startTime,
    required this.onTimeSelected,
  });

  @override
  State<_TimeDropdownSheet> createState() => _TimeDropdownSheetState();
}

class _TimeDropdownSheetState extends State<_TimeDropdownSheet> {
  late List<TimeOfDay> availableTimes;
  TimeOfDay? tempSelectedTime;

  @override
  void initState() {
    super.initState();
    _generateAvailableTimes();
    tempSelectedTime = widget.selectedTime;
  }

  void _generateAvailableTimes() {
    availableTimes = [];

    // 6:00 AM부터 11:00 PM까지 30분 간격으로 시간 생성
    for (int hour = 6; hour <= 23; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        final time = TimeOfDay(hour: hour, minute: minute);

        // 종료 시간 선택 시 시작 시간 이후의 시간만 표시
        if (widget.startTime != null) {
          final startMinutes =
              widget.startTime!.hour * 60 + widget.startTime!.minute;
          final currentMinutes = time.hour * 60 + time.minute;

          if (currentMinutes <= startMinutes) {
            continue;
          }
        }

        availableTimes.add(time);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 핸들
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 헤더
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          // 시간 목록
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: availableTimes.length,
              itemBuilder: (context, index) {
                final time = availableTimes[index];
                final isSelected = tempSelectedTime?.hour == time.hour &&
                    tempSelectedTime?.minute == time.minute;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        tempSelectedTime = time;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF10B981).withValues(alpha: 0.1)
                            : Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF10B981)
                              : Colors.grey[200]!,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _formatTime(time),
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'IBMPlexSansKR',
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: isSelected
                                    ? const Color(0xFF10B981)
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF10B981),
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // 선택 버튼
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: tempSelectedTime != null
                    ? () {
                        widget.onTimeSelected(tempSelectedTime!);
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  tempSelectedTime != null ? '선택 완료' : '시간을 선택해주세요',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour < 12 ? '오전' : '오후';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    return '$period ${displayHour}:${minute}';
  }
}
