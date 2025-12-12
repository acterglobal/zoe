/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/widgets/task_assignee_header_widget.dart';
import 'package:zoe/common/providers/service_providers.dart';
import '../../../test-utils/mock_preferences.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/task_utils.dart';

void main() {
  late ProviderContainer container;
  late MockPreferencesService mockPreferencesService;
  late TaskModel testTaskModel;

  setUp(() async {
    // Create mock preferences service
    mockPreferencesService = await mockGetLoginUserId();

    // Create the container with mock
    container = ProviderContainer.test(
      overrides: [
        preferencesServiceProvider.overrideWithValue(mockPreferencesService),
      ],
    );

    // Get the test task
    testTaskModel = getTaskByIndex(container);
  });

  Future<void> pumpTaskAssigneeHeaderWidget({
    required WidgetTester tester,
    required ProviderContainer container,
    TaskModel? task,
    bool isEditing = false,
    double iconSize = 20,
    double textSize = 14,
  }) async {
    await tester.pumpMaterialWidgetWithProviderScope(
      container: container,
      child: TaskAssigneeHeaderWidget(
        isEditing: isEditing,
        task: task ?? testTaskModel,
        iconSize: iconSize,
        textSize: textSize,
      ),
    );
  }

  group('Task Assignee Header Widget', () {
    group('Basic Rendering', () {
      testWidgets('displays header widget when task exists', (tester) async {
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
        );

        // Verify main components are present
        expect(find.byType(TaskAssigneeHeaderWidget), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
        expect(find.byType(Spacer), findsOneWidget);
      });

      testWidgets('displays correct assignees text', (tester) async {
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
        );

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: TaskAssigneeHeaderWidget,
        );

        // Verify assignees text is displayed
        expect(find.text(l10n.assignees), findsOneWidget);
      });

      testWidgets('displays people icon', (tester) async {
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: testTaskModel,
        );

        // Verify people icon is displayed
        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.icon, equals(Icons.people_rounded));
      });
    });

    group('Icon Size Customization', () {
      testWidgets('uses default icon size when not specified', (tester) async {
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: testTaskModel,
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.size, equals(20)); // Default size
      });

      testWidgets('uses custom icon size when specified', (tester) async {
        const customIconSize = 16.0;
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: testTaskModel,
          iconSize: customIconSize,
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.size, equals(customIconSize));
      });
    });

    group('Text Size Customization', () {
      testWidgets('uses default text size when not specified', (tester) async {
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: testTaskModel,
        );

        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, equals(14)); // Default size
      });

      testWidgets('uses custom text size when specified', (tester) async {
        const customTextSize = 12.0;
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: testTaskModel,
          textSize: customTextSize,
        );

        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, equals(customTextSize));
      });
    });

    group('Edit Mode Behavior', () {
      testWidgets('shows add button when in editing mode', (tester) async {
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: testTaskModel,
          isEditing: true,
        );

        // Verify add button is present
        expect(find.byType(IconButton), findsOneWidget);
        expect(find.byIcon(Icons.add_circle_outline_rounded), findsOneWidget);
      });

      testWidgets('hides add button when not in editing mode', (tester) async {
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: testTaskModel,
          isEditing: false,
        );

        // Verify add button is hidden
        expect(find.byType(IconButton), findsNothing);
        expect(find.byIcon(Icons.add_circle_outline_rounded), findsNothing);
      });

      testWidgets('add button has correct size', (tester) async {
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: testTaskModel,
          isEditing: true,
        );

        final iconButton = tester.widget<IconButton>(find.byType(IconButton));
        final icon = iconButton.icon as Icon;
        expect(icon.size, equals(24));
      });
    });

    group('Text Styling', () {
      testWidgets('uses correct text style', (tester) async {
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: testTaskModel,
        );

        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, equals(14));
        // Verify it uses titleMedium style
        expect(text.style?.fontWeight, isNotNull);
      });

      testWidgets('applies custom text size to style', (tester) async {
        const customTextSize = 16.0;
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: testTaskModel,
          textSize: customTextSize,
        );

        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, equals(customTextSize));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles task with no assigned users', (tester) async {
        final taskWithoutUsers = testTaskModel.copyWith(assignedUsers: []);

        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: taskWithoutUsers,
        );

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: TaskAssigneeHeaderWidget,
        );

        // Should still display header
        expect(find.byType(TaskAssigneeHeaderWidget), findsOneWidget);
        expect(find.text(l10n.assignees), findsOneWidget);
      });

      testWidgets('handles task with multiple assigned users', (tester) async {
        final taskWithMultipleUsers = testTaskModel.copyWith(
          assignedUsers: ['user1', 'user2', 'user3'],
        );

        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: taskWithMultipleUsers,
        );

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: TaskAssigneeHeaderWidget,
        );

        // Should still display header
        expect(find.byType(TaskAssigneeHeaderWidget), findsOneWidget);
        expect(find.text(l10n.assignees), findsOneWidget);
      });

      testWidgets('handles zero icon size', (tester) async {
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: testTaskModel,
          iconSize: 0,
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.size, equals(0));
      });

      testWidgets('handles zero text size', (tester) async {
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: testTaskModel,
          textSize: 0,
        );

        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style?.fontSize, equals(0));
      });
    });

    group('Interaction', () {
      testWidgets('add button is tappable when in editing mode', (
        tester,
      ) async {
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: testTaskModel,
          isEditing: true,
        );

        // Verify add button can be tapped
        final iconButton = tester.widget<IconButton>(find.byType(IconButton));
        expect(iconButton.onPressed, isNotNull);
      });

      testWidgets('add button calls assignTask function', (tester) async {
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: testTaskModel,
          isEditing: true,
        );

        // Tap the add button
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        // The function should be called (we can't easily test the actual function call
        // without mocking the assignTask function, but we can verify the button is tappable)
        expect(find.byType(IconButton), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('has correct semantic properties', (tester) async {
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: testTaskModel,
          isEditing: true,
        );

        // Verify text is accessible
        expect(find.text('Assignees'), findsOneWidget);

        // Verify icon button is accessible
        expect(find.byType(IconButton), findsOneWidget);
      });

      testWidgets('maintains accessibility in non-editing mode', (
        tester,
      ) async {
        await pumpTaskAssigneeHeaderWidget(
          tester: tester,
          container: container,
          task: testTaskModel,
          isEditing: false,
        );

        // Verify text is still accessible
        expect(find.text('Assignees'), findsOneWidget);

        // Verify no interactive elements when not editing
        expect(find.byType(IconButton), findsNothing);
      });
    });
  });
}
*/
