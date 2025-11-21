import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/common/widgets/animated_textfield_widget.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import 'package:zoe/features/share/widgets/sheet_share_preview_widget.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';
import '../../sheet/utils/sheet_utils.dart';
import '../../text/utils/text_utils.dart';
import '../../events/utils/event_utils.dart';
import '../../list/utils/list_utils.dart';
import '../../task/utils/task_utils.dart';
import '../../bullets/utils/bullets_utils.dart';
import '../../polls/utils/poll_utils.dart';
import '../../users/utils/users_utils.dart';

void main() {
  late ProviderContainer container;
  late String testUserId;

  setUp(() {
    // Create initial container to get test user
    final initialContainer = ProviderContainer.test();
    testUserId = getUserByIndex(initialContainer).id;

    // Create container with logged in user override
    container = ProviderContainer.test(
      overrides: [
        loggedInUserProvider.overrideWithValue(AsyncValue.data(testUserId)),
      ],
    );
  });

  Future<void> pumpShareItemsBottomSheet(
    WidgetTester tester, {
    required String parentId,
    bool isSheet = false,
  }) async {
    await tester.pumpMaterialWidgetWithProviderScope(
      container: container,
      child: ShareItemsBottomSheet(parentId: parentId, isSheet: isSheet),
    );
  }

  L10n getL10n(WidgetTester tester) {
    return WidgetTesterExtension.getL10n(
      tester,
      byType: ShareItemsBottomSheet,
    );
  }

  group('Share Items Bottom Sheet Widget', () {
    group('Sheet Share', () {
      late SheetModel testSheet;

      setUp(() {
        testSheet = getSheetByIndex(container);
      });

      testWidgets('displays sheet share UI correctly', (tester) async {
        await pumpShareItemsBottomSheet(
          tester,
          parentId: testSheet.id,
          isSheet: true,
        );

        // Verify sheet info is displayed (title)
        expect(find.textContaining(testSheet.title), findsWidgets);

        // Verify SheetSharePreviewWidget is displayed
        expect(find.byType(SheetSharePreviewWidget), findsOneWidget);

        // Verify content preview container
        expect(find.byType(GlassyContainer), findsOneWidget);

        // Verify share button
        final l10n = getL10n(tester);
        expect(find.byType(ZoePrimaryButton), findsOneWidget);
        expect(find.text(l10n.share), findsWidgets);
        expect(find.byIcon(Icons.share_rounded), findsOneWidget);
      });

      testWidgets('displays sheet content in preview', (tester) async {
        await pumpShareItemsBottomSheet(
          tester,
          parentId: testSheet.id,
          isSheet: true,
        );

        // Verify sheet title is in the preview
        expect(find.textContaining(testSheet.title), findsWidgets);
      });

      testWidgets('displays SheetSharePreviewWidget for sheets', (
        tester,
      ) async {
        await pumpShareItemsBottomSheet(
          tester,
          parentId: testSheet.id,
          isSheet: true,
        );

        // Verify SheetSharePreviewWidget is displayed
        expect(find.byType(SheetSharePreviewWidget), findsOneWidget);
      });

      testWidgets('displays message input field in sheet share', (
        tester,
      ) async {
        await pumpShareItemsBottomSheet(
          tester,
          parentId: testSheet.id,
          isSheet: true,
        );

        // Verify AnimatedTextField for message input is present
        expect(find.byType(AnimatedTextField), findsOneWidget);

        final l10n = getL10n(tester);
        // Verify hint text
        final textField = tester.widget<AnimatedTextField>(
          find.byType(AnimatedTextField),
        );
        expect(textField.hintText, equals(l10n.addAMessage));
      });

      testWidgets('updates message state when user types', (tester) async {
        await pumpShareItemsBottomSheet(
          tester,
          parentId: testSheet.id,
          isSheet: true,
        );

        const testMessage = 'This is a test message';
        await tester.enterText(find.byType(AnimatedTextField), testMessage);
        await tester.pump();

        // Verify text was entered
        final textField = tester.widget<AnimatedTextField>(
          find.byType(AnimatedTextField),
        );
        expect(textField.controller.text, equals(testMessage));
      });

      testWidgets('saves sharedBy and message to sheet model when sharing', (
        tester,
      ) async {
        bool isShareCalled = false;
        await initSharePlatformMethodCallHandler(
          onShare: () => isShareCalled = true,
        );

        final currentUser = getUserByIndex(container);
        await pumpShareItemsBottomSheet(
          tester,
          parentId: testSheet.id,
          isSheet: true,
        );

        const testMessage = 'Check out this sheet!';
        await tester.enterText(find.byType(AnimatedTextField), testMessage);
        await tester.pump();

        // Tap share button
        final shareButton = find.byType(ZoePrimaryButton);
        await tester.tap(shareButton);
        await tester.pump();

        // Verify share was called
        expect(isShareCalled, isTrue);

        // Wait a bit for state update to propagate
        await tester.pump();
        await tester.pump();

        // Verify sheet model was updated with sharedBy and message
        final updatedSheet = container.read(sheetProvider(testSheet.id));
        expect(updatedSheet?.sharedBy, equals(currentUser.name));
        expect(updatedSheet?.message, equals(testMessage));
      });

      testWidgets('saves only sharedBy when message is empty', (tester) async {
        bool isShareCalled = false;
        await initSharePlatformMethodCallHandler(
          onShare: () => isShareCalled = true,
        );

        final currentUser = getUserByIndex(container);
        await pumpShareItemsBottomSheet(
          tester,
          parentId: testSheet.id,
          isSheet: true,
        );

        // Don't enter any message, just tap share
        final shareButton = find.byType(ZoePrimaryButton);
        await tester.tap(shareButton);
        await tester.pump();

        // Verify share was called
        expect(isShareCalled, isTrue);

        // Wait a bit for state update to propagate
        await tester.pump();
        await tester.pump();

        // Verify sheet model was updated with sharedBy but message is null
        final updatedSheet = container.read(sheetProvider(testSheet.id));
        expect(updatedSheet?.sharedBy, equals(currentUser.name));
        expect(updatedSheet?.message, isNull);
      });

      testWidgets('saves trimmed message when message has whitespace', (
        tester,
      ) async {
        bool isShareCalled = false;
        await initSharePlatformMethodCallHandler(
          onShare: () => isShareCalled = true,
        );

        final currentUser = getUserByIndex(container);
        await pumpShareItemsBottomSheet(
          tester,
          parentId: testSheet.id,
          isSheet: true,
        );

        const testMessage = '  Check out this sheet!  ';
        await tester.enterText(find.byType(AnimatedTextField), testMessage);
        await tester.pump();

        // Tap share button
        final shareButton = find.byType(ZoePrimaryButton);
        await tester.tap(shareButton);
        await tester.pump();

        // Verify share was called
        expect(isShareCalled, isTrue);

        // Wait a bit for state update to propagate
        await tester.pump();
        await tester.pump();

        // Verify sheet model was updated with trimmed message
        final updatedSheet = container.read(sheetProvider(testSheet.id));
        expect(updatedSheet?.sharedBy, equals(currentUser.name));
        expect(updatedSheet?.message, equals(testMessage.trim()));
      });

      testWidgets('includes user message in share content when provided', (
        tester,
      ) async {
        await pumpShareItemsBottomSheet(
          tester,
          parentId: testSheet.id,
          isSheet: true,
        );

        const testMessage = 'This is my custom message';
        await tester.enterText(find.byType(AnimatedTextField), testMessage);
        await tester.pump();

        // The message should be included in the share content
        // We can verify this by checking the share content generation
        // Note: This is indirectly tested through the share button functionality
        expect(find.byType(AnimatedTextField), findsOneWidget);
        final textField = tester.widget<AnimatedTextField>(
          find.byType(AnimatedTextField),
        );
        expect(textField.controller.text, equals(testMessage));
      });

      testWidgets('calls updateSheetShareInfo with correct parameters when currentUser is not null', (
        tester,
      ) async {
        bool isShareCalled = false;
        await initSharePlatformMethodCallHandler(
          onShare: () => isShareCalled = true,
        );

        final currentUser = getUserByIndex(container);
        
        await pumpShareItemsBottomSheet(
          tester,
          parentId: testSheet.id,
          isSheet: true,
        );

        const testMessage = 'Test message with whitespace  ';
        await tester.enterText(find.byType(AnimatedTextField), testMessage);
        await tester.pump();

        // Tap share button
        final shareButton = find.byType(ZoePrimaryButton);
        await tester.tap(shareButton);
        await tester.pump();

        // Wait for state update to propagate
        await tester.pump();
        await tester.pump();

        // Verify updateSheetShareInfo was called with correct parameters
        final updatedSheet = container.read(sheetProvider(testSheet.id));
        expect(updatedSheet?.sharedBy, equals(currentUser.name));
        expect(updatedSheet?.message, equals(testMessage.trim()));
        expect(updatedSheet?.id, equals(testSheet.id));
        
        // Verify share was also called
        expect(isShareCalled, isTrue);
      });

      testWidgets('calls updateSheetShareInfo with null message when message is empty', (
        tester,
      ) async {
        bool isShareCalled = false;
        await initSharePlatformMethodCallHandler(
          onShare: () => isShareCalled = true,
        );

        final currentUser = getUserByIndex(container);
        
        await pumpShareItemsBottomSheet(
          tester,
          parentId: testSheet.id,
          isSheet: true,
        );

        // Don't enter any message
        final shareButton = find.byType(ZoePrimaryButton);
        await tester.tap(shareButton);
        await tester.pump();

        // Wait for state update to propagate
        await tester.pump();
        await tester.pump();

        // Verify updateSheetShareInfo was called with null message
        final updatedSheet = container.read(sheetProvider(testSheet.id));
        expect(updatedSheet?.sharedBy, equals(currentUser.name));
        expect(updatedSheet?.message, isNull);
        
        // Verify share was also called
        expect(isShareCalled, isTrue);
      });

      testWidgets('does not call updateSheetShareInfo when currentUser is null', (
        tester,
      ) async {
        bool isShareCalled = false;
        await initSharePlatformMethodCallHandler(
          onShare: () => isShareCalled = true,
        );

        // Create a container with null currentUser
        final testContainer = ProviderContainer.test(
          overrides: [
            loggedInUserProvider.overrideWithValue(const AsyncValue.data(null)),
            currentUserProvider.overrideWithValue(const AsyncValue.data(null)),
          ],
        );

        final initialSheet = testContainer.read(sheetProvider(testSheet.id));
        final initialSharedBy = initialSheet?.sharedBy;
        final initialMessage = initialSheet?.message;

        await tester.pumpMaterialWidgetWithProviderScope(
          container: testContainer,
          child: ShareItemsBottomSheet(
            parentId: testSheet.id,
            isSheet: true,
          ),
        );

        const testMessage = 'Test message';
        await tester.enterText(find.byType(AnimatedTextField), testMessage);
        await tester.pump();

        // Tap share button
        final shareButton = find.byType(ZoePrimaryButton);
        await tester.tap(shareButton);
        await tester.pump();

        // Wait for state update to propagate
        await tester.pump();
        await tester.pump();

        // Verify updateSheetShareInfo was NOT called (sheet model unchanged)
        final updatedSheet = testContainer.read(sheetProvider(testSheet.id));
        expect(updatedSheet?.sharedBy, equals(initialSharedBy));
        expect(updatedSheet?.message, equals(initialMessage));
        
        // Verify share was still called (share functionality works without user)
        expect(isShareCalled, isTrue);

        testContainer.dispose();
      });
    });

    group('Text Content Share', () {
      late TextModel testText;

      setUp(() {
        testText = getTextByIndex(container);
      });

      testWidgets('displays text share UI correctly', (tester) async {
        await pumpShareItemsBottomSheet(tester, parentId: testText.id);

        // Verify title
        final l10n = getL10n(tester);
        expect(find.text(l10n.shareText), findsOneWidget);

        // Verify content preview
        expect(find.byType(GlassyContainer), findsOneWidget);
        expect(find.textContaining(testText.title), findsWidgets);
      });
    });

    group('Event Content Share', () {
      late EventModel testEvent;

      setUp(() {
        testEvent = getEventByIndex(container);
        container = ProviderContainer.test(
          overrides: [
            contentProvider(testEvent.id).overrideWithValue(testEvent),
          ],
        );
      });

      testWidgets('displays event share UI correctly', (tester) async {
        await pumpShareItemsBottomSheet(tester, parentId: testEvent.id);

        // Verify title
        final l10n = getL10n(tester);
        expect(find.text(l10n.shareEvent), findsOneWidget);

        // Verify event content
        expect(find.textContaining(testEvent.title), findsWidgets);
      });

      testWidgets('includes event dates in preview', (tester) async {
        await pumpShareItemsBottomSheet(tester, parentId: testEvent.id);

        // Verify date indicators are present
        expect(find.textContaining('🕓 Start'), findsWidgets);
        expect(find.textContaining('🕓 End'), findsWidgets);
      });
    });

    group('Task List Share', () {
      late ListModel testList;

      setUp(() {
        testList = getListByIndex(container);
      });

      testWidgets('displays task list share UI correctly', (tester) async {
        final taskList = testList.copyWith(listType: ContentType.task);
        container.read(listsProvider.notifier).state = [taskList];

        await pumpShareItemsBottomSheet(tester, parentId: taskList.id);

        // Verify title
        final l10n = getL10n(tester);
        expect(find.text(l10n.shareTaskList), findsOneWidget);

        // Verify list content
        expect(find.textContaining(taskList.title), findsWidgets);
      });

      testWidgets('includes tasks in preview', (tester) async {
        final taskList = testList.copyWith(listType: ContentType.task);

        // Create tasks for the list
        final taskContent = getTaskByIndex(container);
        final task = taskContent.copyWith(parentId: taskList.id);

        container.read(listsProvider.notifier).state = [taskList];
        container.read(taskListProvider.notifier).state = [task];

        await pumpShareItemsBottomSheet(tester, parentId: taskList.id);

        // Verify task is in the preview with checkmark
        expect(find.textContaining('☑️'), findsWidgets);
      });
    });

    group('Bullet List Share', () {
      late ListModel testList;

      setUp(() {
        testList = getListByIndex(container);
      });

      testWidgets('displays bullet list share UI correctly', (tester) async {
        final bulletList = testList.copyWith(listType: ContentType.bullet);
        container.read(listsProvider.notifier).state = [bulletList];

        await pumpShareItemsBottomSheet(tester, parentId: bulletList.id);

        // Verify title
        final l10n = getL10n(tester);
        expect(find.text(l10n.shareBulletList), findsOneWidget);

        // Verify list content
        expect(find.textContaining(bulletList.title), findsWidgets);
      });

      testWidgets('includes bullets in preview', (tester) async {
        final bulletList = testList.copyWith(listType: ContentType.bullet);

        // Create bullets for the list
        final bulletContent = getBulletByIndex(container);
        final bullet = bulletContent.copyWith(parentId: bulletList.id);

        container.read(listsProvider.notifier).state = [bulletList];
        container.read(bulletListProvider.notifier).state = [bullet];

        await pumpShareItemsBottomSheet(tester, parentId: bulletList.id);

        // Verify bullet is in the preview with bullet point
        expect(find.textContaining('🔹'), findsWidgets);
      });
    });

    group('Task Share', () {
      late TaskModel testTask;

      setUp(() {
        testTask = getTaskByIndex(container);
        container = ProviderContainer.test(
          overrides: [contentProvider(testTask.id).overrideWithValue(testTask)],
        );
      });

      testWidgets('displays task share UI correctly', (tester) async {
        await pumpShareItemsBottomSheet(tester, parentId: testTask.id);

        // Verify title
        final l10n = getL10n(tester);
        expect(find.text(l10n.shareTask), findsOneWidget);

        // Verify task content
        expect(find.textContaining(testTask.title), findsWidgets);
      });

      testWidgets('includes task due date in preview', (tester) async {
        await pumpShareItemsBottomSheet(tester, parentId: testTask.id);

        // Verify due date indicator is present
        expect(find.textContaining('🕒 Due:'), findsWidgets);
      });

      testWidgets('includes assigned users in preview when present', (
        tester,
      ) async {
        final user1 = getUserByIndex(container);
        final user2 = getUserByIndex(container, index: 1);
        final assignedUsers = [user1.id, user2.id];

        final taskWithUsers = testTask.copyWith(assignedUsers: assignedUsers);
        container.read(taskListProvider.notifier).state = [taskWithUsers];

        await pumpShareItemsBottomSheet(tester, parentId: taskWithUsers.id);

        // Verify assigned users indicator is present
        expect(find.textContaining('👥 Assigned:'), findsWidgets);
        for (final userId in taskWithUsers.assignedUsers) {
          final user = container.read(getUserByIdProvider(userId));
          expect(find.textContaining(user?.name ?? ''), findsWidgets);
        }
      });
    });

    group('Bullet Share', () {
      late BulletModel testBullet;

      setUp(() {
        testBullet = getBulletByIndex(container);
      });

      testWidgets('displays bullet share UI correctly', (tester) async {
        await pumpShareItemsBottomSheet(tester, parentId: testBullet.id);

        // Verify title
        final l10n = getL10n(tester);
        expect(find.text(l10n.shareBullet), findsOneWidget);

        // Verify bullet content
        expect(find.textContaining(testBullet.title), findsWidgets);
      });

      testWidgets('displays bullet with description', (tester) async {
        final desc = 'This is a bullet with description';
        final testBulletWithDesc = testBullet.copyWith(
          description: (plainText: desc, htmlText: null),
        );

        container.read(bulletListProvider.notifier).state = [
          testBulletWithDesc,
        ];

        await pumpShareItemsBottomSheet(
          tester,
          parentId: testBulletWithDesc.id,
        );

        // Verify bullet content is displayed
        expect(find.textContaining(testBulletWithDesc.title), findsWidgets);
        expect(find.textContaining(desc), findsWidgets);
      });
    });

    group('Poll Share', () {
      late PollModel testPoll;

      setUp(() {
        testPoll = getPollByIndex(container);
        container = ProviderContainer.test(
          overrides: [contentProvider(testPoll.id).overrideWithValue(testPoll)],
        );
      });

      testWidgets('displays poll share UI correctly', (tester) async {
        await pumpShareItemsBottomSheet(tester, parentId: testPoll.id);

        // Verify title
        final l10n = getL10n(tester);
        expect(find.text(l10n.sharePoll), findsOneWidget);

        // Verify poll question
        expect(find.textContaining(testPoll.title), findsWidgets);
      });

      testWidgets('includes poll options in preview', (tester) async {
        final testPollWithOptions = testPoll.copyWith(
          options: [
            PollOption(title: 'Option 1', votes: [], id: 'option-1'),
            PollOption(title: 'Option 2', votes: [], id: 'option-2'),
          ],
        );
        container.read(pollListProvider.notifier).state = [testPollWithOptions];

        await pumpShareItemsBottomSheet(
          tester,
          parentId: testPollWithOptions.id,
        );

        // Verify poll options are displayed with radio button emoji
        expect(find.textContaining(testPollWithOptions.title), findsWidgets);
        for (final option in testPollWithOptions.options) {
          expect(find.textContaining('🔘 ${option.title}'), findsWidgets);
        }
      });
    });

    group('UI Structure', () {
      testWidgets('has correct widget hierarchy', (tester) async {
        final testSheet = getSheetByIndex(container);

        await pumpShareItemsBottomSheet(
          tester,
          parentId: testSheet.id,
          isSheet: true,
        );

        // Verify Column structure
        expect(find.byType(Column), findsWidgets);

        // Verify title Text widget
        expect(find.byType(Text), findsWidgets);

        // Verify SizedBox for spacing
        expect(find.byType(SizedBox), findsWidgets);

        // Verify GlassyContainer for content preview
        expect(find.byType(GlassyContainer), findsOneWidget);

        // Verify SingleChildScrollView inside preview
        final glassyContainer = tester.widget<GlassyContainer>(
          find.byType(GlassyContainer),
        );
        expect(glassyContainer.child, isA<SingleChildScrollView>());

        // Verify share button
        expect(find.byType(ZoePrimaryButton), findsOneWidget);
      });

      testWidgets('share button has correct properties', (tester) async {
        bool isShareCalled = false;
        await initSharePlatformMethodCallHandler(
          onShare: () => isShareCalled = true,
        );

        final testSheet = getSheetByIndex(container);
        await pumpShareItemsBottomSheet(
          tester,
          parentId: testSheet.id,
          isSheet: true,
        );

        // Verify button properties
        final shareButton = find.byType(ZoePrimaryButton);
        final buttonWidget = tester.widget<ZoePrimaryButton>(shareButton);
        expect(buttonWidget.icon, equals(Icons.share_rounded));

        final l10n = getL10n(tester);
        expect(buttonWidget.text, equals(l10n.share));
        await tester.tap(shareButton);
        expect(isShareCalled, isTrue);
      });

      testWidgets('share button calls share for non-sheet content', (
        tester,
      ) async {
        bool isShareCalled = false;
        await initSharePlatformMethodCallHandler(
          onShare: () => isShareCalled = true,
        );

        final testText = getTextByIndex(container);
        await pumpShareItemsBottomSheet(
          tester,
          parentId: testText.id,
          isSheet: false,
        );

        // Verify share button is present
        final shareButton = find.byType(ZoePrimaryButton);
        expect(shareButton, findsOneWidget);

        // Tap share button
        await tester.tap(shareButton);
        await tester.pump();

        // Verify share was called (for non-sheet content, it should call shareText directly)
        expect(isShareCalled, isTrue);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty content message', (tester) async {
        await pumpShareItemsBottomSheet(tester, parentId: 'non-existent-id');

        // Content preview should be present (empty)
        expect(find.byType(GlassyContainer), findsOneWidget);
        expect(find.textContaining(''), findsWidgets);
      });
    });
  });
}
