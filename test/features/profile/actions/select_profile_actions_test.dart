import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/features/profile/actions/select_profile_actions.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/mock_file.dart';
import '../../users/utils/users_utils.dart';
import '../mock_data.dart';

void main() {
  late ProviderContainer container;
  late MockImagePickerPlatform mockImagePickerPlatform;
  late MockXFile mockImageFile;
  late UserModel testUser;

  final testImageFile = File('/test/path/image.jpg');

  setUpAll(() {
    registerFallbackValue(ImageSource.camera);
    registerFallbackValue(ImagePickerOptions());
  });

  setUp(() {
    mockImagePickerPlatform = MockImagePickerPlatform();
    ImagePickerPlatform.instance = mockImagePickerPlatform;

    mockImageFile = MockXFile();
    when(() => mockImageFile.path).thenReturn(testImageFile.path);

    testUser = getUserByIndex(ProviderContainer.test());

    container = ProviderContainer.test(
      overrides: [
        currentUserProvider.overrideWithValue(AsyncValue.data(testUser)),
        userListProvider.overrideWith(() => TestUserList([testUser])),
      ],
    );

    testUser = getUserByIndex(container);
  });

  Widget buildTestWidget({
    required Widget child,
    ProviderContainer? container,
  }) {
    return UncontrolledProviderScope(
      container: container ?? ProviderContainer.test(),
      child: MaterialApp(
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        home: child,
      ),
    );
  }

  group('selectProfileFileSource', () {
    testWidgets('shows bottom sheet with camera and gallery options', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          container: container,
          child: Consumer(
            builder: (context, ref, _) {
              return TextButton(
                onPressed: () =>
                    selectProfileFileSource(context, testUser.id, ref),
                child: const Text('Select Profile'),
              );
            },
          ),
        ),
      );

      // Open bottom sheet
      await tester.tap(find.text('Select Profile'));
      await tester.pumpAndSettle();

      // Verify bottom sheet is shown with options
      expect(find.text('Take photo or video'), findsOneWidget);
      expect(find.text('Select from gallery'), findsOneWidget);
    });

    testWidgets('handles camera selection and updates user avatar', (
      tester,
    ) async {
      // Mock image picker to return our mock file
      when(
        () => mockImagePickerPlatform.getImageFromSource(
          source: ImageSource.camera,
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => mockImageFile);

      bool callbackCalled = false;
      String? selectedPath;

      await tester.pumpWidget(
        buildTestWidget(
          container: container,
          child: Consumer(
            builder: (context, ref, _) {
              return TextButton(
                onPressed: () => selectProfileFileSource(
                  context,
                  testUser.id,
                  ref,
                  onImageSelected: (path) {
                    callbackCalled = true;
                    selectedPath = path;
                  },
                ),
                child: const Text('Select Profile'),
              );
            },
          ),
        ),
      );

      // Open bottom sheet and select camera
      await tester.tap(find.text('Select Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Take photo or video'));
      await tester.pumpAndSettle();

      // Verify callback was called with correct path
      expect(callbackCalled, isTrue);
      expect(selectedPath, equals(testImageFile.path));

      // Verify user was updated
      final updatedUser = container
          .read(userListProvider)
          .firstWhere((user) => user.id == testUser.id);
      expect(updatedUser.avatar, equals(testImageFile.path));
    });

    testWidgets('handles gallery selection and updates user avatar', (
      tester,
    ) async {
      // Mock image picker to return our mock file
      when(
        () => mockImagePickerPlatform.getImageFromSource(
          source: ImageSource.gallery,
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => mockImageFile);

      bool callbackCalled = false;
      String? selectedPath;

      await tester.pumpWidget(
        buildTestWidget(
          container: container,
          child: Consumer(
            builder: (context, ref, _) {
              return TextButton(
                onPressed: () => selectProfileFileSource(
                  context,
                  testUser.id,
                  ref,
                  onImageSelected: (path) {
                    callbackCalled = true;
                    selectedPath = path;
                  },
                ),
                child: const Text('Select Profile'),
              );
            },
          ),
        ),
      );

      // Open bottom sheet and select gallery
      await tester.tap(find.text('Select Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Select from gallery'));
      await tester.pumpAndSettle();

      // Verify callback was called with correct path
      expect(callbackCalled, isTrue);
      expect(selectedPath, equals(testImageFile.path));

      // Verify user was updated
      final updatedUser = container
          .read(userListProvider)
          .firstWhere((user) => user.id == testUser.id);
      expect(updatedUser.avatar, equals(testImageFile.path));
    });

    testWidgets('handles image picker returning null', (tester) async {
      // Create a fresh user with null avatar for this test
      // Note: copyWith doesn't work for setting to null, so create new instance
      final testUserWithNullAvatar = UserModel(
        id: testUser.id,
        email: testUser.email,
        name: testUser.name,
        bio: testUser.bio,
        avatar: null, // Explicitly set to null
      );

      // Create a new container with the null-avatar user
      final testContainer = ProviderContainer.test(
        overrides: [
          currentUserProvider.overrideWithValue(
            AsyncValue.data(testUserWithNullAvatar),
          ),
          userListProvider.overrideWith(
            () => TestUserList([testUserWithNullAvatar]),
          ),
        ],
      );

      // Mock image picker to return null
      when(
        () => mockImagePickerPlatform.getImageFromSource(
          source: any(named: 'source'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => null);

      bool callbackCalled = false;

      await tester.pumpWidget(
        buildTestWidget(
          container: testContainer,
          child: Consumer(
            builder: (context, ref, _) {
              return TextButton(
                onPressed: () => selectProfileFileSource(
                  context,
                  testUserWithNullAvatar.id,
                  ref,
                  onImageSelected: (_) => callbackCalled = true,
                ),
                child: const Text('Select Profile'),
              );
            },
          ),
        ),
      );

      // Open bottom sheet and select camera
      await tester.tap(find.text('Select Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Take photo or video'));
      await tester.pumpAndSettle();

      // Verify callback was not called
      expect(callbackCalled, isFalse);

      // Verify user was not updated
      final updatedUser = testContainer
          .read(userListProvider)
          .firstWhere((user) => user.id == testUserWithNullAvatar.id);
      expect(updatedUser.avatar, isNull);

      testContainer.dispose();
    });

    testWidgets(
      'handles remove image selection and updates user avatar to null',
      (tester) async {
        // Set initial avatar
        testUser = testUser.copyWith(avatar: '/existing/avatar.jpg');
        container
            .read(userListProvider.notifier)
            .updateUser(testUser.id, testUser);

        await tester.pumpWidget(
          buildTestWidget(
            container: container,
            child: Consumer(
              builder: (context, ref, _) {
                return TextButton(
                  onPressed: () => selectProfileFileSource(
                    context,
                    testUser.id,
                    ref,
                    hasAvatar: true,
                  ),
                  child: const Text('Select Profile'),
                );
              },
            ),
          ),
        );

        // Open bottom sheet
        await tester.tap(find.text('Select Profile'));
        await tester.pumpAndSettle();

        // Verify remove option is present and select it
        // Note: The text depends on l10n, assuming 'Remove image' based on typical arb file
        // If l10n is mocked or different, this might need adjustment.
        // Using find.byIcon(Icons.delete) is safer if text varies.
        expect(find.byIcon(Icons.delete), findsOneWidget);
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        // Verify user was updated
        final updatedUser = container
            .read(userListProvider)
            .firstWhere((user) => user.id == testUser.id);
        expect(updatedUser.avatar, isNull);
      },
    );
  });
}
