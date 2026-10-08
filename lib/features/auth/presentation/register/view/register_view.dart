import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../config/di/di.dart';
import '../../../../../config/routing/routes.dart';
import '../../../../../core/extensions/localization_extension.dart';
import '../../../../../core/themes/app_colors/app_colors.dart';
import '../manager/register_cubit.dart';
import '../manager/register_state.dart';
import 'widgets/register_form.dart';
import 'widgets/register_header.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key, this.cubit});

  final RegisterCubit? cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit ?? getIt<RegisterCubit>(),
      child: const RegisterViewBody(),
    );
  }
}

class RegisterViewBody extends StatelessWidget {
  const RegisterViewBody({super.key});

  void _handleStateListener(BuildContext context, RegisterState state) {
    final errorMessage = state.registerState.errorMessage;
    final data = state.registerState.data;

    if (errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: const TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (data != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            data.message ?? context.l10n.registerSuccess,
            style: const TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate to login or home upon successful registration
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocListener<RegisterCubit, RegisterState>(
          listenWhen: (previous, current) =>
              previous.registerState != current.registerState,
          listener: _handleStateListener,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const RegisterHeader(),
                SizedBox(height: 24.h),
                const RegisterForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
