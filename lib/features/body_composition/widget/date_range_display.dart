import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../viewmodel/body_composition_viewmodel.dart';

class DateRangeDisplay extends ConsumerWidget {
  final VoidCallback onShowDatePicker;

  const DateRangeDisplay({
    Key? key,
    required this.onShowDatePicker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ref.watch(dateRangeProvider);
    final dateFormat = DateFormat('yyyy년 MM월 dd일');

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF10B981).withValues(alpha: 0.08),
                const Color(0xFF34D399).withValues(alpha: 0.05),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.date_range,
                    color: Color(0xFF10B981), size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${dateFormat.format(dateRange.startDate)} - ${dateFormat.format(dateRange.endDate)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1F36),
                  ),
                ),
              ),
              TextButton(
                onPressed: onShowDatePicker,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF10B981),
                ),
                child: const Text(
                  '변경',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildQuickDateButton(ref, '최근 7일', DateRangeType.oneWeek, () {
                ref.read(dateRangeProvider.notifier).setQuickDateRange(DateRangeType.oneWeek);
                _refreshData(ref);
              }),
              const SizedBox(width: 8),
              _buildQuickDateButton(ref, '최근 30일', DateRangeType.oneMonth, () {
                ref.read(dateRangeProvider.notifier).setQuickDateRange(DateRangeType.oneMonth);
                _refreshData(ref);
              }),
              const SizedBox(width: 8),
              _buildQuickDateButton(ref, '최근 3개월', DateRangeType.threeMonths, () {
                ref.read(dateRangeProvider.notifier).setQuickDateRange(DateRangeType.threeMonths);
                _refreshData(ref);
              }),
              const SizedBox(width: 8),
              _buildQuickDateButton(ref, '최근 6개월', DateRangeType.sixMonths, () {
                ref.read(dateRangeProvider.notifier).setQuickDateRange(DateRangeType.sixMonths);
                _refreshData(ref);
              }),
              const SizedBox(width: 8),
              _buildQuickDateButton(ref, '최근 1년', DateRangeType.oneYear, () {
                ref.read(dateRangeProvider.notifier).setQuickDateRange(DateRangeType.oneYear);
                _refreshData(ref);
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickDateButton(WidgetRef ref, String label, DateRangeType type, VoidCallback onTap) {
    final dateRange = ref.watch(dateRangeProvider);
    final isSelected = dateRange.selectedType == type;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10B981) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected 
              ? const Color(0xFF10B981) 
              : const Color(0xFF10B981).withValues(alpha: 0.2)
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withValues(alpha: isSelected ? 0.2 : 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF10B981),
          ),
        ),
      ),
    );
  }

  void _refreshData(WidgetRef ref) {
    final dateRange = ref.read(dateRangeProvider);
    ref.read(bodyCompositionNotifierProvider.notifier).loadBodyCompositions(
          startDate: dateRange.startDate.toIso8601String().split('T')[0],
          endDate: dateRange.endDate.toIso8601String().split('T')[0],
        );
  }

  void _updateDateRange(WidgetRef ref, DateTime startDate, DateTime endDate, BuildContext context) {
    ref.read(dateRangeProvider.notifier).updateDateRange(startDate, endDate);

    ref.read(bodyCompositionNotifierProvider.notifier).loadBodyCompositions(
          startDate: startDate.toIso8601String().split('T')[0],
          endDate: endDate.toIso8601String().split('T')[0],
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '날짜 범위 업데이트: ${DateFormat('MM/dd').format(startDate)} - ${DateFormat('MM/dd').format(endDate)}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 6,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}