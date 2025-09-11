import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../pt_reservation/view/reservation_recommendation_view.dart';
import '../../pt_contract/viewmodel/pt_contract_viewmodel.dart';
import '../../pt_contract/model/pt_contract_models.dart';
import '../../trainer_clients/viewmodel/trainer_client_viewmodel.dart';
import '../../trainer_clients/model/trainer_client_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/notion_dashboard_card.dart';
import 'package:intl/intl.dart';

class TrainerReservationMainView extends ConsumerStatefulWidget {
  const TrainerReservationMainView({super.key});

  @override
  ConsumerState<TrainerReservationMainView> createState() => _TrainerReservationMainViewState();
}

class _TrainerReservationMainViewState extends ConsumerState<TrainerReservationMainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          '예약 관리',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'IBMPlexSansKR',
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 예약 현황 요약
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF10B981), Color(0xFF34D399)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '예약 현황',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                            Text(
                              '오늘: ${DateFormat('yyyy년 MM월 dd일 (E)', 'ko').format(DateTime.now())}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildQuickActions(),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 예약 관리 메뉴
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF34D399)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.event_note,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '예약 관리 메뉴',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: NotionDashboardCard(
                          title: 'PT 일정 관리',
                          value: '전체 일정 보기',
                          icon: Icons.schedule,
                          onTap: () {
                            context.push('/pt-schedule');
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: NotionDashboardCard(
                          title: 'PT 예약 생성',
                          value: '새 예약 만들기',
                          icon: Icons.add_circle,
                          onTap: () {
                            _showCreateReservationDialog();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              _showCreateReservationDialog();
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF34D399)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 32,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '새 예약 생성',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () {
              context.push('/pt-schedule');
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.3),
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: Color(0xFF10B981),
                    size: 32,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '전체 일정 보기',
                    style: TextStyle(
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCreateReservationDialog() {
    ref.read(trainerClientListProvider.notifier).loadClients();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _TrainerReservationBottomSheet(),
    );
  }
}

// 트레이너용 예약 생성 바텀시트 (멤버 UI와 동일)
class _TrainerReservationBottomSheet extends ConsumerStatefulWidget {
  const _TrainerReservationBottomSheet();

  @override
  ConsumerState<_TrainerReservationBottomSheet> createState() =>
      _TrainerReservationBottomSheetState();
}

class _TrainerReservationBottomSheetState
    extends ConsumerState<_TrainerReservationBottomSheet> {
  bool _isRequesting = false;
  DateTime? _selectedDate;
  DateTime _focusedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  TrainerClient? _selectedClient;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR', null);
  }

  @override
  Widget build(BuildContext context) {
    final clientsState = ref.watch(trainerClientListProvider);

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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF34D399)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PT 예약 생성',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                      Text(
                        '회원과 날짜, 시간을 선택해주세요',
                        style: TextStyle(
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
          // 내용
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildClientSelector(clientsState),
                  const SizedBox(height: 24),
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

  Widget _buildClientSelector(AsyncValue<TrainerClientResponse> clientsState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '회원 선택',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        const SizedBox(height: 12),
        clientsState.when(
          data: (response) {
            if (response.data.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const Center(
                  child: Text(
                    '등록된 회원이 없습니다',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
              );
            }

            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: response.data.map((client) {
                  final isSelected = _selectedClient?.memberId == client.memberId;
                  return ListTile(
                    onTap: () {
                      setState(() {
                        _selectedClient = client;
                      });
                    },
                    leading: CircleAvatar(
                      backgroundColor: isSelected 
                          ? const Color(0xFF10B981)
                          : const Color(0xFF10B981).withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        color: isSelected ? Colors.white : const Color(0xFF10B981),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      '${client.name} 회원',
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontFamily: 'IBMPlexSansKR',
                        color: isSelected ? const Color(0xFF10B981) : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      client.email ?? '이메일 없음',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                    trailing: isSelected 
                        ? const Icon(Icons.check_circle, color: Color(0xFF10B981))
                        : null,
                  );
                }).toList(),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: const Text(
              '회원 목록을 불러올 수 없습니다',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ),
        ),
      ],
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
                color: Colors.orange.withOpacity(0.3),
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
              return day.isAfter(DateTime.now().subtract(const Duration(days: 1)));
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (selectedDay.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
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
    final morningTimes = <TimeOfDay>[];
    final afternoonTimes = <TimeOfDay>[];
    
    for (int hour = 6; hour <= 23; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
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
      ],
    );
  }

  Widget _buildTimeChip(TimeOfDay time) {
    bool isSelected = false;
    bool isInRange = false;

    if (_selectedStartTime != null && _selectedEndTime != null) {
      final startMinutes = _selectedStartTime!.hour * 60 + _selectedStartTime!.minute;
      final endMinutes = _selectedEndTime!.hour * 60 + _selectedEndTime!.minute;
      final currentMinutes = time.hour * 60 + time.minute;
      
      isInRange = currentMinutes >= startMinutes && currentMinutes <= endMinutes;
      isSelected = currentMinutes == startMinutes || currentMinutes == endMinutes;
    } else if (_selectedStartTime != null) {
      isSelected = time.hour == _selectedStartTime!.hour && time.minute == _selectedStartTime!.minute;
    }

    return GestureDetector(
      onTap: () => _onTimeChipTap(time),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected || isInRange 
              ? Colors.grey.shade800
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected || isInRange 
                ? Colors.grey.shade800
                : Colors.grey.shade300,
          ),
        ),
        child: Text(
          _formatTime(time),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected || isInRange ? Colors.white : Colors.grey.shade700,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
      ),
    );
  }

  void _onTimeChipTap(TimeOfDay time) {
    setState(() {
      if (_selectedStartTime == null) {
        _selectedStartTime = time;
      } else if (_selectedEndTime == null) {
        final startMinutes = _selectedStartTime!.hour * 60 + _selectedStartTime!.minute;
        final currentMinutes = time.hour * 60 + time.minute;
        
        if (currentMinutes > startMinutes) {
          _selectedEndTime = time;
        } else if (currentMinutes == startMinutes) {
          _selectedStartTime = null;
        } else {
          _selectedStartTime = time;
          _selectedEndTime = null;
        }
      } else {
        _selectedStartTime = time;
        _selectedEndTime = null;
      }
    });
  }

  String _formatTime(TimeOfDay time) {
    final hour12 = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour12:$minute';
  }

  Widget _buildRequestButton() {
    final isEnabled = _selectedClient != null && 
                     _selectedDate != null && 
                     _selectedStartTime != null &&
                     !_isRequesting;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 32),
      child: ElevatedButton(
        onPressed: isEnabled ? _submitReservation : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF10B981),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isRequesting 
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'PT 예약 생성',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
      ),
    );
  }

  void _submitReservation() async {
    if (_selectedClient == null || _selectedDate == null || _selectedStartTime == null) {
      return;
    }

    setState(() {
      _isRequesting = true;
    });

    try {
      // 예약 생성 로직 구현
      // API 호출 등
      
      await Future.delayed(const Duration(seconds: 1)); // 임시
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  '${_selectedClient!.name} 회원의 PT 예약이 생성되었습니다',
                  style: const TextStyle(
                    fontFamily: 'IBMPlexSansKR',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            duration: const Duration(seconds: 3),
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
            content: const Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'PT 예약 생성에 실패했습니다',
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansKR',
                    fontWeight: FontWeight.w600,
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