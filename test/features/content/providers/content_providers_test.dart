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

void main() {
  group('ContentList Provider Tests', () {
    test('combines content from all providers', () {
      final container = ProviderContainer(
        overrides: [
          textListProvider.overrideWithValue([
            TextModel(
              parentId: 'parent1',
              sheetId: 'sheet1',
              title: 'Text 1',
              description: (plainText: '', htmlText: ''),
              orderIndex: 0,
            ),
          ]),
          eventListProvider.overrideWithValue([]),
          listsProvider.overrideWithValue([]),
          bulletListProvider.overrideWithValue([]),
          taskListProvider.overrideWithValue([]),
          linkListProvider.overrideWithValue([]),
          pollListProvider.overrideWithValue([]),
          documentListProvider.overrideWithValue([]),
        ],
      );
      addTearDown(container.dispose);

      final contentList = container.read(contentListProvider);
      expect(contentList.length, 1);
      expect(contentList.first.type, ContentType.text);
    });

    test('sorts content by parentId, orderIndex, and createdAt', () {
      final now = DateTime.now();
      final container = ProviderContainer(
        overrides: [
          textListProvider.overrideWithValue([
            TextModel(
              parentId: 'parent1',
              sheetId: 'sheet1',
              title: 'Text 1',
              description: (plainText: '', htmlText: ''),
              orderIndex: 1,
              createdAt: now,
            ),
            TextModel(
              parentId: 'parent1',
              sheetId: 'sheet1',
              title: 'Text 2',
              description: (plainText: '', htmlText: ''),
              orderIndex: 0,
              createdAt: now.add(const Duration(seconds: 1)),
            ),
            TextModel(
              parentId: 'parent2',
              sheetId: 'sheet1',
              title: 'Text 3',
              description: (plainText: '', htmlText: ''),
              orderIndex: 0,
              createdAt: now,
            ),
          ]),
          eventListProvider.overrideWithValue([]),
          listsProvider.overrideWithValue([]),
          bulletListProvider.overrideWithValue([]),
          taskListProvider.overrideWithValue([]),
          linkListProvider.overrideWithValue([]),
          pollListProvider.overrideWithValue([]),
          documentListProvider.overrideWithValue([]),
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
      final container = ProviderContainer(
        overrides: [
          textListProvider.overrideWithValue([
            TextModel(
              parentId: 'parent1',
              sheetId: 'sheet1',
              title: 'Text 1',
              description: (plainText: '', htmlText: ''),
              orderIndex: 0,
            ),
            TextModel(
              parentId: 'parent2',
              sheetId: 'sheet1',
              title: 'Text 2',
              description: (plainText: '', htmlText: ''),
              orderIndex: 0,
            ),
          ]),
          eventListProvider.overrideWithValue([]),
          listsProvider.overrideWithValue([]),
          bulletListProvider.overrideWithValue([]),
          taskListProvider.overrideWithValue([]),
          linkListProvider.overrideWithValue([]),
          pollListProvider.overrideWithValue([]),
          documentListProvider.overrideWithValue([]),
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
      final testContent = TextModel(
        parentId: 'parent1',
        sheetId: 'sheet1',
        title: 'Text 1',
        description: (plainText: '', htmlText: ''),
        orderIndex: 0,
      );

      final container = ProviderContainer(
        overrides: [
          textListProvider.overrideWithValue([testContent]),
          eventListProvider.overrideWithValue([]),
          listsProvider.overrideWithValue([]),
          bulletListProvider.overrideWithValue([]),
          taskListProvider.overrideWithValue([]),
          linkListProvider.overrideWithValue([]),
          pollListProvider.overrideWithValue([]),
          documentListProvider.overrideWithValue([]),
        ],
      );
      addTearDown(container.dispose);

      final foundContent = container.read(contentProvider(testContent.id));
      expect(foundContent, isNotNull);
      expect(foundContent?.id, testContent.id);

      final notFoundContent = container.read(contentProvider('non-existent-id'));
      expect(notFoundContent, isNull);
    });
  });
}
