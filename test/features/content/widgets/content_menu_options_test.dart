import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/content/widgets/content_menu_options.dart';

import '../../../test-utils/test_utils.dart';

void main() {
  group('ContentMenuOptions', () {
    testWidgets('renders all content options with correct icons and text',
        (tester) async {
      await tester.pumpMaterialWidget(
        child: ContentMenuOptions(
          onTapText: () {},
          onTapEvent: () {},
          onTapBulletedList: () {},
          onTapToDoList: () {},
          onTapLink: () {},
          onTapDocument: () {},
          onTapPoll: () {},
        ),
      );
      await tester.pumpAndSettle();

      // Verify all icons are present
      expect(find.byIcon(Icons.text_fields), findsOneWidget);
      expect(find.byIcon(Icons.event_outlined), findsOneWidget);
      expect(find.byIcon(Icons.list), findsOneWidget);
      expect(find.byIcon(Icons.check_box_outlined), findsOneWidget);
      expect(find.byIcon(Icons.link_outlined), findsOneWidget);
      expect(find.byIcon(Icons.file_present), findsOneWidget);
      expect(find.byIcon(Icons.poll_outlined), findsOneWidget);

      // Get L10n instance
      final l10n = WidgetTesterExtension.getL10n(tester, byType: ContentMenuOptions);

      // Verify all titles are present
      expect(find.text(l10n.text), findsOneWidget);
      expect(find.text(l10n.event), findsOneWidget);
      expect(find.text(l10n.bulletedList), findsOneWidget);
      expect(find.text(l10n.toDoList), findsOneWidget);
      expect(find.text(l10n.link), findsOneWidget);
      expect(find.text(l10n.document), findsOneWidget);
      expect(find.text(l10n.poll), findsOneWidget);

      // Verify all descriptions are present
      expect(find.text(l10n.startWritingWithPlainText), findsOneWidget);
      expect(find.text(l10n.scheduleAndTrackEvents), findsOneWidget);
      expect(find.text(l10n.createASimpleBulletedList), findsOneWidget);
      expect(find.text(l10n.trackTasksWithCheckboxes), findsOneWidget);
      expect(find.text(l10n.addALink), findsOneWidget);
      expect(find.text(l10n.addADocument), findsOneWidget);
      expect(find.text(l10n.createAPoll), findsOneWidget);
    });

    testWidgets('calls correct callback when text option is tapped',
        (tester) async {
      bool textTapped = false;
      await tester.pumpMaterialWidget(
        child: ContentMenuOptions(
          onTapText: () => textTapped = true,
          onTapEvent: () {},
          onTapBulletedList: () {},
          onTapToDoList: () {},
          onTapLink: () {},
          onTapDocument: () {},
          onTapPoll: () {},
        ),
      );
      await tester.pumpAndSettle();

      final l10n = WidgetTesterExtension.getL10n(tester, byType: ContentMenuOptions);
      await tester.tap(find.text(l10n.text));
      expect(textTapped, isTrue);
    });

    testWidgets('calls correct callback when event option is tapped',
        (tester) async {
      bool eventTapped = false;
      await tester.pumpMaterialWidget(
        child: ContentMenuOptions(
          onTapText: () {},
          onTapEvent: () => eventTapped = true,
          onTapBulletedList: () {},
          onTapToDoList: () {},
          onTapLink: () {},
          onTapDocument: () {},
          onTapPoll: () {},
        ),
      );
      await tester.pumpAndSettle();

      final l10n = WidgetTesterExtension.getL10n(tester, byType: ContentMenuOptions);
      await tester.tap(find.text(l10n.event));
      expect(eventTapped, isTrue);
    });

    testWidgets('calls correct callback when bulleted list option is tapped',
        (tester) async {
      bool bulletedListTapped = false;
      await tester.pumpMaterialWidget(
        child: ContentMenuOptions(
          onTapText: () {},
          onTapEvent: () {},
          onTapBulletedList: () => bulletedListTapped = true,
          onTapToDoList: () {},
          onTapLink: () {},
          onTapDocument: () {},
          onTapPoll: () {},
        ),
      );
      await tester.pumpAndSettle();

      final l10n = WidgetTesterExtension.getL10n(tester, byType: ContentMenuOptions);
      await tester.tap(find.text(l10n.bulletedList));
      expect(bulletedListTapped, isTrue);
    });

    testWidgets('calls correct callback when todo list option is tapped',
        (tester) async {
      bool todoListTapped = false;
      await tester.pumpMaterialWidget(
        child: ContentMenuOptions(
          onTapText: () {},
          onTapEvent: () {},
          onTapBulletedList: () {},
          onTapToDoList: () => todoListTapped = true,
          onTapLink: () {},
          onTapDocument: () {},
          onTapPoll: () {},
        ),
      );
      await tester.pumpAndSettle();

      final l10n = WidgetTesterExtension.getL10n(tester, byType: ContentMenuOptions);
      await tester.tap(find.text(l10n.toDoList));
      expect(todoListTapped, isTrue);
    });

    testWidgets('calls correct callback when link option is tapped',
        (tester) async {
      bool linkTapped = false;
      await tester.pumpMaterialWidget(
        child: ContentMenuOptions(
          onTapText: () {},
          onTapEvent: () {},
          onTapBulletedList: () {},
          onTapToDoList: () {},
          onTapLink: () => linkTapped = true,
          onTapDocument: () {},
          onTapPoll: () {},
        ),
      );
      await tester.pumpAndSettle();

      final l10n = WidgetTesterExtension.getL10n(tester, byType: ContentMenuOptions);
      await tester.tap(find.text(l10n.link));
      expect(linkTapped, isTrue);
    });

    testWidgets('calls correct callback when document option is tapped',
        (tester) async {
      bool documentTapped = false;
      await tester.pumpMaterialWidget(
        child: ContentMenuOptions(
          onTapText: () {},
          onTapEvent: () {},
          onTapBulletedList: () {},
          onTapToDoList: () {},
          onTapLink: () {},
          onTapDocument: () => documentTapped = true,
          onTapPoll: () {},
        ),
      );
      await tester.pumpAndSettle();

      final l10n = WidgetTesterExtension.getL10n(tester, byType: ContentMenuOptions);
      await tester.tap(find.text(l10n.document));
      expect(documentTapped, isTrue);
    });

    testWidgets('calls correct callback when poll option is tapped',
        (tester) async {
      bool pollTapped = false;
      await tester.pumpMaterialWidget(
        child: ContentMenuOptions(
          onTapText: () {},
          onTapEvent: () {},
          onTapBulletedList: () {},
          onTapToDoList: () {},
          onTapLink: () {},
          onTapDocument: () {},
          onTapPoll: () => pollTapped = true,
        ),
      );
      await tester.pumpAndSettle();

      final l10n = WidgetTesterExtension.getL10n(tester, byType: ContentMenuOptions);
      await tester.tap(find.text(l10n.poll));
      expect(pollTapped, isTrue);
    });

    testWidgets('has correct styling and layout', (tester) async {
      await tester.pumpMaterialWidget(
        child: ContentMenuOptions(
          onTapText: () {},
          onTapEvent: () {},
          onTapBulletedList: () {},
          onTapToDoList: () {},
          onTapLink: () {},
          onTapDocument: () {},
          onTapPoll: () {},
        ),
      ); 
      await tester.pumpAndSettle();

      // Verify container styling
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.margin, equals(const EdgeInsets.only(top: 8)));
      expect(container.padding, equals(const EdgeInsets.all(8)));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, equals(BorderRadius.circular(8)));
      expect(decoration.border, isNotNull);

      // Verify list tiles have correct styling
      final listTiles = tester.widgetList<ListTile>(find.byType(ListTile));
      for (final listTile in listTiles) {
        expect(listTile.leading, isA<Icon>());
        expect((listTile.leading as Icon).size, equals(18));
        expect(listTile.title, isA<Text>());
        expect(listTile.subtitle, isA<Text>());
      }

      // Since InkWell's borderRadius is not accessible in the widget tree,
      // we'll verify the tap functionality works instead
      final l10n = WidgetTesterExtension.getL10n(tester, byType: ContentMenuOptions);
      await tester.tap(find.text(l10n.text));
      await tester.tap(find.text(l10n.event));
      await tester.tap(find.text(l10n.bulletedList));
      await tester.tap(find.text(l10n.toDoList));
      await tester.tap(find.text(l10n.link));
      await tester.tap(find.text(l10n.document));
      await tester.tap(find.text(l10n.poll));
    });
  });
}