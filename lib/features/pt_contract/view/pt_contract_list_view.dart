import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../model/pt_contract_models.dart';
import '../viewmodel/pt_contract_viewmodel.dart';

class PtContractListView extends ConsumerStatefulWidget {
  const PtContractListView({super.key});

  @override
  ConsumerState<PtContractListView> createState() => _PtContractListViewState();
}

class _PtContractListViewState extends ConsumerState<PtContractListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ptContractViewModelProvider.notifier).loadMyContracts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final contractsState = ref.watch(ptContractViewModelProvider);

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
          '내 PT 계약',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: contractsState.when(
        data: (response) {
          if (response == null || response.data.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
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
                  onTap: () => _showContractDetail(contract),
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

  void _showContractDetail(PtContract contract) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ContractDetailSheet(contract: contract),
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
    final isActive = contract.status == 'ACTIVE';
    final statusColor = isActive ? Colors.green : Colors.grey;
    final statusText = isActive ? '진행중' : '완료됨';

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
                    child: Text(
                      '${contract.trainerName} 트레이너',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
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
                  _InfoChip(
                    icon: Icons.fitness_center,
                    label: '${contract.remainingSessions}/${contract.totalSessions}회',
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  if (contract.price != null)
                    _InfoChip(
                      icon: Icons.payment,
                      label: '${_formatPrice(contract.price!)}원',
                      color: Colors.orange,
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

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContractDetailSheet extends ConsumerWidget {
  final PtContract contract;

  const _ContractDetailSheet({required this.contract});

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
                  Text(
                    '${contract.trainerName} 트레이너',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '회원: ${contract.memberName}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _DetailItem(
                    title: '계약 상태',
                    value: contract.status == 'ACTIVE' ? '진행중' : '완료됨',
                    valueColor: contract.status == 'ACTIVE' ? Colors.green : Colors.grey,
                  ),
                  _DetailItem(
                    title: '전체 세션',
                    value: '${contract.totalSessions}회',
                  ),
                  _DetailItem(
                    title: '남은 세션',
                    value: '${contract.remainingSessions}회',
                  ),
                  if (contract.price != null)
                    _DetailItem(
                      title: '계약 금액',
                      value: '${_formatPrice(contract.price!)}원',
                    ),
                  if (contract.startDate != null)
                    _DetailItem(
                      title: '시작일',
                      value: contract.startDate!,
                    ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const _DetailItem({
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

