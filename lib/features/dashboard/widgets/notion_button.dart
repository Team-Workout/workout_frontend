import 'package:flutter/material.dart';
import '../../../core/theme/notion_colors.dart';

/// Notion 스타일 버튼 (ElevatedButton 대체용)
class NotionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;
  final double height;
  final EdgeInsetsGeometry padding;

  const NotionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.height = 48,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: Color(0xFF4CAF50),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isOutlined
                ? (onPressed == null || isLoading
                    ? NotionColors.gray300
                    : NotionColors.black)
                : Colors.transparent,
            width: isOutlined ? 1.5 : 0,
          ),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isOutlined ? NotionColors.black : NotionColors.white,
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: 18,
                        color: isOutlined
                            ? (onPressed == null
                                ? NotionColors.gray400
                                : NotionColors.black)
                            : (onPressed == null
                                ? NotionColors.gray500
                                : NotionColors.white),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'IBMPlexSansKR',
                        color: isOutlined
                            ? (onPressed == null
                                ? NotionColors.gray400
                                : NotionColors.black)
                            : (onPressed == null
                                ? NotionColors.gray500
                                : NotionColors.white),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// 작은 Notion 스타일 버튼 (텍스트 버튼 대체용)
class NotionTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  const NotionTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? NotionColors.black;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: onPressed == null ? NotionColors.gray400 : buttonColor,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'IBMPlexSansKR',
                  color: onPressed == null ? NotionColors.gray400 : buttonColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 플로팅 액션 버튼 대체용
class NotionFloatingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? label;
  final bool mini;

  const NotionFloatingButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = mini ? 48.0 : 56.0;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: size,
        padding: EdgeInsets.symmetric(
          horizontal: label != null ? 20 : 0,
        ),
        decoration: BoxDecoration(
          color: onPressed == null ? NotionColors.gray300 : NotionColors.black,
          borderRadius: BorderRadius.circular(size / 2),
          boxShadow: onPressed == null
              ? []
              : [
                  BoxShadow(
                    color: NotionColors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: NotionColors.white,
              size: mini ? 20 : 24,
            ),
            if (label != null) ...[
              const SizedBox(width: 8),
              Text(
                label!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'IBMPlexSansKR',
                  color: NotionColors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
