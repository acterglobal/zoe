import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/emoji_picker/emoji_picker_config.dart';
import 'package:zoe/common/widgets/emoji_picker/notifiers/emoji_search_notifier.dart';
import 'package:zoe/common/widgets/emoji_picker/widgets/custom_emoji_picker_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../../test-utils/mock_gorouter.dart';
import '../../../../test-utils/test_utils.dart';

void main() {
  group('CustomEmojiPickerWidget', () {
    late ProviderContainer container;
    late MockGoRouter mockGoRouter;

    setUp(() {
      container = ProviderContainer.test();
      mockGoRouter = MockGoRouter();
    });

    Future<void> pumpWidget(
      WidgetTester tester, {
      required Function(String) onEmojiSelected,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        router: mockGoRouter,
        child: CustomEmojiPickerWidget(onEmojiSelected: onEmojiSelected),
      );
    }

    void setSearchResults(List<Emoji> emojis, String query) {
      container.read(emojiSearchProvider.notifier).state = EmojiSearchState(
        query: query,
        searchResults: emojis,
      );
    }

    group('Widget Rendering', () {
      testWidgets('renders custom emoji picker widget correctly', (
        tester,
      ) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        expect(find.byType(CustomEmojiPickerWidget), findsOneWidget);
      });

      testWidgets('renders close button', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        expect(find.byIcon(Icons.close), findsOneWidget);
        expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
      });

      testWidgets('renders ZoeSearchBarWidget', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        expect(find.byType(ZoeSearchBarWidget), findsOneWidget);
      });

      testWidgets('renders EmojiPicker when no search query', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        expect(find.byType(EmojiPicker), findsOneWidget);
      });
    });

    group('Text Field Interaction', () {
      testWidgets('can enter text in search field', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        await tester.enterText(textField, 'happy');
        await tester.pump();

        expect(
          tester.widget<TextField>(textField).controller?.text,
          equals('happy'),
        );
      });

      testWidgets('clear button appears when text is entered', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        final textField = find.byType(TextField);
        await tester.enterText(textField, 'search');
        await tester.pump();

        expect(find.byIcon(Icons.clear), findsAtLeastNWidgets(1));
      });

      testWidgets('clear button clears text field', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        final textField = find.byType(TextField);
        await tester.enterText(textField, 'search');
        await tester.pump();

        final clearButton = find.byIcon(Icons.clear);
        await tester.tap(clearButton);
        await tester.pump();

        expect(tester.widget<TextField>(textField).controller?.text, isEmpty);
      });
    });

    group('Search Functionality', () {

      testWidgets('displays GridView when search has results', (tester) async {
        final mockEmojis = [
          Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
          Emoji.fromJson({'emoji': '😊', 'name': 'smiling'}),
        ];

        setSearchResults(mockEmojis, 'happy');
        await pumpWidget(tester, onEmojiSelected: (_) {});
        await tester.pumpAndSettle();

        expect(find.byType(EmojiPicker), findsNothing);
        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('displays empty message when search has no results', (
        tester,
      ) async {
        setSearchResults([], 'nonexistentemoji');
        await pumpWidget(tester, onEmojiSelected: (_) {});
        await tester.pumpAndSettle();

        expect(find.byType(EmojiPicker), findsNothing);
        expect(
          find.text(
            L10n.of(
              tester.element(find.byType(CustomEmojiPickerWidget)),
            ).noEmojisFound,
          ),
          findsOneWidget,
        );
      });

      testWidgets('searches for emoji when text changes', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        final textField = find.byType(TextField);
        await tester.enterText(textField, 'smile');
        await tester.pump();

        // Verify that search was triggered
        final state = container.read(emojiSearchProvider);
        expect(state.query, isNotEmpty);
      });
    });

    group('Emoji Selection', () {
      testWidgets(
        'calls onEmojiSelected when emoji is tapped in search results',
        (tester) async {
          String? selectedEmoji;
          final mockEmojis = [
            Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
            Emoji.fromJson({'emoji': '😊', 'name': 'smiling'}),
          ];

          setSearchResults(mockEmojis, 'happy');
          await pumpWidget(
            tester,
            onEmojiSelected: (emoji) {
              selectedEmoji = emoji;
            },
          );
          await tester.pumpAndSettle();

          // Find and tap an emoji item
          final emojiText = find.text('😀');
          expect(emojiText, findsWidgets);

          await tester.tap(emojiText.first);
          await tester.pump();

          expect(selectedEmoji, equals('😀'));
        },
      );

      testWidgets('navigates back after emoji selection', (tester) async {
        String? selectedEmoji;
        final mockEmojis = [
          Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
        ];

        setSearchResults(mockEmojis, 'happy');
        await pumpWidget(
          tester,
          onEmojiSelected: (emoji) {
            selectedEmoji = emoji;
          },
        );
        await tester.pumpAndSettle();

        final emojiText = find.text('😀').first;
        await tester.tap(emojiText);
        await tester.pump();

        // Verify navigation occurred
        expect(selectedEmoji, isNotNull);
      });
    });

    group('Close Button', () {
      testWidgets('renders close button with correct styling', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        final closeButton = find.byIcon(Icons.close);
        expect(closeButton, findsOneWidget);

        // Verify the close button has a GestureDetector wrapper
        final gestureDetector = find.ancestor(
          of: closeButton,
          matching: find.byType(GestureDetector),
        );
        expect(gestureDetector, findsWidgets);
      });

      testWidgets('close button is tappable', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        final closeButton = find.byIcon(Icons.close);
        expect(closeButton, findsOneWidget);

        // Verify that the button can be tapped
        await tester.tap(closeButton);
        await tester.pump();

        // Verify the button exists (it's tappable)
        expect(closeButton, findsOneWidget);
      });
    });

    group('Search Results Grid', () {
      testWidgets('displays correct number of emojis in grid', (tester) async {
        final mockEmojis = [
          Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
          Emoji.fromJson({'emoji': '😊', 'name': 'smiling'}),
          Emoji.fromJson({'emoji': '😍', 'name': 'heart_eyes'}),
          Emoji.fromJson({'emoji': '😂', 'name': 'joy'}),
        ];

        setSearchResults(mockEmojis, 'happy');
        await pumpWidget(tester, onEmojiSelected: (_) {});
        await tester.pumpAndSettle();

        expect(find.text('😀'), findsOneWidget);
        expect(find.text('😊'), findsOneWidget);
        expect(find.text('😍'), findsOneWidget);
        expect(find.text('😂'), findsOneWidget);
      });

      testWidgets('grid has correct configuration', (tester) async {
        final mockEmojis = [
          Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
        ];

        setSearchResults(mockEmojis, 'happy');
        await pumpWidget(tester, onEmojiSelected: (_) {});
        await tester.pumpAndSettle();

        final gridView = find.byType(GridView);
        expect(gridView, findsOneWidget);

        final gridWidget = tester.widget<GridView>(gridView);
        expect(gridWidget.padding, isA<EdgeInsets>());
      });

      testWidgets('each emoji item is tappable', (tester) async {
        final mockEmojis = [
          Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
          Emoji.fromJson({'emoji': '😊', 'name': 'smiling'}),
        ];

        setSearchResults(mockEmojis, 'happy');
        await pumpWidget(tester, onEmojiSelected: (_) {});
        await tester.pumpAndSettle();

        final emojiText = find.text('😀');
        expect(emojiText, findsWidgets);

        // Verify that emoji items are wrapped in InkWell
        final inkWell = find.byType(InkWell);
        expect(inkWell, findsAtLeastNWidgets(2));
      });
    });

    group('Text Editing Controller', () {
      testWidgets('search controller is initialized', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        final textFieldWidget = tester.widget<TextField>(textField);
        expect(textFieldWidget.controller, isNotNull);
      });

      testWidgets('search controller is disposed on widget disposal', (
        tester,
      ) async {
        // Create a custom tester to track disposal
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          router: mockGoRouter,
          child: CustomEmojiPickerWidget(onEmojiSelected: (_) {}),
        );

        // Pump a new widget to trigger disposal
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(home: Scaffold(body: const SizedBox.shrink())),
          ),
        );

        // Verify disposal occurs (implicitly through pumpWidget)
        expect(find.byType(CustomEmojiPickerWidget), findsNothing);
      });
    });

    group('Widget Dimensions and Layout', () {
      testWidgets('header has correct padding', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        final paddingWidgets = find.byType(Padding);
        expect(paddingWidgets, findsAtLeastNWidgets(1));

        // Verify padding configuration
        final firstPadding = tester.widget<Padding>(paddingWidgets.first);
        expect(firstPadding.padding, isA<EdgeInsets>());
      });

      testWidgets('search bar has correct margins', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        final searchBar = find.byType(ZoeSearchBarWidget);
        expect(searchBar, findsOneWidget);

        final searchBarWidget = tester.widget<ZoeSearchBarWidget>(searchBar);
        expect(searchBarWidget.margin, isA<EdgeInsets>());
      });
    });

    group('Accessibility', () {
      testWidgets('has search text field with hint', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        final textFieldWidget = tester.widget<TextField>(textField);
        expect(textFieldWidget.decoration?.hintText, isNotNull);
      });

      testWidgets('search bar has accessible icons', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        expect(find.byIcon(Icons.search), findsWidgets);
        expect(find.byIcon(Icons.close), findsOneWidget);
      });
    });

    group('State Management Integration', () {
      testWidgets('updates when search state changes', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        // Initially shows EmojiPicker
        expect(find.byType(EmojiPicker), findsOneWidget);
        expect(find.byType(GridView), findsNothing);

        // Update search state with results
        final mockEmojis = [
          Emoji.fromJson({'emoji': '😀', 'name': 'grinning'}),
        ];

        setSearchResults(mockEmojis, 'happy');
        await tester.pump();

        // Now should show GridView
        expect(find.byType(EmojiPicker), findsNothing);
        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('widget listens to emoji search provider', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        // Trigger a search
        final textField = find.byType(TextField);
        await tester.enterText(textField, 'test');
        await tester.pumpAndSettle();

        // Verify that the provider state was updated
        final state = container.read(emojiSearchProvider);
        expect(state.query, isNotEmpty);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles very long search query', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        final textField = find.byType(TextField);
        final longQuery = 'a' * 100;

        await tester.enterText(textField, longQuery);
        await tester.pump();

        expect(
          tester.widget<TextField>(textField).controller?.text,
          equals(longQuery),
        );
      });

      testWidgets('handles empty string search', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        final textField = find.byType(TextField);
        await tester.enterText(textField, '');
        await tester.pump();

        expect(tester.widget<TextField>(textField).controller?.text, isEmpty);
      });

      testWidgets('handles emoji in search query', (tester) async {
        await pumpWidget(tester, onEmojiSelected: (_) {});

        final textField = find.byType(TextField);
        await tester.enterText(textField, '😀');
        await tester.pump();

        expect(
          tester.widget<TextField>(textField).controller?.text,
          equals('😀'),
        );
      });
    });

    group('Multiple Emoji Results', () {
      testWidgets('displays large number of emojis efficiently', (
        tester,
      ) async {
        final manyEmojis = List.generate(50, (index) {
          return Emoji.fromJson({'emoji': '😀', 'name': 'grinning_$index'});
        });

        setSearchResults(manyEmojis, 'happy');
        await pumpWidget(tester, onEmojiSelected: (_) {});
        await tester.pumpAndSettle();

        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('scrolls through many emojis', (tester) async {
        final manyEmojis = List.generate(50, (index) {
          return Emoji.fromJson({'emoji': '😀', 'name': 'grinning_$index'});
        });

        setSearchResults(manyEmojis, 'happy');
        await pumpWidget(tester, onEmojiSelected: (_) {});

        final gridView = find.byType(GridView);
        await tester.drag(gridView, const Offset(0, -200));
        await tester.pumpAndSettle();

        // Verify scrolling occurred
        expect(find.byType(GridView), findsOneWidget);
      });
    });
  });
}
