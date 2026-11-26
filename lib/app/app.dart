import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/app/router/app_router.dart';
import 'package:mozhivora/app/theme/app_theme.dart';
import 'package:mozhivora/core/config/app_preferences.dart';
import 'package:mozhivora/l10n/app_localizations.dart';

class MozhivoraApp extends ConsumerWidget {
  const MozhivoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(appPreferencesProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'MOZHIVORA',
      debugShowCheckedModeBanner: false,
      locale: prefs.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('ur'),
        Locale('ta'),
        Locale('te'),
        Locale('bn'),
        Locale('mr'),
        Locale('kn'),
        Locale('ml'),
        Locale('gu'),
        Locale('pa'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: prefs.themeMode,
      theme: MozhiTheme.light(
        locale: prefs.locale,
        reducedMotion: prefs.reducedMotion,
      ),
      darkTheme: MozhiTheme.dark(
        locale: prefs.locale,
        reducedMotion: prefs.reducedMotion,
      ),
      routerConfig: router,
    );
  }
}
