import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../model/pt_schedule_models.dart';
import '../viewmodel/pt_schedule_viewmodel.dart';
import '../../pt_contract/viewmodel/pt_contract_viewmodel.dart';
import '../../../common/widgets/simple_time_picker.dart';
import '../../body_composition/widget/custom_date_picker.dart';

class ScheduleChangeRequestDialog extends ConsumerStatefulWidget {
  final PtSchedule schedule;
  final bool isTrainerRequest;

  const ScheduleChangeRequestDialog({
    super.key,
    required this.schedule,
    this.isTrainerRequest = false,
  });

  @override
  ConsumerState<ScheduleChangeRequestDialog> createState() => _ScheduleChangeRequestDialogState();
}

class _ScheduleChangeRequestDialogState extends ConsumerState<ScheduleChangeRequestDialog> {
  late DateTime _newStartDateTime;
  late DateTime _newEndDateTime;
  late int _selectedDurationMinutes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // locale 초기화
    initializeDateFormatting('ko_KR', null);
    
    final originalStart = DateTime.parse(widget.schedule.startTime);
    final originalEnd = DateTime.parse(widget.schedule.endTime);
    
    // 기본값을 현재 시간에서 1시간 후로 설정
    _newStartDateTime = originalStart;
    _newEndDateTime = originalEnd;
    _selectedDurationMinutes = originalEnd.difference(originalStart).inMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF10B981), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF34D399)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '시간 변경 요청',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBMPlexSansKR',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white, size: 20),
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            
            // 컨텐츠
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isTrainerRequest 
                ? '${widget.schedule.memberName} 회원과의 PT 시간을 변경 요청하시겠습니까?'
                : '${widget.schedule.trainerName} 트레이너와의 PT 시간을 변경 요청하시겠습니까?',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            
            // 현재 시간 표시
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '현재 예약 시간',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDateTime(DateTime.parse(widget.schedule.startTime)),
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    '${_formatTime(DateTime.parse(widget.schedule.startTime))} - ${_formatTime(DateTime.parse(widget.schedule.endTime))}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 새로운 시간 선택
            const Text(
              '변경 희망 시간',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            
            InkWell(
              onTap: _selectNewDateTime,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDateTime(_newStartDateTime),
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          '${_formatTime(_newStartDateTime)} - ${_formatTime(_newEndDateTime)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.calendar_today, size: 20),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 소요 시간 선택
            const Text(
              '소요 시간',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _DurationButton(
                  duration: 30,
                  selectedDuration: _selectedDurationMinutes,
                  onSelected: (duration) {
                    setState(() {
                      _selectedDurationMinutes = duration;
                      _newEndDateTime = _newStartDateTime.add(Duration(minutes: duration));
                    });
                  },
                ),
                const SizedBox(width: 8),
                _DurationButton(
                  duration: 60,
                  selectedDuration: _selectedDurationMinutes,
                  onSelected: (duration) {
                    setState(() {
                      _selectedDurationMinutes = duration;
                      _newEndDateTime = _newStartDateTime.add(Duration(minutes: duration));
                    });
                  },
                ),
                const SizedBox(width: 8),
                _DurationButton(
                  duration: 90,
                  selectedDuration: _selectedDurationMinutes,
                  onSelected: (duration) {
                    setState(() {
                      _selectedDurationMinutes = duration;
                      _newEndDateTime = _newStartDateTime.add(Duration(minutes: duration));
                    });
                  },
                ),
                const SizedBox(width: 8),
                _DurationButton(
                  duration: 120,
                  selectedDuration: _selectedDurationMinutes,
                  onSelected: (duration) {
                    setState(() {
                      _selectedDurationMinutes = duration;
                      _newEndDateTime = _newStartDateTime.add(Duration(minutes: duration));
                    });
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Color(0xFF10B981)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.isTrainerRequest
                        ? '회원이 요청을 승인하면 시간이 변경됩니다.'
                        : '트레이너가 요청을 승인하면 시간이 변경됩니다.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF10B981),
                        fontFamily: 'IBMPlexSansKR',
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
            
            // 액션 버튼들
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        textStyle: const TextStyle(
                          fontFamily: 'IBMPlexSansKR',
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('취소'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF34D399)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _isLoading ? null : _submitRequest,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      '요청하기',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'IBMPlexSansKR',
                                      ),
                                    ),
                            ),
                          ),
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
    );
  }

  Future<void> _selectNewDateTime() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initialDate = _newStartDateTime.isBefore(today) ? today : _newStartDateTime;
    
    final date = await showCustomDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 30)),
    );

    if (date != null) {
      final time = await showSimpleTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_newStartDateTime),
        title: '시작 시간 선택',
      );

      if (time != null) {
        final newStartDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        
        setState(() {
          _newStartDateTime = newStartDateTime;
          _newEndDateTime = newStartDateTime.add(Duration(minutes: _selectedDurationMinutes));
        });
      }
    }
  }

  Future<void> _submitRequest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('🔄 [SCHEDULE_CHANGE] 시간 변경 요청 시작');
      print('🔄 [SCHEDULE_CHANGE] 트레이너 요청: ${widget.isTrainerRequest}');
      print('🔄 [SCHEDULE_CHANGE] 새 시작시간: $_newStartDateTime');
      print('🔄 [SCHEDULE_CHANGE] 새 종료시간: $_newEndDateTime');
      
      if (widget.isTrainerRequest) {
        await ref.read(ptContractViewModelProvider.notifier).trainerRequestScheduleChange(
          appointmentId: widget.schedule.appointmentId,
          newStartTime: _newStartDateTime.toIso8601String(),
          newEndTime: _newEndDateTime.toIso8601String(),
        );
      } else {
        await ref.read(ptContractViewModelProvider.notifier).requestScheduleChange(
          appointmentId: widget.schedule.appointmentId,
          newStartTime: _newStartDateTime.toIso8601String(),
          newEndTime: _newEndDateTime.toIso8601String(),
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('시간 변경 요청이 전송되었습니다.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('요청 실패: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    // locale을 지정하지 않고 간단한 포맷 사용
    final weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    final weekday = weekdays[dateTime.weekday % 7];
    return '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일 ($weekday)';
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
}

class _DurationButton extends StatelessWidget {
  final int duration;
  final int selectedDuration;
  final ValueChanged<int> onSelected;

  const _DurationButton({
    required this.duration,
    required this.selectedDuration,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = duration == selectedDuration;
    
    return Expanded(
      child: InkWell(
        onTap: () => onSelected(duration),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              duration >= 60 
                ? '${duration ~/ 60}시간${duration % 60 > 0 ? ' ${duration % 60}분' : ''}'
                : '${duration}분',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}