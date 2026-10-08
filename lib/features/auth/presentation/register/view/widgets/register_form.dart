import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../config/routing/routes.dart';
import '../../../../../../config/utils/auth_validators.dart';
import '../../../../../../core/extensions/localization_extension.dart';
import '../../../../../../core/shared/app_widgets/custom_button.dart';
import '../../../../../../core/shared/app_widgets/custom_text_form_field.dart';
import '../../../../../../core/themes/app_colors/app_colors.dart';
import '../../../../domain/entities/register_entity/register_params.dart';
import '../../manager/register_cubit.dart';
import '../../manager/register_state.dart';
import 'already_have_account_widget.dart';
import 'gender_selection_widget.dart';
import 'terms_and_conditions_widget.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _phoneController;

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit(RegisterState state) {
    if (_formKey.currentState?.validate() ?? false) {
      final params = RegisterParams(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        phone: _phoneController.text.trim(),
        gender: state.selectedGender,
      );
      context.read<RegisterCubit>().register(params);
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Row 1: First name & Last name
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      label: context.l10n.firstNameLabel,
                      hintText: context.l10n.firstNameLabel,
                      controller: _firstNameController,
                      validator: (value) =>
                          AuthValidators.firstName(value, context),
                      autovalidateMode: _autovalidateMode,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomTextFormField(
                      label: context.l10n.lastNameLabel,
                      hintText: context.l10n.lastNameLabel,
                      controller: _lastNameController,
                      validator: (value) =>
                          AuthValidators.lastName(value, context),
                      autovalidateMode: _autovalidateMode,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Row 2: Email
              CustomTextFormField(
                label: context.l10n.emailLabel,
                hintText: context.l10n.emailHint,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => AuthValidators.email(value, context),
                autovalidateMode: _autovalidateMode,
              ),
              SizedBox(height: 16.h),

              // Row 3: Password & Confirm password
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      label: context.l10n.passwordLabel,
                      hintText: context.l10n.passwordLabel,
                      controller: _passwordController,
                      obscureText: !state.isPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          state.isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () => context
                            .read<RegisterCubit>()
                            .togglePasswordVisibility(),
                      ),
                      validator: (value) =>
                          AuthValidators.strongPassword(value, context),
                      autovalidateMode: _autovalidateMode,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomTextFormField(
                      label: context.l10n.confirmPasswordLabel,
                      hintText: context.l10n.confirmPasswordHint,
                      controller: _confirmPasswordController,
                      obscureText: !state.isConfirmPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          state.isConfirmPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () => context
                            .read<RegisterCubit>()
                            .toggleConfirmPasswordVisibility(),
                      ),
                      validator: (value) => AuthValidators.confirmPassword(
                        value,
                        _passwordController.text,
                        context,
                      ),
                      autovalidateMode: _autovalidateMode,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Row 4: Phone number
              CustomTextFormField(
                label: context.l10n.phoneNumberLabel,
                hintText: context.l10n.phoneNumberHint,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) => AuthValidators.phone(value, context),
                autovalidateMode: _autovalidateMode,
              ),
              SizedBox(height: 16.h),

              // Row 5: Gender
              GenderSelectionWidget(
                selectedGender: state.selectedGender,
                onGenderChanged: (gender) {
                  context.read<RegisterCubit>().changeGender(gender);
                },
              ),
              SizedBox(height: 14.h),

              // Row 6: Terms and Conditions
              const TermsAndConditionsWidget(),
              SizedBox(height: 24.h),

              // Row 7: Sign up Button
              CustomButton(
                text: context.l10n.signUp,
                isEnabled: !state.registerState.isLoading,
                isLoading: state.registerState.isLoading,
                enabledColor: AppColors.primary,
                onPressed: () => _submit(state),
              ),
              SizedBox(height: 16.h),

              // Row 8: Already have an account? Login
              AlreadyHaveAccountWidget(
                onLoginPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacementNamed(context, Routes.login);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
