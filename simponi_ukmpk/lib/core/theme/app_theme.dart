// lib/core/theme/app_theme.dart
// Tema visual SIMPONI UKMPK — konsep "Humanitarian Trust".
//
// Palet warna (sumber: README-DASHBOARD.md):
//   Deep Navy       #173B50  → elemen utama, AppBar, teks penting
//   Teal            #176A78  → elemen pendamping
//   Warm Yellow     #E8B94F  → identitas UKMPK, aksen
//   Warm Ivory      #F4F1E8  → background
//   Soft Terracotta #D96B45  → aksen kemanusiaan, error/peringatan

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // --- Warna utama ---
  static const Color deepNavy = Color(0xFF173B50);
  static const Color teal = Color(0xFF176A78);
  static const Color warmYellow = Color(0xFFE8B94F);
  static const Color warmIvory = Color(0xFFF4F1E8);
  static const Color softTerracotta = Color(0xFFD96B45);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: deepNavy,
          primary: deepNavy,
          secondary: teal,
          surface: warmIvory,
          error: softTerracotta,
        ),
        scaffoldBackgroundColor: warmIvory,
        appBarTheme: const AppBarTheme(
          backgroundColor: deepNavy,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: deepNavy,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: teal),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: deepNavy, width: 2),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: softTerracotta),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: softTerracotta, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelStyle: const TextStyle(color: Color(0xFF555555)),
          floatingLabelStyle: const TextStyle(color: deepNavy),
          prefixIconColor: teal,
          suffixIconColor: const Color(0xFF888888),
          filled: true,
          fillColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: deepNavy,
          contentTextStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          behavior: SnackBarBehavior.floating,
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFDDDDDD),
          thickness: 1,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
              color: deepNavy, fontWeight: FontWeight.bold, fontSize: 24),
          headlineSmall: TextStyle(
              color: deepNavy, fontWeight: FontWeight.bold, fontSize: 20),
          titleLarge: TextStyle(
              color: deepNavy, fontWeight: FontWeight.w600, fontSize: 18),
          titleMedium: TextStyle(color: deepNavy, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: deepNavy),
          bodyMedium: TextStyle(color: Color(0xFF333333)),
          bodySmall: TextStyle(color: Color(0xFF666666), fontSize: 12),
        ),
      );
}
