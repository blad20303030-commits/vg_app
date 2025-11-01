import 'package:flutter/material.dart';

/// 🎨 Цветовая палитра VG App (основана на "Пример дизайна 2.webp")
const Color vgPrimary = Color(0xFFE4572E); // кораллово-оранжевый акцент
const Color vgBackground = Color(0xFFF9F9FB); // общий фон
const Color vgSurface = Color(0xFFFFFFFF); // карточки / панели
const Color vgBorder = Color(0xFFE0E3EB); // линии, контуры, разделители
const Color vgTextMain = Color(0xFF1E1E1E); // основной текст
const Color vgTextSub = Color(0xFF7A7A7A); // второстепенный текст
const Color vgHover = Color(0xFFFFF2EE); // подсветка при наведении
const Color vgError = Color(0xFFE53935); // ошибки / предупреждения

ThemeData buildLightTheme() {
  final base = ThemeData.light(useMaterial3: true);

  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: vgPrimary,
    onPrimary: Colors.white,
    secondary: vgBorder,
    onSecondary: vgTextMain,
    surface: vgSurface,
    onSurface: vgTextMain,
    background: vgBackground,
    onBackground: vgTextMain,
    error: vgError,
    onError: Colors.white,
  );

  return base.copyWith(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: vgBackground,
    cardTheme: CardThemeData(
      color: vgSurface,
      shadowColor: Colors.black.withOpacity(0.05),
      elevation: 2,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: vgBorder, width: 0.5),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: vgSurface,
      foregroundColor: vgTextMain,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: vgTextMain,
      ),
      iconTheme: const IconThemeData(color: vgPrimary),
    ),
    textTheme: base.textTheme.copyWith(
      headlineSmall: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 22,
        color: vgTextMain,
      ),
      titleMedium: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: vgTextMain,
      ),
      bodyMedium: const TextStyle(fontSize: 14, color: vgTextSub),
      labelLarge: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: vgPrimary,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: vgSurface,
      hintStyle: const TextStyle(color: vgTextSub),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: vgBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: vgPrimary, width: 1.2),
      ),
    ),
    iconTheme: const IconThemeData(color: vgPrimary),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: vgPrimary,
      foregroundColor: Colors.white,
    ),
    splashColor: vgHover.withOpacity(0.4),
    highlightColor: Colors.transparent,
    dividerColor: vgBorder,
    dividerTheme: const DividerThemeData(
      color: vgBorder,
      thickness: 0.5,
      space: 1,
    ),
  );
}
