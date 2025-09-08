import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime) onDateSelected;
  
  const CustomDatePicker({
    Key? key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime currentDate;
  late DateTime displayedMonth;
  
  @override
  void initState() {
    super.initState();
    currentDate = widget.initialDate;
    displayedMonth = DateTime(currentDate.year, currentDate.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF10B981), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildWeekDays(),
          Expanded(child: _buildCalendar()),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _previousMonth,
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          ),
          GestureDetector(
            onTap: _showYearMonthPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                DateFormat('yyyy년 MM월').format(displayedMonth),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: _nextMonth,
            icon: const Icon(Icons.chevron_right, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDays() {
    const weekDays = ['일', '월', '화', '수', '목', '금', '토'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: weekDays.map((day) => Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                color: const Color(0xFF10B981),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildCalendar() {
    final firstDayOfMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final lastDayOfMonth = DateTime(displayedMonth.year, displayedMonth.month + 1, 0);
    final startDate = firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday % 7));
    
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 42, // 6 weeks * 7 days
      itemBuilder: (context, index) {
        final date = startDate.add(Duration(days: index));
        final isCurrentMonth = date.month == displayedMonth.month;
        final isSelected = date.day == currentDate.day &&
                          date.month == currentDate.month &&
                          date.year == currentDate.year;
        final isToday = date.day == DateTime.now().day &&
                       date.month == DateTime.now().month &&
                       date.year == DateTime.now().year;
        
        return GestureDetector(
          onTap: isCurrentMonth ? () => _selectDate(date) : null,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected 
                  ? const Color(0xFF10B981)
                  : isToday && isCurrentMonth
                      ? const Color(0xFF10B981).withValues(alpha: 0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isToday && !isSelected && isCurrentMonth
                  ? Border.all(color: const Color(0xFF10B981), width: 1)
                  : null,
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : isCurrentMonth
                          ? Colors.black87
                          : Colors.grey.withValues(alpha: 0.4),
                  fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '취소',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onDateSelected(currentDate);
              Navigator.of(context).pop(currentDate);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '선택',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      displayedMonth = DateTime(displayedMonth.year, displayedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      displayedMonth = DateTime(displayedMonth.year, displayedMonth.month + 1, 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      currentDate = date;
    });
  }

  void _showYearMonthPicker() {
    showDialog(
      context: context,
      builder: (context) => _YearMonthPickerDialog(
        initialYear: displayedMonth.year,
        initialMonth: displayedMonth.month,
        firstYear: widget.firstDate.year,
        lastYear: widget.lastDate.year,
        onYearMonthSelected: (year, month) {
          setState(() {
            displayedMonth = DateTime(year, month, 1);
          });
        },
      ),
    );
  }
}

class _YearMonthPickerDialog extends StatefulWidget {
  final int initialYear;
  final int initialMonth;
  final int firstYear;
  final int lastYear;
  final Function(int year, int month) onYearMonthSelected;

  const _YearMonthPickerDialog({
    required this.initialYear,
    required this.initialMonth,
    required this.firstYear,
    required this.lastYear,
    required this.onYearMonthSelected,
  });

  @override
  State<_YearMonthPickerDialog> createState() => _YearMonthPickerDialogState();
}

class _YearMonthPickerDialogState extends State<_YearMonthPickerDialog> {
  late int selectedYear;
  late int selectedMonth;
  late ScrollController _yearScrollController;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialYear;
    selectedMonth = widget.initialMonth;
    
    _yearScrollController = ScrollController();
    
    // 위젯이 빌드된 후 스크롤 위치 조정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_yearScrollController.hasClients) {
        // 선택된 년도가 화면 중앙에 오도록 스크롤
        final int selectedIndex = selectedYear - widget.firstYear;
        final double itemHeight = 40.0; // margin + padding 포함한 아이템 높이
        final double targetOffset = selectedIndex * itemHeight - 80.0; // 위쪽에 약간 여백
        
        _yearScrollController.animateTo(
          targetOffset.clamp(0.0, _yearScrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _yearScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 300,
        height: 400,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF10B981), width: 2),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF34D399)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.date_range, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    '년도 / 월 선택',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildYearPicker()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildMonthPicker()),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    '취소',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onYearMonthSelected(selectedYear, selectedMonth);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '선택',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearPicker() {
    return Column(
      children: [
        Text(
          '년도',
          style: TextStyle(
            color: const Color(0xFF10B981),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            controller: _yearScrollController,
            itemCount: widget.lastYear - widget.firstYear + 1,
            itemBuilder: (context, index) {
              final year = widget.firstYear + index;
              final isSelected = year == selectedYear;
              return GestureDetector(
                onTap: () => setState(() => selectedYear = year),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$year',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMonthPicker() {
    const months = ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'];
    
    return Column(
      children: [
        Text(
          '월',
          style: TextStyle(
            color: const Color(0xFF10B981),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: 12,
            itemBuilder: (context, index) {
              final month = index + 1;
              final isSelected = month == selectedMonth;
              return GestureDetector(
                onTap: () => setState(() => selectedMonth = month),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      months[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Helper function to show the custom date picker
Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showDialog<DateTime>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: CustomDatePicker(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        onDateSelected: (date) {},
      ),
    ),
  );
}