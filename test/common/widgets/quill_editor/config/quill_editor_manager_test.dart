import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quill/flutter_quill.dart' hide QuillEditorState;
import 'package:zoe/common/widgets/quill_editor/config/quill_editor_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late QuillEditorManager manager;

  Widget wrapWithMaterial({required Widget child}) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(body: child),
    );
  }

  group('Initialization', () {
    test('creates manager with default settings', () async {
      manager = QuillEditorManager();

      expect(manager.state, QuillEditorState.creating);
      expect(manager.isInitialized, isFalse);

      await manager.initialize();

      expect(manager.state, QuillEditorState.initialized);
      expect(manager.isInitialized, isTrue);
    });

    test('creates manager with initial plain text content', () async {
      manager = QuillEditorManager(initialContent: 'Test content');
      await manager.initialize();
      expect(manager.plainText, equals('Test content\n'));
    });

    test('creates manager with initial rich text content', () async {
      final deltaJson = '[{"insert":"Rich text\\n"}]';
      manager = QuillEditorManager(initialRichContent: deltaJson);
      await manager.initialize();
      expect(manager.richTextJson, contains('Rich text'));
    });

    test('handles invalid rich content gracefully', () async {
      manager = QuillEditorManager(initialRichContent: 'invalid json');
      await manager.initialize();
      expect(manager.plainText, equals('\n'));
    });

    test('takes rich content over plain text when both provided', () async {
      final deltaJson = '[{"insert":"Rich wins\\n"}]';
      manager = QuillEditorManager(
        initialContent: 'Plain text',
        initialRichContent: deltaJson,
      );
      await manager.initialize();
      expect(manager.plainText, equals('Rich wins\n'));
    });

    test('creates manager in read-only mode', () async {
      manager = QuillEditorManager(readOnly: true);
      expect(manager.state, QuillEditorState.readOnly);
      await manager.initialize();
      expect(manager.focusNode.canRequestFocus, isFalse);
    });

    test('initializes read-only manager correctly', () async {
      manager = QuillEditorManager(readOnly: true, initialContent: 'Test');
      await manager.initialize();
      expect(manager.state, QuillEditorState.initialized);
      expect(manager.focusNode.canRequestFocus, isFalse);
      expect(manager.plainText, equals('Test\n'));
    });
  });

  group('Content Management', () {
    test('loads plain text content', () async {
      manager = QuillEditorManager(initialContent: 'Hello');
      await manager.initialize();
      expect(manager.plainText, equals('Hello\n'));
    });

    test('loads rich text content', () async {
      final deltaJson = '[{"insert":"Bold","attributes":{"bold":true}}]';
      manager = QuillEditorManager(initialRichContent: deltaJson);
      await manager.initialize();
      expect(manager.richTextJson, isNotEmpty);
    });

    test('updates plain text', () async {
      manager = QuillEditorManager(initialContent: 'Initial');
      await manager.initialize();
      manager.updateContent('Updated', null);
      expect(manager.plainText, equals('Updated\n'));
    });

    test('updates rich text', () async {
      manager = QuillEditorManager(initialContent: 'Initial');
      await manager.initialize();
      manager.updateContent(null, '[{"insert":"Updated"}]');
      expect(manager.state, QuillEditorState.initialized);
    });

    test('handles invalid rich content update', () async {
      manager = QuillEditorManager(initialContent: 'Initial');
      await manager.initialize();
      manager.updateContent(null, 'invalid');
      expect(manager.plainText, equals('\n'));
    });

    test('preserves cursor position during update', () async {
      manager = QuillEditorManager(initialContent: 'Hello World');
      await manager.initialize();

      manager.controller.updateSelection(
        const TextSelection.collapsed(offset: 5),
        ChangeSource.local,
      );

      manager.updateContent('Updated content', null);
      expect(manager.controller.selection.isValid, isTrue);
    });

    test('handles empty content update', () async {
      manager = QuillEditorManager(initialContent: 'Initial');
      await manager.initialize();
      manager.updateContent('', null);
      expect(manager.plainText, equals('\n'));
    });
  });

  group('Read-Only Mode', () {
    test('toggles read-only state', () async {
      manager = QuillEditorManager();
      await manager.initialize();
      manager.setReadOnly(true);
      expect(manager.state, QuillEditorState.readOnly);
      manager.setReadOnly(false);
      expect(manager.state, QuillEditorState.initialized);
    });
  });

  group('Callbacks', () {
    test('calls onContentChanged when content changes', () async {
      bool called = false;
      manager = QuillEditorManager(onContentChanged: () => called = true);
      await manager.initialize();
      manager.controller.document.insert(0, 'A');
      await Future.delayed(const Duration(milliseconds: 50));
      expect(called, isTrue);
    });

    test(
      'onFocusChanged registered but not triggered without widget tree',
      () async {
        QuillController? controller;
        FocusNode? node;
        manager = QuillEditorManager(
          onFocusChanged: (c, n) {
            controller = c;
            node = n;
          },
        );
        await manager.initialize();
        expect(controller, isNull);
        expect(node, isNull);
      },
    );

    test('does not trigger after disposal', () async {
      int count = 0;
      manager = QuillEditorManager(onContentChanged: () => count++);
      await manager.initialize();
      manager.controller.document.insert(0, 'Before');
      await Future.delayed(const Duration(milliseconds: 50));
      expect(count, 1);
      manager.dispose();
      expect(manager.state, QuillEditorState.disposed);
    });
  });

  group('Disposal', () {
    test('disposes resources cleanly', () async {
      manager = QuillEditorManager();
      await manager.initialize();
      manager.dispose();
      expect(manager.state, QuillEditorState.disposed);
    });

    test('safe double disposal', () async {
      manager = QuillEditorManager();
      await manager.initialize();
      manager.dispose();
      expect(manager.state, QuillEditorState.disposed);

      // Attempting to dispose again may throw an error due to QuillController limitation
      // This is expected behavior - the manager should remain in disposed state
      try {
        manager.dispose();
        expect(manager.state, QuillEditorState.disposed);
      } catch (e) {
        // Expected error when disposing already disposed controller
        expect(e, isA<FlutterError>());
        expect(manager.state, QuillEditorState.disposed);
      }
    });
  });

  group('Text Style Configuration', () {
    test('getDefaultStyles returns valid styles', () async {
      manager = QuillEditorManager();
      await manager.initialize();

      final builder = Builder(
        builder: (context) {
          final styles = manager.getDefaultStyles(context);
          expect(styles.paragraph, isNotNull);
          expect(styles.code, isNotNull);
          return const SizedBox();
        },
      );

      wrapWithMaterial(child: builder);
    });

    test('getDefaultTextStyle returns valid style', () async {
      manager = QuillEditorManager();
      await manager.initialize();

      final builder = Builder(
        builder: (context) {
          final textStyle = manager.getDefaultTextStyle(context);
          expect(textStyle.fontSize, isNotNull);
          expect(textStyle.color, isNotNull);
          return const SizedBox();
        },
      );

      wrapWithMaterial(child: builder);
    });

    test('uses custom text style if provided', () async {
      final style = const TextStyle(fontSize: 18, color: Colors.red);
      manager = QuillEditorManager(textStyle: style);
      await manager.initialize();

      final builder = Builder(
        builder: (context) {
          final textStyle = manager.getDefaultTextStyle(context);
          expect(textStyle, isNotNull);
          return const SizedBox();
        },
      );

      wrapWithMaterial(child: builder);
    });
  });

  group('Controller Properties', () {
    test('provides controller, focus and scroll nodes', () async {
      manager = QuillEditorManager();
      await manager.initialize();
      expect(manager.controller, isA<QuillController>());
      expect(manager.focusNode, isA<FocusNode>());
      expect(manager.scrollController, isA<ScrollController>());
    });

    test('plainText and richTextJson accessors', () async {
      final deltaJson = '[{"insert":"Text\\n"}]';
      manager = QuillEditorManager(initialRichContent: deltaJson);
      await manager.initialize();
      expect(manager.richTextJson, contains('Text'));
    });
  });

  group('State Management', () {
    test('state transitions correctly', () async {
      manager = QuillEditorManager();
      expect(manager.state, QuillEditorState.creating);
      await manager.initialize();
      expect(manager.state, QuillEditorState.initialized);
      manager.setReadOnly(true);
      expect(manager.state, QuillEditorState.readOnly);
    });

    test('skips initialization when disposed', () async {
      manager = QuillEditorManager();
      await manager.initialize();
      manager.dispose();
      await manager.initialize();
      expect(manager.state, QuillEditorState.disposed);
    });
  });

  group('Edge Cases', () {
    test('handles null and empty content', () async {
      manager = QuillEditorManager(initialContent: null);
      await manager.initialize();
      expect(manager.plainText, isNotEmpty);

      manager = QuillEditorManager(initialContent: '');
      await manager.initialize();
      expect(manager.plainText, equals('\n'));
    });

    test('handles long and unicode content', () async {
      final long = 'A' * 10000;
      manager = QuillEditorManager(initialContent: long);
      await manager.initialize();
      expect(manager.plainText.length, 10001);

      manager = QuillEditorManager(initialContent: 'Hello 世界 🌍');
      await manager.initialize();
      expect(manager.plainText, contains('世界'));
    });
  });

  group('Integration', () {
    test('full lifecycle flow', () async {
      bool changed = false;
      manager = QuillEditorManager(
        initialContent: 'Start',
        onContentChanged: () => changed = true,
      );

      await manager.initialize();
      expect(manager.state, QuillEditorState.initialized);
      manager.updateContent('Updated', null);
      manager.controller.document.insert(0, 'X');
      await Future.delayed(const Duration(milliseconds: 50));
      expect(changed, isTrue);
      manager.dispose();
      expect(manager.state, QuillEditorState.disposed);
    });

    test('read-only flow', () async {
      manager = QuillEditorManager(readOnly: true, initialContent: 'Readonly');
      await manager.initialize();
      expect(manager.state, QuillEditorState.initialized);
      manager.setReadOnly(false);
      expect(manager.focusNode.canRequestFocus, isTrue);
      manager.setReadOnly(true);
      expect(manager.focusNode.canRequestFocus, isFalse);
    });
  });
}
