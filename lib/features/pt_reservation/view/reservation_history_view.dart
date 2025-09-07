import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../model/reservation_models.dart';
import '../viewmodel/reservation_viewmodel.dart';
import '../../../core/providers/auth_provider.dart';
import '../../dashboard/widgets/notion_button.dart';

class ReservationHistoryView extends ConsumerStatefulWidget {
  const ReservationHistoryView({super.key});

  @override
  ConsumerState<ReservationHistoryView> createState() => _ReservationHistoryViewState();
}

class _ReservationHistoryViewState extends ConsumerState<ReservationHistoryView> {
  DateTime? startDate;
  DateTime? endDate;
  String selectedPeriod = '전체';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reservationHistoryViewModelProvider.notifier).loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(reservationHistoryViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          '예약 내역',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: historyState.when(
              data: (response) {
                if (response == null || response.data.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          '예약 내역이 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(reservationHistoryViewModelProvider.notifier).loadHistory(
                      startDate: startDate,
                      endDate: endDate,
                    );
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: response.data.length,
                    itemBuilder: (context, index) {
                      final reservation = response.data[index];
                      return _HistoryCard(
                        reservation: reservation,
                        onTap: () => _showHistoryDetail(reservation),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      error.toString(),
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    NotionButton(
                      onPressed: () {
                        ref.read(reservationHistoryViewModelProvider.notifier).loadHistory(
                          startDate: startDate,
                          endDate: endDate,
                        );
                      },
                      text: '다시 시도',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '기간:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _PeriodChip(
                        label: '전체',
                        isSelected: selectedPeriod == '전체',
                        onTap: () => _onPeriodChanged('전체'),
                      ),
                      const SizedBox(width: 8),
                      _PeriodChip(
                        label: '최근 1주일',
                        isSelected: selectedPeriod == '최근 1주일',
                        onTap: () => _onPeriodChanged('최근 1주일'),
                      ),
                      const SizedBox(width: 8),
                      _PeriodChip(
                        label: '최근 1개월',
                        isSelected: selectedPeriod == '최근 1개월',
                        onTap: () => _onPeriodChanged('최근 1개월'),
                      ),
                      const SizedBox(width: 8),
                      _PeriodChip(
                        label: '최근 3개월',
                        isSelected: selectedPeriod == '최근 3개월',
                        onTap: () => _onPeriodChanged('최근 3개월'),
                      ),
                      const SizedBox(width: 8),
                      _PeriodChip(
                        label: '직접 설정',
                        isSelected: selectedPeriod == '직접 설정',
                        onTap: () => _onPeriodChanged('직접 설정'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (selectedPeriod == '직접 설정') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _selectStartDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: '시작일',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: Text(
                        startDate != null
                            ? DateFormat('yyyy-MM-dd').format(startDate!)
                            : '날짜 선택',
                        style: TextStyle(
                          fontSize: 14,
                          color: startDate != null ? Colors.black : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _selectEndDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: '종료일',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: Text(
                        endDate != null
                            ? DateFormat('yyyy-MM-dd').format(endDate!)
                            : '날짜 선택',
                        style: TextStyle(
                          fontSize: 14,
                          color: endDate != null ? Colors.black : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: NotionButton(
                onPressed: _applyDateFilter,
                text: '적용',
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _onPeriodChanged(String period) {
    setState(() {
      selectedPeriod = period;
      
      switch (period) {
        case '전체':
          startDate = null;
          endDate = null;
          break;
        case '최근 1주일':
          endDate = DateTime.now();
          startDate = endDate!.subtract(const Duration(days: 7));
          break;
        case '최근 1개월':
          endDate = DateTime.now();
          startDate = DateTime(endDate!.year, endDate!.month - 1, endDate!.day);
          break;
        case '최근 3개월':
          endDate = DateTime.now();
          startDate = DateTime(endDate!.year, endDate!.month - 3, endDate!.day);
          break;
        case '직접 설정':
          // User will select dates manually
          return;
      }
    });
    
    if (period != '직접 설정') {
      _applyDateFilter();
    }
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() {
        startDate = date;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() {
        endDate = date;
      });
    }
  }

  void _applyDateFilter() {
    ref.read(reservationHistoryViewModelProvider.notifier).loadHistory(
      startDate: startDate,
      endDate: endDate,
    );
  }

  void _showHistoryDetail(ReservationRequest reservation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _HistoryDetailSheet(reservation: reservation),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final ReservationRequest reservation;
  final VoidCallback onTap;

  const _HistoryCard({
    required this.reservation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${reservation.trainerName} 트레이너',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reservation.type.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: reservation.status.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      reservation.status.displayName,
                      style: TextStyle(
                        color: reservation.status.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          '예약 시간: ${DateFormat('yyyy년 M월 d일 HH:mm').format(reservation.requestedDateTime)}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          '운동 시간: ${reservation.durationMinutes}분',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '요청일: ${DateFormat('yyyy-MM-dd').format(reservation.createdAt)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  if (reservation.responseAt != null)
                    Text(
                      '응답일: ${DateFormat('yyyy-MM-dd').format(reservation.responseAt!)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryDetailSheet extends ConsumerWidget {
  final ReservationRequest reservation;

  const _HistoryDetailSheet({required this.reservation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '예약 내역 상세',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: reservation.status.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          reservation.status.displayName,
                          style: TextStyle(
                            color: reservation.status.color,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _DetailSection(
                    title: '기본 정보',
                    children: [
                      _DetailItem(title: '유형', value: reservation.type.displayName),
                      _DetailItem(title: '트레이너', value: reservation.trainerName),
                      _DetailItem(title: '회원', value: reservation.memberName),
                      _DetailItem(
                        title: '예약 시간',
                        value: DateFormat('yyyy년 M월 d일 HH:mm').format(reservation.requestedDateTime),
                      ),
                      _DetailItem(title: '운동 시간', value: '${reservation.durationMinutes}분'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _DetailSection(
                    title: '메시지',
                    children: [
                      if (reservation.message != null)
                        _MessageCard(
                          title: '요청 메시지',
                          message: reservation.message!,
                          color: Colors.blue,
                        ),
                      if (reservation.responseMessage != null)
                        _MessageCard(
                          title: '응답 메시지',
                          message: reservation.responseMessage!,
                          color: reservation.status == ReservationStatus.approved 
                              ? Colors.green 
                              : Colors.red,
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _DetailSection(
                    title: '일정',
                    children: [
                      _DetailItem(
                        title: '요청일',
                        value: DateFormat('yyyy년 M월 d일 HH:mm').format(reservation.createdAt),
                      ),
                      if (reservation.responseAt != null)
                        _DetailItem(
                          title: '응답일',
                          value: DateFormat('yyyy년 M월 d일 HH:mm').format(reservation.responseAt!),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String title;
  final String value;

  const _DetailItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$title:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final String title;
  final String message;
  final Color color;

  const _MessageCard({
    required this.title,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.message, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}