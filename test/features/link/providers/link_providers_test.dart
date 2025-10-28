import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/link/data/link_list.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/common/providers/common_providers.dart';
import '../../../test-utils/mock_searchValue.dart';
import '../utils/link_utils.dart';

void main() {
  group('Link Providers Tests', () {
    late ProviderContainer container;
    late LinkModel testLink;

    setUp(() {
      container = ProviderContainer.test(
        overrides: [searchValueProvider.overrideWith(MockSearchValue.new)],
      );

      testLink = getLinkByIndex(container);
    });

    List<LinkModel> getLinkList() => container.read(linkListProvider);

    LinkModel? getLinkById(String id) => container.read(linkProvider(id));

    List<LinkModel> getLinksByParent(String parentId) =>
        container.read(linkByParentProvider(parentId));

    List<LinkModel> searchLinks() => container.read(linkListSearchProvider);

    group('LinkList Provider', () {
      test('initial state contains all links', () {
        final links = getLinkList();

        expect(links, isNotEmpty);
        expect(links.length, equals(linkList.length));
        expect(links.first.title, equals('Zoe Official Documentation'));
      });

      test('addLink adds new link to list', () {
        final newLink = LinkModel(
          id: 'new-link-id',
          sheetId: 'sheet-1',
          parentId: 'sheet-1',
          title: 'New Link',
          url: 'https://newlink.com',
          emoji: '🔗',
          orderIndex: 100,
        );

        container.read(linkListProvider.notifier).addLink(newLink);

        final updatedList = getLinkList();
        expect(updatedList.length, equals(linkList.length + 1));
        expect(updatedList.last, equals(newLink));
      });

      test('deleteLink removes link from list', () {
        final initialLength = getLinkList().length;

        container.read(linkListProvider.notifier).deleteLink(testLink.id);

        final updatedList = getLinkList();
        expect(updatedList.length, equals(initialLength - 1));
        expect(updatedList.any((l) => l.id == testLink.id), isFalse);
      });

      test('deleteLink does nothing for non-existent link', () {
        final initialLength = getLinkList().length;

        container.read(linkListProvider.notifier).deleteLink('non-existent-id');

        final updatedList = getLinkList();
        expect(updatedList.length, equals(initialLength));
      });

      test('updateLinkTitle updates link title', () {
        const newTitle = 'Updated Link Title';

        container
            .read(linkListProvider.notifier)
            .updateLinkTitle(testLink.id, newTitle);

        final updatedLink = getLinkById(testLink.id);
        expect(updatedLink?.title, equals(newTitle));
      });

      test('updateLinkUrl updates link URL', () {
        const newUrl = 'https://updated.com';

        container
            .read(linkListProvider.notifier)
            .updateLinkUrl(testLink.id, newUrl);

        final updatedLink = getLinkById(testLink.id);
        expect(updatedLink?.url, equals(newUrl));
      });

      test('updateLinkEmoji updates link emoji', () {
        const newEmoji = '🎉';

        container
            .read(linkListProvider.notifier)
            .updateLinkEmoji(testLink.id, newEmoji);

        final updatedLink = getLinkById(testLink.id);
        expect(updatedLink?.emoji, equals(newEmoji));
      });

      test('updateLinkOrderIndex updates link order', () {
        const newOrderIndex = 999;

        container
            .read(linkListProvider.notifier)
            .updateLinkOrderIndex(testLink.id, newOrderIndex);

        final updatedLink = getLinkById(testLink.id);
        expect(updatedLink?.orderIndex, equals(newOrderIndex));
      });
    });

    group('Link Provider (by ID)', () {
      test('returns correct link by ID', () {
        expect(getLinkById(testLink.id), equals(testLink));
        expect(getLinkById(testLink.id)?.id, equals(testLink.id));
        expect(
          getLinkById(testLink.id)?.title,
          equals('Zoe Official Documentation'),
        );
        expect(
          getLinkById(testLink.id)?.url,
          equals('https://docs.hellozoe.app'),
        );
      });

      test('returns null for non-existent ID', () {
        expect(getLinkById('non-existent-id'), isNull);
      });

      test('link provider updates when link list changes', () {
        expect(getLinkById(testLink.id), equals(testLink));

        container
            .read(linkListProvider.notifier)
            .updateLinkTitle(testLink.id, 'Updated Title');

        final updatedLink = getLinkById(testLink.id);
        expect(updatedLink?.title, equals('Updated Title'));
        expect(updatedLink?.id, equals(testLink.id));
      });
    });

    group('LinkByParent Provider', () {
      test('returns links for specific parent ID', () {
        final links = getLinksByParent('sheet-1');

        expect(links, isNotEmpty);
        expect(links.firstWhere((l) => l.id == 'link-1'), isNotNull);
      });
      test('updates when link parentId changes', () {
        // Add a new link with different parent
        final newLink = testLink.copyWith(
          id: 'new-parent-link',
          parentId: 'sheet-2',
          title: 'Link in Sheet 2',
        );
        container.read(linkListProvider.notifier).addLink(newLink);

        // Verify the new link appears in sheet-2
        final linksInSheet2 = getLinksByParent('sheet-2');
        expect(linksInSheet2.length, greaterThan(0));
        expect(linksInSheet2.any((l) => l.id == 'new-parent-link'), isTrue);
      });
    });

    group('LinkListSearch Provider', () {
      test('returns all links when search is empty', () {
        // Set empty search value
        container.read(searchValueProvider.notifier).update('');

        final searchResults = searchLinks();

        expect(searchResults.length, equals(linkList.length));
      });

      test('filters links by title', () {
        // Set search value
        container.read(searchValueProvider.notifier).update('zoe');

        final searchResults = searchLinks();

        expect(searchResults.length, greaterThan(0));
        for (final link in searchResults) {
          expect(
            link.title.toLowerCase().contains('zoe') ||
                link.url.toLowerCase().contains('zoe'),
            isTrue,
          );
        }
      });

      test('filters links by URL', () {
        // Set search value
        container.read(searchValueProvider.notifier).update('docs');

        final searchResults = searchLinks();

        expect(searchResults.length, greaterThan(0));
        for (final link in searchResults) {
          expect(
            link.title.toLowerCase().contains('docs') ||
                link.url.toLowerCase().contains('docs'),
            isTrue,
          );
        }
      });

      test('is case insensitive', () {
        // Set search value
        container.read(searchValueProvider.notifier).update('COMMUNITY');

        final searchResults = searchLinks();

        expect(searchResults.length, greaterThan(0));
        for (final link in searchResults) {
          expect(
            link.title.toLowerCase().contains('community') ||
                link.url.toLowerCase().contains('community'),
            isTrue,
          );
        }
      });

      test('returns empty list for non-matching search', () {
        // Set search value
        container
            .read(searchValueProvider.notifier)
            .update('non-existent-search-term');

        final searchResults = searchLinks();

        expect(searchResults, isEmpty);
      });

      test('search updates when link data changes', () {
        // Set search for "documentation"
        container.read(searchValueProvider.notifier).update('documentation');
        final initialResults = searchLinks();
        expect(initialResults.length, greaterThan(0));

        // Update a link title to remove "documentation"
        container
            .read(linkListProvider.notifier)
            .updateLinkTitle('link-1', 'New Title');

        // Search should reflect the change
        final updatedResults = searchLinks();
        expect(updatedResults.length, lessThan(initialResults.length));
      });
    });

    group('Link Provider Edge Cases', () {
      test('handles link with empty URL', () {
        final newLink = LinkModel(
          id: 'link-empty-url',
          sheetId: 'sheet-1',
          parentId: 'sheet-1',
          title: 'Link Without URL',
          url: '',
          emoji: '🔗',
          orderIndex: 1000,
        );

        getLinkList().add(newLink);

        final addedLink = getLinkById('link-empty-url');
        expect(addedLink, isNotNull);
        expect(addedLink?.url, isEmpty);
      });

      test('handles link with empty title', () {
        final newLink = LinkModel(
          id: 'link-empty-title',
          sheetId: 'sheet-1',
          parentId: 'sheet-1',
          title: '',
          url: 'https://example.com',
          emoji: '🔗',
          orderIndex: 1001,
        );

        getLinkList().add(newLink);

        final addedLink = getLinkById('link-empty-title');
        expect(addedLink, isNotNull);
        expect(addedLink?.title, isEmpty);
      });

      test('handles link with null emoji', () {
        final newLink = LinkModel(
          id: 'link-no-emoji',
          sheetId: 'sheet-1',
          parentId: 'sheet-1',
          title: 'Link Without Emoji',
          url: 'https://example.com',
          emoji: null,
          orderIndex: 1002,
        );
  
        getLinkList().add(newLink);

        final addedLink = getLinkById('link-no-emoji');
        expect(addedLink, isNotNull);
        expect(addedLink?.emoji, isNull);
      });
    });
  });
}
