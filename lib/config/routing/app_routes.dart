import 'package:flutter/material.dart';

import '../../features/auth/presentation/forget_password/manager/cubit/forget_password_cubit.dart';
import '../../features/auth/presentation/forget_password/view/forget_password_view.dart';
import '../../features/auth/presentation/forget_password/view/reset_password_view.dart';
import '../../features/auth/presentation/forget_password/view/verification_view.dart';
import 'routes.dart';

abstract class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      // Auth
      case Routes.login:
        // Default to forgotPassword view if login screen is not yet implemented
        return MaterialPageRoute(builder: (_) => const ForgetPasswordView());

      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.forgotPassword:
        return MaterialPageRoute(
          builder: (_) =>
              ForgetPasswordView(cubit: args?['cubit'] as ForgetPasswordCubit?),
        );

      case Routes.verificationCode:
        return MaterialPageRoute(
          builder: (_) => VerificationView(
            email: args?['email'] as String?,
            cubit: args?['cubit'] as ForgetPasswordCubit?,
          ),
        );

      case Routes.resetPassword:
        return MaterialPageRoute(
          builder: (_) => ResetPasswordView(
            email: args?['email'] as String?,
            cubit: args?['cubit'] as ForgetPasswordCubit?,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route Not Found'))),
        );
    }
  }
}
