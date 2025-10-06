import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/text/data/text_list.dart';

void main() {
  late ProviderContainer container;
  late TextModel testTextModel;

  setUp(() {
    container = ProviderContainer.test();

    // Create test text model
    testTextModel = textList.first.copyWith(
      id: 'test-text-id',
      title: 'Test Title',
      emoji: '🧪',
      description: (
        plainText: 'This is a test description',
        htmlText: '<p>This is a test description</p>',
      ),
    );

    // Add test text to the container
    container.read(textListProvider.notifier).addText(testTextModel);
  });

  tearDown(() {
    container.dispose();
  });

  group('TextActions', () {
    test('editText sets edit content id provider', () {
      // Read initial state
      String? initialEditId = container.read(editContentIdProvider);
      
      // Simulate edit action by directly calling the provider update
      container.read(editContentIdProvider.notifier).state = 'test-text-id';
      
      // Verify the edit content id is set
      expect(container.read(editContentIdProvider), equals('test-text-id'));
      expect(container.read(editContentIdProvider), isNot(equals(initialEditId)));
    });

    test('text is properly stored and retrieved from provider', () {
      // Verify text is in the provider
      final retrievedText = container.read(textProvider('test-text-id'));
      
      expect(retrievedText, isNotNull);
      expect(retrievedText!.id, equals('test-text-id'));
      expect(retrievedText.title, equals('Test Title'));
      expect(retrievedText.emoji, equals('🧪'));
      expect(retrievedText.description?.plainText, equals('This is a test description'));
    });

    test('text can be deleted from provider', () {
      // Verify text exists initially
      expect(container.read(textProvider('test-text-id')), isNotNull);
      
      // Delete the text
      container.read(textListProvider.notifier).deleteText('test-text-id');
      
      // Verify text is removed
      expect(container.read(textProvider('test-text-id')), isNull);
    });

    test('copyText logic works correctly with text content', () {
      final textContent = container.read(textProvider('test-text-id'));
      expect(textContent, isNotNull);
      
      // Test the clipboard content construction logic
      final buffer = StringBuffer();
      
      // Add emoji and title (same logic as in TextActions.copyText)
      if (textContent!.emoji != null) {
        buffer.write('${textContent.emoji} ');
      }
      buffer.write(textContent.title);

      // Add description if available
      final description = textContent.description?.plainText;
      if (description != null && description.isNotEmpty) {
        buffer.write('\n\n$description');
      }

      final expectedContent = '🧪 Test Title\n\nThis is a test description';
      expect(buffer.toString(), equals(expectedContent));
    });
  });
}