import 'package:flutter/material.dart';

class SimpleTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay>? onTimeSelected;
  final String? title;

  const SimpleTimePicker({
    super.key,
    required this.initialTime,
    this.onTimeSelected,
    this.title,
  });

  @override
  State<SimpleTimePicker> createState() => _SimpleTimePickerState();
}

class _SimpleTimePickerState extends State<SimpleTimePicker> {
  late int selectedHour;
  late int selectedMinute;

  // 시간 옵션 (6시부터 23시까지)
  final List<int> hours = List.generate(18, (index) => index + 6);
  
  // 분 옵션 (0, 15, 30, 45분)
  final List<int> minutes = [0, 15, 30, 45];

  @override
  void initState() {
    super.initState();
    selectedHour = widget.initialTime.hour;
    selectedMinute = _findClosestMinute(widget.initialTime.minute);
  }

  int _findClosestMinute(int minute) {
    return minutes.reduce((curr, next) => 
        (minute - curr).abs() < (minute - next).abs() ? curr : next);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.title != null) ...[
              Text(
                widget.title!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
            ],
            
            // 현재 선택된 시간 표시
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 시간과 분 선택
            Row(
              children: [
                // 시간 선택
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '시간',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          itemCount: hours.length,
                          itemBuilder: (context, index) {
                            final hour = hours[index];
                            final isSelected = hour == selectedHour;
                            
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedHour = hour;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? Colors.blue[100] 
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${hour.toString().padLeft(2, '0')}시',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected 
                                        ? FontWeight.bold 
                                        : FontWeight.normal,
                                    color: isSelected 
                                        ? Colors.blue[700] 
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // 분 선택
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '분',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          itemCount: minutes.length,
                          itemBuilder: (context, index) {
                            final minute = minutes[index];
                            final isSelected = minute == selectedMinute;
                            
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedMinute = minute;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? Colors.blue[100] 
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${minute.toString().padLeft(2, '0')}분',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected 
                                        ? FontWeight.bold 
                                        : FontWeight.normal,
                                    color: isSelected 
                                        ? Colors.blue[700] 
                                        : Colors.black87,
                                  ),
                                ),
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
            
            const SizedBox(height: 24),
            
            // 빠른 선택 버튼들
            const Text(
              '빠른 선택',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _QuickTimeButton(
                  label: '오전 9:00',
                  hour: 9,
                  minute: 0,
                  isSelected: selectedHour == 9 && selectedMinute == 0,
                  onTap: () {
                    setState(() {
                      selectedHour = 9;
                      selectedMinute = 0;
                    });
                  },
                ),
                _QuickTimeButton(
                  label: '오전 10:00',
                  hour: 10,
                  minute: 0,
                  isSelected: selectedHour == 10 && selectedMinute == 0,
                  onTap: () {
                    setState(() {
                      selectedHour = 10;
                      selectedMinute = 0;
                    });
                  },
                ),
                _QuickTimeButton(
                  label: '오후 2:00',
                  hour: 14,
                  minute: 0,
                  isSelected: selectedHour == 14 && selectedMinute == 0,
                  onTap: () {
                    setState(() {
                      selectedHour = 14;
                      selectedMinute = 0;
                    });
                  },
                ),
                _QuickTimeButton(
                  label: '오후 4:00',
                  hour: 16,
                  minute: 0,
                  isSelected: selectedHour == 16 && selectedMinute == 0,
                  onTap: () {
                    setState(() {
                      selectedHour = 16;
                      selectedMinute = 0;
                    });
                  },
                ),
                _QuickTimeButton(
                  label: '오후 6:00',
                  hour: 18,
                  minute: 0,
                  isSelected: selectedHour == 18 && selectedMinute == 0,
                  onTap: () {
                    setState(() {
                      selectedHour = 18;
                      selectedMinute = 0;
                    });
                  },
                ),
                _QuickTimeButton(
                  label: '오후 8:00',
                  hour: 20,
                  minute: 0,
                  isSelected: selectedHour == 20 && selectedMinute == 0,
                  onTap: () {
                    setState(() {
                      selectedHour = 20;
                      selectedMinute = 0;
                    });
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 액션 버튼들
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final selectedTime = TimeOfDay(hour: selectedHour, minute: selectedMinute);
                      widget.onTimeSelected?.call(selectedTime);
                      Navigator.of(context).pop(selectedTime);
                    },
                    child: const Text('확인'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickTimeButton extends StatelessWidget {
  final String label;
  final int hour;
  final int minute;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuickTimeButton({
    required this.label,
    required this.hour,
    required this.minute,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

// 헬퍼 함수: 간단한 시간 선택 대화상자를 표시
Future<TimeOfDay?> showSimpleTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  String? title,
}) {
  return showDialog<TimeOfDay>(
    context: context,
    builder: (BuildContext context) {
      return SimpleTimePicker(
        initialTime: initialTime,
        title: title ?? '시간 선택',
      );
    },
  );
}