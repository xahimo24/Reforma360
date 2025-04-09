import 'package:flutter/material.dart';

class AppTheme {
  // ---------------------------
  // TEMA CLARO: Fondo blanco
  // ---------------------------
  static final ThemeData whiteBlackLightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    useMaterial3: false,

    // Definimos un colorScheme minimalista (blanco/negro)
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Colors.black, // Color principal: negro
      onPrimary: Colors.white, // Texto en botones principales: blanco
      secondary: Colors.black,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
    ),

    // Texto en negro
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
    ),

    // AppBar en blanco con iconos/texto negros
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      iconTheme: IconThemeData(color: Colors.black),
    ),

    // Iconos en negro
    iconTheme: const IconThemeData(color: Colors.black),

    // ElevatedButton: fondo negro, texto blanco
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.black),
        foregroundColor: MaterialStatePropertyAll(Colors.white),
      ),
    ),

    // TextButton: texto negro
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(Colors.black),
      ),
    ),

    // Campos de texto subrayados en negro
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

    // Barra de navegación inferior en blanco, iconos negros
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
    ),
  );

  // ---------------------------
  // TEMA OSCURO: Fondo negro
  // ---------------------------
  static final ThemeData whiteBlackDarkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    useMaterial3: false,

    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.white, // Color principal: blanco
      onPrimary: Colors.black, // Texto en botones principales: negro
      secondary: Colors.white,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      background: Colors.black,
      onBackground: Colors.white,
      surface: Colors.black,
      onSurface: Colors.white,
    ),

    // Texto en blanco
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
    ),

    // AppBar en negro con iconos/texto blancos
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    // Iconos en blanco
    iconTheme: const IconThemeData(color: Colors.white),

    // ElevatedButton: fondo blanco, texto negro (o como prefieras)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        // Fondo blanco
        backgroundColor: MaterialStateProperty.all(Colors.white),
        // Texto negro
        foregroundColor: MaterialStateProperty.all(Colors.black),
      ),
    ),

    // TextButton: texto blanco
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(Colors.white),
      ),
    ),

    // Campos de texto subrayados en blanco
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

    // Barra de navegación inferior en negro, iconos blancos
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
    ),
  );
}
