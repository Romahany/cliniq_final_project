import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/di/di.dart';
import '../manager/cubit/forget_password_cubit.dart';
import '../manager/cubit/forget_password_state.dart';
import 'forget_password_view.dart';
import 'reset_password_view.dart';
import 'verification_view.dart';

class ForgetPasswordFlow extends StatefulWidget {
  const ForgetPasswordFlow({super.key});

  @override
  State<ForgetPasswordFlow> createState() => _ForgetPasswordFlowState();
}

class _ForgetPasswordFlowState extends State<ForgetPasswordFlow> {
  late final ForgetPasswordCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ForgetPasswordCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
        builder: (context, state) {
          if (state.isOtpVerified) {
            return ResetPasswordView(email: state.email, cubit: _cubit);
          } else if (state.isEmailSent) {
            return VerificationView(email: state.email, cubit: _cubit);
          } else {
            return ForgetPasswordView(cubit: _cubit);
          }
        },
      ),
    );
  }
}
