import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_avatar_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/features/users/widgets/user_list_widget.dart';
import 'package:zoe/features/users/widgets/user_widget.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/users_utils.dart';

void main() {
  group('UserListWidget', () {
    late ProviderContainer container;
    late List<String> testUserIds;
    late UserModel testUser1;
    late UserModel testUser2;
    late UserModel testUser3;

    setUp(() {
      container = ProviderContainer.test();
      testUser1 = getUserByIndex(container, index: 0);
      testUser2 = getUserByIndex(container, index: 1);
      testUser3 = getUserByIndex(container, index: 2);
      testUserIds = [testUser1.id, testUser2.id, testUser3.id];
    });

    Future<void> pumpUserListWidget(
      WidgetTester tester, {
      required List<String> userIds,
      String title = 'Test Users',
      Widget? Function(String userId)? actionWidget,
      Function(String userId)? onTapUser,
    }) async {
      // Create a simple provider for the user IDs
      final userIdListProvider = Provider<List<String>>((ref) => userIds);

      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: UserListWidget(
          userIdList: userIdListProvider,
          title: title,
          actionWidget: actionWidget,
          onTapUser: onTapUser,
        ),
      );
    }

    group('Basic Rendering', () {
      testWidgets('renders widget with valid user IDs', (tester) async {
        await pumpUserListWidget(tester, userIds: testUserIds);

        expect(find.byType(UserListWidget), findsOneWidget);
        expect(find.byType(Container), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('renders with empty user list', (tester) async {
        await pumpUserListWidget(tester, userIds: []);

        expect(find.byType(UserListWidget), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(UserWidget), findsNothing);
      });

      testWidgets('renders main components correctly', (tester) async {
        await pumpUserListWidget(tester, userIds: testUserIds);

        expect(find.byType(Container), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Padding), findsAtLeastNWidgets(1));
        expect(find.byType(ListTile), findsOneWidget);
        expect(find.byType(Flexible), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
      });

      testWidgets('applies correct container decoration', (tester) async {
        await pumpUserListWidget(tester, userIds: testUserIds);

        final containers = tester.widgetList<Container>(find.byType(Container));
        final mainContainer = containers.firstWhere(
          (c) => c.decoration != null,
          orElse: () => containers.first,
        );

        expect(mainContainer.decoration, isNotNull);
        final decoration = mainContainer.decoration as BoxDecoration;
        expect(
          decoration.borderRadius,
          const BorderRadius.vertical(top: Radius.circular(20)),
        );
      });

      testWidgets('has correct column structure', (tester) async {
        await pumpUserListWidget(tester, userIds: testUserIds);

        final column = tester.widget<Column>(find.byType(Column));
        expect(column.mainAxisSize, MainAxisSize.min);
        expect(column.children.length, 3); // Padding, Flexible, SizedBox
      });
    });

    group('Header Section', () {
      testWidgets('displays correct title', (tester) async {
        const customTitle = 'Custom User List';
        await pumpUserListWidget(
          tester,
          userIds: testUserIds,
          title: customTitle,
        );

        expect(find.text(customTitle), findsOneWidget);
      });

      testWidgets('renders header components correctly', (tester) async {
        await pumpUserListWidget(tester, userIds: testUserIds);

        expect(find.byType(Padding), findsAtLeastNWidgets(1));
        expect(find.byType(ListTile), findsOneWidget);
        expect(find.byIcon(Icons.people_rounded), findsOneWidget);
        expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      });

      testWidgets('applies correct header padding', (tester) async {
        await pumpUserListWidget(tester, userIds: testUserIds);

        final paddings = tester.widgetList<Padding>(find.byType(Padding));
        const expectedPadding = EdgeInsets.only(
          left: 20,
          right: 5,
          top: 10,
          bottom: 10,
        );
        final headerPadding = paddings.firstWhere(
          (p) => p.padding == expectedPadding,
          orElse: () => paddings.first,
        );
        expect(headerPadding.padding, expectedPadding);
      });

      testWidgets('configures ListTile correctly', (tester) async {
        await pumpUserListWidget(tester, userIds: testUserIds);

        final listTile = tester.widget<ListTile>(find.byType(ListTile));
        expect(listTile.contentPadding, EdgeInsets.zero);
        expect(listTile.leading, isA<Icon>());
        expect(listTile.title, isA<Text>());
        expect(listTile.trailing, isA<IconButton>());
      });

      testWidgets('handles close button tap', (tester) async {
        await pumpUserListWidget(tester, userIds: testUserIds);

        final closeButton = find.byIcon(Icons.close_rounded);
        expect(closeButton, findsOneWidget);

        // Test that the button is tappable
        await tester.tap(closeButton);
        await tester.pump();
      });
    });

    group('User List', () {
      testWidgets('renders correct number of users', (tester) async {
        await pumpUserListWidget(tester, userIds: testUserIds);

        expect(find.byType(UserWidget), findsNWidgets(3));
      });

      testWidgets('renders users with correct IDs', (tester) async {
        await pumpUserListWidget(tester, userIds: testUserIds);

        expect(find.text(testUser1.name), findsOneWidget);
        expect(find.text(testUser2.name), findsOneWidget);
        expect(find.text(testUser3.name), findsOneWidget);
      });

      testWidgets('applies correct padding to user widgets', (tester) async {
        await pumpUserListWidget(tester, userIds: testUserIds);

        final paddings = tester.widgetList<Padding>(find.byType(Padding));
        final userPadding = paddings.firstWhere(
          (p) =>
              p.padding ==
              const EdgeInsets.only(left: 20, right: 20, bottom: 8),
          orElse: () => paddings.first,
        );
        expect(
          userPadding.padding,
          const EdgeInsets.only(left: 20, right: 20, bottom: 8),
        );
      });

      testWidgets('configures ListView correctly', (tester) async {
        await pumpUserListWidget(tester, userIds: testUserIds);

        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.shrinkWrap, isTrue);
        expect(listView.padding, EdgeInsets.zero);
        expect(listView.physics, const NeverScrollableScrollPhysics());
      });

      testWidgets('handles single user', (tester) async {
        await pumpUserListWidget(tester, userIds: [testUser1.id]);

        expect(find.byType(UserWidget), findsOneWidget);
        expect(find.text(testUser1.name), findsOneWidget);
      });

      testWidgets('handles many users', (tester) async {
        final manyUserIds = List.generate(10, (index) => 'user_$index');
        // Add users to the container
        for (int i = 0; i < 10; i++) {
          final user = UserModel(
            id: 'user_$i',
            email: 'user$i@gmail.com',
            name: 'User $i',
            bio: 'Bio for user $i',
            avatar: null,
          );
          container.read(userListProvider.notifier).addUser(user);
        }

        await pumpUserListWidget(tester, userIds: manyUserIds);

        expect(find.byType(UserWidget), findsNWidgets(10));
      });
    });

    group('Action Widget', () {
      testWidgets('shows action widgets when provided', (tester) async {
        await pumpUserListWidget(
          tester,
          userIds: testUserIds,
          actionWidget: (userId) =>
              Icon(Icons.star, key: ValueKey('action_$userId')),
        );

        expect(find.byIcon(Icons.star), findsNWidgets(3));
      });

      testWidgets('hides action widgets when not provided', (tester) async {
        await pumpUserListWidget(tester, userIds: testUserIds);

        expect(find.byIcon(Icons.star), findsNothing);
      });

      testWidgets('handles different action widgets per user', (tester) async {
        await pumpUserListWidget(
          tester,
          userIds: testUserIds,
          actionWidget: (userId) {
            switch (userId) {
              case 'user_1':
                return const Icon(Icons.star, key: ValueKey('star'));
              case 'user_2':
                return const Icon(Icons.favorite, key: ValueKey('favorite'));
              case 'user_3':
                return const Icon(Icons.bookmark, key: ValueKey('bookmark'));
              default:
                return null;
            }
          },
        );

        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsOneWidget);
        expect(find.byIcon(Icons.bookmark), findsOneWidget);
      });

      testWidgets('handles null action widget for specific users', (
        tester,
      ) async {
        await pumpUserListWidget(
          tester,
          userIds: testUserIds,
          actionWidget: (userId) {
            return userId == testUser2.id ? null : const Icon(Icons.star);
          },
        );

        expect(
          find.byIcon(Icons.star),
          findsNWidgets(2),
        ); // Only for user1 and user3
      });
    });

    group('User Interaction', () {
      testWidgets('calls onTapUser callback when first user is tapped', (
        tester,
      ) async {
        String? tappedUserId;
        bool callbackCalled = false;

        await pumpUserListWidget(
          tester,
          userIds: testUserIds,
          onTapUser: (userId) {
            tappedUserId = userId;
            callbackCalled = true;
          },
        );

        // Tap on the first user's text
        await tester.tap(find.text(testUser1.name), warnIfMissed: false);
        await tester.pump();

        expect(callbackCalled, isTrue);
        expect(tappedUserId, testUser1.id);
      });

      testWidgets('calls onTapUser callback when second user is tapped', (
        tester,
      ) async {
        String? tappedUserId;
        bool callbackCalled = false;

        await pumpUserListWidget(
          tester,
          userIds: testUserIds,
          onTapUser: (userId) {
            tappedUserId = userId;
            callbackCalled = true;
          },
        );

        // Tap on the second user's text
        await tester.tap(find.text(testUser2.name), warnIfMissed: false);
        await tester.pump();

        expect(callbackCalled, isTrue);
        expect(tappedUserId, testUser2.id);
      });

      testWidgets('calls onTapUser callback when third user is tapped', (
        tester,
      ) async {
        String? tappedUserId;
        bool callbackCalled = false;

        await pumpUserListWidget(
          tester,
          userIds: testUserIds,
          onTapUser: (userId) {
            tappedUserId = userId;
            callbackCalled = true;
          },
        );

        // Tap on the third user's text
        await tester.tap(find.text(testUser3.name), warnIfMissed: false);
        await tester.pump();

        expect(callbackCalled, isTrue);
        expect(tappedUserId, testUser3.id);
      });

      testWidgets('calls onTapUser callback when user avatar is tapped', (
        tester,
      ) async {
        String? tappedUserId;
        bool callbackCalled = false;

        await pumpUserListWidget(
          tester,
          userIds: [testUser1.id],
          onTapUser: (userId) {
            tappedUserId = userId;
            callbackCalled = true;
          },
        );

        // Tap on the user's avatar
        await tester.tap(find.byType(ZoeUserAvatarWidget), warnIfMissed: false);
        await tester.pump();

        expect(callbackCalled, isTrue);
        expect(tappedUserId, testUser1.id);
      });

      testWidgets('does not call onTapUser when callback is null', (
        tester,
      ) async {
        bool callbackCalled = false;

        await pumpUserListWidget(tester, userIds: testUserIds);

        // Try to tap a user
        await tester.tap(find.text(testUser1.name), warnIfMissed: false);
        await tester.pump();

        expect(callbackCalled, isFalse);
      });

      testWidgets('handles empty user list with callback', (tester) async {
        bool callbackCalled = false;

        await pumpUserListWidget(
          tester,
          userIds: [],
          onTapUser: (userId) {
            callbackCalled = true;
          },
        );

        expect(find.byType(UserListWidget), findsOneWidget);
        expect(find.byType(UserWidget), findsNothing);
        expect(callbackCalled, isFalse);
      });

      testWidgets('handles single user with callback', (tester) async {
        String? tappedUserId;
        bool callbackCalled = false;

        await pumpUserListWidget(
          tester,
          userIds: [testUser1.id],
          onTapUser: (userId) {
            tappedUserId = userId;
            callbackCalled = true;
          },
        );

        await tester.tap(find.text(testUser1.name), warnIfMissed: false);
        await tester.pump();

        expect(callbackCalled, isTrue);
        expect(tappedUserId, testUser1.id);
        expect(find.byType(UserWidget), findsOneWidget);
      });
    });

    group('Theme Integration', () {
      testWidgets('applies correct text style to title', (tester) async {
        await pumpUserListWidget(tester, userIds: testUserIds);

        final titleText = tester.widget<Text>(find.text('Test Users'));
        expect(titleText.style, isNotNull);
        expect(titleText.style?.fontWeight, FontWeight.w600);
      });

      testWidgets('uses theme colors', (tester) async {
        await pumpUserListWidget(tester, userIds: testUserIds);

        final containers = tester.widgetList<Container>(find.byType(Container));
        final mainContainer = containers.firstWhere(
          (c) => c.decoration != null,
          orElse: () => containers.first,
        );

        final decoration = mainContainer.decoration as BoxDecoration;
        expect(decoration.color, isNotNull);
      });

      testWidgets('applies correct icon colors', (tester) async {
        await pumpUserListWidget(tester, userIds: testUserIds);

        final peopleIcon = tester.widget<Icon>(
          find.byIcon(Icons.people_rounded),
        );
        expect(peopleIcon.color, isNotNull);
        expect(peopleIcon.size, 24);
      });

      testWidgets('applies correct close button icon size', (tester) async {
        await pumpUserListWidget(tester, userIds: testUserIds);

        final closeIcon = tester.widget<Icon>(find.byIcon(Icons.close_rounded));
        expect(closeIcon.size, 20);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles very long title', (tester) async {
        const longTitle =
            'This is a very long title that might cause overflow issues in the UI';
        await pumpUserListWidget(
          tester,
          userIds: testUserIds,
          title: longTitle,
        );

        expect(find.text(longTitle), findsOneWidget);
        expect(find.byType(UserListWidget), findsOneWidget);
      });

      testWidgets('handles special characters in title', (tester) async {
        const specialTitle = 'Users@123!@#\$%^&*()';
        await pumpUserListWidget(
          tester,
          userIds: testUserIds,
          title: specialTitle,
        );

        expect(find.text(specialTitle), findsOneWidget);
        expect(find.byType(UserListWidget), findsOneWidget);
      });

      testWidgets('handles unicode characters in title', (tester) async {
        const unicodeTitle = '用户列表🎉🚀✨';
        await pumpUserListWidget(
          tester,
          userIds: testUserIds,
          title: unicodeTitle,
        );

        expect(find.text(unicodeTitle), findsOneWidget);
        expect(find.byType(UserListWidget), findsOneWidget);
      });
    });
  });
}
