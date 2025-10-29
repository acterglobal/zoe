import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/quill_editor/widgets/quill_editor_positioned_toolbar_widget.dart';
import 'package:zoe/common/widgets/quill_editor/widgets/quill_editor_toolbar_widget.dart';
import 'package:zoe/common/widgets/quill_editor/notifiers/quill_toolbar_notifier.dart';

import '../../../../test-utils/test_utils.dart';

void main() {
  group('QuillEditorPositionedToolbarWidget Tests', () {
    late QuillController controller;
    late FocusNode focusNode;
    late ProviderContainer container;
    late QuillToolbarState testState;

    setUp(() {
      controller = QuillController.basic();
      focusNode = FocusNode();

      // Create default test state
      testState = (
        activeController: controller,
        activeFocusNode: focusNode,
        isToolbarVisible: false,
        activeEditorId: 'test-editor',
      );

      container = ProviderContainer.test(
        overrides: [quillToolbarProvider.overrideWithValue(testState)],
      );
    });

    tearDown(() {
      controller.dispose();
      focusNode.dispose();
    });

    Future<void> pumpPositionedToolbar(
      WidgetTester tester, {
      required bool isEditing,
      QuillController? providedController,
      FocusNode? providedFocusNode,
      bool isToolbarVisible = false,
      String? activeEditorId,
    }) async {
      // Update test state with provided values
      testState = (
        activeController: providedController ?? controller,
        activeFocusNode: providedFocusNode ?? focusNode,
        isToolbarVisible: isToolbarVisible,
        activeEditorId: activeEditorId ?? 'test-editor',
      );

      // Update the existing container's override
      container.updateOverrides([
        quillToolbarProvider.overrideWithValue(testState),
      ]);

      await tester.pumpConsumerWidget(
        container: container,
        builder: (context, ref, child) {
          return Stack(
            children: [
              buildQuillEditorPositionedToolbar(
                context,
                ref,
                isEditing: isEditing,
              ),
            ],
          );
        },
      );
    }

    group('Widget Initialization', () {
      testWidgets('renders with correct structure when conditions are met', (
        tester,
      ) async {
        await pumpPositionedToolbar(
          tester,
          isEditing: true,
          isToolbarVisible: true,
        );

        // Check that Positioned widget is present
        expect(find.byType(Positioned), findsOneWidget);

        // Check that QuillEditorToolbarWidget is nested inside
        expect(find.byType(QuillEditorToolbarWidget), findsOneWidget);
      });

      testWidgets('returns SizedBox.shrink when not editing', (tester) async {
        await pumpPositionedToolbar(
          tester,
          isEditing: false,
          isToolbarVisible: true,
        );

        // Should return SizedBox.shrink when not editing
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(Positioned), findsNothing);
        expect(find.byType(QuillEditorToolbarWidget), findsNothing);
      });
    });

    group('Positioning and Layout', () {
      testWidgets('positions toolbar at bottom of screen', (tester) async {
        await pumpPositionedToolbar(
          tester,
          isEditing: true,
          isToolbarVisible: true,
        );

        final positioned = tester.widget<Positioned>(find.byType(Positioned));

        // Should be positioned at bottom
        expect(positioned.left, equals(0));
        expect(positioned.right, equals(0));
        expect(positioned.bottom, equals(0));
        expect(positioned.top, isNull);
      });

      testWidgets('maintains correct positioning during state changes', (
        tester,
      ) async {
        await pumpPositionedToolbar(
          tester,
          isEditing: true,
          isToolbarVisible: false,
        );

        // Initially hidden
        expect(find.byType(Positioned), findsOneWidget);

        // Change to visible
        await pumpPositionedToolbar(
          tester,
          isEditing: true,
          isToolbarVisible: true,
        );

        // Should still be positioned correctly
        final positioned = tester.widget<Positioned>(find.byType(Positioned));
        expect(positioned.left, equals(0));
        expect(positioned.right, equals(0));
        expect(positioned.bottom, equals(0));
      });
    });

    group('Riverpod State Management', () {
      testWidgets('watches quillToolbarProvider correctly', (tester) async {
        await pumpPositionedToolbar(
          tester,
          isEditing: true,
          isToolbarVisible: true,
        );

        // Widget should be present when state is valid
        expect(find.byType(QuillEditorToolbarWidget), findsOneWidget);

        final toolbarWidget = tester.widget<QuillEditorToolbarWidget>(
          find.byType(QuillEditorToolbarWidget),
        );

        // Should receive correct props from provider
        expect(toolbarWidget.controller, equals(controller));
        expect(toolbarWidget.focusNode, equals(focusNode));
        expect(toolbarWidget.isToolbarVisible, isTrue);
      });

      testWidgets('responds to provider state changes', (tester) async {
        await pumpPositionedToolbar(
          tester,
          isEditing: true,
          isToolbarVisible: false,
        );

        // Initially hidden
        expect(find.byType(QuillEditorToolbarWidget), findsOneWidget);

        final toolbarWidget = tester.widget<QuillEditorToolbarWidget>(
          find.byType(QuillEditorToolbarWidget),
        );
        expect(toolbarWidget.isToolbarVisible, isFalse);

        // Change state to visible
        await pumpPositionedToolbar(
          tester,
          isEditing: true,
          isToolbarVisible: true,
        );

        // Should update to visible
        final updatedToolbarWidget = tester.widget<QuillEditorToolbarWidget>(
          find.byType(QuillEditorToolbarWidget),
        );
        expect(updatedToolbarWidget.isToolbarVisible, isTrue);
      });

      testWidgets('handles controller changes from provider', (tester) async {
        await pumpPositionedToolbar(
          tester,
          isEditing: true,
          isToolbarVisible: true,
        );

        // Create new controller
        final newController = QuillController.basic();

        // Update with new controller
        await pumpPositionedToolbar(
          tester,
          isEditing: true,
          providedController: newController,
          isToolbarVisible: true,
        );

        // Should use new controller
        final toolbarWidget = tester.widget<QuillEditorToolbarWidget>(
          find.byType(QuillEditorToolbarWidget),
        );
        expect(toolbarWidget.controller, equals(newController));

        newController.dispose();
      });

      testWidgets('handles focusNode changes from provider', (tester) async {
        await pumpPositionedToolbar(
          tester,
          isEditing: true,
          isToolbarVisible: true,
        );

        // Create new focus node
        final newFocusNode = FocusNode();

        // Update with new focus node
        await pumpPositionedToolbar(
          tester,
          isEditing: true,
          providedFocusNode: newFocusNode,
          isToolbarVisible: true,
        );

        // Should use new focus node
        final toolbarWidget = tester.widget<QuillEditorToolbarWidget>(
          find.byType(QuillEditorToolbarWidget),
        );
        expect(toolbarWidget.focusNode, equals(newFocusNode));

        newFocusNode.dispose();
      });
    });

    group('Callback Integration', () {
      testWidgets('passes correct callback to QuillEditorToolbarWidget', (
        tester,
      ) async {
        await pumpPositionedToolbar(
          tester,
          isEditing: true,
          isToolbarVisible: true,
        );

        final toolbarWidget = tester.widget<QuillEditorToolbarWidget>(
          find.byType(QuillEditorToolbarWidget),
        );

        // Should have callback
        expect(toolbarWidget.onReturnFocusToEditor, isNotNull);
        expect(toolbarWidget.onReturnFocusToEditor, isA<VoidCallback>());
      });
    });

    group('Edge Cases and Error Handling', () {
      testWidgets('handles editing state changes', (tester) async {
        // Start with editing enabled
        await pumpPositionedToolbar(
          tester,
          isEditing: true,
          isToolbarVisible: true,
        );

        expect(find.byType(Positioned), findsOneWidget);

        // Change to not editing
        await pumpPositionedToolbar(
          tester,
          isEditing: false,
          isToolbarVisible: true,
        );

        expect(find.byType(Positioned), findsNothing);

        // Change back to editing
        await pumpPositionedToolbar(
          tester,
          isEditing: true,
          isToolbarVisible: true,
        );

        expect(find.byType(Positioned), findsOneWidget);
      });

      testWidgets('handles empty controller gracefully', (tester) async {
        final emptyController = QuillController.basic();

        await pumpPositionedToolbar(
          tester,
          isEditing: true,
          providedController: emptyController,
          isToolbarVisible: true,
        );

        // Should render with empty controller
        expect(find.byType(Positioned), findsOneWidget);
        expect(find.byType(QuillEditorToolbarWidget), findsOneWidget);

        emptyController.dispose();
      });
    });

    group('Provider Override Testing', () {
      testWidgets('handles different activeEditorId values', (tester) async {
        await pumpPositionedToolbar(
          tester,
          isEditing: true,
          isToolbarVisible: true,
          activeEditorId: 'custom-editor-id',
        );

        // Should render regardless of editor ID
        expect(find.byType(Positioned), findsOneWidget);
        expect(find.byType(QuillEditorToolbarWidget), findsOneWidget);
      });
    });
  });
}
