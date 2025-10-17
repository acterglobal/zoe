import 'package:flutter_test/flutter_test.dart' hide Description;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/list/data/lists.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/common/providers/common_providers.dart';
import '../../../test-utils/mock_searchValue.dart';
import '../utils/list_utils.dart';

void main() {
  group('List Providers Tests', () {
    late ProviderContainer container;
    late ListModel testList;
  
    setUp(() {
      container = ProviderContainer.test(
        overrides: [searchValueProvider.overrideWith(MockSearchValue.new)],
      );
      
      testList = getListByIndex(container);
    });

    group('ListList Provider', () {
      test('initial state contains all lists', () {
        final listList = container.read(listsProvider);
        expect(listList, equals(lists));
        expect(listList.length, equals(lists.length));
      });

      test('addList adds new list to list', () {
        final newList = testList.copyWith(id: 'test-list', title: 'Test List');

        container.read(listsProvider.notifier).addList(newList);

        final updatedList = container.read(listsProvider);
        expect(updatedList.length, equals(lists.length + 1));
        expect(updatedList.last, equals(newList));
      });

      test('deleteList removes list from list', () {
        final initialLength = container.read(listsProvider).length;

        container.read(listsProvider.notifier).deleteList(testList.id);

        final updatedList = container.read(listsProvider);
        expect(updatedList.length, equals(initialLength - 1));
        expect(updatedList.any((l) => l.id == testList.id), isFalse);
      });

      test('deleteList does nothing for non-existent list', () {
        final initialLength = container.read(listsProvider).length;

        container.read(listsProvider.notifier).deleteList('non-existent-id');

        final updatedList = container.read(listsProvider);
        expect(updatedList.length, equals(initialLength));
      });

      test('updateListTitle updates list title', () {
        const newTitle = 'Updated Title';

        container
            .read(listsProvider.notifier)
            .updateListTitle(testList.id, newTitle);

        final updatedList = container.read(listItemProvider(testList.id));
        expect(updatedList?.title, equals(newTitle));
      });

      test('updateListDescription updates list description', () {
        final newDescription = (
          plainText: 'New description',
          htmlText: '<p>New description</p>',
        );

        container
            .read(listsProvider.notifier)
            .updateListDescription(testList.id, newDescription);

        final updatedList = container.read(listItemProvider(testList.id));
        expect(updatedList?.description, equals(newDescription));
      });

      test('updateListEmoji updates list emoji', () {
        const newEmoji = '🎉';

        container
            .read(listsProvider.notifier)
            .updateListEmoji(testList.id, newEmoji);

        final updatedList = container.read(listItemProvider(testList.id));
        expect(updatedList?.emoji, equals(newEmoji));
      });

      test('updateListType updates list type', () {
        const newType = ContentType.task;

        container
            .read(listsProvider.notifier)
            .updateListType(testList.id, newType);

        final updatedList = container.read(listItemProvider(testList.id));
        expect(updatedList?.listType, equals(newType));
      });

      test('updateListOrderIndex updates list order', () {
        const newOrderIndex = 999;

        container
            .read(listsProvider.notifier)
            .updateListOrderIndex(testList.id, newOrderIndex);

        final updatedList = container.read(listItemProvider(testList.id));
        expect(updatedList?.orderIndex, equals(newOrderIndex));
      });
    });

    group('List Provider', () {
      test('list provider returns correct list by ID', () {
        final list = container.read(listItemProvider(testList.id));
        expect(list, equals(testList));
      });

      test('list provider returns null for non-existent ID', () {
        final list = container.read(listItemProvider('non-existent-id'));
        expect(list, isNull);
      });

      test('list provider updates when list list changes', () {
        final initialList = container.read(listItemProvider(testList.id));
        expect(initialList, equals(testList));

        container
            .read(listsProvider.notifier)
            .updateListTitle(testList.id, 'Updated Title');

        final updatedList = container.read(listItemProvider(testList.id));
        expect(updatedList?.title, equals('Updated Title'));
        expect(updatedList?.id, equals(testList.id));
      });
    });

    group('Search Tests', () {
      test('listListSearch returns all lists when search is empty', () {
        container.read(searchValueProvider.notifier).update('');

        final searchResults = container.read(listSearchProvider(''));
        expect(searchResults.length, equals(lists.length));
      });

      test('listListSearch filters lists by title', () {
        container.read(searchValueProvider.notifier).update('action plan');

        final searchResults = container.read(listSearchProvider('action plan'));
        expect(searchResults.length, greaterThan(0));
        for (final list in searchResults) {
          expect(list.title.toLowerCase().contains('action plan'), isTrue);
        }
      });

      test('listListSearch is case insensitive', () {
        container.read(searchValueProvider.notifier).update('ACTION PLAN');

        final searchResults = container.read(listSearchProvider('ACTION PLAN'));
        expect(searchResults.length, greaterThan(0));
        for (final list in searchResults) {
          expect(list.title.toLowerCase().contains('action plan'), isTrue);
        }
      });

      test('listListSearch returns empty list for non-matching search', () {
        container
            .read(searchValueProvider.notifier)
            .update('non-existent-search-term');

        final searchResults = container.read(
          listSearchProvider('non-existent-search-term'),
        );
        expect(searchResults, isEmpty);
      });
    });
  });
}
