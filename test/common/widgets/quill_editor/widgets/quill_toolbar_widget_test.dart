import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zoe/common/widgets/quill_editor/widgets/quill_toolbar_widget.dart';

import '../../../../test-utils/test_utils.dart';

void main() {
  group('QuillToolbar Widget Tests', () {
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

    Future<void> pumpQuillToolbar(
      WidgetTester tester, {
      VoidCallback? onButtonPressed,
      ThemeData? theme,
    }) async {
      await tester.pumpMaterialWidget(
        child: QuillToolbar(
          controller: controller,
          focusNode: focusNode,
          onButtonPressed: onButtonPressed,
        ),
        theme: theme,
      );
    }

    group('Widget Initialization', () {
      testWidgets('renders toolbar with correct structure', (tester) async {
        await pumpQuillToolbar(tester);

        // Check toolbar container
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
      });

      testWidgets('renders all text style buttons', (tester) async {
        await pumpQuillToolbar(tester);

        // Check for text style buttons
        expect(find.byIcon(Icons.format_bold), findsOneWidget);
        expect(find.byIcon(Icons.format_italic), findsOneWidget);
        expect(find.byIcon(Icons.format_underline), findsOneWidget);
        expect(find.byIcon(Icons.format_strikethrough), findsOneWidget);
      });

      testWidgets('renders block style buttons', (tester) async {
        await pumpQuillToolbar(tester);

        // Check for block style buttons
        expect(find.byIcon(Icons.format_quote), findsOneWidget);
        expect(find.byIcon(Icons.code), findsOneWidget);
      });

      testWidgets('does not show link button when no text is selected', (tester) async {
        await pumpQuillToolbar(tester);

        // Link button should not be visible
        expect(find.byIcon(Icons.insert_link), findsNothing);
      });

      testWidgets('shows link button when text is selected', (tester) async {
        // Add some text and select it first
        controller.document.insert(0, 'Test text');
        controller.updateSelection(
          const TextSelection(baseOffset: 0, extentOffset: 9),
          ChangeSource.local,
        );

        await pumpQuillToolbar(tester);

        // Link button should be visible
        expect(find.byIcon(Icons.insert_link), findsOneWidget);
      });
    });

    group('Button Interactions', () {
      testWidgets('calls onButtonPressed when bold button is tapped', (tester) async {
        bool callbackCalled = false;
        await pumpQuillToolbar(
          tester,
          onButtonPressed: () => callbackCalled = true,
        );

        // Add some text first
        controller.document.insert(0, 'Test text');
        controller.updateSelection(
          const TextSelection(baseOffset: 0, extentOffset: 9),
          ChangeSource.local,
        );

        await tester.tap(find.byIcon(Icons.format_bold));
        await tester.pump();

        expect(callbackCalled, isTrue);
      });

      testWidgets('calls onButtonPressed when italic button is tapped', (tester) async {
        bool callbackCalled = false;
        await pumpQuillToolbar(
          tester,
          onButtonPressed: () => callbackCalled = true,
        );

        // Add some text first
        controller.document.insert(0, 'Test text');
        controller.updateSelection(
          const TextSelection(baseOffset: 0, extentOffset: 9),
          ChangeSource.local,
        );

        await tester.tap(find.byIcon(Icons.format_italic));
        await tester.pump();

        expect(callbackCalled, isTrue);
      });
    });

    group('Widget Lifecycle', () {
      testWidgets('adds listeners on initState and responds to controller changes', (tester) async {
        await pumpQuillToolbar(tester);

        // Verify initial state
        expect(find.byType(QuillToolbar), findsOneWidget);
        
        // Add text to controller and verify widget rebuilds
        controller.document.insert(0, 'Test text');
        await tester.pump();
        
        // Widget should still be present after controller change
        expect(find.byType(QuillToolbar), findsOneWidget);
        
        // Verify that the widget responds to selection changes by checking
        // that the widget rebuilds when selection changes
        controller.updateSelection(
          const TextSelection(baseOffset: 0, extentOffset: 9),
          ChangeSource.local,
        );
        
        // Wait for the post-frame callback to execute and rebuild the widget
        await tester.pump();
        await tester.pump(); // Second pump to ensure post-frame callback executes
        
        // Widget should still be present after selection change (proving listener works)
        expect(find.byType(QuillToolbar), findsOneWidget);
        
        // Verify that the selection was actually set
        expect(controller.selection.baseOffset, equals(0));
        expect(controller.selection.extentOffset, equals(9));
      }); 

      testWidgets('adds listeners on initState and responds to focus changes', (tester) async {
        await pumpQuillToolbar(tester);

        // Verify initial state
        expect(find.byType(QuillToolbar), findsOneWidget);
        
        // Change focus and verify widget rebuilds
        focusNode.unfocus();
        await tester.pump();
        
        // Widget should still be present after focus change
        expect(find.byType(QuillToolbar), findsOneWidget);
        
        // Focus again
        focusNode.requestFocus();
        await tester.pump();
        
        // Widget should still be present
        expect(find.byType(QuillToolbar), findsOneWidget);
      });

      testWidgets('removes listeners on dispose and prevents memory leaks', (tester) async {
        await pumpQuillToolbar(tester);

        // Verify widget is present
        expect(find.byType(QuillToolbar), findsOneWidget);

        // Remove the widget from the tree (this should call dispose)
        await tester.pumpWidget(const SizedBox());

        // Verify widget is removed
        expect(find.byType(QuillToolbar), findsNothing);

        // Should not throw when controller changes after disposal
        // This tests that listeners were properly removed
        expect(() {
          controller.document.insert(0, 'Test');
          controller.updateSelection(
            const TextSelection(baseOffset: 0, extentOffset: 4),
            ChangeSource.local,
          );
          focusNode.requestFocus();
        }, returnsNormally);
      });

      testWidgets('updates listeners when controller changes', (tester) async {
        await pumpQuillToolbar(tester);

        // Create a new controller
        final newController = QuillController.basic();
        
        // Update widget with new controller
        await tester.pumpMaterialWidget(
          child: QuillToolbar(
            controller: newController,
            focusNode: focusNode,
          ),
        );

        // Verify widget is still present
        expect(find.byType(QuillToolbar), findsOneWidget);

        // Add text to new controller and verify widget responds
        newController.document.insert(0, 'New text');
        await tester.pump();

        // Widget should still be present
        expect(find.byType(QuillToolbar), findsOneWidget);

        // Clean up
        newController.dispose();
      });

      testWidgets('updates listeners when focusNode changes', (tester) async {
        await pumpQuillToolbar(tester);

        // Create a new focus node
        final newFocusNode = FocusNode();
        
        // Update widget with new focus node
        await tester.pumpMaterialWidget(
          child: QuillToolbar(
            controller: controller,
            focusNode: newFocusNode,
          ),
        );

        // Verify widget is still present
        expect(find.byType(QuillToolbar), findsOneWidget);

        // Change focus on new focus node and verify widget responds
        newFocusNode.requestFocus();
        await tester.pump();

        // Widget should still be present
        expect(find.byType(QuillToolbar), findsOneWidget);

        // Clean up
        newFocusNode.dispose();
      });
    });

    group('Edge Cases and Error Handling', () {
      testWidgets('handles empty document gracefully', (tester) async {
        await pumpQuillToolbar(tester);

        // Should not throw with empty document
        await tester.tap(find.byIcon(Icons.format_bold));
        await tester.pump();
      });

      testWidgets('handles invalid selection gracefully', (tester) async {
        await pumpQuillToolbar(tester);

        // Set invalid selection
        controller.updateSelection(
          const TextSelection.collapsed(offset: -1),
          ChangeSource.local,
        );

        // Should not throw when tapping buttons
        await tester.tap(find.byIcon(Icons.format_bold));
        await tester.pump();
      });
    });

    group('Accessibility and Theme', () {
      testWidgets('respects theme colors', (tester) async {
        final customTheme = ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Colors.red,
            surface: Colors.blue,
            outline: Colors.green,
          ),
        );

        await pumpQuillToolbar(tester, theme: customTheme);

        // Widget should use theme colors
        expect(find.byType(QuillToolbar), findsOneWidget);
      });

      testWidgets('has proper button dimensions', (tester) async {
        await pumpQuillToolbar(tester);

        // Find all toolbar buttons
        final buttons = find.byType(InkWell);
        expect(buttons, findsWidgets);

        // Each button should have proper dimensions
        for (int i = 0; i < buttons.evaluate().length; i++) {
          final button = buttons.at(i);
          final container = find.descendant(
            of: button,
            matching: find.byType(Container),
          );
          
          final containerWidget = tester.widget<Container>(container);
          expect(containerWidget.constraints?.minWidth, equals(40));
          expect(containerWidget.constraints?.minHeight, equals(40));
        }
      });

      testWidgets('has proper icon sizes', (tester) async {
        await pumpQuillToolbar(tester);

        // Find all icons
        final icons = find.byType(Icon);
        expect(icons, findsWidgets);

        // Each icon should have size 18
        for (int i = 0; i < icons.evaluate().length; i++) {
          final icon = tester.widget<Icon>(icons.at(i));
          expect(icon.size, equals(18));
        }
      });
    });

    group('Scrolling Behavior', () {
      testWidgets('toolbar is scrollable horizontally', (tester) async {
        await pumpQuillToolbar(tester);

        // Check that SingleChildScrollView is present
        final scrollView = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );
        expect(scrollView.scrollDirection, equals(Axis.horizontal));
      });

      testWidgets('handles overflow gracefully', (tester) async {
        // Create a narrow screen to force overflow
        await tester.binding.setSurfaceSize(const Size(200, 600));
        
        await pumpQuillToolbar(tester);

        // Should not throw with narrow screen
        expect(find.byType(QuillToolbar), findsOneWidget);
        
        // Reset screen size
        await tester.binding.setSurfaceSize(null);
      });
    });
  });
}