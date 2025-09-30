import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/models/user_display_type.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/bullets/widgets/bullet_item_widget.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/content/widgets/add_content_widget.dart';
import 'package:zoe/features/content/widgets/content_widget.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/documents/widgets/document_widget.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/events/widgets/event_widget.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/link/widgets/link_widget.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/features/list/widgets/list_widget.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/widgets/poll_widget.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/widgets/task_item_widget.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/text/widgets/text_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class MockContent extends ContentModel {
  MockContent({
    required String super.id,
    required super.type,
    required super.title,
  }) : super(
          sheetId: 'sheet-1',
          parentId: 'parent-1',
        );
}

void main() {
  late ProviderContainer container;
  const parentId = 'parent-1';
  const sheetId = 'sheet-1';

  final mockContentList = [
    MockContent(id: 'text-1', type: ContentType.text, title: 'Text 1'),
    MockContent(id: 'event-1', type: ContentType.event, title: 'Event 1'),
    MockContent(id: 'doc-1', type: ContentType.document, title: 'Document 1'),
    MockContent(id: 'task-1', type: ContentType.task, title: 'Task 1'),
    MockContent(id: 'bullet-1', type: ContentType.bullet, title: 'Bullet 1'),
    MockContent(id: 'link-1', type: ContentType.link, title: 'Link 1'),
    MockContent(id: 'poll-1', type: ContentType.poll, title: 'Poll 1'),
    MockContent(id: 'list-1', type: ContentType.list, title: 'List 1'),
  ];

  final mockTextModel = TextModel(
    id: 'text-1',
    title: 'Text 1',
    sheetId: sheetId,
    parentId: parentId,
    description: (plainText: 'Text description', htmlText: '<p>Text description</p>'),
  );

  final mockEventModel = EventModel(
    id: 'event-1',
    title: 'Event 1',
    sheetId: sheetId,
    parentId: parentId,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(hours: 1)),
  );

  final mockDocumentModel = DocumentModel(
    id: 'doc-1',
    title: 'Document 1',
    sheetId: sheetId,
    parentId: parentId,
    filePath: 'path/to/doc.pdf',
  );

  final mockTaskModel = TaskModel(
    id: 'task-1',
    title: 'Task 1',
    sheetId: sheetId,
    parentId: parentId,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    isCompleted: false,
    assignedUsers: [],
  );

  final mockBulletModel = BulletModel(
    id: 'bullet-1',
    title: 'Bullet 1',
    sheetId: sheetId,
    parentId: parentId,
  );

  final mockLinkModel = LinkModel(
    id: 'link-1',
    title: 'Link 1',
    sheetId: sheetId,
    parentId: parentId,
    url: 'https://example.com',
  );

  final mockPollModel = PollModel(
    id: 'poll-1',
    sheetId: sheetId,
    parentId: parentId,
    options: [],
    question: 'Poll question',
  );

  final mockListModel = ListModel(
    id: 'list-1',
    title: 'List 1',
    sheetId: sheetId,
    parentId: parentId,
    listType: ContentType.bullet,
  );

  setUp(() {
    container = ProviderContainer(
      overrides: [
        contentListByParentIdProvider(parentId).overrideWithValue(mockContentList),
        editContentIdProvider.overrideWith((ref) => null),
        // Override individual content providers
        contentProvider('text-1').overrideWithValue(mockContentList[0]),
        contentProvider('event-1').overrideWithValue(mockContentList[1]),
        contentProvider('doc-1').overrideWithValue(mockContentList[2]),
        contentProvider('task-1').overrideWithValue(mockContentList[3]),
        contentProvider('bullet-1').overrideWithValue(mockContentList[4]),
        contentProvider('link-1').overrideWithValue(mockContentList[5]),
        contentProvider('poll-1').overrideWithValue(mockContentList[6]),
        contentProvider('list-1').overrideWithValue(mockContentList[7]),
        // Override type-specific providers
        textProvider('text-1').overrideWithValue(mockTextModel),
        eventProvider('event-1').overrideWithValue(mockEventModel),
        documentProvider('doc-1').overrideWithValue(mockDocumentModel),
        taskProvider('task-1').overrideWithValue(mockTaskModel),
        bulletProvider('bullet-1').overrideWithValue(mockBulletModel),
        linkProvider('link-1').overrideWithValue(mockLinkModel),
        pollProvider('poll-1').overrideWithValue(mockPollModel),
        listsProvider.overrideWithValue([mockListModel]),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  Widget buildTestWidget({
    required Widget child,
    required ProviderContainer container,
  }) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.supportedLocales,
      home: Scaffold(
        body: UncontrolledProviderScope(
          container: container,
          child: SizedBox(
            width: 800,
            height: 600,
            child: SingleChildScrollView(
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  group('ContentWidget', () {
    testWidgets('renders document section in Wrap layout', (tester) async {
      final documentsOnly = [
        MockContent(id: 'doc-1', type: ContentType.document, title: 'Document 1'),
        MockContent(id: 'doc-2', type: ContentType.document, title: 'Document 2'),
      ];

      final mockDoc2 = DocumentModel(
        id: 'doc-2',
        title: 'Document 2',
        sheetId: sheetId,
        parentId: parentId,
        filePath: 'path/to/doc2.pdf',
      );

      final documentsContainer = ProviderContainer(
        overrides: [
          contentListByParentIdProvider(parentId).overrideWithValue(documentsOnly),
          editContentIdProvider.overrideWith((ref) => null),
          contentProvider('doc-1').overrideWithValue(documentsOnly[0]),
          contentProvider('doc-2').overrideWithValue(documentsOnly[1]),
          documentProvider('doc-1').overrideWithValue(mockDocumentModel),
          documentProvider('doc-2').overrideWithValue(mockDoc2),
        ],
      );

      await tester.pumpWidget(
        buildTestWidget(
          child: const ContentWidget(
            parentId: parentId,
            sheetId: sheetId,
          ),
          container: documentsContainer,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DocumentWidget), findsNWidgets(2));
      
      // Find the first DocumentWidget and verify it's inside a Wrap
      final firstDocWidget = find.byType(DocumentWidget).first;
      expect(
        find.ancestor(
          of: firstDocWidget,
          matching: find.byType(Wrap),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders content in ListView when not editing', (tester) async {
      final nonDocumentContent = [
        MockContent(id: 'text-1', type: ContentType.text, title: 'Text 1'),
        MockContent(id: 'event-1', type: ContentType.event, title: 'Event 1'),
      ];

      final nonDocContainer = ProviderContainer(
        overrides: [
          contentListByParentIdProvider(parentId).overrideWithValue(nonDocumentContent),
          editContentIdProvider.overrideWith((ref) => null),
          contentProvider('text-1').overrideWithValue(nonDocumentContent[0]),
          contentProvider('event-1').overrideWithValue(nonDocumentContent[1]),
          textProvider('text-1').overrideWithValue(mockTextModel),
          eventProvider('event-1').overrideWithValue(mockEventModel),
        ],
      );

      await tester.pumpWidget(
        buildTestWidget(
          child: const ContentWidget(
            parentId: parentId,
            sheetId: sheetId,
          ),
          container: nonDocContainer,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ReorderableListView), findsNothing);
    });

    testWidgets('renders ReorderableListView when editing', (tester) async {
      final nonDocumentContent = [
        MockContent(id: 'text-1', type: ContentType.text, title: 'Text 1'),
        MockContent(id: 'event-1', type: ContentType.event, title: 'Event 1'),
      ];

      final editingContainer = ProviderContainer(
        overrides: [
          contentListByParentIdProvider(parentId).overrideWithValue(nonDocumentContent),
          editContentIdProvider.overrideWith((ref) => parentId),
          contentProvider('text-1').overrideWithValue(nonDocumentContent[0]),
          contentProvider('event-1').overrideWithValue(nonDocumentContent[1]),
          textProvider('text-1').overrideWithValue(mockTextModel),
          eventProvider('event-1').overrideWithValue(mockEventModel),
        ],
      );

      await tester.pumpWidget(
        buildTestWidget(
          child: const ContentWidget(
            parentId: parentId,
            sheetId: sheetId,
          ),
          container: editingContainer,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ReorderableListView), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      expect(find.byIcon(Icons.drag_indicator), findsNWidgets(2));
    });

    testWidgets('shows AddContentWidget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: const ContentWidget(
            parentId: parentId,
            sheetId: sheetId,
          ),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AddContentWidget), findsOneWidget);
    });

    testWidgets('renders all content types correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: const ContentWidget(
            parentId: parentId,
            sheetId: sheetId,
          ),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      // Verify each content type widget is rendered
      expect(find.byType(TextWidget), findsOneWidget);
      expect(find.byType(EventWidget), findsOneWidget);
      expect(find.byType(DocumentWidget), findsOneWidget);
      expect(find.byType(TaskWidget), findsOneWidget);
      expect(find.byType(BulletItemWidget), findsOneWidget);
      expect(find.byType(LinkWidget), findsOneWidget);
      expect(find.byType(PollWidget), findsOneWidget);
      expect(find.byType(ListWidget), findsOneWidget);
    });

    testWidgets('shows correct user display type for task and bullet items', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: const ContentWidget(
            parentId: parentId,
            sheetId: sheetId,
          ),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      final taskWidget = tester.widget<TaskWidget>(find.byType(TaskWidget));
      expect(taskWidget.userDisplayType, equals(ZoeUserDisplayType.nameChipsWrap));

      final bulletWidget = tester.widget<BulletItemWidget>(find.byType(BulletItemWidget));
      expect(bulletWidget.userDisplayType, equals(ZoeUserDisplayType.nameChipBelow));
    });

    testWidgets('shows sheet name when showSheetName is true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: const ContentWidget(
            parentId: parentId,
            sheetId: sheetId,
            showSheetName: true,
          ),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      final eventWidget = tester.widget<EventWidget>(find.byType(EventWidget));
      expect(eventWidget.showSheetName, isTrue);

      final taskWidget = tester.widget<TaskWidget>(find.byType(TaskWidget));
      expect(taskWidget.showSheetName, isTrue);

      final linkWidget = tester.widget<LinkWidget>(find.byType(LinkWidget));
      expect(linkWidget.showSheetName, isTrue);

      final documentWidget = tester.widget<DocumentWidget>(find.byType(DocumentWidget));
      expect(documentWidget.showSheetName, isTrue);

      final pollWidget = tester.widget<PollWidget>(find.byType(PollWidget));
      expect(pollWidget.showSheetName, isTrue);
    });

    testWidgets('hides sheet name when showSheetName is false', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: const ContentWidget(
            parentId: parentId,
            sheetId: sheetId,
            showSheetName: false,
          ),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      final eventWidget = tester.widget<EventWidget>(find.byType(EventWidget));
      expect(eventWidget.showSheetName, isFalse);

      final taskWidget = tester.widget<TaskWidget>(find.byType(TaskWidget));
      expect(taskWidget.showSheetName, isFalse);

      final linkWidget = tester.widget<LinkWidget>(find.byType(LinkWidget));
      expect(linkWidget.showSheetName, isFalse);

      final documentWidget = tester.widget<DocumentWidget>(find.byType(DocumentWidget));
      expect(documentWidget.showSheetName, isFalse);

      final pollWidget = tester.widget<PollWidget>(find.byType(PollWidget));
      expect(pollWidget.showSheetName, isFalse);
    });

    testWidgets('handles empty content list', (tester) async {
      final emptyContainer = ProviderContainer(
        overrides: [
          contentListByParentIdProvider(parentId).overrideWithValue([]),
          editContentIdProvider.overrideWith((ref) => null),
        ],
      );

      await tester.pumpWidget(
        buildTestWidget(
          child: const ContentWidget(
            parentId: parentId,
            sheetId: sheetId,
          ),
          container: emptyContainer,
        ),
      );
      await tester.pumpAndSettle();

      // Should only show AddContentWidget when list is empty
      expect(find.byType(AddContentWidget), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      expect(find.byType(Wrap), findsNothing);
    });
  });
}