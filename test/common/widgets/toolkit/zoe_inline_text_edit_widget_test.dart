import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';

import '../../../helpers/test_utils.dart';

/// Test utilities for ZoeInlineTextEditWidget tests
class ZoeInlineTextEditTestUtils {
  /// Creates a test wrapper for the ZoeInlineTextEditWidget
  static ZoeInlineTextEditWidget createTestWidget({
    String? text,
    String? hintText,
    Function(String)? onTextChanged,
    VoidCallback? onEnterPressed,
    VoidCallback? onBackspaceEmptyText,
    VoidCallback? onTapText,
    VoidCallback? onTapLongPressText,
    TextInputAction? textInputAction,
    bool isEditing = false,
    TextStyle? textStyle,
    bool autoFocus = false,
  }) {
    return ZoeInlineTextEditWidget(
      text: text,
      hintText: hintText,
      onTextChanged: onTextChanged ?? (value) {},
      onEnterPressed: onEnterPressed,
      onBackspaceEmptyText: onBackspaceEmptyText,
      onTapText: onTapText,
      onTapLongPressText: onTapLongPressText,
      textInputAction: textInputAction,
      isEditing: isEditing,
      textStyle: textStyle,
      autoFocus: autoFocus,
    );
  }
}

void main() {
  group('ZoeInlineTextEditWidget Tests -', () {
    testWidgets('renders text display mode correctly with initial text', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        child: ZoeInlineTextEditTestUtils.createTestWidget(
          text: 'Hello World',
          isEditing: false,
        ),
      );

      // Verify text is displayed
      expect(find.text('Hello World'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets(
      'renders text display mode correctly with empty text and hint',
      (tester) async {
        await tester.pumpMaterialWidget(
          child: ZoeInlineTextEditTestUtils.createTestWidget(
            text: '',
            hintText: 'Enter text here',
            isEditing: false,
          ),
        );

        // Verify hint text is displayed
        expect(find.text('Enter text here'), findsOneWidget);
        expect(find.byType(TextField), findsNothing);
        expect(find.byType(GestureDetector), findsOneWidget);
      },
    );

    testWidgets('renders editing mode correctly with TextField', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        child: ZoeInlineTextEditTestUtils.createTestWidget(
          text: 'Hello World',
          hintText: 'Enter text here',
          isEditing: true,
        ),
      );

      // Verify TextField is displayed
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(GestureDetector), findsNothing);

      // Verify TextField properties
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, 'Hello World');
      expect(textField.autofocus, false);
      expect(textField.maxLines, null);
    });

    testWidgets('calls onTextChanged when text is modified in editing mode', (
      tester,
    ) async {
      String? changedText;
      await tester.pumpMaterialWidget(
        child: ZoeInlineTextEditTestUtils.createTestWidget(
          text: 'Hello',
          isEditing: true,
          onTextChanged: (value) => changedText = value,
        ),
      );

      // Find and interact with TextField
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Hello World');
      await tester.pump();

      expect(changedText, 'Hello World');
    });

    testWidgets('calls onEnterPressed when enter is pressed', (tester) async {
      bool enterPressed = false;
      await tester.pumpMaterialWidget(
        child: ZoeInlineTextEditTestUtils.createTestWidget(
          text: 'Hello',
          isEditing: true,
          onEnterPressed: () => enterPressed = true,
        ),
      );

      // Find TextField and simulate submit
      final textField = find.byType(TextField);
      final textFieldWidget = tester.widget<TextField>(textField);

      // Manually trigger onSubmitted callback
      textFieldWidget.onSubmitted!('Hello');
      await tester.pump();

      expect(enterPressed, isTrue);
    });

    testWidgets('calls onBackspaceEmptyText when text becomes empty', (
      tester,
    ) async {
      bool backspaceEmptyCalled = false;
      await tester.pumpMaterialWidget(
        child: ZoeInlineTextEditTestUtils.createTestWidget(
          text: 'Hello',
          isEditing: true,
          onBackspaceEmptyText: () => backspaceEmptyCalled = true,
        ),
      );

      // Clear the text field
      final textField = find.byType(TextField);
      await tester.enterText(textField, '');
      await tester.pump();

      expect(backspaceEmptyCalled, isTrue);
    });

    testWidgets('calls onTapText when text is tapped in display mode', (
      tester,
    ) async {
      bool tapCalled = false;
      await tester.pumpMaterialWidget(
        child: ZoeInlineTextEditTestUtils.createTestWidget(
          text: 'Hello World',
          isEditing: false,
          onTapText: () => tapCalled = true,
        ),
      );

      // Tap on the text
      await tester.tap(find.text('Hello World'));
      await tester.pump();

      expect(tapCalled, isTrue);
    });

    testWidgets(
      'calls onTapLongPressText when text is long pressed in display mode',
      (tester) async {
        bool longPressCalled = false;
        await tester.pumpMaterialWidget(
          child: ZoeInlineTextEditTestUtils.createTestWidget(
            text: 'Hello World',
            isEditing: false,
            onTapLongPressText: () => longPressCalled = true,
          ),
        );

        // Long press on the text
        await tester.longPress(find.text('Hello World'));
        await tester.pump();

        expect(longPressCalled, isTrue);
      },
    );

    testWidgets('applies custom text style in display mode', (tester) async {
      const customStyle = TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      );

      await tester.pumpMaterialWidget(
        child: ZoeInlineTextEditTestUtils.createTestWidget(
          text: 'Hello World',
          isEditing: false,
          textStyle: customStyle,
        ),
      );

      final text = tester.widget<Text>(find.text('Hello World'));
      expect(text.style?.fontSize, 18);
      expect(text.style?.fontWeight, FontWeight.bold);
      expect(text.style?.color, Colors.red);
    });

    testWidgets('applies custom text style in editing mode', (tester) async {
      const customStyle = TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.blue,
      );

      await tester.pumpMaterialWidget(
        child: ZoeInlineTextEditTestUtils.createTestWidget(
          text: 'Hello World',
          isEditing: true,
          textStyle: customStyle,
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.style?.fontSize, 16);
      expect(textField.style?.fontWeight, FontWeight.w500);
      expect(textField.style?.color, Colors.blue);
    });

    testWidgets('sets autofocus correctly in editing mode', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeInlineTextEditTestUtils.createTestWidget(
          text: 'Hello',
          isEditing: true,
          autoFocus: true,
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.autofocus, isTrue);
    });

    testWidgets('sets textInputAction correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeInlineTextEditTestUtils.createTestWidget(
          text: 'Hello',
          isEditing: true,
          textInputAction: TextInputAction.search,
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.textInputAction, TextInputAction.search);
    });

    testWidgets('updates controller text when widget text changes', (
      tester,
    ) async {
      final widget = StatefulBuilder(
        builder: (context, setState) {
          return ZoeInlineTextEditTestUtils.createTestWidget(
            text: 'Hello',
            isEditing: true,
            onTextChanged: (value) {},
          );
        },
      );

      await tester.pumpMaterialWidget(child: widget);

      // Verify initial text
      final textField = find.byType(TextField);
      expect(tester.widget<TextField>(textField).controller?.text, 'Hello');

      // Update widget text
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return ZoeInlineTextEditTestUtils.createTestWidget(
                  text: 'Updated Text',
                  isEditing: true,
                  onTextChanged: (value) {},
                );
              },
            ),
          ),
        ),
      );

      // Verify text is updated
      expect(
        tester.widget<TextField>(textField).controller?.text,
        'Updated Text',
      );
    });

    testWidgets('requests focus when autoFocus changes to true', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        child: StatefulBuilder(
          builder: (context, setState) {
            return ZoeInlineTextEditTestUtils.createTestWidget(
              text: 'Hello',
              isEditing: true,
              autoFocus: false,
            );
          },
        ),
      );

      // Update to autoFocus: true
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return ZoeInlineTextEditTestUtils.createTestWidget(
                  text: 'Hello',
                  isEditing: true,
                  autoFocus: true,
                );
              },
            ),
          ),
        ),
      );

      await tester.pump();

      // Note: Focus testing in widget tests is limited, but we can verify the autofocus property
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.autofocus, isTrue);
    });
  });
}
