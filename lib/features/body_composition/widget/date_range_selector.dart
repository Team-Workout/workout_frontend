import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../viewmodel/body_composition_viewmodel.dart';

class DateRangeSelector extends ConsumerWidget {
  const DateRangeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(dateRangeProvider.notifier);
    final state = ref.watch(dateRangeProvider);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.date_range, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              const Text(
                '조회 기간',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQuickDateButton('최근', DateRangeType.oneMonth, state.selectedType == DateRangeType.oneMonth, () => viewModel.setQuickDateRange(DateRangeType.oneMonth)),
                const SizedBox(width: 8),
                _buildQuickDateButton('전체', DateRangeType.oneYear, state.selectedType == DateRangeType.oneYear, () => viewModel.setQuickDateRange(DateRangeType.oneYear)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDateButton(String label, DateRangeType type, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10B981) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected 
              ? const Color(0xFF10B981) 
              : const Color(0xFF10B981).withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                ? const Color(0xFF10B981).withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
              blurRadius: isSelected ? 10 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

}