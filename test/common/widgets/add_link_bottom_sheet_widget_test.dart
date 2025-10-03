import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/add_link_bottom_sheet_widget.dart';
import 'package:zoe/common/widgets/animated_textfield_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/common/widgets/toolkit/zoe_secondary_button.dart';
import 'package:zoe/l10n/generated/l10n.dart';

import '../../test-utils/test_utils.dart';

/// Test utilities for AddLinkBottomSheetWidget tests
class AddLinkBottomSheetTestUtils {
  /// Creates a test wrapper for the AddLinkBottomSheetWidget
  static AddLinkBottomSheetWidget createTestWidget({
    String selectedText = 'Test Text',
  }) {
    return AddLinkBottomSheetWidget(selectedText: selectedText);
  }

  /// Shows the bottom sheet in a test environment
  static Future<String?> showTestBottomSheet(
    WidgetTester tester, {
    String selectedText = 'Test Text',
  }) async {
    String? result;
    await tester.pumpMaterialWidget(
      child: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () async {
              result = await showAddLinkBottomSheet(context, selectedText);
            },
            child: const Text('Show Bottom Sheet'),
          );
        },
      ),
    );

    // Tap the button to show the bottom sheet
    await tester.tap(find.text('Show Bottom Sheet'));
    await tester.pumpAndSettle();

    return result;
  }
}

void main() {
  group('AddLinkBottomSheetWidget Tests -', () {
    testWidgets('renders all required UI elements', (tester) async {
      await tester.pumpMaterialWidget(
        child: AddLinkBottomSheetTestUtils.createTestWidget(
          selectedText: 'Hello World',
        ),
      );

      // Verify icon container is present
      expect(find.byType(StyledIconContainer), findsOneWidget);
      expect(find.byIcon(Icons.link_outlined), findsAtLeastNWidgets(1));

      // Verify text elements
      expect(
        find.text(
          L10n.of(
            tester.element(find.byType(AddLinkBottomSheetWidget)),
          ).insertLinkIn,
        ),
        findsOneWidget,
      );

      // Verify text field
      expect(find.byType(AnimatedTextField), findsOneWidget);

      // Verify buttons
      expect(find.byType(ZoePrimaryButton), findsOneWidget);
      expect(find.byType(ZoeSecondaryButton), findsOneWidget);
      expect(
        find.text(
          L10n.of(
            tester.element(find.byType(AddLinkBottomSheetWidget)),
          ).insertLink,
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          L10n.of(tester.element(find.byType(AddLinkBottomSheetWidget))).cancel,
        ),
        findsOneWidget,
      );
    });

    testWidgets('displays selected text correctly', (tester) async {
      const selectedText = 'Selected Text Content';

      await tester.pumpMaterialWidget(
        child: AddLinkBottomSheetTestUtils.createTestWidget(
          selectedText: selectedText,
        ),
      );

      // Verify selected text is displayed
      expect(find.text("'$selectedText'"), findsOneWidget);
    });

    testWidgets('displays selected text with ellipsis for long text', (
      tester,
    ) async {
      const longText =
          'This is a very long text that should be truncated with ellipsis when displayed in the bottom sheet';

      await tester.pumpMaterialWidget(
        child: AddLinkBottomSheetTestUtils.createTestWidget(
          selectedText: longText,
        ),
      );

      // Verify long text is displayed (ellipsis is handled by Text widget)
      expect(find.text("'$longText'"), findsOneWidget);
    });

    testWidgets('validates URL and returns valid URL on success', (
      tester,
    ) async {
      String? result;

      await tester.pumpMaterialWidget(
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                result = await showAddLinkBottomSheet(context, 'Test Text');
              },
              child: const Text('Show Bottom Sheet'),
            );
          },
        ),
      );

      // Show the bottom sheet
      await tester.tap(find.text('Show Bottom Sheet'));
      await tester.pumpAndSettle();

      // Enter a valid URL
      const validUrl = 'https://www.example.com';
      await tester.enterText(find.byType(AnimatedTextField), validUrl);
      await tester.pump();

      // Tap the insert link button
      await tester.tap(find.byType(ZoePrimaryButton));
      await tester.pumpAndSettle();

      // Verify the result
      expect(result, validUrl);
    });

    testWidgets('shows error for empty URL', (tester) async {
      await tester.pumpMaterialWidget(
        child: AddLinkBottomSheetTestUtils.createTestWidget(),
      );

      // Tap the insert link button without entering any text
      await tester.tap(find.byType(ZoePrimaryButton));
      await tester.pump();

      // Verify error message is shown
      expect(
        find.text(
          L10n.of(
            tester.element(find.byType(AddLinkBottomSheetWidget)),
          ).urlCannotBeEmpty,
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows error for URL with spaces', (tester) async {
      await tester.pumpMaterialWidget(
        child: AddLinkBottomSheetTestUtils.createTestWidget(),
      );

      // Enter URL with spaces
      const urlWithSpaces = 'https://www.example.com/path with spaces';
      await tester.enterText(find.byType(AnimatedTextField), urlWithSpaces);
      await tester.pump();

      // Tap the insert link button
      await tester.tap(find.byType(ZoePrimaryButton));
      await tester.pump();

      // Verify error message is shown
      expect(
        find.text(
          L10n.of(
            tester.element(find.byType(AddLinkBottomSheetWidget)),
          ).urlCannotContainSpaces,
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows error for invalid URL format', (tester) async {
      await tester.pumpMaterialWidget(
        child: AddLinkBottomSheetTestUtils.createTestWidget(),
      );

      // Enter invalid URL
      const invalidUrl = 'not-a-valid-url';
      await tester.enterText(find.byType(AnimatedTextField), invalidUrl);
      await tester.pump();

      // Tap the insert link button
      await tester.tap(find.byType(ZoePrimaryButton));
      await tester.pump();

      // Verify error message is shown
      expect(
        find.text(
          L10n.of(
            tester.element(find.byType(AddLinkBottomSheetWidget)),
          ).pleaseEnterAValidURL,
        ),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('validates URL on text field submission', (tester) async {
      String? result;

      await tester.pumpMaterialWidget(
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                result = await showAddLinkBottomSheet(context, 'Test Text');
              },
              child: const Text('Show Bottom Sheet'),
            );
          },
        ),
      );

      // Show the bottom sheet
      await tester.tap(find.text('Show Bottom Sheet'));
      await tester.pumpAndSettle();

      // Enter a valid URL and submit
      const validUrl = 'https://www.example.com';
      await tester.enterText(find.byType(AnimatedTextField), validUrl);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Verify the result
      expect(result, validUrl);
    });

    testWidgets('cancels and returns null when cancel button is pressed', (
      tester,
    ) async {
      String? result;

      await tester.pumpMaterialWidget(
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                result = await showAddLinkBottomSheet(context, 'Test Text');
              },
              child: const Text('Show Bottom Sheet'),
            );
          },
        ),
      );

      // Show the bottom sheet
      await tester.tap(find.text('Show Bottom Sheet'));
      await tester.pumpAndSettle();

      // Tap the cancel button
      await tester.tap(find.byType(ZoeSecondaryButton));
      await tester.pumpAndSettle();

      // Verify the result is null
      expect(result, isNull);
    });

    testWidgets('handles different URL formats correctly', (tester) async {
      final validUrls = [
        'https://www.example.com',
        'http://example.com',
        'https://subdomain.example.com/path',
        'https://example.com:8080/path',
        'https://192.168.1.1',
        'https://localhost:3000',
      ];

      for (final url in validUrls) {
        String? result;

        await tester.pumpMaterialWidget(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await showAddLinkBottomSheet(context, 'Test Text');
                },
                child: const Text('Show Bottom Sheet'),
              );
            },
          ),
        );

        // Show the bottom sheet
        await tester.tap(find.text('Show Bottom Sheet'));
        await tester.pumpAndSettle();

        // Enter the URL
        await tester.enterText(find.byType(AnimatedTextField), url);
        await tester.pump();

        // Tap the insert link button
        await tester.tap(find.byType(ZoePrimaryButton));
        await tester.pumpAndSettle();

        // Verify the result
        expect(result, url, reason: 'Failed for URL: $url');
      }
    });

    testWidgets('handles edge cases for selected text', (tester) async {
      final edgeCases = [
        '', // Empty string
        ' ', // Single space
        'a', // Single character
        'Very long text that exceeds normal length and should be handled gracefully by the ellipsis overflow',
      ];

      for (final selectedText in edgeCases) {
        await tester.pumpMaterialWidget(
          child: AddLinkBottomSheetTestUtils.createTestWidget(
            selectedText: selectedText,
          ),
        );

        // Verify the text is displayed
        expect(find.text("'$selectedText'"), findsOneWidget);
      }
    });
  });
}
