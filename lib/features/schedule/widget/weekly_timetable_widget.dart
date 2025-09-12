import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../pt_schedule/model/pt_schedule_models.dart';

class WeeklyTimetableWidget extends StatefulWidget {
  final List<PtSchedule> schedules;
  final DateTime selectedWeek;
  final Function(PtSchedule) onScheduleTap;
  final Function(PtSchedule, String) onScheduleAction;

  const WeeklyTimetableWidget({
    super.key,
    required this.schedules,
    required this.selectedWeek,
    required this.onScheduleTap,
    required this.onScheduleAction,
  });

  @override
  State<WeeklyTimetableWidget> createState() => _WeeklyTimetableWidgetState();
}

class _WeeklyTimetableWidgetState extends State<WeeklyTimetableWidget> {
  // 압축 모드는 항상 true로 고정
  final bool _isCompactMode = true;
  
  // 스크롤 컨트롤러들
  late ScrollController _horizontalController;
  late ScrollController _verticalController;
  late ScrollController _headerHorizontalController;

  @override
  void initState() {
    super.initState();
    _horizontalController = ScrollController();
    _verticalController = ScrollController();
    _headerHorizontalController = ScrollController();
    
    // 가로 스크롤 동기화만 유지
    _horizontalController.addListener(() {
      if (_headerHorizontalController.hasClients && 
          _headerHorizontalController.offset != _horizontalController.offset) {
        _headerHorizontalController.jumpTo(_horizontalController.offset);
      }
    });
    
    _headerHorizontalController.addListener(() {
      if (_horizontalController.hasClients && 
          _horizontalController.offset != _headerHorizontalController.offset) {
        _horizontalController.jumpTo(_headerHorizontalController.offset);
      }
    });
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    _headerHorizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 선택된 주의 월요일 계산
    final mondayOfWeek = widget.selectedWeek.subtract(Duration(days: widget.selectedWeek.weekday - 1));
    
    // 시간 슬롯 - 컴팩트 모드에서는 실제 일정이 있는 시간대만 표시
    List<int> timeSlots;
    if (_isCompactMode) {
      final Set<int> usedHours = {};
      for (final schedule in widget.schedules) {
        final startTime = DateTime.parse(schedule.startTime);
        usedHours.add(startTime.hour);
      }
      if (usedHours.isEmpty) {
        timeSlots = [9, 10, 11, 14, 15, 16]; // 기본 시간대
      } else {
        timeSlots = usedHours.toList()..sort();
        // 앞뒤로 한 시간씩 여유 추가
        if (timeSlots.first > 6) timeSlots.insert(0, timeSlots.first - 1);
        if (timeSlots.last < 22) timeSlots.add(timeSlots.last + 1);
      }
    } else {
      timeSlots = List.generate(17, (index) => index + 6); // 6시부터 22시까지
    }
    
    // 요일별로 스케줄 분류
    final Map<int, List<PtSchedule>> schedulesByDay = {};
    for (int i = 0; i < 7; i++) {
      schedulesByDay[i] = [];
    }
    
    for (final schedule in widget.schedules) {
      final scheduleDate = DateTime.parse(schedule.startTime);
      final dayOffset = scheduleDate.difference(mondayOfWeek).inDays;
      if (dayOffset >= 0 && dayOffset < 7) {
        schedulesByDay[dayOffset]!.add(schedule);
      }
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF10B981).withValues(alpha: 0.03),
            const Color(0xFF34D399).withValues(alpha: 0.05),
            const Color(0xFF6EE7B7).withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 헤더
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF10B981),
                  Color(0xFF34D399),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '주간 시간표',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${DateFormat('M월 d일').format(mondayOfWeek)} - ${DateFormat('M월 d일').format(mondayOfWeek.add(const Duration(days: 6)))}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // 시간표 본체 - 고정 헤더와 사이드바가 있는 구조
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final timeColumnWidth = _isCompactMode ? 50.0 : 60.0;
                final headerHeight = 50.0;
                // 화면 너비에서 시간 컬럼을 제외한 나머지를 7일로 나누어 계산
                final availableWidth = MediaQuery.of(context).size.width - timeColumnWidth - 32; // 패딩 제외
                final cellWidth = (availableWidth / 7).clamp(80.0, 120.0); // 최소 80, 최대 120
                final rowHeight = _isCompactMode ? 60.0 : 80.0;
                
                return Stack(
                  children: [
                    // 메인 스크롤 영역 (시간표 데이터)
                    Positioned(
                      left: timeColumnWidth,
                      top: headerHeight,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        color: Colors.white,
                        child: SingleChildScrollView(
                        controller: _horizontalController,
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: cellWidth * 7,
                          child: SingleChildScrollView(
                            controller: _verticalController,
                            child: Column(
                              children: timeSlots.map((hour) {
                                return Container(
                                  height: rowHeight,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey.shade200),
                                    ),
                                  ),
                                  child: Row(
                                    children: List.generate(7, (dayIndex) {
                                      final daySchedules = schedulesByDay[dayIndex]!
                                          .where((schedule) {
                                        final startTime = DateTime.parse(schedule.startTime);
                                        return startTime.hour == hour;
                                      }).toList();
                                      
                                      return Container(
                                        width: cellWidth,
                                        padding: EdgeInsets.all(_isCompactMode ? 1 : 2),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            right: BorderSide(color: Colors.grey.shade200),
                                          ),
                                        ),
                                        child: daySchedules.isEmpty
                                            ? const SizedBox()
                                            : Column(
                                                children: daySchedules.map((schedule) {
                                                  return Expanded(
                                                    child: _buildScheduleItem(schedule),
                                                  );
                                                }).toList(),
                                              ),
                                      );
                                    }),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      ),
                    ),
                    
                    // 고정 요일 헤더
                    Positioned(
                      left: timeColumnWidth,
                      top: 0,
                      right: 0,
                      height: headerHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(color: const Color(0xFF10B981).withValues(alpha: 0.2), width: 2),
                          ),
                        ),
                        child: SingleChildScrollView(
                          controller: _headerHorizontalController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(7, (index) {
                              final date = mondayOfWeek.add(Duration(days: index));
                              final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
                              final isToday = DateFormat('yyyy-MM-dd').format(date) == 
                                             DateFormat('yyyy-MM-dd').format(DateTime.now());
                              final hasSchedule = schedulesByDay[index]!.isNotEmpty;
                              
                              return Container(
                                width: cellWidth,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isToday 
                                      ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                      : hasSchedule 
                                          ? const Color(0xFF10B981).withValues(alpha: 0.05)
                                          : Colors.white.withValues(alpha: 0.5),
                                  border: Border(
                                    right: BorderSide(color: Colors.grey.shade300),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      weekdays[index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _isCompactMode ? 12 : 14,
                                        color: isToday ? Theme.of(context).colorScheme.primary : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      '${date.day}일',
                                      style: TextStyle(
                                        fontSize: _isCompactMode ? 10 : 12,
                                        color: isToday ? Theme.of(context).colorScheme.primary : Colors.grey,
                                      ),
                                    ),
                                    if (hasSchedule && _isCompactMode)
                                      Container(
                                        margin: const EdgeInsets.only(top: 2),
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                    
                    // 고정 시간축
                    Positioned(
                      left: 0,
                      top: headerHeight,
                      width: timeColumnWidth,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            right: BorderSide(color: Colors.grey.shade300, width: 2),
                          ),
                        ),
                        child: Column(
                            children: timeSlots.map((hour) {
                              return Container(
                                height: rowHeight,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                                child: Text(
                                  '${hour.toString().padLeft(2, '0')}:00',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                        ),
                      ),
                    ),
                    
                    // 좌상단 모서리 (시간 헤더)
                    Positioned(
                      left: 0,
                      top: 0,
                      width: timeColumnWidth,
                      height: headerHeight,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          border: Border(
                            right: BorderSide(color: Colors.grey.shade300, width: 2),
                            bottom: BorderSide(color: Colors.grey.shade300, width: 2),
                          ),
                        ),
                        child: const Text(
                          '시간',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          
          // 범례
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(11)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('예약됨', Colors.blue),
                const SizedBox(width: 20),
                _buildLegendItem('완료', Colors.green),
                const SizedBox(width: 20),
                _buildLegendItem('취소', Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildScheduleItem(PtSchedule schedule) {
    final startTime = DateTime.parse(schedule.startTime);
    final endTime = DateTime.parse(schedule.endTime);
    final duration = endTime.difference(startTime).inMinutes;
    
    return GestureDetector(
      onTap: () => _showScheduleMenu(context, schedule),
      child: Container(
        margin: EdgeInsets.all(_isCompactMode ? 0.5 : 1),
        padding: EdgeInsets.all(_isCompactMode ? 2 : 4),
        decoration: BoxDecoration(
          color: _getScheduleColor(schedule.status),
          borderRadius: BorderRadius.circular(_isCompactMode ? 3 : 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: _isCompactMode ? 1 : 2,
              offset: const Offset(0, 1),
            ),
          ],
          border: schedule.hasChangeRequest == true
              ? Border.all(
                  color: Colors.orange,
                  width: 2,
                )
              : null,
        ),
        child: _isCompactMode
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      schedule.memberName.length > 4 
                          ? '${schedule.memberName.substring(0, 4)}'
                          : schedule.memberName,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${DateFormat('HH:mm').format(startTime)}',
                      style: const TextStyle(
                        fontSize: 8,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.memberName,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${DateFormat('HH:mm').format(startTime)}-${DateFormat('HH:mm').format(endTime)}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                    ),
                  ),
                  if (duration > 30)
                    Text(
                      '${duration}분',
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.white60,
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
  
  void _showScheduleMenu(BuildContext context, PtSchedule schedule) {
    print('🎯 [TIMETABLE] 스케줄 메뉴 호출: ${schedule.memberName}');
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.memberName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${DateFormat('MM월 dd일 HH:mm').format(DateTime.parse(schedule.startTime))} - ${DateFormat('HH:mm').format(DateTime.parse(schedule.endTime))}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getScheduleColor(schedule.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(schedule.status),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getScheduleColor(schedule.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // 액션 버튼들
            _buildActionButton(
              context,
              Icons.visibility,
              '상세보기',
              Colors.blue,
              () {
                Navigator.pop(context);
                widget.onScheduleTap(schedule);
              },
            ),
            
            if (schedule.hasChangeRequest == true && schedule.changeRequestBy == 'member') ...[
              _buildActionButton(
                context,
                Icons.check_circle,
                '시간 변경 승인',
                Colors.green,
                () {
                  Navigator.pop(context);
                  widget.onScheduleAction(schedule, 'approve_change');
                },
              ),
              _buildActionButton(
                context,
                Icons.cancel,
                '시간 변경 거절',
                Colors.orange,
                () {
                  Navigator.pop(context);
                  widget.onScheduleAction(schedule, 'reject_change');
                },
              ),
            ],
            
            if (schedule.status == 'SCHEDULED' && schedule.hasChangeRequest != true) ...[
              _buildActionButton(
                context,
                Icons.schedule,
                '시간 변경 요청',
                Colors.purple,
                () {
                  print('🔄 [TIMETABLE] 시간 변경 요청 버튼 클릭');
                  Navigator.pop(context);
                  widget.onScheduleAction(schedule, 'trainer_request_change');
                },
              ),
              _buildActionButton(
                context,
                Icons.check_circle_outline,
                '수업 완료',
                Colors.green,
                () {
                  Navigator.pop(context);
                  widget.onScheduleAction(schedule, 'complete');
                },
              ),
              _buildActionButton(
                context,
                Icons.cancel_outlined,
                '수업 취소',
                Colors.red,
                () {
                  Navigator.pop(context);
                  widget.onScheduleAction(schedule, 'cancel');
                },
              ),
            ],
            
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String text, Color color, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'SCHEDULED':
        return '예약됨';
      case 'COMPLETED':
        return '완료';
      case 'CANCELLED':
        return '취소';
      default:
        return status;
    }
  }

  Color _getScheduleColor(String status) {
    switch (status) {
      case 'SCHEDULED':
        return Colors.blue.withValues(alpha: 0.7);
      case 'COMPLETED':
        return Colors.green.withValues(alpha: 0.7);
      case 'CANCELLED':
        return Colors.red.withValues(alpha: 0.6);
      default:
        return Colors.grey.withValues(alpha: 0.6);
    }
  }
}