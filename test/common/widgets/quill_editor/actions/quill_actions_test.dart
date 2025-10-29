import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zoe/common/widgets/quill_editor/actions/quill_actions.dart';
import 'package:zoe/common/widgets/quill_editor/notifiers/quill_toolbar_notifier.dart';

void main() {
  group('Quill Actions', () {
    group('isAttributeActive', () {
      test('returns false for invalid selection', () {
        final controller = QuillController.basic();

        // Invalid selection
        controller.updateSelection(
          const TextSelection.collapsed(offset: -1),
          ChangeSource.local,
        );

        final result = isAttributeActive(controller, Attribute.bold);
        expect(result, isFalse);
      });

      test('returns false for empty document', () {
        final controller = QuillController.basic();

        final result = isAttributeActive(controller, Attribute.bold);
        expect(result, isFalse);
      });

      test('returns false when attribute is not active', () {
        final controller = QuillController.basic();
        controller.document.insert(0, 'Test text');

        final result = isAttributeActive(controller, Attribute.bold);
        expect(result, isFalse);
      });

      test('returns true when attribute is active', () {
        final controller = QuillController.basic();
        controller.document.insert(0, 'Test text');
        controller.updateSelection(
          const TextSelection(baseOffset: 0, extentOffset: 9),
          ChangeSource.local,
        );
        controller.formatSelection(Attribute.bold);

        final result = isAttributeActive(controller, Attribute.bold);
        expect(result, isTrue);
      });
    });

    group('isBlockAttributeActive', () {
      test('returns false for non-block attributes', () {
        final controller = QuillController.basic();

        final result = isBlockAttributeActive(controller, Attribute.bold);
        expect(result, isFalse);
      });

      test('returns false for empty document', () {
        final controller = QuillController.basic();

        final result = isBlockAttributeActive(controller, Attribute.blockQuote);
        expect(result, isFalse);
      });
    });

    group('toggleAttribute', () {
      test('applies attribute when not active', () {
        final controller = QuillController.basic();
        controller.document.insert(0, 'Test text');
        controller.updateSelection(
          const TextSelection(baseOffset: 0, extentOffset: 9),
          ChangeSource.local,
        );

        toggleAttribute(controller, Attribute.bold);

        final isActive = isAttributeActive(controller, Attribute.bold);
        expect(isActive, isTrue);
      });

      test('removes attribute when already active', () {
        final controller = QuillController.basic();
        controller.document.insert(0, 'Test text');
        controller.updateSelection(
          const TextSelection(baseOffset: 0, extentOffset: 9),
          ChangeSource.local,
        );
        controller.formatSelection(Attribute.bold);

        toggleAttribute(controller, Attribute.bold);

        final isActive = isAttributeActive(controller, Attribute.bold);
        expect(isActive, isFalse);
      });

      test('calls onButtonPressed callback', () {
        final controller = QuillController.basic();
        controller.document.insert(0, 'Test text');
        controller.updateSelection(
          const TextSelection(baseOffset: 0, extentOffset: 9),
          ChangeSource.local,
        );

        bool callbackCalled = false;

        toggleAttribute(
          controller,
          Attribute.bold,
          onButtonPressed: () => callbackCalled = true,
        );

        expect(callbackCalled, isTrue);
      });

      test('handles invalid selection gracefully', () {
        final controller = QuillController.basic();
        controller.updateSelection(
          const TextSelection.collapsed(offset: -1),
          ChangeSource.local,
        );

        // Should not throw
        toggleAttribute(controller, Attribute.bold);
      });
    });

    group('handleInvalidSelection', () {
      test('creates valid selection and applies attribute', () {
        final controller = QuillController.basic();
        controller.document.insert(0, 'Test text');

        handleInvalidSelection(controller, Attribute.bold);

        // Should not throw
        expect(controller.selection.isValid, isTrue);
      });

      test('handles empty document', () {
        final controller = QuillController.basic();

        // Should not throw even with empty document
        handleInvalidSelection(controller, Attribute.bold);
      });
    });

    group('handleLinkAttribute', () {
      testWidgets('removes link when already active', (tester) async {
        final controller = QuillController.basic();
        controller.document.insert(0, 'Test text');
        controller.updateSelection(
          const TextSelection(baseOffset: 0, extentOffset: 9),
          ChangeSource.local,
        );

        // Apply link first
        controller.formatSelection(LinkAttribute('https://example.com'));

        // Verify link is active
        expect(isAttributeActive(controller, Attribute.link), isTrue);

        // Test the link removal logic directly
        controller.formatSelection(Attribute.clone(Attribute.link, null));

        // Verify link is removed
        expect(isAttributeActive(controller, Attribute.link), isFalse);
      });

      testWidgets('handles invalid selection', (tester) async {
        final controller = QuillController.basic();
        controller.updateSelection(
          const TextSelection.collapsed(offset: -1),
          ChangeSource.local,
        );

        // Test handleInvalidSelection directly
        handleInvalidSelection(controller, Attribute.link);

        // Should handle gracefully
        expect(controller.selection.isValid, isTrue);
      });

      testWidgets('handles empty document', (tester) async {
        final controller = QuillController.basic();

        // Test handleInvalidSelection directly
        handleInvalidSelection(controller, Attribute.link);

        // Should handle gracefully - handleInvalidSelection adds content to empty document
        expect(controller.document.length, greaterThan(0));
      });
    });

    group('clearActiveEditorState', () {
      testWidgets('clears active editor state', (tester) async {
        final container = ProviderContainer.test();

        // Set up initial state
        final notifier = container.read(quillToolbarProvider.notifier);
        notifier.updateActiveEditor(
          editorId: 'test-editor',
          controller: QuillController.basic(),
          focusNode: FocusNode(),
        );

        // Verify initial state
        final initialState = container.read(quillToolbarProvider);
        expect(initialState.activeEditorId, equals('test-editor'));

        // Clear the state using the notifier directly
        notifier.clearActiveEditorState('test-editor');

        // Wait for the timer to complete
        await tester.pump(const Duration(milliseconds: 200));

        // Verify state is cleared
        final finalState = container.read(quillToolbarProvider);
        expect(finalState.activeEditorId, isNull);
        expect(finalState.activeController, isNull);
        expect(finalState.isToolbarVisible, isFalse);

        container.dispose();
      });
    });
  });
}
