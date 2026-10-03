import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_colors/app_colors.dart';

abstract final class AppTextThemes {
  static TextTheme textTheme() {
    const baseColor = AppColors.textPrimary;

    final defaultStyles = const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 80, color: baseColor),
      displayMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 40, color: baseColor),
      displaySmall: TextStyle(fontWeight: FontWeight.w600, fontSize: 36, color: baseColor),
      headlineLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 24, color: baseColor),
      headlineMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: baseColor),
      headlineSmall: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: baseColor),
      titleLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: baseColor),
      titleMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: baseColor),
      titleSmall: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: baseColor),
      bodyLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: baseColor),
      bodyMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: baseColor),
      bodySmall: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: baseColor),
      labelLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: baseColor),
      labelMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: baseColor),
      labelSmall: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: baseColor),
    );

    final scaled = defaultStyles.copyWith(
      displayLarge: defaultStyles.displayLarge?.copyWith(fontSize: 80.sp),
      displayMedium: defaultStyles.displayMedium?.copyWith(fontSize: 40.sp),
      displaySmall: defaultStyles.displaySmall?.copyWith(fontSize: 36.sp),
      headlineLarge: defaultStyles.headlineLarge?.copyWith(fontSize: 24.sp),
      headlineMedium: defaultStyles.headlineMedium?.copyWith(fontSize: 20.sp),
      headlineSmall: defaultStyles.headlineSmall?.copyWith(fontSize: 18.sp),
      titleLarge: defaultStyles.titleLarge?.copyWith(fontSize: 18.sp),
      titleMedium: defaultStyles.titleMedium?.copyWith(fontSize: 16.sp),
      titleSmall: defaultStyles.titleSmall?.copyWith(fontSize: 14.sp),
      bodyLarge: defaultStyles.bodyLarge?.copyWith(fontSize: 16.sp),
      bodyMedium: defaultStyles.bodyMedium?.copyWith(fontSize: 14.sp),
      bodySmall: defaultStyles.bodySmall?.copyWith(fontSize: 12.sp),
      labelLarge: defaultStyles.labelLarge?.copyWith(fontSize: 16.sp),
      labelMedium: defaultStyles.labelMedium?.copyWith(fontSize: 14.sp),
      labelSmall: defaultStyles.labelSmall?.copyWith(fontSize: 12.sp),
    );

    return GoogleFonts.interTextTheme(scaled);
  }

  static TextStyle logoTheme() {
    return GoogleFonts.imFellEnglish(
      fontSize: 20.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.primary,
    );
  }
}
