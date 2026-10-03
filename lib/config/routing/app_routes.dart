import 'package:cliniq_final_project/config/routing/routes.dart';

import 'package:flutter/material.dart';


abstract class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Auth
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.verificationCode:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.resetPassword:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route Not Found'))),
        );
    }
  }
}
