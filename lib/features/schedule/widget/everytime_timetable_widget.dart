import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../pt_schedule/model/pt_schedule_models.dart';

class EverytimeTimetableWidget extends StatefulWidget {
  final List<PtSchedule> schedules;
  final DateTime selectedWeek;
  final Function(PtSchedule) onScheduleTap;
  final Function(PtSchedule, String) onScheduleAction;
  final Widget? switchButton; // 스위치 버튼 추가

  const EverytimeTimetableWidget({
    super.key,
    required this.schedules,
    required this.selectedWeek,
    required this.onScheduleTap,
    required this.onScheduleAction,
    this.switchButton, // 옵션널 매개변수
  });

  @override
  State<EverytimeTimetableWidget> createState() =>
      _EverytimeTimetableWidgetState();
}

class _EverytimeTimetableWidgetState extends State<EverytimeTimetableWidget> {
  late ScrollController _verticalController;
  late ScrollController _timeVerticalController;
  late ScrollController _headerHorizontalController;

  @override
  void initState() {
    super.initState();
    _verticalController = ScrollController();
    _timeVerticalController = ScrollController();
    _headerHorizontalController = ScrollController();

    // 세로 스크롤 동기화
    _verticalController.addListener(() {
      if (_timeVerticalController.hasClients &&
          _timeVerticalController.offset != _verticalController.offset) {
        _timeVerticalController.jumpTo(_verticalController.offset);
      }
    });

    _timeVerticalController.addListener(() {
      if (_verticalController.hasClients &&
          _verticalController.offset != _timeVerticalController.offset) {
        _verticalController.jumpTo(_timeVerticalController.offset);
      }
    });
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _timeVerticalController.dispose();
    _headerHorizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 선택된 주의 월요일 계산
    final mondayOfWeek = widget.selectedWeek
        .subtract(Duration(days: widget.selectedWeek.weekday - 1));

    // 에브리타임 스타일: 6시부터 24시까지 모든 시간 표시
    final timeSlots = [
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      0
    ]; // 6시부터 23시, 그리고 0시(24시)

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

    return Column(
      children: [
        // 시간표 본체 - 비율을 늘려서 더 길쭉하게
        Expanded(
          flex: 4, // 범례 대비 4:1 비율로 설정
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: [
                  // 헤더
                  Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF34D399)],
                      ),
                    ),
                    child: Row(
                      children: [
                        // 시간 헤더
                        Container(
                          width: 60,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            border: Border(
                              right:
                                  BorderSide(color: Colors.white, width: 0.5),
                            ),
                          ),
                          child: const Text(
                            '시간',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        // 요일 헤더 (고정 너비로 모든 요일이 보이도록)
                        Expanded(
                          child: Row(
                            children: List.generate(7, (index) {
                              final date =
                                  mondayOfWeek.add(Duration(days: index));
                              final weekdays = [
                                '월',
                                '화',
                                '수',
                                '목',
                                '금',
                                '토',
                                '일'
                              ];
                              final isToday =
                                  DateFormat('yyyy-MM-dd').format(date) ==
                                      DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now());

                              return Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isToday
                                        ? Colors.white.withValues(alpha: 0.2)
                                        : Colors.transparent,
                                    border: const Border(
                                      right: BorderSide(
                                          color: Colors.white, width: 0.5),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        weekdays[index],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: isToday
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${date.day}',
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.8),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 시간표 본체
                  Expanded(
                    child: Row(
                      children: [
                        // 시간축 (고정)
                        Container(
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            border: const Border(
                              right: BorderSide(
                                  color: Color(0xFFD1D5DB), width: 1),
                            ),
                          ),
                          child: SingleChildScrollView(
                            controller: _timeVerticalController,
                            child: Column(
                              children: timeSlots.map((hour) {
                                return Container(
                                  height: 60, // 50에서 60으로 증가
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xFFD1D5DB), width: 0.5),
                                    ),
                                  ),
                                  child: Text(
                                    hour == 0
                                        ? '24:00'
                                        : '${hour.toString().padLeft(2, '0')}:00',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                        // 시간표 격자 (고정 너비로 7일이 모두 보이도록)
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final availableWidth = constraints.maxWidth;
                              final dayWidth = availableWidth / 7;

                              return SingleChildScrollView(
                                controller: _verticalController,
                                child: Stack(
                                  children: [
                                    // 격자 배경
                                    Column(
                                      children: timeSlots.map((hour) {
                                        return Container(
                                          height: 60, // 50에서 60으로 증가
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Color(0xFFD1D5DB),
                                                  width: 0.5),
                                            ),
                                          ),
                                          child: Row(
                                            children:
                                                List.generate(7, (dayIndex) {
                                              return Container(
                                                width: dayWidth,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide(
                                                        color:
                                                            Color(0xFFD1D5DB),
                                                        width: 0.5),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        );
                                      }).toList(),
                                    ),

                                    // 스케줄 블록들
                                    ...schedulesByDay.entries.expand((entry) {
                                      final dayIndex = entry.key;
                                      final daySchedules = entry.value;

                                      return daySchedules.map((schedule) {
                                        final startTime =
                                            DateTime.parse(schedule.startTime);
                                        final endTime =
                                            DateTime.parse(schedule.endTime);

                                        final startHour = startTime.hour;
                                        final startMinute = startTime.minute;
                                        final endHour = endTime.hour;
                                        final endMinute = endTime.minute;

                                        // 시작 시간이 6시보다 이른 경우 6시로 조정
                                        final adjustedStartHour =
                                            startHour < 6 ? 6 : startHour;
                                        final adjustedStartMinute =
                                            startHour < 6 ? 0 : startMinute;

                                        // 종료 시간이 24시(0시)보다 늦은 경우 24시로 조정
                                        // 0시는 24시로 취급하므로 endHour가 0이면 24로 계산
                                        final actualEndHour =
                                            endHour == 0 ? 24 : endHour;
                                        final adjustedEndHour =
                                            actualEndHour > 24
                                                ? 24
                                                : actualEndHour;
                                        final adjustedEndMinute =
                                            actualEndHour > 24 ? 0 : endMinute;

                                        // timeSlots에서의 인덱스 기반 위치 계산
                                        int getTimeIndex(int hour) {
                                          if (hour == 0 || hour == 24)
                                            return 18; // 0시/24시는 마지막 인덱스
                                          if (hour >= 6 && hour <= 23)
                                            return hour - 6;
                                          return -1; // 범위 밖
                                        }

                                        final startIndex =
                                            getTimeIndex(adjustedStartHour);
                                        final endIndex =
                                            getTimeIndex(adjustedEndHour);

                                        // 시간표에서의 위치 계산 (60px 기준으로 조정)
                                        final topOffset = startIndex * 60.0 +
                                            (adjustedStartMinute / 60.0) * 60.0;
                                        final indexDiff = endIndex - startIndex;
                                        final height = indexDiff * 60.0 +
                                            ((adjustedEndMinute -
                                                        adjustedStartMinute) /
                                                    60.0) *
                                                60.0;

                                        return Positioned(
                                          left: dayIndex * dayWidth + 2,
                                          top: topOffset + 2,
                                          width: dayWidth - 4,
                                          height: height - 4,
                                          child: GestureDetector(
                                            onTap: () => _showScheduleMenu(
                                                context, schedule),
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: _getScheduleColor(
                                                    schedule.status),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: schedule
                                                            .hasChangeRequest ==
                                                        true
                                                    ? Border.all(
                                                        color: Colors.orange,
                                                        width: 2)
                                                    : null,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withValues(alpha: 0.1),
                                                    blurRadius: 2,
                                                    offset: const Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    schedule.memberName,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  if (height > 35) ...[
                                                    const SizedBox(height: 1),
                                                    Text(
                                                      '${DateFormat('HH:mm').format(startTime)}-${DateFormat('HH:mm').format(endTime)}',
                                                      style: const TextStyle(
                                                        fontSize: 8,
                                                        color: Colors.white70,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                  if (schedule.hasChangeRequest ==
                                                          true &&
                                                      height > 50) ...[
                                                    const SizedBox(height: 1),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 3,
                                                          vertical: 1),
                                                      decoration: BoxDecoration(
                                                        color: Colors.orange,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2),
                                                      ),
                                                      child: const Text(
                                                        '변경요청',
                                                        style: TextStyle(
                                                          fontSize: 7,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                    }),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 범례 - 흰색 박스 제거하고 투명하게
        Container(
          height: 60, // 고정 높이로 작게 설정
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // 범례 항목들
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem('예약됨', const Color(0xFF3B82F6)),
                    const SizedBox(width: 20),
                    _buildLegendItem('변경요청', Colors.orange),
                  ],
                ),
              ),
              // 스위치 버튼 (제공된 경우에만 표시)
              if (widget.switchButton != null) ...[
                const SizedBox(width: 12),
                widget.switchButton!,
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'IBMPlexSansKR',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showScheduleMenu(BuildContext context, PtSchedule schedule) {
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
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${DateFormat('MM월 dd일 HH:mm').format(DateTime.parse(schedule.startTime))} - ${DateFormat('HH:mm').format(DateTime.parse(schedule.endTime))}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getScheduleColor(schedule.status)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(schedule.status),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getScheduleColor(schedule.status),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'IBMPlexSansKR',
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

            if (schedule.hasChangeRequest == true &&
                schedule.changeRequestBy == 'member') ...[
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

            if (schedule.hasChangeRequest == true &&
                schedule.changeRequestBy == 'trainer') ...[
              _buildActionButton(
                context,
                Icons.check_circle,
                '변경 요청 승인',
                Colors.green,
                () {
                  Navigator.pop(context);
                  widget.onScheduleAction(schedule, 'member_approve_change');
                },
              ),
              _buildActionButton(
                context,
                Icons.cancel,
                '변경 요청 거절',
                Colors.orange,
                () {
                  Navigator.pop(context);
                  widget.onScheduleAction(schedule, 'reject_change');
                },
              ),
            ],

            if (schedule.status == 'SCHEDULED' &&
                schedule.hasChangeRequest != true) ...[
              _buildActionButton(
                context,
                Icons.schedule,
                '시간 변경 요청',
                Colors.purple,
                () {
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

  Widget _buildActionButton(BuildContext context, IconData icon, String text,
      Color color, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
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
                  fontFamily: 'IBMPlexSansKR',
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
      case 'CANCELLED':
        return '취소';
      case 'MEMBER_REQUESTED':
        return '요청됨';
      case 'CHANGE_REQUESTED':
      case 'TRAINER_CHANGE_REQUESTED':
        return '변경요청';
      default:
        return status;
    }
  }

  Color _getScheduleColor(String status) {
    switch (status) {
      case 'SCHEDULED':
        return const Color(0xFF3B82F6); // 파란색
      case 'CANCELLED':
        return const Color(0xFFEF4444); // 빨간색
      case 'MEMBER_REQUESTED':
        return const Color(0xFF8B5CF6); // 보라색
      case 'CHANGE_REQUESTED':
      case 'TRAINER_CHANGE_REQUESTED':
        return Colors.orange; // 오렌지색
      default:
        return Colors.grey;
    }
  }
}
