import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static const String fontFamilyMain = 'NotoSansKR';
  static const String fontFamilySerif = 'Ridibatang';

  static TextStyle get h1 => GoogleFonts.notoSansKr(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.dayText,
  );

  static TextStyle get h2 => GoogleFonts.notoSansKr(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.dayText,
  );

  static TextStyle get body => GoogleFonts.notoSansKr(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.dayText,
  );

  static TextStyle get caption => GoogleFonts.notoSansKr(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.dayText,
  );

  // Dark mode variants
  static TextStyle get h1Dark => h1.copyWith(color: AppColors.nightText);
  static TextStyle get h2Dark => h2.copyWith(color: AppColors.nightText);
  static TextStyle get bodyDark => body.copyWith(color: AppColors.nightText);
  static TextStyle get captionDark =>
      caption.copyWith(color: AppColors.nightText);
}
