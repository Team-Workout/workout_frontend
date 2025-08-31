import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../pt_contract/model/pt_contract_models.dart';
import '../../pt_contract/viewmodel/pt_contract_viewmodel.dart';
import '../../../core/providers/auth_provider.dart';

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
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'PT 약속 생성',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
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
              ElevatedButton(
                onPressed: () {
                  ref.read(ptContractViewModelProvider.notifier).loadMyContracts();
                },
                child: const Text('다시 시도'),
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
                          '${contract.trainerName} 트레이너',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${contract.memberName} 회원',
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
                      color: _getStatusColor(contract.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      contract.status,
                      style: TextStyle(
                        color: _getStatusColor(contract.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.fitness_center, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${contract.remainingSessions}/${contract.totalSessions} 회 남음',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  if (contract.price != null)
                    Text(
                      '${NumberFormat('#,###').format(contract.price!)}원',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (contract.startDate != null)
                Text(
                  '시작일: ${contract.startDate}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
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
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PT 약속 생성',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.contract.trainerName} 트레이너와 ${widget.contract.memberName} 회원',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '시작 시간',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectStartTime(),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          startTime != null
                              ? DateFormat('yyyy년 M월 d일 HH:mm').format(startTime!)
                              : '시작 시간을 선택해주세요',
                          style: TextStyle(
                            color: startTime != null ? Colors.black : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '소요 시간',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
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
                  const SizedBox(height: 8),
                  Text(
                    '종료 시간: ${DateFormat('HH:mm').format(endTime!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _canSubmit() && !isLoading ? _submitAppointment : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            '약속 생성하기',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
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
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
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
          const SnackBar(
            content: Text('PT 약속이 생성되었습니다.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: $error'),
            backgroundColor: Colors.red,
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.orange : Colors.grey[300]!,
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
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}