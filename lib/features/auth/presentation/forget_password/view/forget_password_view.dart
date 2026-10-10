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

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key, this.cubit});

  final ForgetPasswordCubit? cubit;

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late final ForgetPasswordCubit _cubit;
  late final TextEditingController _emailController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSelfCreatedCubit = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    if (widget.cubit != null) {
      _cubit = widget.cubit!;
    } else {
      _cubit = getIt<ForgetPasswordCubit>();
      _isSelfCreatedCubit = true;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    if (_isSelfCreatedCubit) {
      _cubit.close();
    }
    super.dispose();
  }

  void _onConfirmPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      _cubit.doAction(SubmitEmailAction(_emailController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listenWhen: (prev, current) =>
            prev.isEmailSent != current.isEmailSent ||
            prev.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.isEmailSent) {
            Navigator.pushNamed(
              context,
              Routes.verificationCode,
              arguments: {'email': state.email, 'cubit': _cubit},
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
                        context.l10n.forgetPasswordHeader,
                        style: GoogleFonts.inter(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkNavy,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        context.l10n.forgetPasswordSubtitle,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 36.h),
                      CustomTextFormField(
                        label: context.l10n.emailLabel,
                        hintText: context.l10n.emailHint,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            AuthValidators.email(value, context),
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
