import 'package:flutter/material.dart';
import '../model/body_composition_model.dart';
import '../../../core/theme/notion_colors.dart';

class BodyStatsCard extends StatelessWidget {
  final BodyStats? stats;

  const BodyStatsCard({
    Key? key,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (stats == null) {
      return _buildEmptyStatsCard();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildHorizontalStatCard(
            '현재 체중',
            '${stats!.currentWeight.toStringAsFixed(1)}kg',
            stats!.weightChange >= 0
                ? '+${stats!.weightChange.toStringAsFixed(1)}kg'
                : '${stats!.weightChange.toStringAsFixed(1)}kg',
            Icons.monitor_weight,
            (stats!.currentWeight / 120).clamp(0.0, 1.0),
          ),
          const SizedBox(height: 12),
          _buildHorizontalStatCard(
            '근육량',
            '${stats!.muscleMass.toStringAsFixed(1)}kg',
            _getMuscleMassCategory(stats!.muscleMass),
            Icons.fitness_center,
            (stats!.muscleMass / 80).clamp(0.0, 1.0),
          ),
          const SizedBox(height: 12),
          _buildHorizontalStatCard(
            '체지방률',
            '${stats!.bodyFatPercentage.toStringAsFixed(1)}%',
            _getBodyFatCategory(stats!.bodyFatPercentage),
            Icons.speed,
            (stats!.bodyFatPercentage / 35).clamp(0.0, 1.0),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildEmptyHorizontalCard('체중'),
          const SizedBox(height: 12),
          _buildEmptyHorizontalCard('근육량'),
          const SizedBox(height: 12),
          _buildEmptyHorizontalCard('체지방률'),
        ],
      ),
    );
  }

  Widget _buildEmptyHorizontalCard(String title) {
    return Container(
      height: 100, // 높이를 좀 더 크게 설정 (80 → 100)
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          // 왼쪽: 아이콘 - 가운데 정렬을 위해 Container 크기 고정
          Container(
            width: 48, // 고정 너비
            height: 48, // 고정 높이
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center( // 아이콘을 정중앙에 배치
              child: Icon(
                Icons.help_outline, 
                size: 24, 
                color: Colors.grey[400]
              ),
            ),
          ),
          const SizedBox(width: 20),
          // 오른쪽: 텍스트 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '--',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey[400],
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '데이터 없음',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    double progress,
  ) {
    return Container(
      height: 100, // 높이를 좀 더 크게 설정 (80 → 100)
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getIconColor(title).withValues(alpha: 0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _getIconColor(title).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          // 왼쪽: 아이콘 - 가운데 정렬을 위해 Container 크기 고정
          Container(
            width: 48, // 고정 너비
            height: 48, // 고정 높이
            decoration: BoxDecoration(
              color: _getIconColor(title).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center( // 아이콘을 정중앙에 배치
              child: Icon(icon, size: 24, color: _getIconColor(title)),
            ),
          ),
          const SizedBox(width: 20),
          // 오른쪽: 텍스트 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: _getIconColor(title),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getIconColor(title).withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMuscleMassCategory(double muscleMass) {
    if (muscleMass < 30) return '낮음';
    if (muscleMass < 40) return '보통';
    if (muscleMass < 50) return '좋음';
    return '우수';
  }

  Color _getMuscleMassColor(double muscleMass) {
    if (muscleMass < 30) return Colors.orange;
    if (muscleMass < 40) return Colors.blue;
    if (muscleMass < 50) return Colors.green;
    return Colors.purple;
  }

  String _getBodyFatCategory(double bodyFat) {
    if (bodyFat < 10) return '매우 낮음';
    if (bodyFat < 15) return '낮음';
    if (bodyFat < 20) return '정상';
    if (bodyFat < 25) return '약간 높음';
    return '높음';
  }

  Color _getBodyFatColor(double bodyFat) {
    if (bodyFat < 10) return Colors.blue;
    if (bodyFat < 15) return Colors.green;
    if (bodyFat < 20) return Colors.lightGreen;
    if (bodyFat < 25) return Colors.orange;
    return Colors.red;
  }


  Color _getIconColor(String title) {
    switch (title) {
      case '현재 체중':
        return const Color(0xFF10B981); // Green
      case '근육량':
        return const Color(0xFF6366F1); // Purple
      case '체지방률':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }
}