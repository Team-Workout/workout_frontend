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
      child: IntrinsicHeight( // 자동으로 가장 높은 카드에 맞춰 높이 조정
        child: Row(
          children: [
            Expanded(
              child: _buildModernStatCard(
                '현재 체중',
                '${stats!.currentWeight.toStringAsFixed(1)}kg',
                stats!.weightChange >= 0
                    ? '+${stats!.weightChange.toStringAsFixed(1)}kg'
                    : '${stats!.weightChange.toStringAsFixed(1)}kg',
                const LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)]),
                Icons.monitor_weight,
                (stats!.currentWeight / 120).clamp(0.0, 1.0),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildModernStatCard(
                'BMI',
                stats!.bmi.toStringAsFixed(1),
                _getBMICategory(stats!.bmi),
                const LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)]),
                Icons.health_and_safety,
                _getBMIProgress(stats!.bmi),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildModernStatCard(
                '체지방률',
                '${stats!.bodyFatPercentage.toStringAsFixed(1)}%',
                _getBodyFatCategory(stats!.bodyFatPercentage),
                const LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)]),
                Icons.speed,
                (stats!.bodyFatPercentage / 35).clamp(0.0, 1.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight( // 자동으로 가장 높은 카드에 맞춰 높이 조정
        child: Row(
          children: [
            Expanded(child: _buildEmptyCard('체중')),
            const SizedBox(width: 8),
            Expanded(child: _buildEmptyCard('BMI')),
            const SizedBox(width: 8),
            Expanded(child: _buildEmptyCard('체지방률')),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(String title) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: NotionColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // 내용에 따라 높이 결정
        children: [
          // 상단: 아이콘
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.help_outline, 
                  size: 20, 
                  color: Colors.grey[400]
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 제목
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: NotionColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          // 값
          const Text(
            '-- ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: NotionColors.textSecondary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          // 부제목
          const Text(
            '데이터 없음',
            style: TextStyle(
              fontSize: 10,
              color: NotionColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernStatCard(
    String title,
    String value,
    String subtitle,
    LinearGradient gradient,
    IconData icon,
    double progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // 내용에 따라 높이 결정
        children: [
          // 상단: 아이콘
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getIconColor(title).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: _getIconColor(title)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 중간: 제목과 값
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: _getIconColor(title),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          // 하단: 부제목
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: _getIconColor(title).withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return '저체중';
    if (bmi < 23.0) return '정상';
    if (bmi < 25.0) return '과체중';
    return '비만';
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 23.0) return Colors.green;
    if (bmi < 25.0) return Colors.orange;
    return Colors.red;
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

  LinearGradient _getBMIGradient(double bmi) {
    if (bmi < 18.5) return const LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF03DAC6)]);
    if (bmi < 23.0) return const LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)]);
    if (bmi < 25.0) return const LinearGradient(colors: [Color(0xFFFF9800), Color(0xFFFFC107)]);
    return const LinearGradient(colors: [Color(0xFFFF5722), Color(0xFFE91E63)]);
  }

  LinearGradient _getBodyFatGradient(double bodyFat) {
    if (bodyFat < 10) return const LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF03DAC6)]);
    if (bodyFat < 15) return const LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)]);
    if (bodyFat < 20) return const LinearGradient(colors: [Color(0xFF8BC34A), Color(0xFFCDDC39)]);
    if (bodyFat < 25) return const LinearGradient(colors: [Color(0xFFFF9800), Color(0xFFFFC107)]);
    return const LinearGradient(colors: [Color(0xFFFF5722), Color(0xFFE91E63)]);
  }

  double _getBMIProgress(double bmi) {
    // BMI 35를 최대값으로 설정하고 정규화
    return (bmi / 35).clamp(0.0, 1.0);
  }

  Color _getIconColor(String title) {
    switch (title) {
      case '현재 체중':
        return const Color(0xFF10B981); // Green
      case 'BMI':
        return const Color(0xFF6366F1); // Purple
      case '체지방률':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }
}