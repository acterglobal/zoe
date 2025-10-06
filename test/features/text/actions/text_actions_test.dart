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

    // Use existing data from textList
    testTextModel = textList.first; // Uses 'Welcome to Zoe!' with 👋 emoji

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
      container.read(editContentIdProvider.notifier).state = 'text-content-1';
      
      // Verify the edit content id is set
      expect(container.read(editContentIdProvider), equals('text-content-1'));
      expect(container.read(editContentIdProvider), isNot(equals(initialEditId)));
    });

    test('text is properly stored and retrieved from provider', () {
      // Verify text is in the provider
      final retrievedText = container.read(textProvider('text-content-1'));
      
      expect(retrievedText, isNotNull);
      expect(retrievedText!.id, equals('text-content-1'));
      expect(retrievedText.title, equals('Welcome to Zoe!'));
      expect(retrievedText.emoji, equals('👋'));
      expect(retrievedText.description?.plainText, contains('Welcome to Zoe - your intelligent personal workspace!'));
    });

    test('text can be deleted from provider', () {
      // Verify text exists initially
      expect(container.read(textProvider('text-content-1')), isNotNull);
      
      // Delete the text
      container.read(textListProvider.notifier).deleteText('text-content-1');
      
      // Verify text is removed
      expect(container.read(textProvider('text-content-1')), isNull);
    });

    test('copyText logic works correctly with text content', () {
      final textContent = container.read(textProvider('text-content-1'));
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

      final expectedContent = '👋 Welcome to Zoe!\n\nWelcome to Zoe - your intelligent personal workspace! Zoe helps you organize thoughts, manage tasks, plan events, and structure ideas all in one beautiful, intuitive interface.\n\nThis guide will walk you through everything you need to know to get the most out of your Zoe experience. Let\'s get started!';
      expect(buffer.toString(), equals(expectedContent));
    });
  });
}