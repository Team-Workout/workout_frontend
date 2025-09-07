import 'package:flutter/material.dart';

/// 🎨 Notion 스타일 모노톤 컬러 시스템
/// 흰색, 검은색, 회색만으로 구성된 미니멀 디자인
class NotionColors {
  NotionColors._(); // private constructor

  // 🔲 기본 모노톤
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF191919);

  // 🌫️ 회색 스케일 (Notion 기반)
  static const Color gray50 = Color(0xFFF9FAFB); // 거의 흰색 (배경)
  static const Color gray100 = Color(0xFFF3F4F6); // 매우 연한 회색 (카드 배경)
  static const Color gray200 = Color(0xFFE5E7EB); // 연한 회색 (border)
  static const Color gray300 = Color(0xFFD1D5DB); // 중간 연한 회색
  static const Color gray400 = Color(0xFF9CA3AF); // 중간 회색 (placeholder)
  static const Color gray500 = Color(0xFF6B7280); // 중간 진한 회색 (보조 텍스트)
  static const Color gray600 = Color(0xFF4B5563); // 진한 회색
  static const Color gray700 = Color(0xFF374151); // 매우 진한 회색
  static const Color gray800 = Color(0xFF1F2937); // 거의 검은색
  static const Color gray900 = Color(0xFF111827); // 검은색에 가까운

  // 📝 텍스트 컬러
  static const Color textPrimary = black;
  static const Color textSecondary = gray600;
  static const Color textTertiary = gray500;
  static const Color textPlaceholder = gray400;
  static const Color textOnDark = white;

  // 🎯 UI 요소
  static const Color background = white;
  static const Color surface = white;
  static const Color cardBackground = white;
  static const Color border = gray200;
  static const Color divider = gray200;
  static const Color hover = gray50;
  static const Color selected = gray100;

  // 🔵 최소한의 액센트 (노션의 파란색)
  static const Color accent = Color(0xFF0070F3); // 노션 블루
  static const Color accentLight = Color(0xFFE8F4FD);

  // ⚠️ 상태 컬러 (모노톤으로 변환)
  static const Color success = gray800;
  static const Color warning = gray700;
  static const Color error = black;
  static const Color info = gray600;
}

/// 🎨 Notion 스타일 테마
class NotionTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // 컬러 스킴
      colorScheme: const ColorScheme.light(
        primary: NotionColors.black,
        secondary: NotionColors.gray600,
        surface: NotionColors.surface,
        background: NotionColors.background,
        error: NotionColors.black,
        onPrimary: NotionColors.white,
        onSecondary: NotionColors.white,
        onSurface: NotionColors.black,
        onBackground: NotionColors.black,
        onError: NotionColors.white,
      ),

      // 스캐폴드 배경
      scaffoldBackgroundColor: NotionColors.gray50,

      // AppBar 테마
      appBarTheme: const AppBarTheme(
        backgroundColor: NotionColors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        iconTheme: IconThemeData(color: NotionColors.black),
        titleTextStyle: TextStyle(
          color: NotionColors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),

      // 카드 테마
      cardTheme: CardThemeData(
        color: NotionColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: NotionColors.border, width: 1),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: NotionColors.black,
          side: const BorderSide(color: NotionColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: NotionColors.gray600,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        ),
      ),

      // Input 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NotionColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: NotionColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: NotionColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: NotionColors.black, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        hintStyle: const TextStyle(color: NotionColors.textPlaceholder),
      ),

      // 탭 테마
      tabBarTheme: const TabBarThemeData(
        labelColor: NotionColors.black,
        unselectedLabelColor: NotionColors.gray500,
        indicatorColor: NotionColors.black,
        labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        unselectedLabelStyle:
            TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
      ),

      // Divider 테마
      dividerTheme: const DividerThemeData(
        color: NotionColors.divider,
        thickness: 1,
      ),

      // Icon 테마
      iconTheme: const IconThemeData(
        color: NotionColors.gray600,
        size: 20,
      ),
    );
  }
}
