import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/whatsapp/utils/image_utils.dart';

void main() {
  group('ImageUtils - Static Constants', () {
    const basePath = 'assets/images/whatsapp';

    test('invite member image paths are correct', () {
      expect(ImageUtils.inviteMemberAndroidDark,
          '$basePath/invite_member_android_dark.png');
      expect(ImageUtils.inviteMemberAndroidLight,
          '$basePath/invite_member_android_light.png');
      expect(ImageUtils.inviteMemberIosDark,
          '$basePath/invite_member_ios_dark.png');
      expect(ImageUtils.inviteMemberIosLight,
          '$basePath/invite_member_ios_light.png');
    });

    test('copy link image paths are correct', () {
      expect(ImageUtils.copyLinkAndroidDark,
          '$basePath/copy_link_android_dark.png');
      expect(ImageUtils.copyLinkAndroidLight,
          '$basePath/copy_link_android_light.png');
      expect(ImageUtils.copyLinkIosDark, '$basePath/copy_link_ios_dark.png');
      expect(ImageUtils.copyLinkIosLight, '$basePath/copy_link_ios_light.png');
    });

    test('permission image paths are correct', () {
      expect(ImageUtils.permissionAndroidDark,
          '$basePath/permission_android_dark.png');
      expect(ImageUtils.permissionAndroidLight,
          '$basePath/permission_android_light.png');
      expect(ImageUtils.permissionIosDark, '$basePath/permission_ios_dark.png');
      expect(ImageUtils.permissionIosLight, '$basePath/permission_ios_light.png');
    });

    test('invite link image paths are correct', () {
      expect(ImageUtils.inviteLinkAndroidDark,
          '$basePath/invite_link_android_dark.png');
      expect(ImageUtils.inviteLinkAndroidLight,
          '$basePath/invite_link_android_light.png');
      expect(ImageUtils.inviteLinkIosDark, '$basePath/invite_link_ios_dark.png');
      expect(ImageUtils.inviteLinkIosLight,
          '$basePath/invite_link_ios_light.png');
    });
  });

  group('ImageUtils - Dynamic Methods', () {
    testWidgets('getInviteMemberImagePath returns correct paths',
        (WidgetTester tester) async {
      // Test dark theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Builder(
            builder: (context) {
              return Text(ImageUtils.getInviteMemberImagePath(context));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(ImageUtils.inviteMemberIosDark), findsOneWidget);

      // Test light theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Builder(
            builder: (context) {
              return Text(ImageUtils.getInviteMemberImagePath(context));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(ImageUtils.inviteMemberIosLight), findsOneWidget);
    });

    testWidgets('getCopyLinkImagePath returns correct paths',
        (WidgetTester tester) async {
      // Test dark theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Builder(
            builder: (context) {
              return Text(ImageUtils.getCopyLinkImagePath(context));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(ImageUtils.copyLinkIosDark), findsOneWidget);

      // Test light theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Builder(
            builder: (context) {
              return Text(ImageUtils.getCopyLinkImagePath(context));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(ImageUtils.copyLinkIosLight), findsOneWidget);
    });

    testWidgets('getGroupPermissionImagePath returns correct paths',
        (WidgetTester tester) async {
      // Test dark theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Builder(
            builder: (context) {
              return Text(ImageUtils.getGroupPermissionImagePath(context));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(ImageUtils.permissionIosDark), findsOneWidget);

      // Test light theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Builder(
            builder: (context) {
              return Text(ImageUtils.getGroupPermissionImagePath(context));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(ImageUtils.permissionIosLight), findsOneWidget);
    });

    testWidgets('getInviteLinkImagePath returns correct paths',
        (WidgetTester tester) async {
      // Test dark theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Builder(
            builder: (context) {
              return Text(ImageUtils.getInviteLinkImagePath(context));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(ImageUtils.inviteLinkIosDark), findsOneWidget);

      // Test light theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Builder(
            builder: (context) {
              return Text(ImageUtils.getInviteLinkImagePath(context));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(ImageUtils.inviteLinkIosLight), findsOneWidget);
    });
  });
}