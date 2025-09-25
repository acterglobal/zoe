import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/l10n/generated/l10n.dart';

extension WidgetTesterExtension on WidgetTester {
  Future<void> pumpMaterialWidget({required Widget child}) async {
    await pumpWidget(
      MaterialApp(
        localizationsDelegates: const [L10n.delegate],
        home: Scaffold(body: child),
      ),
    );
  }

  Future<void> pumpMaterialWidgetWithProviderScope({
    required Widget child,
    required ProviderContainer container,
  }) async {
    await pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(
          localizationsDelegates: const [L10n.delegate],
          home: Scaffold(body: child),
        ),
      ),
    );
  }
}
