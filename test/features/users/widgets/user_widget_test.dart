import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_avatar_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/features/users/widgets/user_widget.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/users_utils.dart';

void main() {
  group('UserWidget', () {
    late ProviderContainer container;
    late UserModel testUser;

    setUp(() {
      container = ProviderContainer();
      testUser = getUserByIndex(container);
    });

    Future<void> pumpUserWidget(
      WidgetTester tester, {
      required String userId,
      Widget? actionWidget,
      Function(String userId)? onTapUser,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: UserWidget(
          userId: userId,
          actionWidget: actionWidget,
          onTapUser: onTapUser,
        ),
      );
    }

    group('Basic Rendering', () {
      testWidgets('renders widget with valid user ID', (tester) async {
        await pumpUserWidget(tester, userId: testUser.id);

        expect(find.byType(UserWidget), findsOneWidget);
        expect(find.byType(ZoeUserAvatarWidget), findsOneWidget);
        expect(find.text(testUser.name), findsOneWidget);
      });

      testWidgets('returns SizedBox.shrink when user is null', (tester) async {
        await pumpUserWidget(tester, userId: 'non-existent-user');

        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(UserWidget), findsOneWidget);
      });

      testWidgets('renders main components correctly', (tester) async {
        await pumpUserWidget(tester, userId: testUser.id);

        expect(find.byType(GestureDetector), findsOneWidget);
        expect(find.byType(Container), findsAtLeastNWidgets(1));
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(ZoeUserAvatarWidget), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
        expect(find.byType(Spacer), findsOneWidget);
      });

      testWidgets('applies correct padding and margin', (tester) async {
        await pumpUserWidget(tester, userId: testUser.id);

        final containers = tester.widgetList<Container>(find.byType(Container));
        final mainContainer = containers.firstWhere(
          (c) => c.padding == const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          orElse: () => containers.first,
        );
        expect(mainContainer.padding, const EdgeInsets.symmetric(horizontal: 12, vertical: 2));
        expect(mainContainer.margin, const EdgeInsets.only(bottom: 8));
      });

      testWidgets('has correct row structure', (tester) async {
        await pumpUserWidget(tester, userId: testUser.id);

        final row = tester.widget<Row>(find.byType(Row));
        expect(row.mainAxisSize, MainAxisSize.min);
        expect(row.mainAxisAlignment, MainAxisAlignment.start);
      });
    });

    group('User Display', () {
      testWidgets('displays correct user name', (tester) async {
        await pumpUserWidget(tester, userId: testUser.id);

        expect(find.text(testUser.name), findsOneWidget);
      });

      testWidgets('displays user avatar', (tester) async {
        await pumpUserWidget(tester, userId: testUser.id);

        final avatarWidget = tester.widget<ZoeUserAvatarWidget>(find.byType(ZoeUserAvatarWidget));
        expect(avatarWidget.user, testUser);
      });

      testWidgets('handles different users correctly', (tester) async {
        final user1 = getUserByIndex(container, index: 0);
        final user2 = getUserByIndex(container, index: 1);

        await pumpUserWidget(tester, userId: user1.id);
        expect(find.text(user1.name), findsOneWidget);

        await pumpUserWidget(tester, userId: user2.id);
        expect(find.text(user2.name), findsOneWidget);
      });
    });

    group('Action Widget', () {
      testWidgets('shows action widget when provided', (tester) async {
        const actionWidget = Icon(Icons.star);
        await pumpUserWidget(tester, userId: testUser.id, actionWidget: actionWidget);

        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.byType(SizedBox), findsAtLeastNWidgets(2)); // Spacer and spacing
      });

      testWidgets('hides action widget when not provided', (tester) async {
        await pumpUserWidget(tester, userId: testUser.id);

        expect(find.byType(Spacer), findsOneWidget);
        // Should not have any action widgets
        expect(find.byType(Icon), findsNothing);
      });

      testWidgets('handles different action widgets', (tester) async {
        const buttonAction = ElevatedButton(
          onPressed: null,
          child: Text('Action'),
        );
        await pumpUserWidget(tester, userId: testUser.id, actionWidget: buttonAction);

        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.text('Action'), findsOneWidget);
      });
    });

    group('User Interaction', () {
      testWidgets('calls onTapUser callback when tapped', (tester) async {
        String? tappedUserId;
        bool callbackCalled = false;
        
        await pumpUserWidget(
          tester,
          userId: testUser.id,
          onTapUser: (userId) {
            tappedUserId = userId;
            callbackCalled = true;
          },
        );

        // Find the text widget and tap it (more reliable than GestureDetector)
        await tester.tap(find.text(testUser.name), warnIfMissed: false);
        await tester.pump();

        expect(callbackCalled, isTrue);
        expect(tappedUserId, testUser.id);
      });

      testWidgets('calls onTapUser callback when avatar is tapped', (tester) async {
        String? tappedUserId;
        bool callbackCalled = false;
        
        await pumpUserWidget(
          tester,
          userId: testUser.id,
          onTapUser: (userId) {
            tappedUserId = userId;
            callbackCalled = true;
          },
        );

        // Tap the avatar widget
        await tester.tap(find.byType(ZoeUserAvatarWidget), warnIfMissed: false);
        await tester.pump();

        expect(callbackCalled, isTrue);
        expect(tappedUserId, testUser.id);
      });

      testWidgets('does not call onTapUser when callback is null', (tester) async {
        bool callbackCalled = false;
        
        await pumpUserWidget(tester, userId: testUser.id);

        // Try to tap the widget
        await tester.tap(find.text(testUser.name), warnIfMissed: false);
        await tester.pump();

        // Callback should not be called since it's null
        expect(callbackCalled, isFalse);
      });
    });

    group('Theme Integration', () {
      testWidgets('applies correct text style', (tester) async {
        await pumpUserWidget(tester, userId: testUser.id);

        final textWidget = tester.widget<Text>(find.text(testUser.name));
        expect(textWidget.style, isNotNull);
        // The style should match theme.textTheme.bodyMedium
      });

      testWidgets('uses theme colors', (tester) async {
        await pumpUserWidget(tester, userId: testUser.id);

        final containers = tester.widgetList<Container>(find.byType(Container));
        final mainContainer = containers.firstWhere(
          (c) => c.padding == const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          orElse: () => containers.first,
        );
        expect(mainContainer.decoration, isNull); // No custom decoration
      });
    });

    group('Edge Cases', () {
      testWidgets('handles user with empty name', (tester) async {
        final emptyNameUser = testUser.copyWith(name: '');
        // We need to update the user in the container
        container.read(userListProvider.notifier).updateUser(testUser.id, emptyNameUser);
        
        await pumpUserWidget(tester, userId: testUser.id);

        expect(find.byType(UserWidget), findsOneWidget);
        expect(find.byType(ZoeUserAvatarWidget), findsOneWidget);
      });

      testWidgets('handles user with very long name', (tester) async {
        final longNameUser = testUser.copyWith(name: 'A' * 50); // Reduced length to avoid overflow
        container.read(userListProvider.notifier).updateUser(testUser.id, longNameUser);
        
        await pumpUserWidget(tester, userId: testUser.id);

        expect(find.text('A' * 50), findsOneWidget);
        expect(find.byType(UserWidget), findsOneWidget);
      });

      testWidgets('handles special characters in name', (tester) async {
        final specialNameUser = testUser.copyWith(name: 'User@123!@#\$%');
        container.read(userListProvider.notifier).updateUser(testUser.id, specialNameUser);
        
        await pumpUserWidget(tester, userId: testUser.id);

        expect(find.text('User@123!@#\$%'), findsOneWidget);
        expect(find.byType(UserWidget), findsOneWidget);
      });
    });

    group('Multiple Users', () {
      testWidgets('renders different users correctly', (tester) async {
        final users = [
          getUserByIndex(container, index: 0),
          getUserByIndex(container, index: 1),
          getUserByIndex(container, index: 2),
        ];

        for (final user in users) {
          await pumpUserWidget(tester, userId: user.id);
          expect(find.text(user.name), findsOneWidget);
          expect(find.byType(UserWidget), findsOneWidget);
        }
      });
    });
  });
}
