import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/l10n/generated/l10n.dart';

extension WidgetTesterExtension on WidgetTester {
  Future<void> pumpMaterialWidget({
    required Widget child,
    GoRouter? router,
    ThemeData? theme,
  }) async {
    await pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: theme,
        localizationsDelegates: [
          L10n.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L10n.supportedLocales,
        home: Scaffold(
          body: router != null
              ? InheritedGoRouter(
                  goRouter: router,
                  child: child,
                )
              : child,
        ),
      ),
    );
  }

  Future<void> pumpMaterialWidgetWithProviderScope({
    required Widget child,
    required ProviderContainer container,
    GoRouter? router,
    ThemeData? theme,
  }) async {
    await pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('en'),
          theme: theme,
          localizationsDelegates: [
            L10n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: L10n.supportedLocales,
          home: Scaffold(
            body: router != null
                ? InheritedGoRouter(
                    goRouter: router,
                    child: child,
                  )
                : child,
          ),
        ),
      ),
    );
  }
}