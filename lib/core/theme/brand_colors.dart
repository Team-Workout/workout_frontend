import 'package:flutter/material.dart';

/// 🎨 브랜드 컬러 시스템
/// 로고에서 추출한 브랜드 아이덴티티 컬러
class BrandColors {
  BrandColors._(); // private constructor

  // 🔵 Primary Blue (신뢰감, 전문성)
  static const Color primaryBlue = Color(0xFF4F8FFF);
  static const Color primaryBlue100 = Color(0xFFE8F2FF); // 매우 연한
  static const Color primaryBlue200 = Color(0xFFCCE4FF); // 연한
  static const Color primaryBlue300 = Color(0xFF99CCFF); // 중간
  static const Color primaryBlue700 = Color(0xFF3B73CC); // 진한
  static const Color primaryBlue900 = Color(0xFF1E3A66); // 매우 진한

  // 🟢 Primary Green (성장, 건강, 성공)
  static const Color primaryGreen = Color(0xFF42D7A5);
  static const Color primaryGreen100 = Color(0xFFE6F8F2); // 매우 연한
  static const Color primaryGreen200 = Color(0xFFCCF0E5); // 연한
  static const Color primaryGreen300 = Color(0xFF99E1CB); // 중간
  static const Color primaryGreen700 = Color(0xFF35B88A); // 진한
  static const Color primaryGreen900 = Color(0xFF1B5C45); // 매우 진한

  // 🌈 그라데이션 (메인 브랜드)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryGreen],
  );

  // 🌈 연한 그라데이션 (배경용)
  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue100, primaryGreen100],
  );

  // 📱 UI 컬러 (기능별)
  static const Color success = primaryGreen;
  static const Color successLight = primaryGreen200;
  static const Color successDark = primaryGreen700;

  static const Color primary = primaryBlue;
  static const Color primaryLight = primaryBlue200;
  static const Color primaryDark = primaryBlue700;

  static const Color accent = primaryGreen;
  static const Color background = Color(0xFFF8FAFE); // 매우 연한 블루 베이스
  static const Color surface = Colors.white;
  static const Color cardBackground = Color(0xFFFDFDFF);

  // 🎯 상태별 컬러
  static const Color active = primaryGreen;
  static const Color inactive = Color(0xFFE0E0E0);
  static const Color warning = Color(0xFFFF8A50);
  static const Color error = Color(0xFFFF5252);
  static const Color info = primaryBlue;

  // 📝 텍스트 컬러
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Colors.white;
}

/// 🎨 브랜드 테마 데이터
class BrandTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: BrandColors.primaryBlue,
        primary: BrandColors.primaryBlue,
        secondary: BrandColors.primaryGreen,
        surface: BrandColors.surface,
        background: BrandColors.background,
      ),
      
      // AppBar 테마
      appBarTheme: const AppBarTheme(
        backgroundColor: BrandColors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: BrandColors.textPrimary),
        titleTextStyle: TextStyle(
          color: BrandColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      // 카드 테마
      cardTheme: CardThemeData(
        color: BrandColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: BrandColors.primaryBlue.withOpacity(0.1),
      ),

      // 버튼 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: BrandColors.primaryBlue,
          foregroundColor: BrandColors.textOnPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),

      // FAB 테마
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: BrandColors.primaryGreen,
        foregroundColor: BrandColors.textOnPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Input 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BrandColors.primaryBlue100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: BrandColors.primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // 탭 테마
      tabBarTheme: const TabBarThemeData(
        labelColor: BrandColors.primaryBlue,
        unselectedLabelColor: BrandColors.textSecondary,
        indicatorColor: BrandColors.primaryBlue,
        labelStyle: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// 🎯 브랜드 그라데이션 컴포넌트
class BrandGradientContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final LinearGradient? gradient;

  const BrandGradientContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient ?? BrandColors.primaryGradient,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

/// 🎨 브랜드 버튼 (그라데이션)
class BrandGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  const BrandGradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: BrandColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: BrandColors.primaryBlue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: BrandColors.textOnPrimary),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: const TextStyle(
                    color: BrandColors.textOnPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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