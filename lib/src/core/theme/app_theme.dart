// lib/src/core/theme/app_theme.dart
// -----------------------------------------------------------------------------
// Tema claro / oscuro 100 % coherente con el modo del sistema.
// Incluye correcciones para SnackBars, diálogos, PopupMenus, Dropdowns,
// ProgressIndicators, Cards, FABs y usa MaterialStateProperty.all()
// (el anterior MaterialStatePropertyAll provocaba warnings).
// -----------------------------------------------------------------------------
import 'package:flutter/material.dart';

class AppTheme {
  // ═══════════════════════════════════════════════════════════════════════════
  // TEMA CLARO  (fondo blanco, texto negro)
  // ═══════════════════════════════════════════════════════════════════════════
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true, // M3 = hereda mejor los colores
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.black,

    colorScheme: const ColorScheme.light().copyWith(
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.black,
      onSecondary: Colors.white,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.white,
    ),

    // ---------- Tipografía ----------
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
    ),

    // ---------- AppBar ----------
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      iconTheme: IconThemeData(color: Colors.black),
    ),

    // ---------- Iconos ----------
    iconTheme: const IconThemeData(color: Colors.black),

    // ---------- Botones ----------
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.black),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),

    // ---------- Campos de texto ----------
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.black),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2),
      ),
      hintStyle: TextStyle(color: Colors.grey),
    ),

    // ---------- Barras inferiores ----------
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
    ),

    // ---------- Widgets que antes “fallaban” ----------
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.black,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.black,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Colors.white,
      textStyle: TextStyle(color: Colors.black),
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
      textStyle: TextStyle(color: Colors.black),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
      contentTextStyle: TextStyle(color: Colors.black),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    listTileTheme: const ListTileThemeData(iconColor: Colors.black),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(Colors.black),
      checkColor: MaterialStateProperty.all(Colors.white),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.black),
      trackColor: MaterialStateProperty.all(Colors.black26),
    ),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // TEMA OSCURO  (fondo negro, texto blanco)
  // ═══════════════════════════════════════════════════════════════════════════
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.white,

    colorScheme: const ColorScheme.dark().copyWith(
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: Colors.white,
      onSecondary: Colors.black,
      background: Colors.black,
      onBackground: Colors.white,
      surface: Colors.black,
      onSurface: Colors.white,
      error: Colors.red,
      onError: Colors.white,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    iconTheme: const IconThemeData(color: Colors.white),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        foregroundColor: MaterialStateProperty.all(Colors.black),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),

    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      hintStyle: TextStyle(color: Colors.grey),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
    ),

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.white,
      contentTextStyle: TextStyle(color: Colors.black),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.white,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Colors.black,
      textStyle: TextStyle(color: Colors.white),
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
      textStyle: TextStyle(color: Colors.white),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    cardTheme: CardTheme(
      color: Colors.grey.shade900,
      surfaceTintColor: Colors.grey.shade900,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    listTileTheme: const ListTileThemeData(iconColor: Colors.white),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(Colors.white),
      checkColor: MaterialStateProperty.all(Colors.black),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.white),
      trackColor: MaterialStateProperty.all(Colors.white24),
    ),
  );
}
