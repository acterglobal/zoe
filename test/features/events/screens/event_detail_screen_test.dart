import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:zoe/common/widgets/floating_action_button_wrapper.dart';
import 'package:zoe/common/widgets/content_menu_button.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';
import 'package:zoe/common/widgets/quill_editor/widgets/quill_editor_toolbar_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/features/content/widgets/content_widget.dart';
import 'package:zoe/features/events/data/event_list.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/quill_editor/notifiers/quill_toolbar_notifier.dart';
import 'package:zoe/features/events/screens/event_detail_screen.dart';
import 'package:zoe/features/events/widgets/event_details_additional_fields.dart';
import 'package:zoe/features/events/widgets/event_rsvp_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart' as sheet_models;
import '../../../test-utils/test_utils.dart';

void main() {
  group('EventDetailScreen', () {
    late EventModel testEvent;

    setUp(() {
      testEvent = eventList.first;
    });

    Future<ProviderContainer> pumpScreen(
      WidgetTester tester, {
      required String eventId,
      List<EventModel>? events,
      bool isEditing = false,
    }) async {
      final overrides = [
        eventListProvider.overrideWith(() => EventList()),
        editContentIdProvider.overrideWith((ref) => isEditing ? eventId : null),
      ];

      final scoped = ProviderContainer(overrides: overrides);

      await tester.pumpMaterialWidgetWithProviderScope(
        container: scoped,
        child: EventDetailScreen(eventId: eventId),
      );
      await tester.pump();

      if (events != null) {
        scoped.read(eventListProvider.notifier).state = events;
        await tester.pump();
      }
      return scoped;
    }

    testWidgets('shows empty state when event not found', (tester) async {
      await pumpScreen(
        tester,
        eventId: 'missing',
        events: [],
      );

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.byType(ZoeAppBar), findsOneWidget);
      expect(
        find.text(L10n.of(tester.element(find.byType(EmptyStateWidget))).eventNotFound),
        findsOneWidget,
      );
    });

    testWidgets('renders data layout sections and FAB', (tester) async {
      await pumpScreen(
        tester,
        eventId: testEvent.id,
        events: [testEvent],
        isEditing: false,
      );

      expect(find.byType(NotebookPaperBackgroundWidget), findsOneWidget);
      expect(find.byType(ZoeAppBar), findsOneWidget);
      expect(find.byType(MaxWidthWidget), findsOneWidget);
      expect(find.byType(EventRsvpWidget), findsOneWidget);
      expect(find.byType(ContentWidget), findsOneWidget);
      expect(find.byType(EventDetailsAdditionalFields), findsOneWidget);
      expect(find.byType(FloatingActionButtonWrapper), findsOneWidget);
      final fab = tester.widget<FloatingActionButtonWrapper>(find.byType(FloatingActionButtonWrapper));
      expect(fab.parentId, testEvent.id);
      expect(fab.sheetId, testEvent.sheetId);
    });

    testWidgets('updates title in edit mode', (tester) async {
      final eventListNotifier = EventList();
      final scoped = ProviderContainer(overrides: [
        eventListProvider.overrideWith(() => eventListNotifier),
        editContentIdProvider.overrideWith((ref) => testEvent.id),
      ]);

      await tester.pumpMaterialWidgetWithProviderScope(
        container: scoped,
        child: EventDetailScreen(eventId: testEvent.id),
      );
      await tester.pump();

      // Seed event list after provider is initialized
      scoped.read(eventListProvider.notifier).state = [testEvent];
      await tester.pump();

      final titleEditor = tester.widget<ZoeInlineTextEditWidget>(find.byType(ZoeInlineTextEditWidget));
      titleEditor.onTextChanged.call('New Title');
      await tester.pump();

      expect(
        scoped.read(eventListProvider).firstWhere((e) => e.id == testEvent.id).title,
        'New Title',
      );
    });

    testWidgets('app bar contains ContentMenuButton and tapping it does not crash', (tester) async {
      await pumpScreen(
        tester,
        eventId: testEvent.id,
        events: [testEvent],
        isEditing: false,
      );

      expect(find.byType(ContentMenuButton), findsOneWidget);
      await tester.tap(find.byType(ContentMenuButton));
      await tester.pump();
      expect(find.byType(EventDetailScreen), findsOneWidget);
    });

    testWidgets('title editor isEditing is false when not editing', (tester) async {
      await pumpScreen(
        tester,
        eventId: testEvent.id,
        events: [testEvent],
        isEditing: false,
      );
      final titleEditor = tester.widget<ZoeInlineTextEditWidget>(find.byType(ZoeInlineTextEditWidget));
      expect(titleEditor.isEditing, isFalse);
    });

    testWidgets('title editor isEditing is true when editing', (tester) async {
      await pumpScreen(
        tester,
        eventId: testEvent.id,
        events: [testEvent],
        isEditing: true,
      );
      final titleEditor = tester.widget<ZoeInlineTextEditWidget>(find.byType(ZoeInlineTextEditWidget));
      expect(titleEditor.isEditing, isTrue);
    });

    testWidgets('content widget receives correct parentId and sheetId', (tester) async {
      await pumpScreen(
        tester,
        eventId: testEvent.id,
        events: [testEvent],
      );

      final content = tester.widget<ContentWidget>(find.byType(ContentWidget));
      expect(content.parentId, testEvent.id);
      expect(content.sheetId, testEvent.sheetId);
    });

    testWidgets('html editor has correct editorId', (tester) async {
      await pumpScreen(
        tester,
        eventId: testEvent.id,
        events: [testEvent],
      );

      final htmlEditor = tester.widget<ZoeHtmlTextEditWidget>(find.byType(ZoeHtmlTextEditWidget));
      expect(htmlEditor.editorId, 'event-description-${testEvent.id}');
    });

    testWidgets('toolbar is hidden when not editing', (tester) async {
      await pumpScreen(
        tester,
        eventId: testEvent.id,
        events: [testEvent],
        isEditing: false,
      );

      // Quill toolbar should not be present because not editing
      expect(find.byType(QuillEditorToolbarWidget), findsNothing);
    });

    testWidgets('toolbar is hidden when editing but toolbar state inactive', (tester) async {
      await pumpScreen(
        tester,
        eventId: testEvent.id,
        events: [testEvent],
        isEditing: true,
      );

      // Without active controller/focus, toolbar should remain hidden
      expect(find.byType(QuillEditorToolbarWidget), findsNothing);
    });

    testWidgets('toolbar is visible when editing and toolbar state active', (tester) async {
      final controller = QuillController.basic();
      final focusNode = FocusNode();
  
      final scoped = ProviderContainer(overrides: [
        eventListProvider.overrideWith(() => EventList()),
        editContentIdProvider.overrideWith((ref) => testEvent.id),
        quillToolbarProvider.overrideWithValue((
          activeController: controller,
          activeFocusNode: focusNode,
          isToolbarVisible: true,
          activeEditorId: 'event-description-${testEvent.id}',
        )),
      ]);

      await tester.pumpMaterialWidgetWithProviderScope(
        container: scoped,
        child: EventDetailScreen(eventId: testEvent.id),
      );
      await tester.pump();

      expect(find.byType(QuillEditorToolbarWidget), findsOneWidget);

      focusNode.dispose();
    });

    testWidgets('description onContentChanged updates provider', (tester) async {
      final eventListNotifier = EventList();
      final scoped = ProviderContainer(overrides: [
        eventListProvider.overrideWith(() => eventListNotifier),
        editContentIdProvider.overrideWith((ref) => testEvent.id),
      ]);

      await tester.pumpMaterialWidgetWithProviderScope(
        container: scoped,
        child: EventDetailScreen(eventId: testEvent.id),
      );
      await tester.pump();

      final htmlEditor = tester.widget<ZoeHtmlTextEditWidget>(find.byType(ZoeHtmlTextEditWidget));
      final sheet_models.Description newDesc = (plainText: 'Plain', htmlText: '<p>HTML</p>');
      htmlEditor.onContentChanged?.call(newDesc);
      await tester.pump();

      expect(
        scoped.read(eventListProvider).firstWhere((e) => e.id == testEvent.id).description?.plainText,
        'Plain',
      );
      expect(
        scoped.read(eventListProvider).firstWhere((e) => e.id == testEvent.id).description?.htmlText,
        '<p>HTML</p>',
      );
    });
  });
}


