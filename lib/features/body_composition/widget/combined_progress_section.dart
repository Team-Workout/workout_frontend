import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../model/body_composition_model.dart';
import '../model/body_image_model.dart';
import '../viewmodel/body_composition_viewmodel.dart';
import '../../../core/theme/notion_colors.dart';
import '../../../core/config/api_config.dart';
import 'mini_weight_chart.dart';

class CombinedProgressSection extends ConsumerWidget {
  final List<BodyComposition> compositions;

  const CombinedProgressSection({
    Key? key,
    required this.compositions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bodyImagesAsync = ref.watch(bodyImageNotifierProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFF8F9FF),
            Color(0xFFF0F4FF),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 4,
          ),
        ],
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.timeline, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ).createShader(bounds),
                        child: const Text(
                          '나의 변화 기록',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Progress Timeline',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF34D399)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  '몸무게 + 사진',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          bodyImagesAsync.when(
            data: (images) {
              print('=== UI Debug ===');
              print('Body images count in UI: ${images.length}');
              for (final image in images) {
                print('UI Image: ${image.fileUrl} on ${image.recordDate}');
              }
              return _buildCombinedTimeline(compositions, images);
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                ),
              ),
            ),
            error: (error, _) {
              print('Body images error in UI: $error');
              return _buildWeightOnlyTimeline(compositions);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCombinedTimeline(List<BodyComposition> compositions, List<BodyImageResponse> images) {
    final combinedData = <Map<String, dynamic>>[];
    
    // 체성분 데이터 추가
    for (final comp in compositions) {
      combinedData.add({
        'type': 'weight',
        'date': DateTime.parse(comp.measurementDate),
        'weight': comp.weightKg,
        'data': comp,
      });
    }
    
    // 사진 데이터 추가  
    for (final img in images) {
      combinedData.add({
        'type': 'photo',
        'date': DateTime.parse(img.recordDate),
        'data': img,
      });
    }
    
    // 날짜순 정렬 (최신순)
    combinedData.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    
    if (combinedData.isEmpty) {
      return _buildEmptyState();
    }
    
    return Column(
      children: [
        ...combinedData.take(10).map((item) => _buildTimelineItem(item)).toList(),
        if (combinedData.length > 10)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextButton(
              onPressed: () {}, // TODO: Implement _showAllProgressHistory
              child: Text(
                '전체 기록 보기 (${combinedData.length}개)',
                style: TextStyle(
                  color: NotionColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildTimelineItem(Map<String, dynamic> item) {
    final date = item['date'] as DateTime;
    final type = item['type'] as String;
    final dateFormat = DateFormat('MM/dd');
    final timeFormat = DateFormat('HH:mm');
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFormat.format(date),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: NotionColors.black,
                  ),
                ),
                Text(
                  timeFormat.format(date),
                  style: TextStyle(
                    fontSize: 11,
                    color: NotionColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: type == 'weight' ? NotionColors.black : NotionColors.gray500,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 40,
                color: NotionColors.border,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: type == 'weight' 
                ? _buildWeightTimelineCard(item['data'] as BodyComposition, item['weight'] as double)
                : _buildPhotoTimelineCard(item['data'] as BodyImageResponse),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWeightTimelineCard(BodyComposition comp, double weight) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NotionColors.gray100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: NotionColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.monitor_weight_outlined,
            color: NotionColors.black,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weight.toStringAsFixed(1)}kg',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: NotionColors.black,
                  ),
                ),
                Text(
                  '체지방률 ${((comp.fatKg / comp.weightKg) * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: NotionColors.gray500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoTimelineCard(BodyImageResponse image) {
    print('=== Building Photo Card ===');
    print('Image URL: ${image.fileUrl}');
    print('Record Date: ${image.recordDate}');
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF34D399)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.photo_camera,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '체형 사진 촬영',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: NotionColors.black,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                Text(
                  '체형 기록',
                  style: TextStyle(
                    fontSize: 12,
                    color: NotionColors.gray500,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ],
            ),
          ),
          // 실제 이미지 표시
          if (image.fileUrl != null && image.fileUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image.fileUrl!.startsWith('http') 
                    ? image.fileUrl!
                    : '${ApiConfig.baseUrl.replaceAll('/api', '')}${image.fileUrl!.startsWith('/') ? '' : '/'}${image.fileUrl}',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[400],
                      size: 24,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF10B981),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          else
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.image,
                color: Colors.grey[400],
                size: 24,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeightOnlyTimeline(List<BodyComposition> compositions) {
    if (compositions.isEmpty) {
      return _buildEmptyState();
    }
    
    return Column(
      children: [
        ...compositions.take(10).map((comp) {
          return _buildTimelineItem({
            'type': 'weight',
            'date': DateTime.parse(comp.measurementDate),
            'weight': comp.weightKg,
            'data': comp,
          });
        }).toList(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.timeline,
              size: 64,
              color: NotionColors.gray400,
            ),
            const SizedBox(height: 16),
            Text(
              '아직 기록이 없어요',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: NotionColors.gray500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '첫 번째 체성분 측정을 시작해보세요',
              style: TextStyle(
                fontSize: 14,
                color: NotionColors.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}