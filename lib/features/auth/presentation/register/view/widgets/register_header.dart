import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/extensions/localization_extension.dart';
import '../../../../../../core/themes/app_colors/app_colors.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key, this.onBackPressed});

  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBackPressed ?? () => Navigator.maybePop(context),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: 44.w,
            height: 44.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border, width: 1.w),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Text(
          context.l10n.signUp,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
