import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/task/actions/task_actions.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/task_utils.dart';

void main() {
  late ProviderContainer container;
  late TaskModel testFirstTask;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Create the container
    container = ProviderContainer.test();

    // Get the first task model
    testFirstTask = getTaskByIndex(container);
  });

  group('Task Actions', () {
    group('Copy Task Action', () {
      final buttonText = 'Copy';

      testWidgets('copies task content to clipboard', (tester) async {
        // Pump the widget with the task content
        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              TaskActions.copyTask(context, ref, testFirstTask.id),
        );

        // Tap the copy button
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify snackbar is shown (this indicates the action completed)
        expect(find.byType(SnackBar), findsOneWidget);
      });
    });

    group('Share Task Action', () {
      final buttonText = 'Share';

      Future<void> pumpShareActionsWidget(WidgetTester tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              TaskActions.shareTask(context, testFirstTask.id),
        );
      }

      testWidgets('shows share bottom sheet when share action is triggered', (
        tester,
      ) async {
        await pumpShareActionsWidget(tester);

        // Tap the share button
        await tester.tap(find.text(buttonText));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify bottom sheet is shown
        expect(find.byType(BottomSheet), findsOneWidget);
      });

      testWidgets('displays correct task content in share preview', (
        tester,
      ) async {
        await pumpShareActionsWidget(tester);

        // Get the context of the share button
        await tester.tap(find.text(buttonText));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify bottom sheet is shown
        expect(find.byType(BottomSheet), findsOneWidget);

        // Verify task title is displayed in the bottom sheet
        expect(find.textContaining(testFirstTask.title), findsOneWidget);
      });

      testWidgets('share task bottom sheet can be dismissed', (tester) async {
        await pumpShareActionsWidget(tester);

        // Tap the share button
        await tester.tap(find.text(buttonText));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify bottom sheet is shown
        expect(find.byType(BottomSheet), findsOneWidget);

        // Dismiss the bottom sheet by tapping outside or using back gesture
        // Tap outside the bottom sheet
        await tester.tapAt(const Offset(10, 10));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify bottom sheet is dismissed
        expect(find.byType(BottomSheet), findsNothing);
      });

      testWidgets(
        'tapping share button in bottom sheet triggers platform share',
        (tester) async {
          bool isShareCalled = false;
          await initSharePlatformMethodCallHandler(
            onShare: () => isShareCalled = true,
          );

          // Pump the widget with the task content
          await pumpShareActionsWidget(tester);

          // Tap the share button to open bottom sheet
          await tester.tap(find.text(buttonText));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));

          // Verify bottom sheet is shown
          expect(find.byType(BottomSheet), findsOneWidget);

          // Find and tap the share button inside the bottom sheet
          // Look for the share text within the bottom sheet and tap on it
          final shareButtonInSheet = find.descendant(
            of: find.byType(BottomSheet),
            matching: find.text(buttonText),
          );

          expect(shareButtonInSheet, findsOneWidget);
          await tester.tap(shareButtonInSheet);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));

          // Verify that the platform share method was called
          expect(isShareCalled, isTrue);
        },
      );
    });

    group('Edit Task Action', () {
      final buttonText = 'Edit';
      late TaskModel testSecondTask;

      setUp(() {
        container = ProviderContainer.test(
          overrides: [editContentIdProvider.overrideWith((ref) => null)],
        );
        testSecondTask = getTaskByIndex(container, index: 1);
      });

      Future<void> pumpEditActionsWidget(
        WidgetTester tester, {
        String? taskId,
      }) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              TaskActions.editTask(ref, taskId ?? testFirstTask.id),
        );
      }

      testWidgets('sets edit content id when edit action is triggered', (
        tester,
      ) async {
        // Verify initial state - no task is being edited
        expect(container.read(editContentIdProvider), isNull);

        // Pump the widget with the task content
        await pumpEditActionsWidget(tester);

        // Tap the edit button
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify that the edit content id is set to the task id
        expect(container.read(editContentIdProvider), equals(testFirstTask.id));
      });

      testWidgets('edit action sets correct task id for editing', (
        tester,
      ) async {
        // Add multiple tasks
        final taskId1 = testFirstTask.id;
        final taskId2 = testSecondTask.id;

        // Verify initial state
        expect(container.read(editContentIdProvider), isNull);

        // Edit first task
        await pumpEditActionsWidget(tester, taskId: taskId1);

        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify first task is being edited
        expect(container.read(editContentIdProvider), equals(taskId1));

        // Now edit second task
        await tester.pumpWidget(Container()); // Clear previous widget
        await pumpEditActionsWidget(tester, taskId: taskId2);

        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify second task is now being edited
        expect(container.read(editContentIdProvider), equals(taskId2));
      });

      testWidgets('edit action can clear edit state by setting null', (
        tester,
      ) async {
        final taskId = testFirstTask.id;
        // Set initial edit state
        container.read(editContentIdProvider.notifier).state = taskId;
        expect(container.read(editContentIdProvider), equals(taskId));

        // Clear edit state manually (simulating cancel edit)
        container.read(editContentIdProvider.notifier).state = null;
        expect(container.read(editContentIdProvider), isNull);

        // Now trigger edit action again
        await pumpEditActionsWidget(tester);

        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify edit state is set again
        expect(container.read(editContentIdProvider), equals(taskId));
      });

      testWidgets(
        'edit action preserves task data integrity and update the task',
        (tester) async {
          final updatedTitle = 'Updated Title';
          final taskId = testFirstTask.id;
          final originalTitle = testFirstTask.title;

          // Pump the widget
          await pumpEditActionsWidget(tester);

          // Trigger edit action
          await tester.tap(find.text(buttonText));
          await tester.pumpAndSettle();

          // Verify edit state is set
          expect(container.read(editContentIdProvider), equals(taskId));

          // Verify task data is unchanged
          final taskBeforeEdit = container.read(taskProvider(taskId));
          expect(taskBeforeEdit, isNotNull);
          expect(taskBeforeEdit?.title, equals(originalTitle));
          expect(taskBeforeEdit?.id, equals(taskId));

          // Update the task title
          final taskNotifier = container.read(taskListProvider.notifier);
          taskNotifier.updateTaskTitle(taskId, updatedTitle);

          // Verify task data is updated
          final taskAfterEdit = container.read(taskProvider(taskId));
          expect(taskAfterEdit, isNotNull);
          expect(taskAfterEdit?.title, equals(updatedTitle));
          expect(taskAfterEdit?.id, equals(taskId));
        },
      );
    });

    group('Delete Task Action', () {
      final buttonText = 'Delete';

      Future<void> pumpDeleteActionsWidget(
        WidgetTester tester, {
        required String taskId,
      }) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              TaskActions.deleteTask(context, ref, taskId),
        );
      }

      testWidgets('deletes task from list when delete action is triggered', (
        tester,
      ) async {
        final taskId = testFirstTask.id;

        // Verify task exists
        final taskBeforeDelete = container.read(taskProvider(taskId));
        expect(taskBeforeDelete, isNotNull);

        // Pump the widget with the task content
        await pumpDeleteActionsWidget(tester, taskId: taskId);

        // Tap the delete button
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify task is deleted
        final taskAfterDelete = container.read(taskProvider(taskId));
        expect(taskAfterDelete, isNull);

        // Verify snackbar is shown (indicating delete completed)
        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('deletes correct task when multiple tasks exist', (
        tester,
      ) async {
        // Add multiple tasks
        final testFirstTask = getTaskByIndex(container);
        final taskId1 = testFirstTask.id;
        final testSecondTask = getTaskByIndex(container, index: 1);
        final taskId2 = testSecondTask.id;

        // Verify both tasks exist
        final taskBeforeDelete1 = container.read(taskProvider(taskId1));
        expect(taskBeforeDelete1, isNotNull);
        final taskBeforeDelete2 = container.read(taskProvider(taskId2));
        expect(taskBeforeDelete2, isNotNull);

        // Delete first task
        await pumpDeleteActionsWidget(tester, taskId: taskId1);

        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify only first task is deleted
        final taskAfterDelete1 = container.read(taskProvider(taskId1));
        expect(taskAfterDelete1, isNull);
        final taskAfterDelete2 = container.read(taskProvider(taskId2));
        expect(taskAfterDelete2, isNotNull);
      });

      testWidgets('delete action updates task focus correctly', (
        tester,
      ) async {
        final testFirstTask = getTaskByIndex(container);
        final firstTaskId = testFirstTask.id;
        final testSecondTask = getTaskByIndex(container, index: 1);
        final secondTaskId = testSecondTask.id;

        // Set focus to first task
        container.read(taskFocusProvider.notifier).state = firstTaskId;
        expect(container.read(taskFocusProvider), equals(firstTaskId));

        // Delete first task
        await pumpDeleteActionsWidget(tester, taskId: firstTaskId);

        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify focus is updated to second task
        expect(container.read(taskFocusProvider), equals(secondTaskId));
      });
    });
  });
}
