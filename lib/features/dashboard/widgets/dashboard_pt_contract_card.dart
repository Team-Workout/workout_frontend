import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../pt_contracts/viewmodel/pt_contract_viewmodel.dart';
import '../../pt_contracts/model/pt_contract_model.dart';
import '../../../core/theme/notion_colors.dart';

class DashboardPtContractCard extends ConsumerWidget {
  const DashboardPtContractCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.push('/pt-contracts'),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF27AE60).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.description_outlined,
                          color: const Color(0xFF27AE60),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '현재 PT 계약',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: NotionColors.black,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '자세히 보기',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontFamily: 'IBMPlexSansKR',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _ContractInfo(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContractInfo extends ConsumerWidget {
  const _ContractInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contractAsync = ref.watch(latestActiveContractProvider);

    return contractAsync.when(
      loading: () => Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF27AE60),
          ),
        ),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[600],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              '계약 정보를 불러올 수 없습니다',
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ],
        ),
      ),
      data: (contract) {
        if (contract == null) {
          return const _NoContractState();
        }
        return _ActiveContractState(contract: contract);
      },
    );
  }
}

class _NoContractState extends StatelessWidget {
  const _NoContractState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.grey[600],
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            '진행 중인 PT 계약이 없습니다',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '새로운 PT를 시작해보세요!',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontFamily: 'IBMPlexSansKR',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveContractState extends StatelessWidget {
  final PtContract contract;

  const _ActiveContractState({required this.contract});

  @override
  Widget build(BuildContext context) {
    final paymentDate = DateTime.parse(contract.paymentDate);
    final formattedDate = DateFormat('MM월 dd일').format(paymentDate);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF27AE60).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF27AE60).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                contract.trainerName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF27AE60),
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF27AE60),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '진행중',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ContractStat('잔여 횟수', '${contract.remainingSessions}회'),
              _ContractStat('다음 결제일', formattedDate),
              _ContractStat('총 계약 금액', '${NumberFormat('#,###').format(contract.price)}원'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContractStat extends StatelessWidget {
  final String label;
  final String value;

  const _ContractStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF27AE60),
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
      ],
    );
  }
}