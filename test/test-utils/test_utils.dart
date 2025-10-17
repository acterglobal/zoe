import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        theme: theme ?? ThemeData.light(),
        localizationsDelegates: [
          L10n.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L10n.supportedLocales,
        home: Scaffold(
          body: router != null
              ? InheritedGoRouter(goRouter: router, child: child)
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
          theme: theme ?? ThemeData.light(),
          localizationsDelegates: [
            L10n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: L10n.supportedLocales,
          home: Scaffold(
            body: router != null
                ? InheritedGoRouter(goRouter: router, child: child)
                : child,
          ),
        ),
      ),
    );
  }

  Future<void> pumpConsumerWidget({
    required ProviderContainer container,
    required Function(BuildContext context, WidgetRef ref, Widget? child)
    builder,
    GoRouter? router,
  }) async {
    await pumpMaterialWidgetWithProviderScope(
      container: container,
      router: router,
      child: Consumer(
        builder: (context, ref, child) => builder(context, ref, child),
      ),
    );
  }

  Future<void> pumpActionsWidget({
    required ProviderContainer container,
    required String buttonText,
    required Function(BuildContext, WidgetRef) onPressed,
    GoRouter? router,
  }) async {
    await pumpConsumerWidget(
      container: container,
      router: router,
      builder: (context, ref, child) => ElevatedButton(
        onPressed: () => onPressed(context, ref),
        child: Text(buttonText),
      ),
    );
  }

  /// Gets the L10n instance for any widget type
  /// Usage: getL10n(tester, byType: MyWidget)
  static L10n getL10n(WidgetTester tester, {required Type byType}) {
    return L10n.of(tester.element(find.byType(byType)));
  }

  /// Gets the Theme instance for any widget type
  /// Usage: getTheme(tester, byType: MyWidget)
  static ThemeData getTheme(WidgetTester tester, {required Type byType}) {
    return Theme.of(tester.element(find.byType(byType)));
  }
}

/// Initializes the share platform method call handler
Future<void> initSharePlatformMethodCallHandler({VoidCallback? onShare}) async {
  final shareChannel = MethodChannel('dev.fluttercommunity.plus/share');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(shareChannel, (call) async {
        if (call.method == 'share') onShare?.call();
        return null;
      });
}

/// Initializes haptic feedback method call handler for testing
void initHapticFeedbackMethodCallHandler() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(const MethodChannel('flutter/haptic'), (
        MethodCall methodCall,
      ) async {
        if (methodCall.method == 'HapticFeedback.lightImpact') {
          return null;
        }
        throw MissingPluginException(
          'No implementation found for method ${methodCall.method}',
        );
      });
}