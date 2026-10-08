import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/extensions/localization_extension.dart';
import '../../../../../../core/themes/app_colors/app_colors.dart';

class TermsAndConditionsWidget extends StatelessWidget {
  const TermsAndConditionsWidget({super.key, this.onTermsPressed});

  final VoidCallback? onTermsPressed;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: AppColors.textSecondary, fontSize: 12.sp),
        children: [
          TextSpan(text: context.l10n.termsPrefix),
          TextSpan(
            text: context.l10n.termsLink,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTermsPressed,
          ),
        ],
      ),
    );
  }
}
