import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_avatar_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';

import '../../../helpers/test_utils.dart';

/// Test utilities for ZoeUserAvatar widget tests
class ZoeUserAvatarTestUtils {
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

  /// Creates a test wrapper for the ZoeUserAvatar widget
  static ZoeUserAvatarWidget createTestWidget({
    UserModel? user,
    double? size,
    double? fontSize,
    String? selectedImagePath,
  }) {
    return ZoeUserAvatarWidget(
      user: user ?? createTestUser(),
      size: size,
      fontSize: fontSize,
      selectedImagePath: selectedImagePath,
    );
  }
}

void main() {
  group('ZoeUserAvatar Widget Tests -', () {
    testWidgets('renders placeholder with first letter when no avatar', (tester) async {
      final user = ZoeUserAvatarTestUtils.createTestUser(
        name: 'John Doe',
      );

      await tester.pumpMaterialWidget(
        child: ZoeUserAvatarTestUtils.createTestWidget(
          user: user,
        ),
      );

      expect(find.text('J'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('renders question mark when name is empty', (tester) async {
      final user = ZoeUserAvatarTestUtils.createTestUser(
        name: '',
      );

      await tester.pumpMaterialWidget(
        child: ZoeUserAvatarTestUtils.createTestWidget(
          user: user,
        ),
      );

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('applies custom size correctly', (tester) async {
      const customSize = 48.0;
      await tester.pumpMaterialWidget(
        child: ZoeUserAvatarTestUtils.createTestWidget(
          size: customSize,
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
      
      final constraints = tester.getSize(find.byType(Container).first);
      expect(constraints.width, customSize);
      expect(constraints.height, customSize);
    });

    testWidgets('applies custom font size correctly', (tester) async {
      const customFontSize = 24.0;
      await tester.pumpMaterialWidget(
        child: ZoeUserAvatarTestUtils.createTestWidget(
          fontSize: customFontSize,
        ),
      );

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontSize, customFontSize);
    });

    testWidgets('renders network image when avatar URL provided', (tester) async {
      final user = ZoeUserAvatarTestUtils.createTestUser(
        avatar: 'https://example.com/avatar.jpg',
      );

      await tester.pumpMaterialWidget(
        child: ZoeUserAvatarTestUtils.createTestWidget(
          user: user,
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<NetworkImage>());
    });

    testWidgets('renders file image when local path provided', (tester) async {
      final user = ZoeUserAvatarTestUtils.createTestUser(
        avatar: '/path/to/avatar.jpg',
      );

      await tester.pumpMaterialWidget(
        child: ZoeUserAvatarTestUtils.createTestWidget(
          user: user,
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<FileImage>());
    });

    testWidgets('shows error icon when network image fails to load', (tester) async {
      final user = ZoeUserAvatarTestUtils.createTestUser(
        avatar: 'https://example.com/invalid.jpg',
      );

      await tester.pumpMaterialWidget(
        child: ZoeUserAvatarTestUtils.createTestWidget(
          user: user,
        ),
      );

      // Trigger error callback
      final errorBuilder = tester.widget<Image>(find.byType(Image)).errorBuilder!;
      final errorWidget = errorBuilder(
        tester.element(find.byType(Image)),
        Error(),
        StackTrace.empty,
      );

      // Pump the error widget
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: errorWidget),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows error icon when file image fails to load', (tester) async {
      final user = ZoeUserAvatarTestUtils.createTestUser(
        avatar: '/invalid/path.jpg',
      );

      await tester.pumpMaterialWidget(
        child: ZoeUserAvatarTestUtils.createTestWidget(
          user: user,
        ),
      );

      // Trigger error callback
      final errorBuilder = tester.widget<Image>(find.byType(Image)).errorBuilder!;
      final errorWidget = errorBuilder(
        tester.element(find.byType(Image)),
        Error(),
        StackTrace.empty,
      );

      // Pump the error widget
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: errorWidget),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('uses selected image path over user avatar', (tester) async {
      final user = ZoeUserAvatarTestUtils.createTestUser(
        avatar: 'https://example.com/avatar.jpg',
      );

      await tester.pumpMaterialWidget(
        child: ZoeUserAvatarTestUtils.createTestWidget(
          user: user,
          selectedImagePath: '/path/to/selected.jpg',
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<FileImage>());
    });

    testWidgets('applies correct placeholder colors', (tester) async {
      final user = ZoeUserAvatarTestUtils.createTestUser(
        name: 'Test User',
      );

      await tester.pumpMaterialWidget(
        child: ZoeUserAvatarTestUtils.createTestWidget(
          user: user,
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      final expectedColor = CommonUtils().getRandomColorFromName(user.name);

      expect(decoration.color, equals(expectedColor.withValues(alpha: 0.2)));
      expect(
        (decoration.border as Border).top.color,
        equals(expectedColor),
      );

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.color, equals(expectedColor));
    });

    testWidgets('clips avatar image to circle', (tester) async {
      final user = ZoeUserAvatarTestUtils.createTestUser(
        avatar: 'https://example.com/avatar.jpg',
      );

      await tester.pumpMaterialWidget(
        child: ZoeUserAvatarTestUtils.createTestWidget(
          user: user,
        ),
      );

      expect(find.byType(ClipOval), findsOneWidget);
    });
  });
}