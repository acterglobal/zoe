import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/state_widgets/error_state_widget.dart';
import 'package:zoe/common/widgets/state_widgets/loading_state_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_avatar_widget.dart';
import 'package:zoe/features/profile/screens/edit_profile_screen.dart';
import 'package:zoe/features/profile/widgets/profile_user_bio_widget.dart';
import 'package:zoe/features/profile/widgets/profile_user_name_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../helpers/test_utils.dart';

class TestUserList extends UserList {
  final List<UserModel> initialUsers;

  TestUserList(this.initialUsers);

  @override
  List<UserModel> build() => initialUsers;
}

void main() {
  late ProviderContainer container;
  final testUser = UserModel(
    id: 'test-id',
    name: 'Test User',
    bio: 'Test Bio',
  );
  late List<UserModel> users;

  setUp(() {
    users = [testUser];
    container = ProviderContainer(
      overrides: [
        currentUserProvider.overrideWithValue(AsyncValue.data(testUser)),
        userListProvider.overrideWith(() => TestUserList(users)),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpMaterialWidgetWithProviderScope(
      child: const EditProfileScreen(),
      container: container,
    );
    // Wait for post-frame callbacks and animations
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  group('Loading and Error States', () {
    testWidgets('shows loading state', (tester) async {
      container = ProviderContainer(
        overrides: [
          currentUserProvider.overrideWithValue(const AsyncValue.loading()),
          userListProvider.overrideWithValue([]),
        ],
      );

      await pumpScreen(tester);
      expect(find.byType(LoadingStateWidget), findsOneWidget);
    });

    testWidgets('shows error state', (tester) async {
      container = ProviderContainer(
        overrides: [
          currentUserProvider.overrideWithValue(
            AsyncValue.error('Test Error', StackTrace.empty),
          ),
          userListProvider.overrideWithValue([]),
        ],
      );

      await pumpScreen(tester);
      expect(find.byType(ErrorStateWidget), findsOneWidget);
    });

    testWidgets('shows user not found message when user is null', (tester) async {
      container = ProviderContainer(
        overrides: [
          currentUserProvider.overrideWithValue(const AsyncValue.data(null)),
          userListProvider.overrideWithValue([]),
        ],
      );

      await pumpScreen(tester);
      expect(
        find.text(L10n.of(tester.element(find.byType(EditProfileScreen))).userNotFound),
        findsOneWidget,
      );
    });
  });

  group('Profile Content', () {
    testWidgets('displays user avatar', (tester) async {
      await pumpScreen(tester);
      expect(find.byType(ZoeUserAvatarWidget), findsOneWidget);
    });

    testWidgets('displays name and bio fields', (tester) async {
      await pumpScreen(tester);
      expect(find.byType(ProfileUserNameWidget), findsOneWidget);
      expect(find.byType(ProfileUserBioWidget), findsOneWidget);
    });

    testWidgets('initializes fields with user data', (tester) async {
      await pumpScreen(tester);
      
      // Wait for post-frame callback
      await tester.pump();

      final nameField = tester.widget<TextField>(
        find.descendant(
          of: find.byType(ProfileUserNameWidget),
          matching: find.byType(TextField),
        ),
      );
      expect(nameField.controller?.text, equals(testUser.name));

      final bioField = tester.widget<TextField>(
        find.descendant(
          of: find.byType(ProfileUserBioWidget),
          matching: find.byType(TextField),
        ),
      );
      expect(bioField.controller?.text, equals(testUser.bio));
    });
  });

  group('Save Functionality', () {
    testWidgets('validates empty name', (tester) async {
      await pumpScreen(tester);

      // Clear name field
      await tester.enterText(
        find.descendant(
          of: find.byType(ProfileUserNameWidget),
          matching: find.byType(TextField),
        ),
        '',
      );
      await tester.pump();

      // Try to save
      await tester.tap(find.byType(ZoePrimaryButton));
      await tester.pump();

      // Should still be on the same screen (not popped)
      expect(find.byType(EditProfileScreen), findsOneWidget);
    });

    testWidgets('saves valid changes', (tester) async {
      await pumpScreen(tester);

      const newName = 'New Name';
      const newBio = 'New Bio';

      // Update fields
      await tester.enterText(
        find.descendant(
          of: find.byType(ProfileUserNameWidget),
          matching: find.byType(TextField),
        ),
        newName,
      );
      await tester.pump();

      await tester.enterText(
        find.descendant(
          of: find.byType(ProfileUserBioWidget),
          matching: find.byType(TextField),
        ),
        newBio,
      );
      await tester.pump();

      // Save changes
      await tester.tap(find.byType(ZoePrimaryButton));
      await tester.pumpAndSettle();

      // Verify navigation occurred
      expect(find.byType(EditProfileScreen), findsNothing);
    });
  });

  group('UI Elements', () {
    testWidgets('shows camera and QR code buttons', (tester) async {
      await pumpScreen(tester);
      
      // Check for camera button
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      
      // Check for QR code button in app bar
      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
    });
  });
}