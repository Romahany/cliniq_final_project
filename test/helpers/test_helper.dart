import 'package:cliniq_final_project/config/routing/routes.dart';
import 'package:cliniq_final_project/core/themes/app_themes/app_theme.dart';
import 'package:cliniq_final_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

Widget createTestableWidget({
  required Widget child,
  NavigatorObserver? navigatorObserver,
  Map<String, WidgetBuilder>? routes,
}) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    child: MaterialApp(
      theme: AppTheme.light,
      initialRoute: Routes.signUp,
      navigatorObservers: [?navigatorObserver],
      onGenerateRoute: (settings) {
        if (settings.name == Routes.signUp) {
          return MaterialPageRoute(builder: (_) => child, settings: settings);
        }
        if (routes != null && routes.containsKey(settings.name)) {
          return MaterialPageRoute(
            builder: routes[settings.name]!,
            settings: settings,
          );
        }
        return null;
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      locale: const Locale('en'),
    ),
  );
}
