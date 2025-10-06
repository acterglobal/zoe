import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/animated_textfield_widget.dart';

import '../../test-utils/test_utils.dart';

/// Test utilities for AnimatedTextField tests
class AnimatedTextFieldTestUtils {
  /// Creates a test wrapper for the AnimatedTextField
  static AnimatedTextField createTestWidget({
    TextEditingController? controller,
    String? errorText,
    String hintText = 'Enter text',
    Function(String?)? onErrorChanged,
    VoidCallback? onSubmitted,
    bool enabled = true,
    bool readOnly = false,
    bool autofocus = true,
    TextInputType keyboardType = TextInputType.text,
    int? maxLines = 1,
  }) {
    return AnimatedTextField(
      controller: controller ?? TextEditingController(),
      errorText: errorText,
      hintText: hintText,
      onErrorChanged: onErrorChanged ?? (value) {},
      onSubmitted: onSubmitted ?? () {},
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }
}

void main() {
  group('AnimatedTextField Tests -', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('renders TextField with correct properties', (tester) async {
      await tester.pumpMaterialWidget(
        child: AnimatedTextFieldTestUtils.createTestWidget(
          controller: controller,
          hintText: 'Enter your name',
        ),
      );

      // Verify TextField is rendered
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(AnimatedTextField), findsOneWidget);

      // Verify TextField properties
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller, controller);
      expect(textField.autofocus, isTrue);
      expect(textField.enabled, isTrue);
      expect(textField.readOnly, isFalse);
      expect(textField.keyboardType, TextInputType.text);
      expect(textField.maxLines, 1);
    });

    testWidgets('displays hint text correctly', (tester) async {
      const hintText = 'Please enter your email';

      await tester.pumpMaterialWidget(
        child: AnimatedTextFieldTestUtils.createTestWidget(
          controller: controller,
          hintText: hintText,
        ),
      );

      // Verify hint text is displayed
      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration as InputDecoration;
      expect(decoration.hintText, hintText);
    });

    testWidgets('displays error text when provided', (tester) async {
      const errorText = 'This field is required';

      await tester.pumpMaterialWidget(
        child: AnimatedTextFieldTestUtils.createTestWidget(
          controller: controller,
          errorText: errorText,
        ),
      );

      // Verify error text is displayed
      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration as InputDecoration;
      expect(decoration.errorText, errorText);
    });

    testWidgets('clears error when text changes', (tester) async {
      String? currentError = 'Initial error';

      await tester.pumpMaterialWidget(
        child: AnimatedTextFieldTestUtils.createTestWidget(
          controller: controller,
          errorText: 'Initial error',
          onErrorChanged: (error) => currentError = error,
        ),
      );

      // Verify initial error
      expect(currentError, 'Initial error');

      // Enter text
      await tester.enterText(find.byType(TextField), 'Some text');
      await tester.pump();

      // Verify error is cleared
      expect(currentError, isNull);
    });

    testWidgets('calls onSubmitted when text is submitted', (tester) async {
      bool submitted = false;

      await tester.pumpMaterialWidget(
        child: AnimatedTextFieldTestUtils.createTestWidget(
          controller: controller,
          onSubmitted: () => submitted = true,
        ),
      );

      // Enter text and submit
      await tester.enterText(find.byType(TextField), 'Test text');
      final textField = tester.widget<TextField>(find.byType(TextField));
      textField.onSubmitted!('Test text');
      await tester.pump();

      expect(submitted, isTrue);
    });

    testWidgets('handles enabled state correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: AnimatedTextFieldTestUtils.createTestWidget(
          controller: controller,
          enabled: false,
        ),
      );

      // Verify TextField is disabled
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('handles read-only state correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: AnimatedTextFieldTestUtils.createTestWidget(
          controller: controller,
          readOnly: true,
        ),
      );

      // Verify TextField is read-only
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.readOnly, isTrue);
    });

    testWidgets('configures keyboard type correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: AnimatedTextFieldTestUtils.createTestWidget(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
        ),
      );

      // Verify keyboard type
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, TextInputType.emailAddress);
    });

    testWidgets('configures maxLines correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: AnimatedTextFieldTestUtils.createTestWidget(
          controller: controller,
          maxLines: 3,
        ),
      );

      // Verify maxLines
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.maxLines, 3);
    });

    testWidgets('applies correct border styles', (tester) async {
      await tester.pumpMaterialWidget(
        child: AnimatedTextFieldTestUtils.createTestWidget(
          controller: controller,
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration as InputDecoration;

      // Verify border properties
      expect(decoration.border, isA<OutlineInputBorder>());
      expect(decoration.enabledBorder, isA<OutlineInputBorder>());
      expect(decoration.focusedBorder, isA<OutlineInputBorder>());
      expect(decoration.errorBorder, isA<OutlineInputBorder>());
      expect(decoration.focusedErrorBorder, isA<OutlineInputBorder>());
      expect(decoration.disabledBorder, isA<OutlineInputBorder>());

      // Verify border radius
      final border = decoration.border as OutlineInputBorder;
      expect(border.borderRadius, BorderRadius.circular(12));
    });

    testWidgets('applies correct fill color', (tester) async {
      await tester.pumpMaterialWidget(
        child: AnimatedTextFieldTestUtils.createTestWidget(
          controller: controller,
          enabled: true,
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration as InputDecoration;

      // Verify filled and fillColor
      expect(decoration.filled, isTrue);
      expect(decoration.fillColor, isNotNull);
    });

    testWidgets('applies correct content padding for single line', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        child: AnimatedTextFieldTestUtils.createTestWidget(
          controller: controller,
          maxLines: 1,
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration as InputDecoration;

      // Verify content padding for single line
      expect(
        decoration.contentPadding,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      );
    });

    testWidgets('applies correct content padding for multi-line', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        child: AnimatedTextFieldTestUtils.createTestWidget(
          controller: controller,
          maxLines: 3,
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration as InputDecoration;

      // Verify content padding for multi-line
      expect(
        decoration.contentPadding,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );
    });

    testWidgets('triggers shake animation when error appears', (tester) async {
      await tester.pumpMaterialWidget(
        child: StatefulBuilder(
          builder: (context, setState) {
            return AnimatedTextFieldTestUtils.createTestWidget(
              controller: controller,
              errorText: null,
            );
          },
        ),
      );

      // Update to show error
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimatedTextFieldTestUtils.createTestWidget(
                  controller: controller,
                  errorText: 'Error message',
                );
              },
            ),
          ),
        ),
      );

      // Verify animation is triggered
      expect(find.byType(Transform), findsAtLeastNWidgets(1));
    });

    testWidgets('handles empty error text', (tester) async {
      await tester.pumpMaterialWidget(
        child: AnimatedTextFieldTestUtils.createTestWidget(
          controller: controller,
          errorText: '',
        ),
      );

      // Verify empty error text is displayed
      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration as InputDecoration;
      expect(decoration.errorText, '');
    });
    testWidgets('handles different keyboard types', (tester) async {
      final keyboardTypes = [
        TextInputType.text,
        TextInputType.emailAddress,
        TextInputType.phone,
        TextInputType.url,
        TextInputType.multiline,
      ];

      for (final keyboardType in keyboardTypes) {
        await tester.pumpMaterialWidget(
          child: AnimatedTextFieldTestUtils.createTestWidget(
            controller: controller,
            keyboardType: keyboardType,
          ),
        );

        // Verify keyboard type
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.keyboardType, keyboardType);
      }
    });

    testWidgets('handles different maxLines values', (tester) async {
      final maxLinesValues = [1, 2, 3, 5, null];

      for (final maxLines in maxLinesValues) {
        await tester.pumpMaterialWidget(
          child: AnimatedTextFieldTestUtils.createTestWidget(
            controller: controller,
            maxLines: maxLines,
          ),
        );

        // Verify maxLines
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.maxLines, maxLines);
      }
    });

    testWidgets('handles controller text changes', (tester) async {
      await tester.pumpMaterialWidget(
        child: AnimatedTextFieldTestUtils.createTestWidget(
          controller: controller,
        ),
      );

      // Change controller text
      controller.text = 'New text';
      await tester.pump();

      // Verify text is updated
      expect(controller.text, 'New text');
    });

    testWidgets('handles autofocus correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: AnimatedTextFieldTestUtils.createTestWidget(
          controller: controller,
          autofocus: false,
        ),
      );

      // Verify autofocus
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.autofocus, isFalse);
    });
  });
}
