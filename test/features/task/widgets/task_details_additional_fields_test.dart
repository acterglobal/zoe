/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/widgets/task_details_additional_fields.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/task_utils.dart';

void main() {
  late ProviderContainer container;
  late TaskModel testTaskModel;

  setUp(() async {
    // Create the container
    container = ProviderContainer.test();

    // Get the test task
    testTaskModel = getTaskByIndex(container);
  });

  Future<void> pumpTaskDetailsAdditionalFields({
    required WidgetTester tester,
    required ProviderContainer container,
    TaskModel? task,
    bool isEditing = false,
  }) async {
    await tester.pumpMaterialWidgetWithProviderScope(
      container: container,
      child: TaskDetailsAdditionalFields(
        task: task ?? testTaskModel,
        isEditing: isEditing,
      ),
    );
  }

  group('Task Details Additional Fields', () {
    group('Basic Rendering', () {
      testWidgets('displays widget when task exists', (tester) async {
        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
        );

        // Verify main components are present
        expect(find.byType(TaskDetailsAdditionalFields), findsOneWidget);
        expect(
          find.byType(Container),
          findsAtLeastNWidgets(2),
        ); // Main container + field item container
      });

      testWidgets('displays correct due date text', (tester) async {
        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
        );

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: TaskDetailsAdditionalFields,
        );

        // Verify due date text is displayed
        expect(find.text(l10n.dueDate), findsOneWidget);
        expect(find.text(l10n.date), findsOneWidget);

        // Verify the formatted date is displayed
        final dateText = find.byType(Text).evaluate().last.widget as Text;
        expect(dateText.data, isNotNull);
        expect(dateText.data, isNotEmpty);
      });
    });

    group('Due Date Card Styling', () {
      testWidgets('has correct container decoration', (tester) async {
        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
        );

        // Verify main container decoration
        final mainContainer = tester.widget<Container>(
          find.byType(Container).first,
        );
        expect(mainContainer.decoration, isNotNull);
        expect(mainContainer.padding, equals(const EdgeInsets.all(12)));
      });

      testWidgets('has correct border radius', (tester) async {
        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
        );

        // Verify border radius
        final mainContainer = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = mainContainer.decoration as BoxDecoration;
        expect(decoration.borderRadius, equals(BorderRadius.circular(12)));
      });

      testWidgets('has correct header styling', (tester) async {
        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
        );

        // Verify flag icon
        expect(find.byIcon(Icons.flag_outlined), findsOneWidget);

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: TaskDetailsAdditionalFields,
        );

        // Verify header text
        expect(find.text(l10n.dueDate), findsOneWidget);
      });

      testWidgets('has correct field item styling', (tester) async {
        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
        );

        // Verify calendar icon
        expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: TaskDetailsAdditionalFields,
        );

        // Verify field item text
        expect(find.text(l10n.date), findsOneWidget);
      });
    });

    group('Editing Mode Behavior', () {
      testWidgets('shows tappable field when in editing mode', (tester) async {
        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
          isEditing: true,
        );

        // Verify GestureDetector is present for interaction
        expect(find.byType(GestureDetector), findsOneWidget);

        // Verify the field item has tap functionality
        final gestureDetector = tester.widget<GestureDetector>(
          find.byType(GestureDetector),
        );
        expect(gestureDetector.onTap, isNotNull);
      });

      testWidgets('shows non-tappable field when not in editing mode', (
        tester,
      ) async {
        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
        );

        // Verify GestureDetector is present but with null onTap
        expect(find.byType(GestureDetector), findsOneWidget);

        // Verify the field item has no tap functionality
        final gestureDetector = tester.widget<GestureDetector>(
          find.byType(GestureDetector),
        );
        expect(gestureDetector.onTap, isNull);
      });

      testWidgets('has different border styling in editing mode', (
        tester,
      ) async {
        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
          isEditing: true,
        );

        // Verify field item container has border when tappable
        final fieldContainer = tester.widget<Container>(
          find.byType(Container).at(1), // Second container is the field item
        );
        final decoration = fieldContainer.decoration as BoxDecoration?;
        expect(decoration?.border, isNotNull);
      });

      testWidgets('has no border styling when not in editing mode', (
        tester,
      ) async {
        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
          isEditing: false,
        );

        // Verify field item container has no border when not tappable
        final fieldContainer = tester.widget<Container>(
          find.byType(Container).at(1), // Second container is the field item
        );
        final decoration = fieldContainer.decoration as BoxDecoration?;
        expect(decoration?.border, isNull);
      });
    });

    group('Field Item Structure', () {
      testWidgets('has correct field item layout', (tester) async {
        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
        );

        // Verify field item structure
        expect(find.byType(Column), findsAtLeastNWidgets(2));
        expect(find.byType(Row), findsAtLeastNWidgets(2));
        expect(
          find.byType(SizedBox),
          findsAtLeastNWidgets(2),
        ); // Spacing elements
      });

      testWidgets('displays correct icons and labels', (tester) async {
        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
        );

        // Verify all expected icons
        expect(find.byIcon(Icons.flag_outlined), findsOneWidget);
        expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: TaskDetailsAdditionalFields,
        );

        // Verify all expected labels
        expect(find.text(l10n.dueDate), findsOneWidget);
        expect(find.text(l10n.date), findsOneWidget);
      });
    });

    group('Task Data Integration', () {
      testWidgets('displays task due date correctly', (tester) async {
        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
        );

        // Verify the task's due date is displayed
        final task = container.read(taskProvider(testTaskModel.id));
        expect(task, isNotNull);

        // The date should be formatted and displayed
        final textWidgets = tester.widgetList<Text>(find.byType(Text));
        final dateTextData = textWidgets.last.data;
        final dueDateText = DateTimeUtils.formatDate(testTaskModel.dueDate);
        expect(dateTextData, isNotNull);
        expect(dateTextData, isNotEmpty);
        expect(dateTextData, equals(dueDateText));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles task with different due dates', (tester) async {
        // Test with a task that has a specific due date
        final taskWithSpecificDate = testTaskModel.copyWith(
          dueDate: DateTime.now().subtract(const Duration(days: 2)),
        );

        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
          task: taskWithSpecificDate,
        );

        // Verify the widget renders without errors
        expect(find.byType(TaskDetailsAdditionalFields), findsOneWidget);
        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: TaskDetailsAdditionalFields,
        );
        expect(find.text(l10n.dueDate), findsOneWidget);
        expect(find.text(l10n.date), findsOneWidget);
      });

      testWidgets('handles task with current date', (tester) async {
        final taskWithCurrentDate = testTaskModel.copyWith(
          dueDate: DateTime.now(),
        );

        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
          task: taskWithCurrentDate,
        );

        // Verify the widget renders without errors
        expect(find.byType(TaskDetailsAdditionalFields), findsOneWidget);
        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: TaskDetailsAdditionalFields,
        );
        expect(find.text(l10n.dueDate), findsOneWidget);
        expect(find.text(l10n.date), findsOneWidget);
      });

      testWidgets('handles task with future date', (tester) async {
        final taskWithFutureDate = testTaskModel.copyWith(
          dueDate: DateTime.now().add(const Duration(days: 30)),
        );

        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
          task: taskWithFutureDate,
        );

        // Verify the widget renders without errors
        expect(find.byType(TaskDetailsAdditionalFields), findsOneWidget);
        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: TaskDetailsAdditionalFields,
        );
        expect(find.text(l10n.dueDate), findsOneWidget);
        expect(find.text(l10n.date), findsOneWidget);
      });
    });

    group('Theme Integration', () {
      testWidgets('uses correct theme colors', (tester) async {
        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
        );

        final theme = WidgetTesterExtension.getTheme(
          tester,
          byType: TaskDetailsAdditionalFields,
        );

        // Verify icons use theme colors
        final flagIcon = tester.widget<Icon>(find.byIcon(Icons.flag_outlined));
        expect(flagIcon.color, equals(theme.colorScheme.primary));

        final calendarIcon = tester.widget<Icon>(
          find.byIcon(Icons.calendar_today_outlined),
        );
        expect(
          calendarIcon.color,
          theme.colorScheme.onSurface.withValues(alpha: 0.6),
        );
      });

      testWidgets('uses correct text styles', (tester) async {
        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
        );

        // Verify text styles are applied
        final textWidgets = tester.widgetList<Text>(find.byType(Text));
        expect(textWidgets.length, greaterThanOrEqualTo(3));

        // All text widgets should have styles
        for (final textWidget in textWidgets) {
          expect(textWidget.style, isNotNull);
        }
      });

      testWidgets('adapts to different themes', (tester) async {
        await pumpTaskDetailsAdditionalFields(
          tester: tester,
          container: container,
        );

        final theme = WidgetTesterExtension.getTheme(
          tester,
          byType: TaskDetailsAdditionalFields,
        );

        // Verify the widget uses theme colors
        final mainContainer = tester.widget<Container>(
          find.byType(Container).first,
        );

        // Verify the widget uses theme colors
        final decoration = mainContainer.decoration as BoxDecoration;
        expect(
          decoration.color,
          theme.colorScheme.surface.withValues(alpha: 0.3),
        );
      });
    });
  });
}
*/
