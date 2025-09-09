import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../model/body_composition_model.dart';
import '../viewmodel/body_composition_viewmodel.dart';
import '../../dashboard/widgets/notion_button.dart';

class BodyDataListSection extends ConsumerWidget {
  final List<BodyComposition> compositions;

  const BodyDataListSection({
    Key? key,
    required this.compositions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (compositions.isEmpty) return const SizedBox.shrink();

    final sortedCompositions = List<BodyComposition>.from(compositions)
      ..sort((a, b) => b.measurementDate.compareTo(a.measurementDate));

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '체성분 데이터 목록',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${sortedCompositions.length}개 항목',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...sortedCompositions.map((composition) => 
            _buildDataListItem(context, ref, composition)).toList(),
        ],
      ),
    );
  }

  Widget _buildDataListItem(BuildContext context, WidgetRef ref, BodyComposition composition) {
    final dateFormat = DateFormat('yyyy년 MM월 dd일');
    final bodyFatPercentage = (composition.fatKg / composition.weightKg) * 100;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFormat.format(DateTime.parse(composition.measurementDate)),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildDataPoint(
                        '체중', 
                        '${composition.weightKg.toStringAsFixed(1)}kg',
                        Icons.monitor_weight,
                      ),
                    ),
                    Expanded(
                      child: _buildDataPoint(
                        '체지방', 
                        '${bodyFatPercentage.toStringAsFixed(1)}%',
                        Icons.pie_chart,
                      ),
                    ),
                    Expanded(
                      child: _buildDataPoint(
                        '근육량', 
                        '${composition.muscleMassKg.toStringAsFixed(1)}kg',
                        Icons.fitness_center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => _showDeleteConfirmDialog(context, ref, composition),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 20,
              ),
            ),
            tooltip: '삭제',
          ),
        ],
      ),
    );
  }

  Widget _buildDataPoint(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon, 
              size: 14, 
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1F36),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, WidgetRef ref, BodyComposition composition) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 헤더 영역
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: const Icon(
                        Icons.warning_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '데이터 삭제',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IBMPlexSansKR',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '체성분 데이터 삭제',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontFamily: 'IBMPlexSansKR',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 콘텐츠 영역
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFF6B6B).withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(composition.measurementDate))}의',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                              fontFamily: 'IBMPlexSansKR',
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '체성분 데이터를 삭제하시겠습니까?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                              fontFamily: 'IBMPlexSansKR',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Colors.orange[600],
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  '이 작업은 되돌릴 수 없습니다.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF718096),
                                    fontFamily: 'IBMPlexSansKR',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 버튼 영역
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text(
                              '취소',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF718096),
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B6B),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () async {
                              Navigator.pop(context);
                              try {
                                // 체성분 데이터 삭제
                                await ref
                                    .read(bodyCompositionNotifierProvider.notifier)
                                    .deleteBodyComposition(composition.id);
                                
                                // 모든 관련 Provider 강제 새로고침
                                ref.invalidate(bodyCompositionListProvider);
                                ref.invalidate(bodyStatsProvider);
                                
                                // 지연 후 한 번 더 invalidate (캐싱 문제 해결)
                                await Future.delayed(const Duration(milliseconds: 100));
                                ref.invalidate(bodyCompositionListProvider);
                                ref.invalidate(bodyStatsProvider);
                                
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('체성분 데이터가 삭제되었습니다.'),
                                      backgroundColor: Color(0xFF10B981),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('삭제 실패: ${e.toString()}'),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                }
                              }
                            },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: const Text(
                              '삭제',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'IBMPlexSansKR',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}