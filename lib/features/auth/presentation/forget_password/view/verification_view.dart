import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../config/di/di.dart';
import '../../../../../config/routing/routes.dart';
import '../../../../../core/extensions/localization_extension.dart';
import '../../../../../core/shared/app_widgets/circular_back_button.dart';
import '../../../../../core/themes/app_colors/app_colors.dart';
import '../manager/cubit/forget_password_cubit.dart';
import '../manager/cubit/forget_password_event.dart';
import '../manager/cubit/forget_password_state.dart';
import 'widgets/custom_pin_widget.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({super.key, this.email, this.cubit});

  final String? email;
  final ForgetPasswordCubit? cubit;

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  late final ForgetPasswordCubit _cubit;
  late final TextEditingController _pinController;
  late final FocusNode _pinFocusNode;
  bool _isSelfCreatedCubit = false;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
    _pinFocusNode = FocusNode();
    if (widget.cubit != null) {
      _cubit = widget.cubit!;
    } else {
      _cubit = getIt<ForgetPasswordCubit>();
      _isSelfCreatedCubit = true;
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    if (_isSelfCreatedCubit) {
      _cubit.close();
    }
    super.dispose();
  }

  void _onPinCompleted(String pin) {
    if (pin.length == 4) {
      _cubit.doAction(VerifyOtpAction(pin));
    }
  }

  void _onResendPressed() {
    _pinController.clear();
    _cubit.doAction(const ResendOtpAction());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listenWhen: (prev, current) =>
            prev.isOtpVerified != current.isOtpVerified ||
            prev.statusMessage != current.statusMessage,
        listener: (context, state) {
          if (state.isOtpVerified) {
            Navigator.pushNamed(
              context,
              Routes.resetPassword,
              arguments: {'email': state.email, 'cubit': _cubit},
            );
          } else if (state.statusMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.statusMessage!),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.surface,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 16.h),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: CircularBackButton(
                        onPressed: () => Navigator.maybePop(context),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    Text(
                      context.l10n.emailVerificationTitle,
                      style: GoogleFonts.inter(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkNavy,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      context.l10n.emailVerificationSubtitle,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.h),
                    CustomPinWidget(
                      controller: _pinController,
                      focusNode: _pinFocusNode,
                      hasError: state.isOtpInvalid,
                      onCompleted: _onPinCompleted,
                      onChanged: (val) {
                        _cubit.doAction(OtpChangedAction(val));
                      },
                    ),
                    if (state.isOtpInvalid) ...[
                      SizedBox(height: 12.h),
                      Text(
                        state.errorMessage ?? context.l10n.invalidCodeError,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    SizedBox(height: 36.h),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          context.l10n.didntReceiveCode,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: state.isLoading ? null : _onResendPressed,
                          child: Text(
                            context.l10n.resendLink,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (state.isLoading) ...[
                      SizedBox(height: 24.h),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
