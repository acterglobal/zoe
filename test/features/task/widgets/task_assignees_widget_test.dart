/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/models/user_chip_type.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/widgets/task_assignees_widget.dart';
import 'package:zoe/features/task/widgets/task_assignee_header_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_chip_widget.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/task_utils.dart';

void main() {
  late ProviderContainer container;
  late TaskModel testTaskModel;
  const invalidUserId = 'invalid-user-id';

  setUp(() async {
    // Create the container with mock
    container = ProviderContainer.test();

    // Get the test task
    testTaskModel = getTaskByIndex(container);
  });

  Future<void> pumpTaskAssigneesWidget({
    required WidgetTester tester,
    required ProviderContainer container,
    TaskModel? task,
    bool isEditing = false,
  }) async {
    await tester.pumpMaterialWidgetWithProviderScope(
      container: container,
      child: TaskAssigneesWidget(
        isEditing: isEditing,
        task: task ?? testTaskModel,
      ),
    );
  }

  group('Task Assignees Widget', () {
    group('Basic Rendering', () {
      testWidgets('displays widget when task exists', (tester) async {
        await pumpTaskAssigneesWidget(tester: tester, container: container);

        // Verify main components are present
        expect(find.byType(TaskAssigneesWidget), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(TaskAssigneeHeaderWidget), findsOneWidget);
      });

      testWidgets('displays header widget with correct parameters', (
        tester,
      ) async {
        await pumpTaskAssigneesWidget(
          tester: tester,
          container: container,
          isEditing: true,
        );

        // Verify header widget is present
        expect(find.byType(TaskAssigneeHeaderWidget), findsOneWidget);

        // Verify header widget has correct parameters
        final header = tester.widget<TaskAssigneeHeaderWidget>(
          find.byType(TaskAssigneeHeaderWidget),
        );
        expect(header.isEditing, equals(true));
        expect(header.task, equals(testTaskModel));
      });
    });

    group('Empty State', () {
      testWidgets('displays no assignees message when no assigned users', (
        tester,
      ) async {
        final taskWithoutUsers = testTaskModel.copyWith(assignedUsers: []);

        await pumpTaskAssigneesWidget(
          tester: tester,
          container: container,
          task: taskWithoutUsers,
        );

        // Verify no assignees message is displayed
        expect(find.byType(Icon), findsAtLeastNWidgets(1));
        expect(find.byType(Text), findsAtLeastNWidgets(1));

        // Verify info icon (there might be multiple icons, so find the specific one)
        expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
      });

      testWidgets('displays correct no assignees text', (tester) async {
        final taskWithoutUsers = testTaskModel.copyWith(assignedUsers: []);

        await pumpTaskAssigneesWidget(
          tester: tester,
          container: container,
          task: taskWithoutUsers,
        );

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: TaskAssigneesWidget,
        );

        // Verify no assignees text
        expect(find.text(l10n.noAssigneesYet), findsOneWidget);
      });
    });

    group('With Assignees', () {
      testWidgets('displays assignee chips when users are assigned', (
        tester,
      ) async {
        await pumpTaskAssigneesWidget(tester: tester, container: container);

        // Verify user chips are displayed
        expect(
          find.byType(ZoeUserChipWidget),
          findsNWidgets(testTaskModel.assignedUsers.length),
        );
        expect(find.byType(Wrap), findsOneWidget);
      });

      testWidgets('has correct wrap spacing', (tester) async {
        await pumpTaskAssigneesWidget(tester: tester, container: container);

        // Verify wrap properties
        final wrap = tester.widget<Wrap>(find.byType(Wrap));
        expect(wrap.spacing, equals(8));
        expect(wrap.runSpacing, equals(8));
      });
    });

    group('Assignee Chips', () {
      testWidgets('displays correct user chip type', (tester) async {
        await pumpTaskAssigneesWidget(tester: tester, container: container);

        // Verify user chip type
        for (var i = 0; i < testTaskModel.assignedUsers.length; i++) {
          final userId = testTaskModel.assignedUsers[i];
          final userChip = tester.widget<ZoeUserChipWidget>(
            find.byType(ZoeUserChipWidget).at(i),
          );
          expect(userChip.type, equals(ZoeUserChipType.userNameWithAvatarChip));
          expect(
            userChip.user,
            equals(container.read(getUserByIdProvider(userId))),
          );
        }
      });

      testWidgets('shows remove button when in editing mode', (tester) async {
        await pumpTaskAssigneesWidget(
          tester: tester,
          container: container,
          isEditing: true,
        );

        // Verify user chip has remove callback
        for (var i = 0; i < testTaskModel.assignedUsers.length; i++) {
          final userChip = tester.widget<ZoeUserChipWidget>(
            find.byType(ZoeUserChipWidget).at(i),
          );
          expect(userChip.onRemove, isNotNull);
        }
      });

      testWidgets('hides remove button when not in editing mode', (
        tester,
      ) async {
        await pumpTaskAssigneesWidget(
          tester: tester,
          container: container,
          isEditing: false,
        );

        // Verify user chip has no remove callback
        for (var i = 0; i < testTaskModel.assignedUsers.length; i++) {
          final userChip = tester.widget<ZoeUserChipWidget>(
            find.byType(ZoeUserChipWidget).at(i),
          );
          expect(userChip.onRemove, isNull);
        }
      });

      testWidgets('handles null user gracefully', (tester) async {
        final taskWithInvalidUser = testTaskModel.copyWith(
          assignedUsers: [invalidUserId],
        );

        await pumpTaskAssigneesWidget(
          tester: tester,
          container: container,
          task: taskWithInvalidUser,
        );

        // Should not crash and should not display any chips
        expect(find.byType(ZoeUserChipWidget), findsNothing);
      });
    });

    group('Edit Mode Behavior', () {
      testWidgets('passes editing state to header widget', (tester) async {
        await pumpTaskAssigneesWidget(
          tester: tester,
          container: container,
          isEditing: true,
        );

        // Verify header receives editing state
        final header = tester.widget<TaskAssigneeHeaderWidget>(
          find.byType(TaskAssigneeHeaderWidget),
        );
        expect(header.isEditing, equals(true));
      });

      testWidgets('passes editing state to user chips', (tester) async {
        await pumpTaskAssigneesWidget(
          tester: tester,
          container: container,
          isEditing: true,
        );

        // Verify user chip receives editing state
        for (var i = 0; i < testTaskModel.assignedUsers.length; i++) {
          final userChip = tester.widget<ZoeUserChipWidget>(
            find.byType(ZoeUserChipWidget).at(i),
          );
          expect(userChip.onRemove, isNotNull);
        }
      });
    });

    group('Edge Cases', () {
      testWidgets('handles single assignee correctly', (tester) async {
        if (testTaskModel.assignedUsers.isEmpty) fail('No assigned users');
        final taskWithSingleUser = testTaskModel.copyWith(
          assignedUsers: [testTaskModel.assignedUsers.first],
        );

        await pumpTaskAssigneesWidget(
          tester: tester,
          container: container,
          task: taskWithSingleUser,
        );

        // Verify single chip is displayed
        expect(find.byType(ZoeUserChipWidget), findsOneWidget);
        expect(find.byType(Wrap), findsOneWidget);
      });

      testWidgets('handles multiple assignees correctly', (tester) async {
        await pumpTaskAssigneesWidget(tester: tester, container: container);

        // Verify multiple chips are displayed
        expect(
          find.byType(ZoeUserChipWidget),
          findsNWidgets(testTaskModel.assignedUsers.length),
        );
        expect(find.byType(Wrap), findsOneWidget);
      });
    });
  });
}
*/
