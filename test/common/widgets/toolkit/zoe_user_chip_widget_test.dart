import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/models/user_chip_type.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_avatar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_chip_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';

import '../../../test-utils/test_utils.dart';

/// Test utilities for ZoeUserChip widget tests
class ZoeUserChipTestUtils {
  /// Creates a test user model
  static UserModel createTestUser({
    String id = 'test_id',
    String name = 'Test User',
    String? avatar,
  }) {
    return UserModel(
      id: id,
      name: name,
      avatar: avatar,
    );
  }

  /// Creates a test wrapper for the ZoeUserChip widget
  static ZoeUserChipWidget createTestWidget({
    UserModel? user,
    VoidCallback? onRemove,
    ZoeUserChipType type = ZoeUserChipType.userNameChip,
  }) {
    return ZoeUserChipWidget(
      user: user ?? createTestUser(),
      onRemove: onRemove,
      type: type,
    );
  }
}

void main() {
  group('ZoeUserChip Widget Tests -', () {
    testWidgets('renders user name chip correctly', (tester) async {
      final user = ZoeUserChipTestUtils.createTestUser(
        name: 'John Doe',
      );

      await tester.pumpMaterialWidget(
        child: ZoeUserChipTestUtils.createTestWidget(
          user: user,
          type: ZoeUserChipType.userNameChip,
        ),
      );

      // Verify text is rendered
      expect(find.text('John Doe'), findsOneWidget);

      // Verify avatar is not rendered
      expect(find.byType(ZoeUserAvatarWidget), findsNothing);

      // Verify remove button is not rendered
      expect(find.byType(IconButton), findsNothing);

      // Verify chip style
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(6));
      expect(container.padding, const EdgeInsets.symmetric(horizontal: 5, vertical: 2));
      expect(container.margin, const EdgeInsets.only(right: 4));
    });

    testWidgets('renders user name with avatar chip correctly', (tester) async {
      final user = ZoeUserChipTestUtils.createTestUser(
        name: 'John Doe',
      );

      await tester.pumpMaterialWidget(
        child: ZoeUserChipTestUtils.createTestWidget(
          user: user,
          type: ZoeUserChipType.userNameWithAvatarChip,
        ),
      );

      // Verify text and avatar are rendered
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.byType(ZoeUserAvatarWidget), findsOneWidget);

      // Verify remove button is not rendered
      expect(find.byType(IconButton), findsNothing);

      // Verify chip style
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(20));
      expect(container.padding, const EdgeInsets.symmetric(horizontal: 5, vertical: 4));
      expect(container.margin, isNull);
    });

    testWidgets('shows remove button when onRemove provided', (tester) async {
      bool wasRemoved = false;
      await tester.pumpMaterialWidget(
        child: ZoeUserChipTestUtils.createTestWidget(
          type: ZoeUserChipType.userNameWithAvatarChip,
          onRemove: () => wasRemoved = true,
        ),
      );

      // Verify remove button is rendered
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      // Verify button style
      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.padding, EdgeInsets.zero);
      expect(iconButton.constraints, const BoxConstraints(minWidth: 20, minHeight: 20));
      expect(iconButton.visualDensity, VisualDensity.compact);

      // Verify icon style
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 14);

      // Verify callback
      await tester.tap(find.byType(IconButton));
      expect(wasRemoved, isTrue);
    });

    testWidgets('applies correct colors based on user name', (tester) async {
      final user = ZoeUserChipTestUtils.createTestUser(
        name: 'John Doe',
      );

      await tester.pumpMaterialWidget(
        child: ZoeUserChipTestUtils.createTestWidget(
          user: user,
          type: ZoeUserChipType.userNameChip,
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      final expectedColor = CommonUtils().getRandomColorFromName(user.name);

      // Verify background color
      expect(decoration.color, equals(expectedColor.withValues(alpha: 0.1)));

      // Verify border color
      expect(
        (decoration.border as Border).top.color,
        equals(expectedColor.withValues(alpha: 0.3)),
      );

      // Verify text color
      final text = tester.widget<Text>(find.text('John Doe'));
      expect(text.style?.color, equals(expectedColor));
    });

    testWidgets('applies correct text style', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeUserChipTestUtils.createTestWidget(),
      );

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontSize, 12);
    });

    testWidgets('adds spacing between avatar and text', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeUserChipTestUtils.createTestWidget(
          type: ZoeUserChipType.userNameWithAvatarChip,
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == 8,
        ),
        findsOneWidget,
      );
    });
  });
}
