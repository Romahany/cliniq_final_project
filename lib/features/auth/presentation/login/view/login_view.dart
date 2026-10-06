import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../config/di/di.dart';
import '../../../../../config/routing/routes.dart';
import '../../../../../config/utils/auth_validators.dart';
import '../../../../../core/extensions/localization_extension.dart';
import '../../../../../core/shared/app_widgets/custom_button.dart';
import '../../../../../core/shared/app_widgets/custom_outlined_button.dart';
import '../../../../../core/shared/app_widgets/custom_text_form_field.dart';
import '../../../../../core/themes/app_colors/app_colors.dart';
import '../manager/login_cubit.dart';
import '../manager/login_state.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key, this.cubit});

  final LoginCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider.value(value: cubit!, child: const LoginViewBody());
    }

    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: const LoginViewBody(),
    );
  }
}

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context, LoginCubit cubit) {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      cubit.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  void _handleContinueAsGuest(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.loginState.errorMessage.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.loginState.errorMessage,
                    style: GoogleFonts.inter(color: Colors.white),
                  ),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    // Header Bar (Back Button + Title)
                    Row(
                      children: [
                        Semantics(
                          label: 'Back',
                          button: true,
                          child: InkWell(
                            onTap: () {
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              }
                            },
                            borderRadius: BorderRadius.circular(22.r),
                            child: Container(
                              width: 44.w,
                              height: 44.h,
                              decoration: const BoxDecoration(
                                color: AppColors.surfaceVariant,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.chevron_left_rounded,
                                size: 28.sp,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          context.l10n.loginTitle,
                          style: GoogleFonts.inter(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 36.h),

                    // Email Field
                    CustomTextFormField(
                      key: const Key('login_email_field'),
                      label: context.l10n.emailLabel,
                      hintText: context.l10n.emailHint,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          AuthValidators.email(value, context),
                    ),
                    SizedBox(height: 16.h),

                    // Password Field
                    CustomTextFormField(
                      key: const Key('login_password_field'),
                      label: context.l10n.passwordLabel,
                      hintText: context.l10n.passwordHint,
                      controller: _passwordController,
                      obscureText: !state.isPasswordVisible,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleLogin(context, cubit),
                      validator: (value) =>
                          AuthValidators.password(value, context),
                      suffixIcon: IconButton(
                        key: const Key('login_password_visibility_button'),
                        icon: Icon(
                          state.isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textSecondary,
                          size: 22.sp,
                        ),
                        onPressed: cubit.togglePasswordVisibility,
                        tooltip: state.isPasswordVisible
                            ? 'Hide password'
                            : 'Show password',
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Remember Me & Forgot Password Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: InkWell(
                            onTap: () =>
                                cubit.toggleRememberMe(!state.rememberMe),
                            borderRadius: BorderRadius.circular(4.r),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 22.w,
                                  height: 22.h,
                                  child: Checkbox(
                                    key: const Key(
                                      'login_remember_me_checkbox',
                                    ),
                                    value: state.rememberMe,
                                    onChanged: cubit.toggleRememberMe,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Flexible(
                                  child: Text(
                                    context.l10n.rememberMe,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          key: const Key('login_forgot_password_button'),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(Routes.forgotPassword);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(50.w, 30.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            context.l10n.forgetPassword,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 28.h),

                    // Login Button (Filled Button)
                    CustomButton(
                      key: const Key('login_submit_button'),
                      text: context.l10n.loginButton,
                      isEnabled: true,
                      isLoading: state.loginState.isLoading,
                      enabledColor: AppColors.primary,
                      onPressed: () => _handleLogin(context, cubit),
                    ),
                    SizedBox(height: 14.h),

                    // Continue as guest Button (Outlined Button)
                    CustomOutlinedButton(
                      key: const Key('login_guest_button'),
                      text: context.l10n.continueAsGuest,
                      onPressed: () => _handleContinueAsGuest(context),
                    ),
                    SizedBox(height: 28.h),

                    // Don't have an account? Sign up
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            context.l10n.dontHaveAccount,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          GestureDetector(
                            key: const Key('login_signup_link'),
                            onTap: () {
                              Navigator.of(context).pushNamed(Routes.signUp);
                            },
                            child: Text(
                              context.l10n.signUp,
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
