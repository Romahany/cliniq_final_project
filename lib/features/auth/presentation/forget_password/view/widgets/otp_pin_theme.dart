import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../core/themes/app_colors/app_colors.dart';

abstract final class OtpPinTheme {
  static PinTheme defaultTheme() {
    return PinTheme(
      width: 64.w,
      height: 64.h,
      textStyle: GoogleFonts.inter(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.darkNavy,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
    );
  }

  static PinTheme focusedTheme() {
    return defaultTheme().copyWith(
      decoration: defaultTheme().decoration?.copyWith(
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  static PinTheme submittedTheme() {
    return defaultTheme();
  }

  static PinTheme errorTheme() {
    return defaultTheme().copyWith(
      decoration: defaultTheme().decoration?.copyWith(
        border: Border.all(color: AppColors.error, width: 1.5),
      ),
    );
  }
}
