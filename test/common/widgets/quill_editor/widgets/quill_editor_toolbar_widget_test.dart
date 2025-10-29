import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zoe/common/widgets/quill_editor/widgets/quill_editor_toolbar_widget.dart';
import 'package:zoe/common/widgets/quill_editor/widgets/quill_toolbar_widget.dart';

import '../../../../test-utils/test_utils.dart';

void main() {
  group('QuillEditorToolbarWidget Tests', () {
    late QuillController controller;
    late FocusNode focusNode;

    setUp(() {
      controller = QuillController.basic();
      focusNode = FocusNode();
    });

    tearDown(() {
      controller.dispose();
      focusNode.dispose();
    });

    Future<void> pumpQuillEditorToolbar(
      WidgetTester tester, {
      FocusNode? providedFocusNode,
      QuillController? providedController,
      bool isToolbarVisible = false,
      VoidCallback? onReturnFocusToEditor,
      ThemeData? theme,
    }) async {
      await tester.pumpMaterialWidget(
        child: QuillEditorToolbarWidget(
          controller: providedController ?? controller,
          focusNode: providedFocusNode ?? focusNode,
          isToolbarVisible: isToolbarVisible,
          onReturnFocusToEditor: onReturnFocusToEditor,
        ),
        theme: theme,
      );
    }

    group('Widget Initialization', () {
      testWidgets('renders with correct structure when visible', (
        tester,
      ) async {
        await pumpQuillEditorToolbar(tester, isToolbarVisible: true);

        // Check main container
        expect(find.byType(AnimatedContainer), findsOneWidget);
        expect(find.byType(AnimatedOpacity), findsOneWidget);
        expect(find.byType(QuillToolbar), findsOneWidget);
      });

      testWidgets('renders with correct structure when hidden', (tester) async {
        await pumpQuillEditorToolbar(tester, isToolbarVisible: false);

        // Check main container
        expect(find.byType(AnimatedContainer), findsOneWidget);
        expect(find.byType(AnimatedOpacity), findsOneWidget);
        // QuillToolbar should still be present but with opacity 0
        expect(find.byType(QuillToolbar), findsOneWidget);
      });
    });

    group('Visibility and Animation', () {
      testWidgets('shows toolbar when isToolbarVisible is true', (
        tester,
      ) async {
        await pumpQuillEditorToolbar(tester, isToolbarVisible: true);

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        expect(animatedContainer.constraints?.maxHeight, equals(60));

        final animatedOpacity = tester.widget<AnimatedOpacity>(
          find.byType(AnimatedOpacity),
        );
        expect(animatedOpacity.opacity, equals(1.0));
      });

      testWidgets('hides toolbar when isToolbarVisible is false', (
        tester,
      ) async {
        await pumpQuillEditorToolbar(tester, isToolbarVisible: false);

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        expect(animatedContainer.constraints?.maxHeight, equals(0));

        final animatedOpacity = tester.widget<AnimatedOpacity>(
          find.byType(AnimatedOpacity),
        );
        expect(animatedOpacity.opacity, equals(0.0));
      });

      testWidgets('animates visibility changes', (tester) async {
        await pumpQuillEditorToolbar(tester, isToolbarVisible: false);

        // Initially hidden
        expect(
          tester
              .widget<AnimatedContainer>(find.byType(AnimatedContainer))
              .constraints
              ?.maxHeight,
          equals(0),
        );

        // Change to visible
        await pumpQuillEditorToolbar(tester, isToolbarVisible: true);

        // Should animate to visible state
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Check that animation is in progress
        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        expect(animatedContainer.constraints?.maxHeight, greaterThan(0));
        expect(animatedContainer.constraints?.maxHeight, lessThanOrEqualTo(60));
      });

      testWidgets('has correct animation duration and curve', (tester) async {
        await pumpQuillEditorToolbar(tester, isToolbarVisible: true);

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final animatedOpacity = tester.widget<AnimatedOpacity>(
          find.byType(AnimatedOpacity),
        );

        // Both should have the same duration
        expect(animatedContainer.duration, equals(animatedOpacity.duration));

        // Duration should be reasonable (between 200-250ms)
        expect(
          animatedContainer.duration.inMilliseconds,
          greaterThanOrEqualTo(200),
        );
        expect(
          animatedContainer.duration.inMilliseconds,
          lessThanOrEqualTo(250),
        );
      });
    });

    group('Platform-Specific Behavior', () {
      testWidgets('uses appropriate animation curve based on platform', (
        tester,
      ) async {
        await pumpQuillEditorToolbar(tester, isToolbarVisible: true);

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );

        // Should use either easeInOut or easeOut curve
        expect(
          animatedContainer.curve,
          anyOf(equals(Curves.easeInOut), equals(Curves.easeOut)),
        );
      });

      testWidgets('has appropriate animation duration', (tester) async {
        await pumpQuillEditorToolbar(tester, isToolbarVisible: true);

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );

        // Should use either 200ms or 250ms duration
        expect(
          animatedContainer.duration.inMilliseconds,
          anyOf(equals(200), equals(250)),
        );
      });

      testWidgets('maintains consistent animation properties', (tester) async {
        await pumpQuillEditorToolbar(tester, isToolbarVisible: true);

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final animatedOpacity = tester.widget<AnimatedOpacity>(
          find.byType(AnimatedOpacity),
        );

        // Both animations should have the same duration
        expect(animatedContainer.duration, equals(animatedOpacity.duration));

        // Duration should be reasonable
        expect(
          animatedContainer.duration.inMilliseconds,
          greaterThanOrEqualTo(200),
        );
        expect(
          animatedContainer.duration.inMilliseconds,
          lessThanOrEqualTo(250),
        );
      });
    });

    group('Decoration and Styling', () {
      testWidgets('applies correct decoration when visible', (tester) async {
        await pumpQuillEditorToolbar(tester, isToolbarVisible: true);

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );

        final decoration = animatedContainer.decoration as BoxDecoration;
        expect(
          decoration.color,
          equals(
            Theme.of(
              tester.element(find.byType(QuillEditorToolbarWidget)),
            ).colorScheme.surface,
          ),
        );
        expect(decoration.boxShadow, isNotNull);
        expect(decoration.boxShadow!.length, equals(1));

        final shadow = decoration.boxShadow!.first;
        expect(shadow.color, equals(Colors.black.withValues(alpha: 0.1)));
        expect(shadow.blurRadius, equals(4));
        expect(shadow.offset, equals(const Offset(0, 2)));
      });

      testWidgets('applies correct decoration when hidden', (tester) async {
        await pumpQuillEditorToolbar(tester, isToolbarVisible: false);

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );

        final decoration = animatedContainer.decoration as BoxDecoration;
        expect(
          decoration.color,
          equals(
            Theme.of(
              tester.element(find.byType(QuillEditorToolbarWidget)),
            ).colorScheme.surface,
          ),
        );
        expect(decoration.boxShadow, isNull);
      });

      testWidgets('respects theme colors', (tester) async {
        final customTheme = ThemeData(
          colorScheme: const ColorScheme.light(
            surface: Colors.red,
            primary: Colors.blue,
          ),
        );

        await pumpQuillEditorToolbar(
          tester,
          isToolbarVisible: true,
          theme: customTheme,
        );

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );

        final decoration = animatedContainer.decoration as BoxDecoration;
        expect(decoration.color, equals(Colors.red));
      });
    });

    group('Callback Functionality', () {
      testWidgets('passes onReturnFocusToEditor callback to QuillToolbar', (
        tester,
      ) async {
        bool callbackCalled = false;
        await pumpQuillEditorToolbar(
          tester,
          isToolbarVisible: true,
          onReturnFocusToEditor: () => callbackCalled = true,
        );

        // Find the QuillToolbar and verify it has the callback
        final quillToolbar = tester.widget<QuillToolbar>(
          find.byType(QuillToolbar),
        );

        expect(quillToolbar.onButtonPressed, isNotNull);

        // The callback should be the same function we passed
        expect(quillToolbar.onButtonPressed, isA<VoidCallback>());

        // Test that the callback actually works by triggering it
        quillToolbar.onButtonPressed!();
        expect(callbackCalled, isTrue);
      });

      testWidgets('handles null callback gracefully', (tester) async {
        await pumpQuillEditorToolbar(
          tester,
          isToolbarVisible: true,
          onReturnFocusToEditor: null,
        );

        // Should not throw
        expect(find.byType(QuillEditorToolbarWidget), findsOneWidget);

        final quillToolbar = tester.widget<QuillToolbar>(
          find.byType(QuillToolbar),
        );

        expect(quillToolbar.onButtonPressed, isNull);
      });
    });

    group('Widget Lifecycle', () {
      testWidgets('handles controller changes properly', (tester) async {
        await pumpQuillEditorToolbar(tester, isToolbarVisible: true);

        // Create a new controller
        final newController = QuillController.basic();

        // Update widget with new controller
        await pumpQuillEditorToolbar(
          tester,
          providedController: newController,
          isToolbarVisible: true,
        );

        // Widget should still be present
        expect(find.byType(QuillEditorToolbarWidget), findsOneWidget);
        expect(find.byType(QuillToolbar), findsOneWidget);

        // Clean up
        newController.dispose();
      });

      testWidgets('handles focusNode changes properly', (tester) async {
        await pumpQuillEditorToolbar(tester, isToolbarVisible: true);

        // Create a new focus node
        final newFocusNode = FocusNode();

        // Update widget with new focus node
        await pumpQuillEditorToolbar(
          tester,
          providedFocusNode: newFocusNode,
          isToolbarVisible: true,
        );

        // Widget should still be present
        expect(find.byType(QuillEditorToolbarWidget), findsOneWidget);
        expect(find.byType(QuillToolbar), findsOneWidget);

        // Clean up
        newFocusNode.dispose();
      });

      testWidgets('disposes properly without memory leaks', (tester) async {
        await pumpQuillEditorToolbar(tester, isToolbarVisible: true);

        // Remove widget from tree
        await tester.pumpWidget(const SizedBox());

        // Should not throw when controller/focusNode change after disposal
        expect(() {
          controller.document.insert(0, 'Test');
          focusNode.requestFocus();
        }, returnsNormally);
      });
    });

    group('Edge Cases and Error Handling', () {
      testWidgets('handles empty controller gracefully', (tester) async {
        final emptyController = QuillController.basic();

        await pumpQuillEditorToolbar(
          tester,
          providedController: emptyController,
          isToolbarVisible: true,
        );

        // Should not throw
        expect(find.byType(QuillEditorToolbarWidget), findsOneWidget);

        emptyController.dispose();
      });
    });
  });
}
