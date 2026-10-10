import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:pinput/pinput.dart';

import 'otp_pin_theme.dart';

class CustomPinWidget extends StatelessWidget {
  const CustomPinWidget({
    super.key,
    required this.controller,
    this.focusNode,
    this.onCompleted,
    this.onChanged,
    this.hasError = false,
    this.length = 4,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final bool hasError;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Pinput(
      length: length,
      controller: controller,
      focusNode: focusNode,
      defaultPinTheme: OtpPinTheme.defaultTheme(),
      focusedPinTheme: OtpPinTheme.focusedTheme(),
      submittedPinTheme: OtpPinTheme.submittedTheme(),
      errorPinTheme: OtpPinTheme.errorTheme(),
      forceErrorState: hasError,
      separatorBuilder: (index) => SizedBox(width: 16.w),
      showCursor: true,
      keyboardType: TextInputType.number,
      onCompleted: onCompleted,
      onChanged: onChanged,
    );
  }
}
