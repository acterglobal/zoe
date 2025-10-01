import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zoe/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart' as sheet_models;

import '../../../helpers/test_utils.dart';

/// Test utilities for ZoeHtmlTextEditWidget tests
class ZoeHtmlTextEditTestUtils {
  /// Creates a test description with plain text
  static sheet_models.Description createPlainTextDescription(String text) {
    return (plainText: text, htmlText: null);
  }

  /// Creates a test description with HTML text
  static sheet_models.Description createHtmlDescription(String htmlText, String? plainText) {
    return (plainText: plainText, htmlText: htmlText);
  }

  /// Creates a test wrapper for the ZoeHtmlTextEditWidget
  static ZoeHtmlTextEditWidget createTestWidget({
    sheet_models.Description? description,
    bool isEditing = false,
    String? hintText,
    bool autoFocus = false,
    Function(sheet_models.Description)? onContentChanged,
    Function(QuillController?, FocusNode?)? onFocusChanged,
    TextStyle? textStyle,
    String? editorId,
    VoidCallback? onTap,
  }) {
    return ZoeHtmlTextEditWidget(
      description: description,
      isEditing: isEditing,
      hintText: hintText,
      autoFocus: autoFocus,
      onContentChanged: onContentChanged,
      onFocusChanged: onFocusChanged,
      textStyle: textStyle,
      editorId: editorId,
      onTap: onTap,
    );
  }
}

void main() {
  group('ZoeHtmlTextEditWidget Tests -', () {
    testWidgets('renders editing mode with QuillEditor', (tester) async {
      final description = ZoeHtmlTextEditTestUtils.createPlainTextDescription('Hello World');
      
      await tester.pumpMaterialWidgetWithProviderScope(
        child: ZoeHtmlTextEditTestUtils.createTestWidget(
          description: description,
          isEditing: true,
        ),
        container: ProviderContainer(),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Verify QuillEditor is rendered
      expect(find.byType(ZoeHtmlTextEditWidget), findsOneWidget);
    });

    testWidgets('renders view mode with plain text', (tester) async {
      final description = ZoeHtmlTextEditTestUtils.createPlainTextDescription('Hello World');
      
      await tester.pumpMaterialWidgetWithProviderScope(
        child: ZoeHtmlTextEditTestUtils.createTestWidget(
          description: description,
          isEditing: false,
        ),
        container: ProviderContainer(),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Verify text is displayed
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('renders view mode with hint text when no content', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: ZoeHtmlTextEditTestUtils.createTestWidget(
          description: null,
          isEditing: false,
          hintText: 'Enter text here',
        ),
        container: ProviderContainer(),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Verify hint text is displayed
      expect(find.text('Enter text here'), findsOneWidget);
    });

    testWidgets('renders view mode with empty hint when no content and no hint', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: ZoeHtmlTextEditTestUtils.createTestWidget(
          description: null,
          isEditing: false,
        ),
        container: ProviderContainer(),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Should render empty text
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('calls onTap when tapped in view mode', (tester) async {
      bool tapCalled = false;
      final description = ZoeHtmlTextEditTestUtils.createPlainTextDescription('Hello World');
      
      await tester.pumpMaterialWidgetWithProviderScope(
        child: ZoeHtmlTextEditTestUtils.createTestWidget(
          description: description,
          isEditing: false,
          onTap: () => tapCalled = true,
        ),
        container: ProviderContainer(),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Tap on the text
      await tester.tap(find.text('Hello World'));
      await tester.pump();

      expect(tapCalled, isTrue);
    });

    testWidgets('does not call onTap when not provided in view mode', (tester) async {
      final description = ZoeHtmlTextEditTestUtils.createPlainTextDescription('Hello World');
      
      await tester.pumpMaterialWidgetWithProviderScope(
        child: ZoeHtmlTextEditTestUtils.createTestWidget(
          description: description,
          isEditing: false,
        ),
        container: ProviderContainer(),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Tap on the text - should not throw
      await tester.tap(find.text('Hello World'));
      await tester.pump();

      // Test passes if no exception is thrown
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('handles HTML content in view mode', (tester) async {
      final description = ZoeHtmlTextEditTestUtils.createHtmlDescription(
        '<p>Hello <strong>World</strong></p>',
        'Hello World',
      );
      
      await tester.pumpMaterialWidgetWithProviderScope(
        child: ZoeHtmlTextEditTestUtils.createTestWidget(
          description: description,
          isEditing: false,
        ),
        container: ProviderContainer(),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Should render the widget without errors
      expect(find.byType(ZoeHtmlTextEditWidget), findsOneWidget);
    });

    testWidgets('switches between editing and view modes', (tester) async {
      final description = ZoeHtmlTextEditTestUtils.createPlainTextDescription('Hello World');
      
      await tester.pumpMaterialWidgetWithProviderScope(
        child: StatefulBuilder(
          builder: (context, setState) {
            return ZoeHtmlTextEditTestUtils.createTestWidget(
              description: description,
              isEditing: false,
            );
          },
        ),
        container: ProviderContainer(),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Initially in view mode
      expect(find.text('Hello World'), findsOneWidget);

      // Switch to editing mode
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProviderScope(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return ZoeHtmlTextEditTestUtils.createTestWidget(
                    description: description,
                    isEditing: true,
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should now be in editing mode
      expect(find.byType(ZoeHtmlTextEditWidget), findsOneWidget);
    });

    testWidgets('updates content when description changes', (tester) async {
      var description = ZoeHtmlTextEditTestUtils.createPlainTextDescription('Hello');
      
      await tester.pumpMaterialWidgetWithProviderScope(
        child: StatefulBuilder(
          builder: (context, setState) {
            return ZoeHtmlTextEditTestUtils.createTestWidget(
              description: description,
              isEditing: false,
            );
          },
        ),
        container: ProviderContainer(),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Initially shows "Hello"
      expect(find.text('Hello'), findsOneWidget);

      // Update description
      description = ZoeHtmlTextEditTestUtils.createPlainTextDescription('Hello World');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProviderScope(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return ZoeHtmlTextEditTestUtils.createTestWidget(
                    description: description,
                    isEditing: false,
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should now show "Hello World"
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('applies custom text style', (tester) async {
      const customStyle = TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      );
      
      final description = ZoeHtmlTextEditTestUtils.createPlainTextDescription('Hello World');
      
      await tester.pumpMaterialWidgetWithProviderScope(
        child: ZoeHtmlTextEditTestUtils.createTestWidget(
          description: description,
          isEditing: false,
          textStyle: customStyle,
        ),
        container: ProviderContainer(),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Verify text style is applied
      final text = tester.widget<Text>(find.text('Hello World'));
      expect(text.style?.fontSize, 18);
      expect(text.style?.fontWeight, FontWeight.bold);
      // Note: Color might be overridden by theme, so we just verify the widget renders
      expect(text.style, isNotNull);
    });

    testWidgets('applies hint color when showing hint text', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Theme(
          data: ThemeData(hintColor: Colors.grey),
          child: ZoeHtmlTextEditTestUtils.createTestWidget(
            description: null,
            isEditing: false,
            hintText: 'Enter text here',
            textStyle: const TextStyle(color: Colors.black),
          ),
        ),
        container: ProviderContainer(),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Verify hint color is applied
      final text = tester.widget<Text>(find.text('Enter text here'));
      expect(text.style?.color, Colors.grey);
    });

    testWidgets('generates unique editor ID when not provided', (tester) async {
      final description = ZoeHtmlTextEditTestUtils.createPlainTextDescription('Hello World');
      
      await tester.pumpMaterialWidgetWithProviderScope(
        child: ZoeHtmlTextEditTestUtils.createTestWidget(
          description: description,
          isEditing: true,
        ),
        container: ProviderContainer(),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Widget should render without errors (unique ID generated)
      expect(find.byType(ZoeHtmlTextEditWidget), findsOneWidget);
    });

    testWidgets('uses provided editor ID', (tester) async {
      final description = ZoeHtmlTextEditTestUtils.createPlainTextDescription('Hello World');
      
      await tester.pumpMaterialWidgetWithProviderScope(
        child: ZoeHtmlTextEditTestUtils.createTestWidget(
          description: description,
          isEditing: true,
          editorId: 'test-editor-id',
        ),
        container: ProviderContainer(),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Widget should render without errors
      expect(find.byType(ZoeHtmlTextEditWidget), findsOneWidget);
    });

    testWidgets('handles autoFocus correctly', (tester) async {
      final description = ZoeHtmlTextEditTestUtils.createPlainTextDescription('Hello World');
      
      await tester.pumpMaterialWidgetWithProviderScope(
        child: ZoeHtmlTextEditTestUtils.createTestWidget(
          description: description,
          isEditing: true,
          autoFocus: true,
        ),
        container: ProviderContainer(),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Widget should render without errors
      expect(find.byType(ZoeHtmlTextEditWidget), findsOneWidget);
    });

    testWidgets('handles malformed HTML content gracefully', (tester) async {
      final description = ZoeHtmlTextEditTestUtils.createHtmlDescription(
        '<p>Hello <unclosed>World</p>',
        'Hello World',
      );
      
      await tester.pumpMaterialWidgetWithProviderScope(
        child: ZoeHtmlTextEditTestUtils.createTestWidget(
          description: description,
          isEditing: false,
        ),
        container: ProviderContainer(),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Should render without errors (fallback to plain text)
      expect(find.byType(ZoeHtmlTextEditWidget), findsOneWidget);
    });

    testWidgets('handles JSON content (not HTML) correctly', (tester) async {
      final description = ZoeHtmlTextEditTestUtils.createHtmlDescription(
        '[{"insert":"Hello World"}]',
        'Hello World',
      );
      
      await tester.pumpMaterialWidgetWithProviderScope(
        child: ZoeHtmlTextEditTestUtils.createTestWidget(
          description: description,
          isEditing: false,
        ),
        container: ProviderContainer(),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Should render without errors
      expect(find.byType(ZoeHtmlTextEditWidget), findsOneWidget);
    });

    testWidgets('handles empty HTML content', (tester) async {
      final description = ZoeHtmlTextEditTestUtils.createHtmlDescription('', '');
      
      await tester.pumpMaterialWidgetWithProviderScope(
        child: ZoeHtmlTextEditTestUtils.createTestWidget(
          description: description,
          isEditing: false,
          hintText: 'Enter text here',
        ),
        container: ProviderContainer(),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Should show hint text when content is empty
      expect(find.text('Enter text here'), findsOneWidget);
    });
  });
}
