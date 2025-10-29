import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/quill_editor/notifiers/quill_toolbar_notifier.dart';

void main() {
  group('QuillToolbar Notifier Tests', () {
    late ProviderContainer container;
    late QuillController controller;
    late FocusNode focusNode;
    late QuillToolbar notifier;

    setUp(() {
      controller = QuillController.basic();
      focusNode = FocusNode();
      container = ProviderContainer.test();
      notifier = container.read(quillToolbarProvider.notifier);
    });

    tearDown(() {
      controller.dispose();
      focusNode.dispose();
    });

    group('Initial State', () {
      test('should have correct initial state', () {
        final state = container.read(quillToolbarProvider);

        expect(state.activeController, isNull);
        expect(state.activeFocusNode, isNull);
        expect(state.isToolbarVisible, isFalse);
        expect(state.activeEditorId, isNull);
      });
    });

    group('updateActiveEditor', () {
      test('should update state for new editor with valid focus node', () {
        const editorId = 'test-editor-1';

        notifier.updateActiveEditor(
          editorId: editorId,
          controller: controller,
          focusNode: focusNode,
        );

        final state = container.read(quillToolbarProvider);
        expect(state.activeController, equals(controller));
        expect(state.activeFocusNode, equals(focusNode));
        expect(
          state.isToolbarVisible,
          isFalse,
        ); // focusNode not focused initially
        expect(state.activeEditorId, equals(editorId));
      });

      test(
        'should update state for new editor with null controller and focus node',
        () {
          const editorId = 'test-editor-1';

          notifier.updateActiveEditor(
            editorId: editorId,
            controller: null,
            focusNode: null,
          );

          final state = container.read(quillToolbarProvider);
          expect(state.activeController, isNull);
          expect(state.activeFocusNode, isNull);
          expect(state.isToolbarVisible, isFalse);
          expect(state.activeEditorId, equals(editorId));
        },
      );

      test('should update state for same editor multiple times', () {
        const editorId = 'test-editor-1';

        // First update
        notifier.updateActiveEditor(
          editorId: editorId,
          controller: controller,
          focusNode: focusNode,
        );

        // Second update with same editor
        notifier.updateActiveEditor(
          editorId: editorId,
          controller: controller,
          focusNode: focusNode,
        );

        final state = container.read(quillToolbarProvider);
        expect(state.activeController, equals(controller));
        expect(state.activeFocusNode, equals(focusNode));
        expect(
          state.isToolbarVisible,
          isFalse,
        ); // focusNode not focused in test environment
        expect(state.activeEditorId, equals(editorId));
      });

      test('should handle multiple different editors', () {
        const editorId1 = 'test-editor-1';
        const editorId2 = 'test-editor-2';
        final controller2 = QuillController.basic();
        final focusNode2 = FocusNode();

        // Update first editor
        notifier.updateActiveEditor(
          editorId: editorId1,
          controller: controller,
          focusNode: focusNode,
        );

        // Update second editor
        notifier.updateActiveEditor(
          editorId: editorId2,
          controller: controller2,
          focusNode: focusNode2,
        );

        final state = container.read(quillToolbarProvider);
        expect(state.activeController, equals(controller2));
        expect(state.activeFocusNode, equals(focusNode2));
        expect(state.activeEditorId, equals(editorId2));

        controller2.dispose();
        focusNode2.dispose();
      });
    });

    group('clearActiveEditorState', () {
      test('should clear state for active editor after delay', () async {
        const editorId = 'test-editor-1';

        // Set up active editor
        notifier.updateActiveEditor(
          editorId: editorId,
          controller: controller,
          focusNode: focusNode,
        );

        // Clear the state
        notifier.clearActiveEditorState(editorId);

        // State should still be active immediately
        var state = container.read(quillToolbarProvider);
        expect(state.activeController, equals(controller));
        expect(state.activeEditorId, equals(editorId));

        // Wait for timer to complete
        await Future.delayed(const Duration(milliseconds: 150));

        // State should be cleared
        state = container.read(quillToolbarProvider);
        expect(state.activeController, isNull);
        expect(state.activeFocusNode, isNull);
        expect(state.isToolbarVisible, isFalse);
        expect(state.activeEditorId, isNull);
      });

      test('should not clear state for different editor', () {
        const editorId1 = 'test-editor-1';
        const editorId2 = 'test-editor-2';

        // Set up active editor
        notifier.updateActiveEditor(
          editorId: editorId1,
          controller: controller,
          focusNode: focusNode,
        );

        // Try to clear different editor
        notifier.clearActiveEditorState(editorId2);

        // State should still be active immediately since we cleared a different editor
        final state = container.read(quillToolbarProvider);
        expect(state.activeController, equals(controller));
        expect(state.activeEditorId, equals(editorId1));
      });

      test('should cancel timer if called multiple times', () async {
        const editorId = 'test-editor-1';

        // Set up active editor
        notifier.updateActiveEditor(
          editorId: editorId,
          controller: controller,
          focusNode: focusNode,
        );

        // Clear state multiple times
        notifier.clearActiveEditorState(editorId);
        notifier.clearActiveEditorState(editorId);
        notifier.clearActiveEditorState(editorId);

        // Wait for timer to complete
        await Future.delayed(const Duration(milliseconds: 150));

        // State should be cleared only once
        final state = container.read(quillToolbarProvider);
        expect(state.activeController, isNull);
        expect(state.activeEditorId, isNull);
      });
    });

    group('returnFocusToEditor', () {
      test('should call requestFocus on active focus node', () {
        const editorId = 'test-editor-1';

        // Set up active editor
        notifier.updateActiveEditor(
          editorId: editorId,
          controller: controller,
          focusNode: focusNode,
        );

        // Return focus to editor - this should not throw
        expect(() => notifier.returnFocusToEditor(), returnsNormally);
      });

      test('should clear state if focus node is null', () {
        const editorId = 'test-editor-1';

        // Set up active editor with null focus node
        notifier.updateActiveEditor(
          editorId: editorId,
          controller: controller,
          focusNode: null,
        );

        // Return focus to editor
        notifier.returnFocusToEditor();

        // State should be cleared
        final state = container.read(quillToolbarProvider);
        expect(state.activeController, isNull);
        expect(state.activeFocusNode, isNull);
        expect(state.isToolbarVisible, isFalse);
        expect(state.activeEditorId, isNull);
      });

      test('should handle returnFocusToEditor with no active editor', () {
        // Call returnFocusToEditor with no active editor
        notifier.returnFocusToEditor();

        // Should not throw and state should remain null
        final state = container.read(quillToolbarProvider);
        expect(state.activeController, isNull);
        expect(state.activeFocusNode, isNull);
        expect(state.isToolbarVisible, isFalse);
        expect(state.activeEditorId, isNull);
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle null controller and focus node updates', () {
        const editorId = 'test-editor-1';

        // Update with null values
        notifier.updateActiveEditor(
          editorId: editorId,
          controller: null,
          focusNode: null,
        );

        final state = container.read(quillToolbarProvider);
        expect(state.activeController, isNull);
        expect(state.activeFocusNode, isNull);
        expect(state.isToolbarVisible, isFalse);
        expect(state.activeEditorId, equals(editorId));
      });

      test('should handle empty editor ID', () {
        const editorId = '';

        notifier.updateActiveEditor(
          editorId: editorId,
          controller: controller,
          focusNode: focusNode,
        );

        final state = container.read(quillToolbarProvider);
        expect(state.activeEditorId, equals(editorId));
      });

      test('should handle dispose during timer', () async {
        const editorId = 'test-editor-1';

        // Set up active editor
        notifier.updateActiveEditor(
          editorId: editorId,
          controller: controller,
          focusNode: focusNode,
        );

        // Clear the state
        notifier.clearActiveEditorState(editorId);

        // Dispose container before timer completes
        container.dispose();

        // Should not throw
        expect(() => container.dispose(), returnsNormally);
      });
    });

    group('State Transitions', () {
      test('should transition from active to cleared state', () async {
        const editorId = 'test-editor-1';

        // Set up active state
        notifier.updateActiveEditor(
          editorId: editorId,
          controller: controller,
          focusNode: focusNode,
        );

        // Clear state
        notifier.clearActiveEditorState(editorId);

        // Wait for timer
        await Future.delayed(const Duration(milliseconds: 150));

        // State should be cleared
        final state = container.read(quillToolbarProvider);
        expect(state.activeController, isNull);
        expect(state.activeEditorId, isNull);
      });

      test('should transition between different editors', () {
        const editorId1 = 'test-editor-1';
        const editorId2 = 'test-editor-2';
        final controller2 = QuillController.basic();
        final focusNode2 = FocusNode();

        // First editor
        notifier.updateActiveEditor(
          editorId: editorId1,
          controller: controller,
          focusNode: focusNode,
        );

        var state = container.read(quillToolbarProvider);
        expect(state.activeEditorId, equals(editorId1));

        // Second editor
        notifier.updateActiveEditor(
          editorId: editorId2,
          controller: controller2,
          focusNode: focusNode2,
        );

        state = container.read(quillToolbarProvider);
        expect(state.activeEditorId, equals(editorId2));
        expect(state.activeController, equals(controller2));

        controller2.dispose();
        focusNode2.dispose();
      });
    });
  });
}
