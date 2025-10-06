import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/toolkit/zoe_stacked_avatars_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_avatar_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';

import '../../../test-utils/test_utils.dart';

/// Test utilities for ZoeStackedAvatars widget tests
class ZoeStackedAvatarsTestUtils {
  /// Creates a test user model
  static UserModel createTestUser({
    String id = 'test_id',
    String name = 'Test User',
    String? avatar,
    String? bio,
  }) {
    return UserModel(
      id: id,
      name: name,
      avatar: avatar,
      bio: bio,
    );
  }

  /// Creates a list of test users
  static List<UserModel> createTestUsers({
    int count = 3,
    bool withAvatars = false,
  }) {                                                                                                                                                                                                                                                                                  
    return List.generate(count, (index) {
      return createTestUser(
        id: 'user_$index',
        name: 'User $index',
        avatar: withAvatars ? 'https://example.com/avatar$index.jpg' : null,
        bio: 'Bio for user $index',
      );
    });
  }

  /// Creates a test wrapper for the ZoeStackedAvatars widget
  static ZoeStackedAvatarsWidget createTestWidget({
    List<UserModel>? users,
    int maxUsers = 3,
    double spacing = -6,
    double avatarSize = 20,
  }) {
    return ZoeStackedAvatarsWidget(
      users: users ?? createTestUsers(),
      maxUsers: maxUsers,
      spacing: spacing,
      avatarSize: avatarSize,
    );
  }
}

void main() {
  group('ZoeStackedAvatars Widget Tests -', () {
    testWidgets('renders nothing when users list is empty', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeStackedAvatarsTestUtils.createTestWidget(
          users: [],
        ),
      );

      expect(find.byType(ZoeUserAvatarWidget), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
      expect(
        tester.widget<SizedBox>(find.byType(SizedBox)).width,
        0.0,
      );
    });

    testWidgets('renders correct number of avatars within maxUsers', (tester) async {
      final users = ZoeStackedAvatarsTestUtils.createTestUsers(count: 3);
      
      await tester.pumpMaterialWidget(
        child: ZoeStackedAvatarsTestUtils.createTestWidget(
          users: users,
          maxUsers: 3,
        ),
      );

      expect(find.byType(ZoeUserAvatarWidget), findsNWidgets(3));
      expect(find.text('+0'), findsNothing);
    });

    testWidgets('shows +X indicator when users exceed maxUsers', (tester) async {
      final users = ZoeStackedAvatarsTestUtils.createTestUsers(count: 5);
      
      await tester.pumpMaterialWidget(
        child: ZoeStackedAvatarsTestUtils.createTestWidget(
          users: users,
          maxUsers: 3,
        ),
      );

      expect(find.byType(ZoeUserAvatarWidget), findsNWidgets(3));
      expect(find.text('+2'), findsOneWidget);
    });

    testWidgets('applies custom avatar size correctly', (tester) async {
      const customSize = 30.0;
      final users = ZoeStackedAvatarsTestUtils.createTestUsers(count: 1);
      
      await tester.pumpMaterialWidget(
        child: ZoeStackedAvatarsTestUtils.createTestWidget(
          users: users,
          avatarSize: customSize,
        ),
      );

      final container = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(Positioned),
          matching: find.byType(SizedBox),
        ),
      );
      expect(container.width, customSize);
      expect(container.height, customSize);
    });

    testWidgets('calculates total width correctly', (tester) async {
      const avatarSize = 20.0;
      const spacing = -6.0;
      final users = ZoeStackedAvatarsTestUtils.createTestUsers(count: 3);
      
      await tester.pumpMaterialWidget(
        child: ZoeStackedAvatarsTestUtils.createTestWidget(
          users: users,
          avatarSize: avatarSize,
          spacing: spacing,
        ),
      );

      final container = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(ZoeStackedAvatarsWidget),
          matching: find.byType(SizedBox),
        ).first,
      );

      // Width = _getPosition(displayCount)
      // _getPosition(index) = index * (avatarSize + spacing)
      final expectedWidth = 3 * (avatarSize + spacing);
      expect(container.width, expectedWidth);
    });

    testWidgets('calculates width with remaining count indicator correctly', (tester) async {
      const avatarSize = 20.0;
      const spacing = -6.0;
      final users = ZoeStackedAvatarsTestUtils.createTestUsers(count: 5);
      
      await tester.pumpMaterialWidget(
        child: ZoeStackedAvatarsTestUtils.createTestWidget(
          users: users,
          maxUsers: 3,
          avatarSize: avatarSize,
          spacing: spacing,
        ),
      );

      final container = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(ZoeStackedAvatarsWidget),
          matching: find.byType(SizedBox),
        ).first,
      );

      // Width = _getPosition(displayCount) + avatarSize + 5
      // _getPosition(index) = index * (avatarSize + spacing)
      final expectedWidth = 3 * (avatarSize + spacing) + avatarSize + 5;
      expect(container.width, expectedWidth);
    });

    testWidgets('positions avatars correctly', (tester) async {
      const avatarSize = 20.0;
      const spacing = -6.0;
      final users = ZoeStackedAvatarsTestUtils.createTestUsers(count: 3);
      
      await tester.pumpMaterialWidget(
        child: ZoeStackedAvatarsTestUtils.createTestWidget(
          users: users,
          avatarSize: avatarSize,
          spacing: spacing,
        ),
      );

      final positions = tester.widgetList<Positioned>(
        find.descendant(
          of: find.byType(Stack),
          matching: find.byType(Positioned),
        ),
      );
      var index = 0;
      for (final pos in positions) {
        expect(pos.left, index * (avatarSize + spacing));
        index++;
      }
    });
  });
}