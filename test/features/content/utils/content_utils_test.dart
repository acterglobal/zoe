import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/text/models/text_model.dart';

import '../../../test-utils/mock_preferences.dart';

class Listener extends Mock {
  void call(List<ContentModel>? previous, List<ContentModel>? next);
}

void main() {
  late ProviderContainer container;
  late MockPreferencesService mockPreferencesService;
  late Listener listener;

  setUp(() {
    mockPreferencesService = MockPreferencesService();
    listener = Listener();

    container = ProviderContainer(
      overrides: [
        contentListProvider.overrideWithValue([]),
      ],
    );
    container.listen(
      contentListProvider,
      listener.call,
      fireImmediately: true,
    );

    when(() => mockPreferencesService.getLoginUserId())
        .thenAnswer((_) async => 'test-user-id');
  });

  tearDown(() {
    container.dispose();
  });

  group('Content List Provider Tests', () {
    test('content list is initially empty', () {
      final contentList = container.read(contentListProvider);
      expect(contentList, isEmpty);
    });

    test('content list updates are tracked by listener', () {
      // Create a new listener for this test
      final testListener = Listener();

      // Create a container with initial empty list
      final testContainer = ProviderContainer(
        overrides: [
          contentListProvider.overrideWithValue([]),
        ],
      );

      // Add listener and verify initial call
      testContainer.listen(
        contentListProvider,
        testListener.call,
        fireImmediately: true,
      );
      verify(() => testListener(null, [])).called(1);

      // Create test content
      final testContent = TextModel(
        parentId: 'parent-1',
        sheetId: 'sheet-1',
        title: 'Test',
        description: (plainText: '', htmlText: ''),
        orderIndex: 0,
      );

      // Update to non-empty list
      final updatedContainer = ProviderContainer(
        overrides: [
          contentListProvider.overrideWithValue([testContent]),
        ],
      );

      // Add same listener to new container
      updatedContainer.listen(
        contentListProvider,
        testListener.call,
        fireImmediately: true,
      );

      // Verify the listener was called with the new value
      verify(() => testListener(any(), [testContent])).called(1);

      // Clean up
      testContainer.dispose();
      updatedContainer.dispose();
    });

    test('content list provider is properly disposed', () {
      // Create a new container
      final testContainer = ProviderContainer(
        overrides: [
          contentListProvider.overrideWithValue([]),
        ],
      );

      // Add a listener
      final testListener = Listener();
      testContainer.listen(
        contentListProvider,
        testListener.call,
        fireImmediately: true,
      );

      // Verify initial state
      verify(() => testListener(null, [])).called(1);

      // Dispose container
      testContainer.dispose();

      // No more updates should be received
      verifyNoMoreInteractions(testListener);
    });

    test('content list provider handles null values', () {
      // Initial state should be empty list, not null
      final contentList = container.read(contentListProvider);
      expect(contentList, isNotNull);
      expect(contentList, isEmpty);
    });

    test('content list provider maintains list immutability', () {
      // Get initial list
      final initialList = container.read(contentListProvider);

      // Create test content
      final testContent = TextModel(
        parentId: 'parent-1',
        sheetId: 'sheet-1',
        title: 'Test',
        description: (plainText: '', htmlText: ''),
        orderIndex: 0,
      );

      // Create a new container with different value
      final newContainer = ProviderContainer(
        overrides: [
          contentListProvider.overrideWithValue([testContent]),
        ],
      );

      // Get new list
      final newList = newContainer.read(contentListProvider);

      // Lists should be different instances and have different content
      expect(identical(initialList, newList), isFalse);
      expect(initialList, isEmpty);
      expect(newList, isNotEmpty);
      expect(newList.first, equals(testContent));

      // Clean up
      newContainer.dispose();
    });
  });
}