import 'package:flutter/material.dart';
import '../../core/theme/notion_colors.dart';

/// 🎨 Notion 스타일 대시보드 카드
/// 모노톤 미니멀 디자인
class NotionDashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isHighlighted;  // 강조가 필요한 경우 (PT 신청 대기 등)
  
  const NotionDashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighlighted 
              ? const Color(0xFF10B981) 
              : const Color(0xFF10B981).withOpacity(0.2),
          width: isHighlighted ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          hoverColor: NotionColors.hover,
          splashColor: NotionColors.gray100,
          highlightColor: NotionColors.selected,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 아이콘
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isHighlighted 
                        ? const Color(0xFF10B981) 
                        : const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    icon,
                    color: isHighlighted 
                        ? Colors.white 
                        : const Color(0xFF10B981),
                    size: 18,
                  ),
                ),
                const SizedBox(height: 10),
                // 콘텐츠
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: TextStyle(
                        color: isHighlighted 
                            ? const Color(0xFF10B981) 
                            : const Color(0xFF10B981).withOpacity(0.9),
                        fontSize: 13,
                        fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 화살표 아이콘 (우측 하단)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.arrow_forward,
                    color: const Color(0xFF10B981).withOpacity(0.4),
                    size: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 🎯 Notion 스타일 통계 카드 (차트용)
class NotionStatCard extends StatelessWidget {
  final String title;
  final Widget child;
  final String? subtitle;
  final Widget? action;
  
  const NotionStatCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NotionColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: NotionColors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: NotionColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          color: NotionColors.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
                if (action != null) action!,
              ],
            ),
          ),
          
          // Divider
          const Divider(
            height: 1,
            thickness: 1,
            color: NotionColors.divider,
          ),
          
          // 콘텐츠
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }
}