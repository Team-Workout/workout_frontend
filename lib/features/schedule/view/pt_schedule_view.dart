import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pt_service/features/schedule/model/pt_schedule_model.dart';
import 'package:pt_service/features/schedule/viewmodel/schedule_viewmodel.dart';
import 'package:pt_service/core/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class PTScheduleView extends ConsumerStatefulWidget {
  const PTScheduleView({super.key});

  @override
  ConsumerState<PTScheduleView> createState() => _PTScheduleViewState();
}

class _PTScheduleViewState extends ConsumerState<PTScheduleView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  
  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final schedules = ref.watch(ptScheduleListProvider);
    final user = ref.watch(currentUserProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('PT 일정 관리'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddScheduleDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: TableCalendar<PTSchedule>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              eventLoader: (day) {
                return schedules.when(
                  data: (data) => data.where((schedule) => 
                    isSameDay(schedule.dateTime, day)).toList(),
                  loading: () => [],
                  error: (_, __) => [],
                );
              },
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                markerDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
            ),
          ),
          Expanded(
            child: schedules.when(
              data: (data) => _buildScheduleList(data),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('오류가 발생했습니다: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildScheduleList(List<PTSchedule> allSchedules) {
    final selectedSchedules = allSchedules.where((schedule) => 
      _selectedDay != null && isSameDay(schedule.dateTime, _selectedDay!)
    ).toList();
    
    selectedSchedules.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    
    if (selectedSchedules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _selectedDay != null
                ? '${DateFormat('M월 d일').format(_selectedDay!)}에 예약된 PT가 없습니다'
                : '날짜를 선택해주세요',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: selectedSchedules.length,
      itemBuilder: (context, index) {
        final schedule = selectedSchedules[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(schedule.status).withOpacity(0.2),
              child: Icon(
                _getStatusIcon(schedule.status),
                color: _getStatusColor(schedule.status),
              ),
            ),
            title: Text(
              ref.watch(currentUserProvider)?.userType.name == 'trainer'
                ? schedule.memberName
                : schedule.trainerName,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${DateFormat('HH:mm').format(schedule.dateTime)} - ${DateFormat('HH:mm').format(schedule.dateTime.add(Duration(minutes: schedule.durationMinutes)))}',
                ),
                if (schedule.notes != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    schedule.notes!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _showEditScheduleDialog(context, schedule);
                    break;
                  case 'complete':
                    _completeSchedule(schedule);
                    break;
                  case 'cancel':
                    _cancelSchedule(schedule);
                    break;
                  case 'delete':
                    _deleteSchedule(schedule);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('수정'),
                ),
                if (schedule.status == PTScheduleStatus.scheduled) ...[
                  const PopupMenuItem(
                    value: 'complete',
                    child: Text('완료'),
                  ),
                  const PopupMenuItem(
                    value: 'cancel',
                    child: Text('취소'),
                  ),
                ],
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('삭제'),
                ),
              ],
            ),
            onTap: () {
              _showScheduleDetail(context, schedule);
            },
          ),
        );
      },
    );
  }
  
  Color _getStatusColor(PTScheduleStatus status) {
    switch (status) {
      case PTScheduleStatus.scheduled:
        return Colors.blue;
      case PTScheduleStatus.completed:
        return Colors.green;
      case PTScheduleStatus.cancelled:
        return Colors.red;
    }
  }
  
  IconData _getStatusIcon(PTScheduleStatus status) {
    switch (status) {
      case PTScheduleStatus.scheduled:
        return Icons.schedule;
      case PTScheduleStatus.completed:
        return Icons.check_circle;
      case PTScheduleStatus.cancelled:
        return Icons.cancel;
    }
  }
  
  void _showAddScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddScheduleDialog(),
    );
  }
  
  void _showEditScheduleDialog(BuildContext context, PTSchedule schedule) {
    showDialog(
      context: context,
      builder: (context) => EditScheduleDialog(schedule: schedule),
    );
  }
  
  void _showScheduleDetail(BuildContext context, PTSchedule schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('일정 상세'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('트레이너', schedule.trainerName),
            _buildDetailRow('회원', schedule.memberName),
            _buildDetailRow('날짜', DateFormat('yyyy년 M월 d일').format(schedule.dateTime)),
            _buildDetailRow('시간', 
              '${DateFormat('HH:mm').format(schedule.dateTime)} - ${DateFormat('HH:mm').format(schedule.dateTime.add(Duration(minutes: schedule.durationMinutes)))}'),
            _buildDetailRow('상태', _getStatusText(schedule.status)),
            if (schedule.notes != null)
              _buildDetailRow('노트', schedule.notes!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
  
  String _getStatusText(PTScheduleStatus status) {
    switch (status) {
      case PTScheduleStatus.scheduled:
        return '예약됨';
      case PTScheduleStatus.completed:
        return '완료';
      case PTScheduleStatus.cancelled:
        return '취소';
    }
  }
  
  void _completeSchedule(PTSchedule schedule) {
    ref.read(scheduleViewModelProvider.notifier).updateScheduleStatus(
      schedule.id,
      PTScheduleStatus.completed,
    );
  }
  
  void _cancelSchedule(PTSchedule schedule) {
    ref.read(scheduleViewModelProvider.notifier).updateScheduleStatus(
      schedule.id,
      PTScheduleStatus.cancelled,
    );
  }
  
  void _deleteSchedule(PTSchedule schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일정 삭제'),
        content: const Text('이 일정을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(scheduleViewModelProvider.notifier).deleteSchedule(schedule.id);
              Navigator.of(context).pop();
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}

class AddScheduleDialog extends ConsumerStatefulWidget {
  const AddScheduleDialog({super.key});

  @override
  ConsumerState<AddScheduleDialog> createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends ConsumerState<AddScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _memberNameController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  int _duration = 60;
  
  @override
  void dispose() {
    _memberNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('PT 일정 추가'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _memberNameController,
                decoration: const InputDecoration(
                  labelText: '회원 이름',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '회원 이름을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDateTime,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '날짜 및 시간',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    DateFormat('yyyy년 M월 d일 HH:mm').format(_selectedDateTime),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _duration,
                decoration: const InputDecoration(
                  labelText: '운동 시간',
                  border: OutlineInputBorder(),
                ),
                items: [30, 45, 60, 90, 120].map((duration) {
                  return DropdownMenuItem(
                    value: duration,
                    child: Text('$duration분'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _duration = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: '노트 (선택)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _saveSchedule,
          child: const Text('저장'),
        ),
      ],
    );
  }
  
  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      
      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }
  
  void _saveSchedule() {
    if (_formKey.currentState!.validate()) {
      final user = ref.read(currentUserProvider);
      if (user == null) return;
      
      ref.read(scheduleViewModelProvider.notifier).addSchedule(
        trainerId: user.id,
        trainerName: user.name,
        memberName: _memberNameController.text,
        dateTime: _selectedDateTime,
        durationMinutes: _duration,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );
      
      Navigator.of(context).pop();
    }
  }
}

class EditScheduleDialog extends ConsumerStatefulWidget {
  final PTSchedule schedule;
  
  const EditScheduleDialog({super.key, required this.schedule});

  @override
  ConsumerState<EditScheduleDialog> createState() => _EditScheduleDialogState();
}

class _EditScheduleDialogState extends ConsumerState<EditScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _memberNameController;
  late final TextEditingController _notesController;
  late DateTime _selectedDateTime;
  late int _duration;
  
  @override
  void initState() {
    super.initState();
    _memberNameController = TextEditingController(text: widget.schedule.memberName);
    _notesController = TextEditingController(text: widget.schedule.notes ?? '');
    _selectedDateTime = widget.schedule.dateTime;
    _duration = widget.schedule.durationMinutes;
  }
  
  @override
  void dispose() {
    _memberNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('PT 일정 수정'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _memberNameController,
                decoration: const InputDecoration(
                  labelText: '회원 이름',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '회원 이름을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDateTime,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '날짜 및 시간',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    DateFormat('yyyy년 M월 d일 HH:mm').format(_selectedDateTime),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _duration,
                decoration: const InputDecoration(
                  labelText: '운동 시간',
                  border: OutlineInputBorder(),
                ),
                items: [30, 45, 60, 90, 120].map((duration) {
                  return DropdownMenuItem(
                    value: duration,
                    child: Text('$duration분'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _duration = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: '노트 (선택)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _updateSchedule,
          child: const Text('수정'),
        ),
      ],
    );
  }
  
  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      
      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }
  
  void _updateSchedule() {
    if (_formKey.currentState!.validate()) {
      final updatedSchedule = widget.schedule.copyWith(
        memberName: _memberNameController.text,
        dateTime: _selectedDateTime,
        durationMinutes: _duration,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );
      
      ref.read(scheduleViewModelProvider.notifier).updateSchedule(updatedSchedule);
      Navigator.of(context).pop();
    }
  }
}