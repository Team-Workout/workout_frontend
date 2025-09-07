import 'package:flutter/material.dart';
import '../../../core/theme/notion_colors.dart';

class DashboardStat extends StatelessWidget {
  final String label;
  final String value;

  const DashboardStat({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12, 
            color: Colors.grey[600],
            fontFamily: 'IBMPlexSansKR',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: NotionColors.black,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
      ],
    );
  }
}

class DashboardActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DashboardActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: NotionColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: NotionColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: NotionColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: NotionColors.textPrimary,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ],
        ),
      ),
    );
  }
}