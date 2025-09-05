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
        color: NotionColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighlighted ? NotionColors.black : NotionColors.border,
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
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 아이콘
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isHighlighted ? NotionColors.black : NotionColors.gray100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isHighlighted ? NotionColors.white : NotionColors.gray600,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 16),
                // 콘텐츠
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: NotionColors.textTertiary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: Text(
                          value,
                          style: TextStyle(
                            color: isHighlighted ? NotionColors.black : NotionColors.textPrimary,
                            fontSize: 15,
                            fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // 화살표 아이콘 (우측 하단)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.arrow_forward,
                    color: NotionColors.gray300,
                    size: 14,
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}