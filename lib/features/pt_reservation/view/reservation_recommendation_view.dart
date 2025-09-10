import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../pt_contract/model/pt_contract_models.dart';
import '../../pt_contract/viewmodel/pt_contract_viewmodel.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../common/widgets/simple_time_picker.dart';
import '../../dashboard/widgets/notion_button.dart';

class ReservationRecommendationView extends ConsumerStatefulWidget {
  const ReservationRecommendationView({super.key});

  @override
  ConsumerState<ReservationRecommendationView> createState() => _ReservationRecommendationViewState();
}

class _ReservationRecommendationViewState extends ConsumerState<ReservationRecommendationView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ptContractViewModelProvider.notifier).loadMyContracts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final contractState = ref.watch(ptContractViewModelProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF10B981), Color(0xFF34D399), Color(0xFF6EE7B7)],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'PT 예약 생성',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        centerTitle: true,
      ),
      body: user?.userType.name != 'trainer' 
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.block, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  '트레이너만 PT 약속을 생성할 수 있습니다',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          )
        : contractState.when(
        data: (response) {
          if (response == null || response.data.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'PT 계약이 없습니다',
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
            color: const Color(0xFF10B981),
            onRefresh: () async {
              await ref.read(ptContractViewModelProvider.notifier).loadMyContracts();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: response.data.length,
              itemBuilder: (context, index) {
                final contract = response.data[index];
                return _ContractCard(
                  contract: contract,
                  onTap: () => _showCreateAppointmentForContract(contract),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF10B981),
            strokeWidth: 3,
          ),
        ),
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
                  ref.read(ptContractViewModelProvider.notifier).loadMyContracts();
                },
                text: '다시 시도',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateAppointmentForContract(PtContract contract) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateAppointmentSheet(contract: contract),
    );
  }
}

class _ContractCard extends StatelessWidget {
  final PtContract contract;
  final VoidCallback onTap;

  const _ContractCard({
    required this.contract,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // 계약 아이콘
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF34D399)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.handshake,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 계약 정보
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${contract.memberName} 회원',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontFamily: 'IBMPlexSansKR',
                                  ),
                                ),
                              ),
                              _buildStatusBadge(contract.status),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${contract.trainerName} 트레이너',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontFamily: 'IBMPlexSansKR',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // 계약 상세 정보
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.fitness_center,
                            size: 18,
                            color: const Color(0xFF10B981),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '잔여 수업',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontFamily: 'IBMPlexSansKR',
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${contract.remainingSessions}/${contract.totalSessions} 회',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontFamily: 'IBMPlexSansKR',
                            ),
                          ),
                        ],
                      ),
                      if (contract.price != null) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.payments,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '계약 금액',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${NumberFormat('#,###').format(contract.price!)}원',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (contract.startDate != null) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '시작일',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                            const Spacer(),
                            Text(
                              contract.startDate!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // 예약 생성 버튼 영역
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add_circle,
                            size: 16,
                            color: Color(0xFF10B981),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '예약 생성하기',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'IBMPlexSansKR',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor;
    String statusText;
    
    switch (status.toLowerCase()) {
      case 'active':
        statusColor = const Color(0xFF10B981);
        statusText = '활성';
        break;
      case 'inactive':
        statusColor = Colors.red;
        statusText = '비활성';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusText = '대기중';
        break;
      default:
        statusColor = Colors.grey;
        statusText = status;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: 'IBMPlexSansKR',
        ),
      ),
    );
  }
}

class _CreateAppointmentSheet extends ConsumerStatefulWidget {
  final PtContract contract;

  const _CreateAppointmentSheet({required this.contract});

  @override
  ConsumerState<_CreateAppointmentSheet> createState() => _CreateAppointmentSheetState();
}

class _CreateAppointmentSheetState extends ConsumerState<_CreateAppointmentSheet> {
  DateTime? startTime;
  int selectedDurationMinutes = 60; // 기본 1시간
  bool isLoading = false;
  
  DateTime? get endTime => startTime?.add(Duration(minutes: selectedDurationMinutes));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // 드래그 핸들
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 헤더 섹션
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF34D399)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'PT 예약 생성',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.contract.memberName} 회원과 새로운 PT 예약을 만들어보세요',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontFamily: 'IBMPlexSansKR',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 폼 섹션
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.access_time,
                          color: Color(0xFF10B981),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '시작 시간 선택',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectStartTime(),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: const Color(0xFF10B981),
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  startTime != null ? '선택된 시간' : '시작 시간을 선택해주세요',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontFamily: 'IBMPlexSansKR',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  startTime != null
                                      ? DateFormat('yyyy년 M월 d일 HH:mm').format(startTime!)
                                      : '날짜와 시간을 선택해보세요',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: startTime != null ? Colors.black87 : Colors.grey[500],
                                    fontFamily: 'IBMPlexSansKR',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.timer,
                          color: Color(0xFF10B981),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '소요 시간 선택',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _DurationButton(
                        duration: 30,
                        selectedDuration: selectedDurationMinutes,
                        onSelected: (duration) {
                          setState(() {
                            selectedDurationMinutes = duration;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _DurationButton(
                        duration: 60,
                        selectedDuration: selectedDurationMinutes,
                        onSelected: (duration) {
                          setState(() {
                            selectedDurationMinutes = duration;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _DurationButton(
                        duration: 90,
                        selectedDuration: selectedDurationMinutes,
                        onSelected: (duration) {
                          setState(() {
                            selectedDurationMinutes = duration;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _DurationButton(
                        duration: 120,
                        selectedDuration: selectedDurationMinutes,
                        onSelected: (duration) {
                          setState(() {
                            selectedDurationMinutes = duration;
                          });
                        },
                      ),
                    ],
                  ),
                  if (startTime != null && endTime != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            color: Color(0xFF10B981),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '예약 시간 확인',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${DateFormat('HH:mm').format(startTime!)} - ${DateFormat('HH:mm').format(endTime!)} (${selectedDurationMinutes}분)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _canSubmit() && !isLoading ? _submitAppointment : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'PT 예약 생성하기',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canSubmit() {
    return startTime != null && endTime != null && endTime!.isAfter(startTime!);
  }

  Future<void> _selectStartTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showSimpleTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        title: 'PT 시작 시간 선택',
      );

      if (time != null) {
        setState(() {
          startTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }


  Future<void> _submitAppointment() async {
    if (!_canSubmit()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await ref.read(ptContractViewModelProvider.notifier).createAppointment(
        contractId: widget.contract.contractId,
        startTime: startTime!.toIso8601String(),
        endTime: endTime!.toIso8601String(),
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'PT 예약이 성공적으로 생성되었습니다!',
              style: TextStyle(
                fontFamily: 'IBMPlexSansKR',
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'PT 예약 생성에 실패했습니다: $error',
              style: const TextStyle(
                fontFamily: 'IBMPlexSansKR',
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF10B981) : Colors.white,
            border: Border.all(
              color: isSelected ? const Color(0xFF10B981) : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [
              BoxShadow(
                color: const Color(0xFF10B981).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Center(
            child: Text(
              duration >= 60 
                ? '${duration ~/ 60}시간${duration % 60 > 0 ? ' ${duration % 60}분' : ''}'
                : '${duration}분',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ),
        ),
      ),
    );
  }
}