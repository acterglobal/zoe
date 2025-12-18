import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/core/constants/firestore_collection_constants.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import '../utils/mock_fakefirestore_text.dart';

void main() {
  late ProviderContainer container;
  late FakeFirebaseFirestore fakeFirestore;
  // final testUser = 'test-user';

  setUp(() async {
    fakeFirestore = FakeFirebaseFirestore();
    container = ProviderContainer.test(
      overrides: [
        firestoreProvider.overrideWithValue(fakeFirestore),
        // currentUserProvider.overrideWithValue(AsyncValue.data(testUser)),
      ],
    );

    // Add initial data
    await fakeFirestore
        .collection(FirestoreCollections.texts)
        .doc(mockText1.id)
        .set(mockText1.toJson());
    await fakeFirestore
        .collection(FirestoreCollections.texts)
        .doc(mockText2.id)
        .set(mockText2.toJson());

    int retries = 0;
    while (container.read(textListProvider).length < 2 && retries < 20) {
      await Future.delayed(const Duration(milliseconds: 50));
      retries++;
    }
  });

  // Helper methods
  List<TextModel> getTextList() => container.read(textListProvider);
  TextModel? getTextById(String id) => container.read(textProvider(id));
  List<TextModel> getTextsByParent(String parentId) =>
      container.read(textByParentProvider(parentId));
  List<TextModel> searchTexts(String searchTerm) =>
      container.read(textListSearchProvider(searchTerm));
  List<TextModel> getSortedTexts() => container.read(sortedTextsProvider);

  group('TextList Provider', () {
    test('initial state is populated from Firestore', () {
      final textList = getTextList();
      expect(textList, isA<List<TextModel>>());
      expect(textList.length, 2);
      expect(textList.any((t) => t.id == textContent1), isTrue);
    });

    test('addText adds new text to the list', () async {
      final newText = mockText1.copyWith(
        id: 'new-text-id',
        title: 'New Text',
        emoji: '🆕',
      );

      await container.read(textListProvider.notifier).addText(newText);
      await Future.delayed(
        const Duration(milliseconds: 50),
      ); // allow stream to update

      final updatedList = getTextList();
      expect(updatedList.length, 3);
      expect(updatedList.any((t) => t.id == 'new-text-id'), isTrue);
    });

    test('deleteText removes data from the list', () async {
      await container.read(textListProvider.notifier).deleteText(textContent1);
      await Future.delayed(const Duration(milliseconds: 50));

      final updatedList = getTextList();
      expect(updatedList.length, 1);
      expect(updatedList.any((t) => t.id == textContent1), isFalse);
    });

    test('updateTextTitle changes title of data', () async {
      await container
          .read(textListProvider.notifier)
          .updateTextTitle(textContent1, 'Updated Title');
      await Future.delayed(const Duration(milliseconds: 50));

      final targetText = getTextById(textContent1);
      expect(targetText?.title, equals('Updated Title'));
    });

    test('updateTextDescription changes description of data', () async {
      final newDescription = (
        plainText: 'Updated description content',
        htmlText: '<p>Updated description content</p>',
      );

      await container
          .read(textListProvider.notifier)
          .updateTextDescription(textContent1, newDescription);
      await Future.delayed(const Duration(milliseconds: 50));

      final targetText = getTextById(textContent1);
      expect(
        targetText?.description?.plainText,
        equals(newDescription.plainText),
      );
    });

    test('updateTextEmoji changes emoji of data', () async {
      await container
          .read(textListProvider.notifier)
          .updateTextEmoji(textContent1, '🎉');
      await Future.delayed(const Duration(milliseconds: 50));

      final targetText = getTextById(textContent1);
      expect(targetText?.emoji, equals('🎉'));
    });

    test('updateTextOrderIndex changes order index of data', () async {
      await container
          .read(textListProvider.notifier)
          .updateTextOrderIndex(textContent1, 99);
      await Future.delayed(const Duration(milliseconds: 50));

      final targetText = getTextById(textContent1);
      expect(targetText?.orderIndex, equals(99));
    });
  });

  group('Text Provider (by ID)', () {
    test('returns correct text for data', () {
      final text = getTextById(textContent1);
      expect(text, isNotNull);
      expect(text!.id, equals(textContent1));
      expect(text.title, equals('Welcome to Zoe!'));
    });

    test('returns null for non-existent ID', () {
      final text = getTextById('non-existent-id');
      expect(text, isNull);
    });
  });

  group('TextByParent Provider', () {
    test('returns texts filtered by parentId', () {
      final texts = getTextsByParent('sheet-1');
      expect(texts.length, 2);
      expect(texts.every((t) => t.parentId == 'sheet-1'), isTrue);
    });

    test('returns texts sorted by orderIndex', () {
      final texts = getTextsByParent('sheet-1');
      expect(texts[0].id, textContent1);
      expect(texts[1].id, textContent2);
    });
  });

  group('TextListSearch Provider', () {
    test('returns all texts when search term is empty', () {
      final texts = searchTexts('');
      expect(texts.length, 2);
    });

    test('returns filtered texts based on search term', () {
      final texts = searchTexts('welcome');
      expect(texts.length, 1);
      expect(texts.first.id, textContent1);
    });

    test('returns empty list for non-matching search term', () {
      final texts = searchTexts('nonexistent');
      expect(texts, isEmpty);
    });
  });

  group('SortedTexts Provider', () {
    test('returns texts sorted by title', () {
      final sortedTexts = getSortedTexts();
      // 'Understanding Sheets' comes before 'Welcome to Zoe!'
      expect(sortedTexts[0].id, textContent2);
      expect(sortedTexts[1].id, textContent1);
    });
  });
}
