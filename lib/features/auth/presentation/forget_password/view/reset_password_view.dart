import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../config/di/di.dart';
import '../../../../../config/routing/routes.dart';
import '../../../../../config/utils/auth_validators.dart';
import '../../../../../core/extensions/localization_extension.dart';
import '../../../../../core/shared/app_widgets/circular_back_button.dart';
import '../../../../../core/shared/app_widgets/custom_button.dart';
import '../../../../../core/shared/app_widgets/custom_text_form_field.dart';
import '../../../../../core/themes/app_colors/app_colors.dart';
import '../manager/cubit/forget_password_cubit.dart';
import '../manager/cubit/forget_password_event.dart';
import '../manager/cubit/forget_password_state.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key, this.email, this.cubit});

  final String? email;
  final ForgetPasswordCubit? cubit;

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  late final ForgetPasswordCubit _cubit;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSelfCreatedCubit = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    if (widget.cubit != null) {
      _cubit = widget.cubit!;
    } else {
      _cubit = getIt<ForgetPasswordCubit>();
      _isSelfCreatedCubit = true;
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    if (_isSelfCreatedCubit) {
      _cubit.close();
    }
    super.dispose();
  }

  void _onConfirmPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      _cubit.doAction(
        ResetPasswordAction(
          newPassword: _newPasswordController.text,
          confirmPassword: _confirmPasswordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listenWhen: (prev, current) =>
            prev.isPasswordResetSuccess != current.isPasswordResetSuccess ||
            prev.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.isPasswordResetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.statusMessage ?? context.l10n.passwordResetSuccess,
                ),
                backgroundColor: AppColors.success,
              ),
            );
            // Navigate back to login
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.login,
              (route) => false,
            );
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          CircularBackButton(
                            onPressed: () => Navigator.maybePop(context),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Text(
                              context.l10n.resetPasswordTitle,
                              style: GoogleFonts.inter(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkNavy,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 28.h),
                      // Information Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.createSecurePassword,
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkNavy,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              context.l10n.createSecurePasswordSubtitle,
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      CustomTextFormField(
                        label: context.l10n.newPasswordLabel,
                        hintText: context.l10n.enterNewPasswordHint,
                        controller: _newPasswordController,
                        obscureText: state.isNewPasswordObscured,
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.isNewPasswordObscured
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textSecondary,
                            size: 22.sp,
                          ),
                          onPressed: () {
                            _cubit.doAction(
                              const ToggleNewPasswordVisibilityAction(),
                            );
                          },
                        ),
                        validator: (value) =>
                            AuthValidators.strongPassword(value, context),
                      ),
                      SizedBox(height: 18.h),
                      CustomTextFormField(
                        label: context.l10n.confirmPasswordLabel,
                        hintText: context.l10n.confirmNewPasswordHint,
                        controller: _confirmPasswordController,
                        obscureText: state.isConfirmPasswordObscured,
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.isConfirmPasswordObscured
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textSecondary,
                            size: 22.sp,
                          ),
                          onPressed: () {
                            _cubit.doAction(
                              const ToggleConfirmPasswordVisibilityAction(),
                            );
                          },
                        ),
                        validator: (value) => AuthValidators.confirmPassword(
                          value,
                          _newPasswordController.text,
                          context,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      CustomButton(
                        text: context.l10n.confirmButton,
                        onPressed: _onConfirmPressed,
                        isEnabled: !state.isLoading,
                        isLoading: state.isLoading,
                        enabledColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
