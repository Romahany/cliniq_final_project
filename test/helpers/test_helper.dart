import 'package:cliniq_final_project/core/themes/app_themes/app_theme.dart';
import 'package:cliniq_final_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

Widget createTestableWidget({
  required Widget child,
  NavigatorObserver? navigatorObserver,
  RouteFactory? onGenerateRoute,
}) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      locale: const Locale('en'),
      navigatorObservers: navigatorObserver != null ? [navigatorObserver] : [],
      onGenerateRoute: onGenerateRoute,
      home: child,
    ),
  );
}
