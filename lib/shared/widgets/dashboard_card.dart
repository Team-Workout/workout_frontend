import 'package:flutter/material.dart';
import '../../core/theme/brand_colors.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  
  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: BrandColors.primaryBlue.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 아이콘 배경을 브랜드 그라데이션으로
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: _getIconGradient(color),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: BrandColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Flexible(
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: BrandColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 색상에 따라 적절한 그라데이션 반환
  LinearGradient _getIconGradient(Color color) {
    // 브랜드 컬러 기반으로 그라데이션 매핑
    if (color == Colors.blue || color == BrandColors.primaryBlue) {
      return LinearGradient(
        colors: [BrandColors.primaryBlue, BrandColors.primaryBlue700],
      );
    } else if (color == Colors.green || color == BrandColors.primaryGreen) {
      return LinearGradient(
        colors: [BrandColors.primaryGreen, BrandColors.primaryGreen700],
      );
    } else if (color == Colors.indigo) {
      return BrandColors.primaryGradient; // 메인 그라데이션
    } else if (color == Colors.red) {
      return LinearGradient(
        colors: [BrandColors.error, const Color(0xFFD32F2F)],
      );
    } else if (color == Colors.orange) {
      return LinearGradient(
        colors: [BrandColors.warning, const Color(0xFFF57C00)],
      );
    } else if (color == Colors.purple) {
      return const LinearGradient(
        colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
      );
    } else if (color == Colors.teal) {
      return LinearGradient(
        colors: [BrandColors.primaryGreen300, BrandColors.primaryGreen700],
      );
    } else if (color == Colors.deepPurple) {
      return const LinearGradient(
        colors: [Color(0xFF673AB7), Color(0xFF512DA8)],
      );
    } else {
      // 기본값: 브랜드 그라데이션
      return BrandColors.primaryGradient;
    }
  }
}