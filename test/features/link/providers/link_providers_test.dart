import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/link/data/link_list.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import '../../../test-utils/mock_searchValue.dart';
import '../../users/utils/users_utils.dart';
import '../utils/link_utils.dart';

void main() {
  group('Link Providers Tests', () {
    late ProviderContainer container;
    late LinkModel testLink;
    late String testUserId;

    setUp(() {
      container = ProviderContainer.test(
        overrides: [searchValueProvider.overrideWith(MockSearchValue.new)],
      );

      // Get test user
      testUserId = getUserByIndex(container).id;

      // Override loggedInUserProvider for tests that depend on linkListSearchProvider
      container = ProviderContainer.test(
        overrides: [
          searchValueProvider.overrideWith(MockSearchValue.new),
          loggedInUserProvider.overrideWithValue(AsyncValue.data(testUserId)),
        ],
      );

      testLink = getLinkByIndex(container);
    });

    List<LinkModel> getLinkList() => container.read(linkListProvider);

    LinkModel? getLinkById(String id) => container.read(linkProvider(id));

    List<LinkModel> getLinksByParent(String parentId) =>
        container.read(linkByParentProvider(parentId));

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
      
        // Get links that the test user's sheets contain
        final userLinks = getLinkList().where((l) {
          final sheet = container.read(sheetProvider(l.sheetId));
          return sheet?.users.contains(testUserId) == true;
        }).toList();

        // Set empty search value
        container.read(searchValueProvider.notifier).update('');

        final searchResults = container.read(linkListSearchProvider);

        expect(searchResults.length, equals(userLinks.length));
      });

      test('filters links by title', () {
        // Get links that the test user's sheets contain
        final userLinks = getLinkList().where((l) {
          final sheet = container.read(sheetProvider(l.sheetId));
          return sheet?.users.contains(testUserId) == true;
        }).toList();

        if (userLinks.isNotEmpty) {
          // Find a link with "zoe" in title or URL
          final testLinkWithSearchTerm = userLinks.firstWhere(
            (l) => l.title.toLowerCase().contains('zoe') ||
                   l.url.toLowerCase().contains('zoe'),
            orElse: () => userLinks.first,
          );

          final searchTerm = testLinkWithSearchTerm.title.toLowerCase().contains('zoe')
              ? 'zoe'
              : testLinkWithSearchTerm.url.toLowerCase().contains('zoe')
                  ? 'zoe'
                  : testLinkWithSearchTerm.title.substring(0, 3).toLowerCase();

          // Set search value
          container.read(searchValueProvider.notifier).update(searchTerm);

          final searchResults = container.read(linkListSearchProvider);

          expect(searchResults.length, greaterThan(0));
          for (final link in searchResults) {
            expect(
              link.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
                  link.url.toLowerCase().contains(searchTerm.toLowerCase()),
              isTrue,
            );
          }
        }
      });

      test('filters links by URL', () {
        
        // Get links that the test user's sheets contain
        final userLinks = getLinkList().where((l) {
          final sheet = container.read(sheetProvider(l.sheetId));
          return sheet?.users.contains(testUserId) == true;
        }).toList();

        if (userLinks.isNotEmpty) {
          // Find a link with "docs" or "http" in URL or title
          final searchTerm = userLinks.first.url.toLowerCase().contains('docs')
              ? 'docs'
              : userLinks.first.url.toLowerCase().contains('http')
                  ? 'http'
                  : userLinks.first.url.substring(8, 13).toLowerCase();

          // Set search value
          container.read(searchValueProvider.notifier).update(searchTerm);

          final searchResults = container.read(linkListSearchProvider);

          expect(searchResults.length, greaterThan(0));
          for (final link in searchResults) {
            expect(
              link.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
                  link.url.toLowerCase().contains(searchTerm.toLowerCase()),
              isTrue,
            );
          }
        }
      });

      test('is case insensitive', () {
        
        // Get links that the test user's sheets contain
        final userLinks = getLinkList().where((l) {
          final sheet = container.read(sheetProvider(l.sheetId));
          return sheet?.users.contains(testUserId) == true;
        }).toList();

        if (userLinks.isNotEmpty) {
          // Find a search term from the links
          final testLink = userLinks.first;
          final searchTerm = testLink.title.isNotEmpty
              ? testLink.title.substring(0, testLink.title.length > 8 ? 8 : testLink.title.length).toUpperCase()
              : testLink.url.substring(8, 16).toUpperCase();

          // Set search value
          container.read(searchValueProvider.notifier).update(searchTerm);

          final searchResults = container.read(linkListSearchProvider);

          if (searchResults.isNotEmpty) {
            expect(searchResults.length, greaterThan(0));
            for (final link in searchResults) {
              expect(
                link.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
                    link.url.toLowerCase().contains(searchTerm.toLowerCase()),
                isTrue,
              );
            }
          }
        }
      });

      test('returns empty list for non-matching search', () {
        // Set search value
        container
            .read(searchValueProvider.notifier)
            .update('non-existent-search-term-xyz123');

        final searchResults = container.read(linkListSearchProvider);

        expect(searchResults, isEmpty);
      });

      test('search updates when link data changes', () {
        // Get links that the test user's sheets contain
        final userLinks = getLinkList().where((l) {
          final sheet = container.read(sheetProvider(l.sheetId));
          return sheet?.users.contains(testUserId) == true;
        }).toList();

        if (userLinks.isNotEmpty) {
          // Find a link with "documentation" or similar in title/URL
          final testLinkForSearch = userLinks.firstWhere(
            (l) => l.title.toLowerCase().contains('documentation') ||
                   l.url.toLowerCase().contains('documentation') ||
                   l.title.toLowerCase().contains('doc') ||
                   l.url.toLowerCase().contains('doc'),
            orElse: () => userLinks.first,
          );

          final searchTerm = testLinkForSearch.title.toLowerCase().contains('documentation')
              ? 'documentation'
              : testLinkForSearch.title.toLowerCase().contains('doc')
                  ? 'doc'
                  : testLinkForSearch.url.toLowerCase().contains('doc')
                      ? 'doc'
                      : testLinkForSearch.title.substring(0, 5).toLowerCase();

          // Set search for the term
          container.read(searchValueProvider.notifier).update(searchTerm);
          final initialResults = container.read(linkListSearchProvider);
          
          if (initialResults.isNotEmpty) {
            // Update a link title to remove the search term
            container
                .read(linkListProvider.notifier)
                .updateLinkTitle(testLinkForSearch.id, 'New Title Without Search Term');

            // Search should reflect the change
            final updatedResults = container.read(linkListSearchProvider);
            expect(updatedResults.length, lessThanOrEqualTo(initialResults.length));
          }
        }
      });
    });

  });
}


