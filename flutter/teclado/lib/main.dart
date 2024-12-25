import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:signals/signals_flutter.dart';
import 'package:teclado/core/bindings/teclado_application_bindings.dart';
import 'package:teclado/core/navigator/app_navigator.dart';
import 'package:teclado/core/ui/theme_manager.dart';
import 'package:teclado/core/ui/ui_config.dart';
import 'package:teclado/modules/home/home_module.dart';
import 'package:asyncstate/asyncstate.dart' as asyncstate;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
        bindings: TecladoApplicationBindings(),
        modules: [
          // SplashModule(),
          HomeModule(),
        ],
        builder: (context, routes, isReady) {
          final themeManager = Injector.get<ThemeManager>()..getDarkMode();
          return asyncstate.AsyncStateBuilder(
            builder: (asyncNavigatorObserver) {
              return Watch(
                (_) {
                  return MaterialApp(
                    localizationsDelegates: const [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: const [
                      Locale('pt', 'BR'),
                    ],
                    debugShowCheckedModeBanner: false,
                    title: "ZappyHeat",
                    theme: UiConfig.lightTheme,
                    darkTheme: UiConfig.darkTheme,
                    navigatorKey: AppNavigator.navigatorKey,
                    themeMode: themeManager.isDarkMode
                        ? ThemeMode.dark
                        : ThemeMode.light,
                    navigatorObservers: [
                      asyncNavigatorObserver,
                    ],
                    routes: routes,
                    initialRoute: "/home/",
                  );
                },
              );
            },
          );
        });
  }
}
