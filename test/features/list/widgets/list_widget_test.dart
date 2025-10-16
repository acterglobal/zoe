import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/emoji_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/features/list/widgets/list_widget.dart';
import 'package:zoe/features/list/data/lists.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('ListWidget', () {
    late ListModel testList;

    setUp(() {
      testList = lists.first;
    });

    Future<void> pumpListWidget(
      WidgetTester tester, {
      required String listId,
      bool isEditing = false,
      ListModel? customList,
    }) async {
      final listToUse =
          customList ??
          lists.firstWhere((l) => l.id == listId, orElse: () => lists.first);

      final container = ProviderContainer(
        overrides: [
          listItemProvider(listId).overrideWith((ref) => listToUse),
          editContentIdProvider.overrideWith(
            (ref) => isEditing ? listId : null,
          ),
        ],
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: ListWidget(listId: listId),
      );
    }

    ListModel createList({
      ContentType type = ContentType.text,
      String? title,
      String? emoji,
    }) {
      return testList.copyWith(
        listType: type,
        title: title ?? testList.title,
        emoji: emoji,
      );
    }

    ZoeInlineTextEditWidget? findTitleWidget(
      WidgetTester tester,
      String title,
    ) {
      final textWidgets = tester.widgetList<ZoeInlineTextEditWidget>(
        find.byType(ZoeInlineTextEditWidget),
      );
      try {
        return textWidgets.firstWhere((w) => w.text == title);
      } catch (e) {
        return textWidgets.isNotEmpty ? textWidgets.first : null;
      }
    }

    EmojiWidget? findEmojiWidget(WidgetTester tester, String emoji) {
      final emojis = tester.widgetList<EmojiWidget>(find.byType(EmojiWidget));
      try {
        return emojis.firstWhere((w) => w.emoji == emoji);
      } catch (e) {
        return emojis.isNotEmpty ? emojis.first : null;
      }
    }

    group('Rendering', () {
      testWidgets('renders widget with valid list ID', (tester) async {
        await pumpListWidget(tester, listId: testList.id);

        expect(find.byType(ListWidget), findsOneWidget);
        expect(find.byType(Padding), findsWidgets);
      });

      testWidgets('renders SizedBox when list is null', (tester) async {
        await pumpListWidget(tester, listId: 'non-existent');

        expect(find.byType(SizedBox), findsWidgets);
        expect(find.byType(ListWidget), findsNothing);
      });

      testWidgets('renders main components', (tester) async {
        await pumpListWidget(tester, listId: testList.id);

        expect(find.byType(EmojiWidget), findsWidgets);
        expect(find.byType(ZoeInlineTextEditWidget), findsWidgets);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Row), findsWidgets);
      });
    });

    group('Edit Mode', () {
      testWidgets('shows delete button when editing', (tester) async {
        await pumpListWidget(tester, listId: testList.id, isEditing: true);
        expect(find.byType(ZoeDeleteButtonWidget), findsOneWidget);
      });

      testWidgets('hides delete button when not editing', (tester) async {
        await pumpListWidget(tester, listId: testList.id, isEditing: false);
        expect(find.byType(ZoeDeleteButtonWidget), findsNothing);
      });

      testWidgets('shows add button when editing', (tester) async {
        await pumpListWidget(tester, listId: testList.id, isEditing: true);
        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.text('Add item'), findsOneWidget);
      });

      testWidgets('hides add button when not editing', (tester) async {
        await pumpListWidget(tester, listId: testList.id, isEditing: false);
        expect(find.byIcon(Icons.add), findsNothing);
        expect(find.text('Add item'), findsNothing);
      });
    });

    group('List Types', () {
      final types = [
        ContentType.bullet,
        ContentType.task,
        ContentType.text,
        ContentType.event,
        ContentType.link,
        ContentType.document,
        ContentType.poll,
      ];

      for (var type in types) {
        testWidgets('renders correctly for $type type', (tester) async {
          final custom = createList(type: type);
          await pumpListWidget(tester, listId: testList.id, customList: custom);
          expect(find.byType(ListWidget), findsOneWidget);
        });
      }
    });

    group('Title & Emoji', () {
      testWidgets('displays correct title', (tester) async {
        await pumpListWidget(tester, listId: testList.id);
        final titleWidget = findTitleWidget(tester, testList.title);
        expect(titleWidget, isNotNull);
        expect(titleWidget!.text, testList.title);
      });

      testWidgets('displays emoji correctly', (tester) async {
        await pumpListWidget(tester, listId: testList.id);
        final emojiWidget = findEmojiWidget(tester, testList.emoji ?? '🔸');
        expect(emojiWidget, isNotNull);
        expect(emojiWidget!.emoji, testList.emoji ?? '🔸');
      });
    });

    group('Error Handling & Edge Cases', () {
      testWidgets('handles invalid/empty list gracefully', (tester) async {
        await pumpListWidget(tester, listId: 'invalid');
        expect(find.byType(ListWidget), findsNothing);
        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('handles long title', (tester) async {
        final custom = createList(
          title: 'A very long title that should not overflow',
        );
        await pumpListWidget(tester, listId: testList.id, customList: custom);
        expect(find.byType(ListWidget), findsOneWidget);
        expect(find.byType(ZoeInlineTextEditWidget), findsWidgets);
      });

      testWidgets('handles empty title', (tester) async {
        final custom = createList(title: '');
        await pumpListWidget(tester, listId: testList.id, customList: custom);
        expect(find.byType(ListWidget), findsOneWidget);
        expect(find.byType(ZoeInlineTextEditWidget), findsWidgets);
      });

      testWidgets('handles special characters in title', (tester) async {
        final custom = createList(
          title: 'Special chars: !@#\$%^&*()_+-=[]{}|;:,.<>?',
        );
        await pumpListWidget(tester, listId: testList.id, customList: custom);
        expect(find.byType(ListWidget), findsOneWidget);
        expect(find.byType(ZoeInlineTextEditWidget), findsWidgets);
      });

      testWidgets('handles unicode emoji in title', (tester) async {
        final custom = createList(title: 'Title with emoji 🎉🚀✨');
        await pumpListWidget(tester, listId: testList.id, customList: custom);
        expect(find.byType(ListWidget), findsOneWidget);
        expect(find.byType(ZoeInlineTextEditWidget), findsWidgets);
      });
    });
  });
}
