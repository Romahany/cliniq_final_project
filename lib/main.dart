
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'config/di/di.dart';
import 'config/routing/app_routes.dart';
import 'config/routing/routes.dart';
import 'core/themes/app_themes/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(
    ScreenUtilPlusInit(
      designSize: const Size(375, 812),

      minTextAdapt: true,

      splitScreenMode: true,

      child: CliniqApp(),
    ),
  );
}

class CliniqApp extends StatelessWidget {
  const CliniqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: Routes.login,
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      title: 'Cliniq App',
    );
  }
}
