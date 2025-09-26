import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/features/profile/actions/select_profile_actions.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class MockImagePicker extends Mock implements ImagePicker {}
class MockXFile extends Mock implements XFile {}

void main() {
  late ProviderContainer container;
  late MockImagePicker mockImagePicker;
  late MockXFile mockImageFile;
  late UserModel testUser;

  setUpAll(() {
    registerFallbackValue(ImageSource.camera);
  });

  setUp(() {
    mockImagePicker = MockImagePicker();
    mockImageFile = MockXFile();
    when(() => mockImageFile.path).thenReturn('/test/path/image.jpg');

    testUser = UserModel(
      id: 'test-id',
      name: 'Test User',
      bio: 'Test Bio',
    );

    container = ProviderContainer(
      overrides: [
        currentUserProvider.overrideWithValue(AsyncValue.data(testUser)),
        userListProvider.overrideWith(() => TestUserList([testUser])),
        imagePickerProvider.overrideWithValue(mockImagePicker),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  Widget buildTestWidget({
    required Widget child,
    ProviderContainer? container,
  }) {
    return UncontrolledProviderScope(
      container: container ?? ProviderContainer(),
      child: MaterialApp(
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        home: child,
      ),
    );
  }

  group('selectProfileFileSource', () {
    testWidgets('shows bottom sheet with camera and gallery options',
        (tester) async {
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

      // Verify bottom sheet is shown with options
      expect(find.text('Take photo or video'), findsOneWidget);
      expect(find.text('Select from gallery'), findsOneWidget);
    });

    testWidgets('handles camera selection and updates user avatar',
        (tester) async {
      // Mock image picker to return our mock file
      when(
        () => mockImagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: any(named: 'imageQuality'),
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
      expect(selectedPath, equals('/test/path/image.jpg'));

      // Verify user was updated
      final updatedUser = container
          .read(userListProvider)
          .firstWhere((user) => user.id == testUser.id);
      expect(updatedUser.avatar, equals('/test/path/image.jpg'));
    });

    testWidgets('handles gallery selection and updates user avatar',
        (tester) async {
      // Mock image picker to return our mock file
      when(
        () => mockImagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: any(named: 'imageQuality'),
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
      expect(selectedPath, equals('/test/path/image.jpg'));

      // Verify user was updated
      final updatedUser = container
          .read(userListProvider)
          .firstWhere((user) => user.id == testUser.id);
      expect(updatedUser.avatar, equals('/test/path/image.jpg'));
    });

    testWidgets('handles image picker returning null', (tester) async {
      // Mock image picker to return null
      when(
        () => mockImagePicker.pickImage(
          source: any(named: 'source'),
          imageQuality: any(named: 'imageQuality'),
        ),
      ).thenAnswer((_) async => null);

      bool callbackCalled = false;

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
      final updatedUser = container
          .read(userListProvider)
          .firstWhere((user) => user.id == testUser.id);
      expect(updatedUser.avatar, isNull);
    });

    testWidgets('handles null current user', (tester) async {
      // Override container with null current user
      container = ProviderContainer(
        overrides: [
          currentUserProvider.overrideWithValue(const AsyncValue.data(null)),
          userListProvider.overrideWith(() => TestUserList([testUser])),
          imagePickerProvider.overrideWithValue(mockImagePicker),
        ],
      );

      // Mock image picker to return our mock file
      when(
        () => mockImagePicker.pickImage(
          source: any(named: 'source'),
          imageQuality: any(named: 'imageQuality'),
        ),
      ).thenAnswer((_) async => mockImageFile);

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

      // Verify user list was not modified
      final users = container.read(userListProvider);
      expect(users.length, equals(1));
      expect(users.first.avatar, isNull);
    });
  });
}

class TestUserList extends UserList {
  final List<UserModel> initialUsers;

  TestUserList(this.initialUsers);

  @override
  List<UserModel> build() => initialUsers;
}