import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        primary: AppColors.baseBlue,
        secondary: AppColors.baseRed,
        surface: AppColors.bg,
        error: Colors.redAccent,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.colorDark,
        onError: AppColors.white,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.bg,
      cardColor: AppColors.white,
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.blackPrimary,
        ),
        iconTheme: IconThemeData(color: AppColors.colorDark),
        elevation: 0,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.baseBlue,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.baseBlue,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.baseBlue,
          side: BorderSide(color: AppColors.baseBlue),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.baseBlue),
      ),
      iconTheme: IconThemeData(color: AppColors.infoDark),
      dividerTheme: DividerThemeData(color: AppColors.infoLight),
      cardTheme: CardTheme(
        color: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
