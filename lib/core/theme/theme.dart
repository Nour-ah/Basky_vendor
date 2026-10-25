import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

export 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      // / scaffoldBackgroundColor: AppColors.primary.withValues(alpha: 0.001),
      fontFamily: GoogleFonts.cairo().fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation:1,
        iconTheme: IconThemeData(color: AppColors.white),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColors.primary,
        secondary: AppColors.lightGrey,
      ),
    );
  }
}
