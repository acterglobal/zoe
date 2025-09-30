import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/list/providers/list_providers.dart';

/// Test utilities for content provider tests
class ContentTestUtils {
  /// Creates a test text model with default values
  static TextModel createTestText({
    String parentId = 'parent1',
    String sheetId = 'sheet1',
    String title = 'Text 1',
    String plainText = '',
    String htmlText = '',
    int orderIndex = 0,
    DateTime? createdAt,
  }) {
    return TextModel(
      parentId: parentId,
      sheetId: sheetId,
      title: title,
      description: (plainText: plainText, htmlText: htmlText),
      orderIndex: orderIndex,
      createdAt: createdAt,
    );
  }

  /// Creates a provider container with given text models and empty other providers
  static ProviderContainer createContainer({List<TextModel> texts = const []}) {
    return ProviderContainer(
      overrides: [
        textListProvider.overrideWithValue(texts),
        eventListProvider.overrideWithValue([]),
        listsProvider.overrideWithValue([]),
        bulletListProvider.overrideWithValue([]),
        taskListProvider.overrideWithValue([]),
        linkListProvider.overrideWithValue([]),
        pollListProvider.overrideWithValue([]),
        documentListProvider.overrideWithValue([]),
      ],
    );
  }
}

void main() {
  group('ContentList Provider Tests', () {
    test('combines content from all providers', () {
      final container = ContentTestUtils.createContainer(
        texts: [ContentTestUtils.createTestText()],
      );
      addTearDown(container.dispose);

      final contentList = container.read(contentListProvider);
      expect(contentList.length, 1);
      expect(contentList.first.type, ContentType.text);
    });

    test('sorts content by parentId, orderIndex, and createdAt', () {
      final now = DateTime.now();
      final container = ContentTestUtils.createContainer(
        texts: [
          ContentTestUtils.createTestText(
            parentId: 'parent1',
            orderIndex: 1,
            createdAt: now,
          ),
          ContentTestUtils.createTestText(
            parentId: 'parent1',
            orderIndex: 0,
            createdAt: now.add(const Duration(seconds: 1)),
          ),
          ContentTestUtils.createTestText(
            parentId: 'parent2',
            orderIndex: 0,
            createdAt: now,
          ),
        ],
      );
      addTearDown(container.dispose);

      final contentList = container.read(contentListProvider);
      expect(contentList.length, 3);

      // Check sorting by parentId
      expect(contentList[0].parentId, 'parent1');
      expect(contentList[1].parentId, 'parent1');
      expect(contentList[2].parentId, 'parent2');

      // Check sorting by orderIndex within same parent
      expect(contentList[0].orderIndex, 0);
      expect(contentList[1].orderIndex, 1);
    });
  });

  group('ContentListByParentId Provider Tests', () {
    test('filters content by parentId', () {
      final container = ContentTestUtils.createContainer(
        texts: [
          ContentTestUtils.createTestText(parentId: 'parent1'),
          ContentTestUtils.createTestText(parentId: 'parent2'),
        ],
      );
      addTearDown(container.dispose);

      final parent1Content = container.read(contentListByParentIdProvider('parent1'));
      expect(parent1Content.length, 1);
      expect(parent1Content.first.parentId, 'parent1');

      final parent2Content = container.read(contentListByParentIdProvider('parent2'));
      expect(parent2Content.length, 1);
      expect(parent2Content.first.parentId, 'parent2');

      final nonExistentParentContent = container.read(contentListByParentIdProvider('parent3'));
      expect(nonExistentParentContent, isEmpty);
    });
  });

  group('Content Provider Tests', () {
    test('finds content by id', () {
      final testContent = ContentTestUtils.createTestText();
      final container = ContentTestUtils.createContainer(texts: [testContent]);
      addTearDown(container.dispose);

      final foundContent = container.read(contentProvider(testContent.id));
      expect(foundContent, isNotNull);
      expect(foundContent?.id, testContent.id);

      final notFoundContent = container.read(contentProvider('non-existent-id'));
      expect(notFoundContent, isNull);
    });
  });
}