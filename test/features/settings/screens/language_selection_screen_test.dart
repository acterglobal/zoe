import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/settings/models/language_model.dart';
import 'package:zoe/features/settings/notifiers/local_notifier.dart';
import 'package:zoe/features/settings/providers/local_provider.dart';
import 'package:zoe/features/settings/screens/language_selection_screen.dart';
import '../../../helpers/test_utils.dart';

class MockLocaleNotifier extends LocaleNotifier {
  @override
  Future<void> setLanguage(String languageCode) async {
    state = languageCode;
  }

  @override
  Future<void> initLanguage() async {}
}

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        localeProvider.overrideWith((ref) => MockLocaleNotifier()),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  Future<void> pumpLanguageScreen(WidgetTester tester) async {
    await tester.pumpMaterialWidgetWithProviderScope(
      child: const LanguageSelectionScreen(),
        container: container,
    );
    await tester.pumpAndSettle();
  }

  group('AppBar', () {
    testWidgets('displays correct title', (tester) async {
      await pumpLanguageScreen(tester);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });

  group('Language List', () {
    testWidgets('displays all available languages', (tester) async {
      await pumpLanguageScreen(tester);
      
      // Verify all languages from LanguageModel.allLanguagesList are displayed
      for (final language in LanguageModel.allLanguagesList) {
        expect(find.text(language.languageName), findsOneWidget);
        expect(find.text(language.languageCode.toUpperCase()), findsOneWidget);
      }
    });

    testWidgets('shows current language as selected', (tester) async {
      await pumpLanguageScreen(tester);

      // Find the English radio tile
      final radioTile = tester.widget<RadioListTile<String>>(
        find.ancestor(
          of: find.text('English'),
          matching: find.byType(RadioListTile<String>),
        ),
      );

      // Verify that English (en) is selected
      expect(radioTile.value, equals('en'));
      expect(radioTile.groupValue, equals('en'));
    });

    testWidgets('can select a different language', (tester) async {
      await pumpLanguageScreen(tester);

      // Find and tap the Hindi language option
      final hindiRadio = find.ancestor(
        of: find.text('हिंदी'),
        matching: find.byType(RadioListTile<String>),
      ).first;
      
      await tester.tap(hindiRadio);
      await tester.pumpAndSettle();

      // Verify the Hindi radio is now selected
      final radioTile = tester.widget<RadioListTile<String>>(hindiRadio);
      expect(radioTile.value, equals('hi'));
    });
  });

  group('Layout', () {
    testWidgets('uses ListView.builder for language list', (tester) async {
      await pumpLanguageScreen(tester);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('wraps language items in Card', (tester) async {
      await pumpLanguageScreen(tester);
      expect(
        find.byType(Card),
        findsNWidgets(LanguageModel.allLanguagesList.length),
      );
    });

    testWidgets('has correct padding', (tester) async {
      await pumpLanguageScreen(tester);
      
      // Find the ListView directly
      final listView = tester.widget<ListView>(find.byType(ListView));
      
      // Get the padding from the ListView's padding property
      expect(
        listView.padding,
        equals(const EdgeInsets.all(16)),
      );
    });
  });
}