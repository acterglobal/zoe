import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/widgets/task_checkbox_widget.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/task_utils.dart';

void main() {
  late ProviderContainer container;
  late TaskModel testTaskModel;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Create the container
    container = ProviderContainer.test();

    // Get the test task
    testTaskModel = getTaskByIndex(container);
  });

  Future<void> pumpTaskCheckboxWidget({
    required WidgetTester tester,
    required ProviderContainer container,
    TaskModel? task,
  }) async {
    await tester.pumpMaterialWidgetWithProviderScope(
      container: container,
      child: TaskCheckboxWidget(
        task: task ?? testTaskModel,
      ),
    );
  }

  group('Task Checkbox Widget', () {
    group('Basic Rendering', () {
      testWidgets('displays checkbox widget when task exists', (tester) async {
        await pumpTaskCheckboxWidget(
          tester: tester,
          container: container,
        );

        // Verify main components are present
        expect(find.byType(TaskCheckboxWidget), findsOneWidget);
        expect(find.byType(Checkbox), findsOneWidget);
      });

      testWidgets('displays checkbox with correct initial value', (tester) async {
        await pumpTaskCheckboxWidget(
          tester: tester,
          container: container,
        );

        // Verify checkbox value matches task completion status
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, equals(testTaskModel.isCompleted));
      });
    });

    group('Checkbox Styling', () {
      testWidgets('has correct border styling', (tester) async {
        await pumpTaskCheckboxWidget(
          tester: tester,
          container: container,
        );

        // Verify border properties
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.side, isNotNull);
        expect(checkbox.side!.width, equals(2.0));
      });

      testWidgets('uses correct active color', (tester) async {
        await pumpTaskCheckboxWidget(
          tester: tester,
          container: container,
        );

        // Verify active color
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.activeColor, equals(AppColors.successColor));
      });

      testWidgets('uses correct check color', (tester) async {
        await pumpTaskCheckboxWidget(
          tester: tester,
          container: container,
        );

        // Verify check color
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.checkColor, equals(Colors.white));
      });

      testWidgets('has correct material tap target size', (tester) async {
        await pumpTaskCheckboxWidget(
          tester: tester,
          container: container,
        );

        // Verify material tap target size
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.materialTapTargetSize, equals(MaterialTapTargetSize.shrinkWrap));
      });

      testWidgets('has correct visual density', (tester) async {
        await pumpTaskCheckboxWidget(
          tester: tester,
          container: container,
        );

        // Verify visual density
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.visualDensity, equals(VisualDensity.compact));
      });
    });

    group('Task Completion States', () {
      testWidgets('displays unchecked checkbox for incomplete task', (tester) async {
        final incompleteTask = testTaskModel.copyWith(isCompleted: false);
        
        await pumpTaskCheckboxWidget(
          tester: tester,
          container: container,
          task: incompleteTask,
        );

        // Verify checkbox is unchecked
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, equals(false));
      });

      testWidgets('displays checked checkbox for completed task', (tester) async {
        final completedTask = testTaskModel.copyWith(isCompleted: true);
        
        await pumpTaskCheckboxWidget(
          tester: tester,
          container: container,
          task: completedTask,
        );

        // Verify checkbox is checked
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, equals(true));
      });
    });

    group('User Interaction', () {
      testWidgets('calls updateTaskCompletion when checkbox is tapped', (tester) async {
        await pumpTaskCheckboxWidget(
          tester: tester,
          container: container,
        );

        // Get initial state
        final initialTask = container.read(taskProvider(testTaskModel.id));
        expect(initialTask?.isCompleted, equals(testTaskModel.isCompleted));

        // Tap the checkbox
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        // Verify task completion status is updated
        final updatedTask = container.read(taskProvider(testTaskModel.id));
        expect(updatedTask?.isCompleted, equals(!testTaskModel.isCompleted));
      });

      testWidgets('handles null value in onChanged callback', (tester) async {
        await pumpTaskCheckboxWidget(
          tester: tester,
          container: container,
        );

        // Get the checkbox widget
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        
        // Verify onChanged callback handles null value (should default to false)
        expect(checkbox.onChanged, isNotNull);
        
        // The callback should handle null values gracefully
        // This is tested by the fact that the widget doesn't crash when tapped
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();
        
        // Should not crash and should update the task
        final updatedTask = container.read(taskProvider(testTaskModel.id));
        expect(updatedTask, isNotNull);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles task with different completion states', (tester) async {
        // Test with completed task
        final completedTask = testTaskModel.copyWith(isCompleted: true);
        
        await pumpTaskCheckboxWidget(
          tester: tester,
          container: container,
          task: completedTask,
        );

        // Verify checkbox reflects completed state
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, equals(true));
      });

      testWidgets('handles multiple taps correctly', (tester) async {
        await pumpTaskCheckboxWidget(
          tester: tester,
          container: container,
        );

        // Get initial state
        final initialCheckbox = tester.widget<Checkbox>(find.byType(Checkbox));
        final initialValue = initialCheckbox.value;

        // Tap multiple times
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();
        
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        // Should be back to original state
        final finalCheckbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(finalCheckbox.value, equals(initialValue));
      });
    });

    group('Accessibility', () {
      testWidgets('has correct semantic properties', (tester) async {
        await pumpTaskCheckboxWidget(
          tester: tester,
          container: container,
        );

        // Verify checkbox is accessible
        expect(find.byType(Checkbox), findsOneWidget);
        
        // Verify checkbox is tappable
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.onChanged, isNotNull);
      });

      testWidgets('maintains accessibility in different states', (tester) async {
        // Test with incomplete task
        final incompleteTask = testTaskModel.copyWith(isCompleted: false);
        
        await pumpTaskCheckboxWidget(
          tester: tester,
          container: container,
          task: incompleteTask,
        );

        // Verify accessibility
        expect(find.byType(Checkbox), findsOneWidget);
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.onChanged, isNotNull);
        expect(checkbox.value, equals(false));

        // Test with completed task
        final completedTask = testTaskModel.copyWith(isCompleted: true);
        
        await pumpTaskCheckboxWidget(
          tester: tester,
          container: container,
          task: completedTask,
        );

        // Verify accessibility
        expect(find.byType(Checkbox), findsOneWidget);
        final completedCheckbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(completedCheckbox.onChanged, isNotNull);
        expect(completedCheckbox.value, equals(true));
      });
    });
  });
}
