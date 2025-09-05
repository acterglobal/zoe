import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/features/home/zoe_preview_widget.dart';
import 'package:widgetbook_workspace/features/polls/mock_poll_providers.dart';
import 'package:widgetbook_workspace/features/tasks/mock_task_providers.dart';
import 'package:widgetbook_workspace/features/events/mock_event_providers.dart';
import 'package:zoe/features/bullets/screens/bullet_detail_screen.dart';
import 'package:zoe/features/bullets/widgets/bullet_list_widget.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/documents/screens/document_preview_screen.dart';
import 'package:zoe/features/documents/screens/documents_list_screen.dart';
import 'package:zoe/features/documents/widgets/document_action_button_widget.dart';
import 'package:zoe/features/documents/widgets/document_list_widget.dart';
import 'package:zoe/features/documents/widgets/document_widget.dart';
import 'package:zoe/features/documents/widgets/unsupported_preview_widget.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/events_proivder.dart';
import 'package:zoe/features/events/screens/event_detail_screen.dart';
import 'package:zoe/features/events/screens/events_list_screen.dart';
import 'package:zoe/features/events/widgets/event_list_widget.dart';
import 'package:zoe/features/events/widgets/event_widget.dart';
import 'package:zoe/features/home/screens/home_screen.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/widgets/poll_list_widget.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/link/screens/links_list_screen.dart';
import 'package:zoe/features/link/widgets/link_list_widget.dart';
import 'package:zoe/features/link/widgets/link_widget.dart';
import 'package:zoe/features/polls/screens/poll_details_screen.dart';
import 'package:zoe/features/polls/screens/polls_list_screen.dart';
import 'package:zoe/features/polls/widgets/poll_widget.dart';
import 'package:zoe/features/quick-search/screens/quick_search_screen.dart';
import 'package:zoe/features/quick-search/widgets/quick_search_tab_section_header_widget.dart';
import 'package:zoe/features/settings/models/theme.dart';
import 'package:zoe/features/settings/providers/theme_provider.dart';
import 'package:zoe/features/settings/screens/settings_screen.dart';
import '../settings/mock_theme_providers.dart';
import 'package:zoe/features/sheet/screens/sheet_detail_screen.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/screens/task_detail_screen.dart';
import 'package:zoe/features/task/screens/tasks_list_screen.dart';
import 'package:zoe/features/task/widgets/task_item_widget.dart';
import 'package:zoe/features/task/widgets/task_list_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/features/users/widgets/user_widget.dart';


@widgetbook.UseCase(name: 'Zoe Home Screen', type: HomeScreen)
Widget buildZoeHomeScreenUseCase(BuildContext context) {
  return ZoePreview(
    child: HomeScreen()
  );
}

@widgetbook.UseCase(name: 'Settings Screen', type: SettingsScreen)
Widget buildSettingsScreenUseCase(BuildContext context) {
  final selectedTheme = context.knobs.list(
    label: 'Current Theme',
    options: AppThemeMode.values,
    initialOption: AppThemeMode.light,
  );

  return Consumer(
    builder: (context, ref, _) {
      return ProviderScope(
        overrides: [
          // Override theme provider with mock provider
          themeProvider.overrideWith((ref) => MockThemeNotifier(ref)..setTheme(selectedTheme)),
        ],
        child: ZoePreview(
          child: SettingsScreen(),
        ),
      );
    },
  );
}

@widgetbook.UseCase(name: 'Sheet Detail Screen', type: SheetDetailScreen)
Widget buildSheetDetailScreenUseCase(BuildContext context) {
  final sheetId = context.knobs.string(
    label: 'Sheet ID',
    initialValue: 'sheet-1',
  );

  return ZoePreview(child: SheetDetailScreen(sheetId: sheetId));
}

// Task
@widgetbook.UseCase(name: 'Task List Screen', type: TaskListWidget)
Widget buildTaskListScreenUseCase(BuildContext context) {
  final isEditing = context.knobs.boolean(
    label: 'Is Editing',
    description: 'Toggle edit mode',
    initialValue: false,
  );

  final shrinkWrap = context.knobs.boolean(
    label: 'Shrink Wrap',
    description: 'Whether to shrink wrap the list',
    initialValue: true,
  );

  final maxItems = context.knobs.int.input(
    label: 'Max Items',
    description: 'Maximum number of items to display',
    initialValue: 3,
  );

   return Consumer(
    builder: (context, ref, _) {
      final taskCount = context.knobs.int.input(
        label: 'Task Count',
        initialValue: 3,
      );

      final tasks = List.generate(taskCount, (index) {
        return TaskModel(
          id: 'task-$index',
          title: context.knobs.string(
            label: 'Task $index Title',
            initialValue: 'Task $index',
          ),
          dueDate: DateTime.now().add(Duration(days: index - 1)),
          isCompleted: context.knobs.boolean(
            label: 'Task $index Completed',
            initialValue: index.isEven,
          ),
          parentId: 'list-1',
          orderIndex: index,
          assignedUsers: ['user_1'],
          sheetId: '',
        );
      });


              return ProviderScope(
          overrides: [
            taskListProvider.overrideWith((ref) => MockTaskNotifier(ref)..setTasks(tasks)),
            taskProvider.overrideWith((ref, taskId) {
              final taskList = ref.watch(taskListProvider);
              return taskList.where((t) => t.id == taskId).firstOrNull;
            }),
            contentListProvider.overrideWith((ref) => []),
            contentProvider.overrideWith((ref, id) => null),
            contentListByParentIdProvider.overrideWith((ref, id) => []),
            isEditValueProvider.overrideWith((ref, id) => false),
            todaysTasksProvider.overrideWith((ref) => ref.watch(mockTodaysTasksProvider)),
            upcomingTasksProvider.overrideWith((ref) => ref.watch(mockUpcomingTasksProvider)),
            pastDueTasksProvider.overrideWith((ref) => ref.watch(mockPastDueTasksProvider)),
          ],
        child: ZoePreview(
          child: TaskListWidget(
            tasksProvider: taskListProvider,
            isEditing: isEditing,
            shrinkWrap: shrinkWrap,
            maxItems: maxItems,
          ),
        ),
      );
    },
  );
}

@widgetbook.UseCase(name: 'Task Detail Screen', type: TaskDetailScreen)
Widget buildTaskDetailScreenUseCase(BuildContext context) {
  final taskId = context.knobs.string(
    label: 'Task ID',
    initialValue: 'task-1',
  );

  final task = TaskModel(
    id: taskId,
    title: context.knobs.string(
      label: 'Task Title',
      initialValue: 'Sample Task',
    ),
    dueDate: DateTime.now(),
    isCompleted: context.knobs.boolean(
      label: 'Is Completed',
      initialValue: false,
    ),
    parentId: 'list-1',
    orderIndex: 0,
    assignedUsers: ['user_1'],
    sheetId: '',
  );

  return Consumer(
    builder: (context, ref, _) {
      return ProviderScope(
        overrides: [
          taskListProvider.overrideWith((ref) => MockTaskNotifier(ref)..setTasks([task])),
          taskProvider.overrideWith((ref, id) => id == taskId ? task : null),
          contentProvider.overrideWith((ref, id) => null),
          contentListProvider.overrideWith((ref) => const []),
        ],
        child: ZoePreview(
          child: TaskDetailScreen(taskId: taskId),
        ),
      );
    },
  );
}

@widgetbook.UseCase(name: 'Tasks List Screen', type: TasksListScreen)
Widget buildSheetWidgetUseCase(BuildContext context) {
  return ZoePreview(child: TasksListScreen());
}

@widgetbook.UseCase(name: 'Task Widget', type: TaskWidget)
Widget buildTaskWidgetUseCase(BuildContext context) {
  final taskId = context.knobs.string(
    label: 'Task ID',
    initialValue: 'task-1',
  );

  return ZoePreview(child: TaskWidget(taskId: taskId, isEditing: false));
}

// Event
@widgetbook.UseCase(name: 'Event List Widget', type: EventListWidget)
Widget buildEventListWidgetUseCase(BuildContext context) {
  final isEditing = context.knobs.boolean(
    label: 'Is Editing',
    description: 'Toggle edit mode',
    initialValue: false,
  );

  final shrinkWrap = context.knobs.boolean(
    label: 'Shrink Wrap',
    description: 'Whether to shrink wrap the list',
    initialValue: true,
  );

  final maxItems = context.knobs.int.input(
    label: 'Max Items',
    description: 'Maximum number of items to display',
    initialValue: 3,
  );

  final currentUserRsvp = context.knobs.list(
    label: 'Current User RSVP',
    options: RsvpStatus.values,
    initialOption: RsvpStatus.yes,
  );

  final rsvpYesCount = context.knobs.int.input(
    label: 'RSVP Yes Count',
    initialValue: 1,
    description: 'Number of users who RSVP\'d yes',
  );

  final totalRsvpCount = context.knobs.int.input(
    label: 'Total RSVP Count',
    initialValue: 3,
    description: 'Total number of RSVPs',
  );

  return Consumer(
    builder: (context, ref, _) {
      final eventCount = context.knobs.int.input(
        label: 'Event Count',
        initialValue: 3,
      );

      final events = List.generate(eventCount, (index) {
        final startDate = DateTime.now().add(Duration(days: index));
        return EventModel(
          id: 'event-$index',
          title: context.knobs.string(
            label: 'Event $index Title',
            initialValue: 'Event $index',
          ),
          startDate: startDate,
          endDate: startDate.add(const Duration(hours: 2)),
          parentId: 'list-1',
          orderIndex: index,
          rsvpResponses: {
            'user_1': RsvpStatus.yes,
          },
          sheetId: 'mock-sheet-1',
        );
      });

      return ProviderScope(
        overrides: [
          eventListProvider.overrideWith((ref) => MockEventNotifier()..setEvents(events)),
          eventProvider.overrideWith((ref, eventId) {
            final eventList = ref.watch(eventListProvider);
            return eventList.where((e) => e.id == eventId).firstOrNull;
          }),
          todaysEventsProvider.overrideWith((ref) => ref.watch(mockTodaysEventsProvider)),
          upcomingEventsProvider.overrideWith((ref) => ref.watch(mockUpcomingEventsProvider)),
          pastEventsProvider.overrideWith((ref) => ref.watch(mockPastEventsProvider)),
          contentListProvider.overrideWith((ref) => []),
          contentProvider.overrideWith((ref, id) => null),
          contentListByParentIdProvider.overrideWith((ref, id) => []),
          isEditValueProvider.overrideWith((ref, id) => false),
          loggedInUserProvider.overrideWith((ref) => Future.value('mock-user-id')),
          eventRsvpYesCountProvider.overrideWith((ref, id) => rsvpYesCount),
          eventTotalRsvpCountProvider.overrideWith((ref, id) => totalRsvpCount),
          eventRsvpYesUsersProvider.overrideWith((ref, id) => ['mock-user-id', 'user_1']),
          currentUserRsvpProvider.overrideWith((ref, id) => Future.value(currentUserRsvp)),
        ],
        child: ZoePreview(
          child: EventListWidget(
            eventsProvider: eventListProvider,
            isEditing: isEditing,
            shrinkWrap: shrinkWrap,
            maxItems: maxItems,
          ),
        ),
      );
    },
  );
}

@widgetbook.UseCase(name: 'Event Widget', type: EventWidget)
Widget buildEventWidgetUseCase(BuildContext context) {
  final eventId = context.knobs.string(
    label: 'Event ID',
    initialValue: 'event-1',
  );

  return ZoePreview(child: EventWidget(eventsId: eventId, isEditing: false));
}

@widgetbook.UseCase(name: 'Event List Screen', type: EventsListScreen)
Widget buildEventsListScreenUseCase(BuildContext context) {
  return ZoePreview(child: EventsListScreen());
}

@widgetbook.UseCase(name: 'Event Detail Screen', type: EventDetailScreen)
Widget buildEventDetailScreenUseCase(BuildContext context) {
  final eventId = context.knobs.string(
    label: 'Event ID',
    initialValue: 'event-1',
  );

  final currentUserRsvp = context.knobs.list(
    label: 'Current User RSVP',
    options: RsvpStatus.values,
    initialOption: RsvpStatus.yes,
  );

  final rsvpYesCount = context.knobs.int.input(
    label: 'RSVP Yes Count',
    initialValue: 1,
    description: 'Number of users who RSVP\'d yes',
  );

  final totalRsvpCount = context.knobs.int.input(
    label: 'Total RSVP Count',
    initialValue: 3,
    description: 'Total number of RSVPs',
  );

  final event = EventModel(
    id: eventId,
    title: context.knobs.string(
      label: 'Event Title',
      initialValue: 'Sample Event',
    ),
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(hours: 2)),
    parentId: 'list-1',
    orderIndex: 0,
    sheetId: 'mock-sheet-1',
    rsvpResponses: {
      'mock-user-id': currentUserRsvp,
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.no,
      'user_3': RsvpStatus.maybe,
    },
  );

  return Consumer(
    builder: (context, ref, _) {
      return ProviderScope(
        overrides: [
          eventListProvider.overrideWith((ref) => MockEventNotifier()..setEvents([event])),
          eventProvider.overrideWith((ref, id) => id == eventId ? event : null),
          contentProvider.overrideWith((ref, id) => null),
          contentListProvider.overrideWith((ref) => const []),
          contentListByParentIdProvider.overrideWith((ref, id) => []),
          isEditValueProvider.overrideWith((ref, id) => false),
          loggedInUserProvider.overrideWith((ref) => Future.value('mock-user-id')),
          eventRsvpYesCountProvider.overrideWith((ref, id) => rsvpYesCount),
          eventTotalRsvpCountProvider.overrideWith((ref, id) => totalRsvpCount),
          eventRsvpYesUsersProvider.overrideWith((ref, id) => ['mock-user-id', 'user_1']),
          currentUserRsvpProvider.overrideWith((ref, id) => Future.value(currentUserRsvp)),
        ],
        child: ZoePreview(
          child: EventDetailScreen(eventId: eventId),
        ),
      );
    },
  );
}

// Bullet
@widgetbook.UseCase(name: 'Bullet List Screen', type: BulletListWidget)
Widget buildBulletListScreenUseCase(BuildContext context) {
  final parentId = context.knobs.string(
    label: 'Parent ID',
    initialValue: 'list-bulleted-trip-1',
  );

  return ZoePreview(child: BulletListWidget(parentId: parentId, isEditing: false));
}

@widgetbook.UseCase(name: 'Bullet Detail Screen', type: BulletDetailScreen)
Widget buildBulletDetailScreenUseCase(BuildContext context) {

  final bulletId = context.knobs.string(
    label: 'Bullet ID',
    initialValue: 'bullet-trip-destinations-1',
  );

  return ZoePreview(child: BulletDetailScreen(bulletId: bulletId));
}

// Document
@widgetbook.UseCase(name: 'Document List Screen', type: DocumentListWidget)
Widget buildDocumentListScreenUseCase(BuildContext context) {
  return ZoePreview(child: DocumentListWidget(documentsProvider: documentListProvider, isEditing: false, maxItems: 3));
}

@widgetbook.UseCase(name: 'Document Widget', type: DocumentWidget)
Widget buildDocumentWidgetUseCase(BuildContext context) {
  final documentId = context.knobs.string(
    label: 'Document ID',
    initialValue: 'document-1',
  );

  return ZoePreview(child: DocumentWidget(documentId: documentId, isEditing: false));
}

@widgetbook.UseCase(name: 'Documents List Screen', type: DocumentsListScreen)
Widget buildDocumentsListScreenUseCase(BuildContext context) {
  return ZoePreview(child: DocumentsListScreen());
}

@widgetbook.UseCase(name: 'Document Detail Screen', type: DocumentPreviewScreen)
Widget buildDocumentPreviewScreenUseCase(BuildContext context) {
  final documentId = context.knobs.string(
    label: 'Document ID',
    initialValue: 'document-1',
  );

  return ZoePreview(child: DocumentPreviewScreen(documentId: documentId));
}

@widgetbook.UseCase(name: 'Unsupported Preview Widget', type: UnsupportedPreviewWidget)
Widget buildUnsupportedPreviewWidgetUseCase(BuildContext context) {
  final document = context.knobs.object.dropdown(
    label: 'Document',
    options: [
      DocumentModel(id: 'document-1', title: 'Document 1', filePath: 'document-1.pdf', parentId: '', sheetId: ''),
      DocumentModel(id: 'document-2', title: 'Document 2', filePath: 'document-2.pdf', parentId: '', sheetId: ''),
      DocumentModel(id: 'document-3', title: 'Document 3', filePath: 'document-3.pdf', parentId: '', sheetId: ''),
    ],
    labelBuilder: (document) => document.title,
  );

  return ZoePreview(child: UnsupportedPreviewWidget(document: document));
}

@widgetbook.UseCase(name: 'Document Action Button Widget', type: DocumentActionButtons)
Widget buildDocumentActionButtonWidgetUseCase(BuildContext context) {
  return ZoePreview(child: DocumentActionButtons(onDownload: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Downloading...')),
    );
  }, onShare: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing...')),
    );
  }));
}

// Link
@widgetbook.UseCase(name: 'Link List Screen', type: LinkListWidget)
Widget buildLinkListScreenUseCase(BuildContext context) {
  return ZoePreview(child: LinkListWidget(linksProvider: linkListProvider, isEditing: false, shrinkWrap: true, maxItems: 3));
}

@widgetbook.UseCase(name: 'Link Widget', type: LinkWidget)
Widget buildLinkWidgetUseCase(BuildContext context) {
  final linkId = context.knobs.string(
    label: 'Link ID',
    initialValue: 'link-1', 
  );

  return ZoePreview(child: LinkWidget(linkId: linkId, isEditing: false));
}

@widgetbook.UseCase(name: 'Links List Screen', type: LinksListScreen)
Widget buildLinksListScreenUseCase(BuildContext context) {
  return ZoePreview(child: LinksListScreen());
} 

// Quick Search
@widgetbook.UseCase(name: 'Quick Search Tab Section Header Widget', type: QuickSearchTabSectionHeaderWidget)
Widget buildQuickSearchTabSectionHeaderWidgetUseCase(BuildContext context) {
  return ZoePreview(child: QuickSearchTabSectionHeaderWidget(title: 'Quick Search', icon: Icons.search, onTap: () {}, color: Colors.blueAccent));
}

@widgetbook.UseCase(name: 'Quick Search Screen', type: QuickSearchScreen)
Widget buildQuickSearchScreenUseCase(BuildContext context) {
  return ZoePreview(child: QuickSearchScreen());
}

// Poll
@widgetbook.UseCase(name: 'Poll List Screen', type: PollListWidget)
Widget buildPollListScreenUseCase(BuildContext context) {
  final pollCount = context.knobs.int.input(
    label: 'Number of Polls',
    initialValue: 3,
    description: 'Number of polls to display',
  );

  final isEditing = context.knobs.boolean(
    label: 'Is Editing',
    description: 'Toggle edit mode',
    initialValue: false,
  );

  final polls = List.generate(pollCount, (index) {
    final status = context.knobs.list(
      label: 'Poll ${index + 1} Status',
      options: ['Not Started', 'Active', 'Completed'],
      initialOption: index == 0 ? 'Active' : (index == 1 ? 'Not Started' : 'Completed'),
    );

    final now = DateTime.now();
    DateTime? startDate;
    DateTime? endDate;

    switch (status) {
      case 'Not Started':
        startDate = now.add(const Duration(days: 1));
        endDate = now.add(const Duration(days: 7));
        break;
      case 'Active':
        startDate = now.subtract(const Duration(days: 1));
        endDate = now.add(const Duration(days: 6));
        break;
      case 'Completed':
        startDate = now.subtract(const Duration(days: 7));
        endDate = now.subtract(const Duration(days: 1));
        break;
    }

    final optionCount = context.knobs.int.input(
      label: 'Poll ${index + 1} Options',
      initialValue: 3,
      description: 'Number of options for poll ${index + 1}',
    );

    return PollModel(
      id: 'poll-$index',
      parentId: 'list-1',
      sheetId: 'mock-sheet-1',
      question: context.knobs.string(
        label: 'Poll ${index + 1} Question',
        initialValue: 'Question ${index + 1}?',
        description: 'The question for poll ${index + 1}',
      ),
      options: List.generate(optionCount, (optionIndex) {
        return PollOption(
          id: 'poll-$index-option-$optionIndex',
          title: context.knobs.string(
            label: 'Poll ${index + 1} Option ${optionIndex + 1}',
            initialValue: 'Option ${optionIndex + 1}',
            description: 'Text for option ${optionIndex + 1}',
          ),
          votes: List.generate(
            context.knobs.int.input(
              label: 'Poll ${index + 1} Option ${optionIndex + 1} Votes',
              initialValue: optionIndex == 0 ? 3 : 1,
              description: 'Number of votes for this option',
            ),
            (voteIndex) => Vote(
              userId: 'user_$voteIndex',
              createdAt: DateTime.now(),
            ),
          ),
        );
      }),
      isMultipleChoice: context.knobs.boolean(
        label: 'Poll ${index + 1} Multiple Choice',
        initialValue: false,
      ),
      startDate: startDate,
      endDate: endDate,
    );
  });

  return Consumer(
    builder: (context, ref, _) {
      return ProviderScope(
        overrides: [
          pollListProvider.overrideWith((ref) => MockPollNotifier(ref)..setPolls(polls)),
          pollProvider.overrideWith((ref, id) {
            final pollList = ref.watch(pollListProvider);
            return pollList.where((p) => p.id == id).firstOrNull;
          }),
          // Mock user providers for votes view
          usersBySheetIdProvider.overrideWith((ref, sheetId) => [
            UserModel(
              id: 'user_1',
              name: 'Test User 1',
            ),
            UserModel(
              id: 'user_2',
              name: 'Test User 2',
            ),
          ]),
          pollVotedMembersProvider.overrideWith((ref, pollId) {
            final poll = ref.watch(pollProvider(pollId));
            if (poll == null) return [];
            final members = ref.watch(usersBySheetIdProvider(poll.sheetId));
            return members.where((member) {
              return poll.options.any((option) => 
                option.votes.any((vote) => vote.userId == member.id)
              );
            }).toList();
          }),
        ],
        child: ZoePreview(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: PollListWidget(
              pollsProvider: pollListProvider,
              isEditing: isEditing,
              shrinkWrap: false, // Allow the list to handle its own scrolling
              maxItems: null, // Allow all items to be shown
            ),
          ),
        ),
      );
    },
  );
}

@widgetbook.UseCase(name: 'Poll Widget', type: PollWidget)    
Widget buildPollWidgetUseCase(BuildContext context) {
  final pollId = context.knobs.string(
    label: 'Poll ID',
    initialValue: 'poll-1',
  );

  final question = context.knobs.string(
    label: 'Question',
    initialValue: 'What is your favorite color?',
    description: 'The question to display in the poll',
  );

  final isMultipleChoice = context.knobs.boolean(
    label: 'Multiple Choice',
    description: 'Allow multiple answers',
    initialValue: false,
  );

  final optionCount = context.knobs.int.input(
    label: 'Number of Options',
    initialValue: 3,
    description: 'Number of answer options',
  );

  final options = List.generate(optionCount, (index) {
    return PollOption(
      id: 'option-$index',
      title: context.knobs.string(
        label: 'Option ${index + 1}',
        initialValue: 'Option ${index + 1}',
      ),
      votes: List.generate(
        context.knobs.int.input(
          label: 'Votes for Option ${index + 1}',
          initialValue: index == 0 ? 2 : 1,
        ),
        (voteIndex) => Vote(
          userId: 'user_$voteIndex',
          createdAt: DateTime.now(),
        ),
      ),
    );
  });

  final poll = PollModel(
    id: pollId,
    parentId: 'list-1',
    sheetId: 'mock-sheet-1',
    question: question,
    options: options,
    isMultipleChoice: isMultipleChoice,
    startDate: DateTime.now().subtract(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 6)),
  );

  return Consumer(
    builder: (context, ref, _) {
      return ProviderScope(
        overrides: [
          pollListProvider.overrideWith((ref) => MockPollNotifier(ref)..setPolls([poll])),
          pollProvider.overrideWith((ref, id) {
            final pollList = ref.watch(pollListProvider);
            return pollList.where((p) => p.id == id).firstOrNull;
          }),
          // Mock user providers for votes view
          usersBySheetIdProvider.overrideWith((ref, sheetId) => [
            UserModel(
              id: 'user_1',
              name: 'Test User 1',
            ),
            UserModel(
              id: 'user_2',
              name: 'Test User 2',
            ),
          ]),
          pollVotedMembersProvider.overrideWith((ref, pollId) {
            final poll = ref.watch(pollProvider(pollId));
            if (poll == null) return [];
            final members = ref.watch(usersBySheetIdProvider(poll.sheetId));
            return members.where((member) {
              return poll.options.any((option) => 
                option.votes.any((vote) => vote.userId == member.id)
              );
            }).toList();
          }),
        ],
        child: ZoePreview(
          child: PollWidget(pollId: pollId, isEditing: false),
        ),
      );
    },
  );
}

@widgetbook.UseCase(name: 'Polls List Screen', type: PollsListScreen)
Widget buildPollsListScreenUseCase(BuildContext context) {
  return ZoePreview(child: PollsListScreen());
}

@widgetbook.UseCase(name: 'Poll Detail Screen', type: PollDetailsScreen)
Widget buildPollDetailScreenUseCase(BuildContext context) {
  final pollId = context.knobs.string(
    label: 'Poll ID',
    initialValue: 'poll-1',
  );

  return ZoePreview(child: PollDetailsScreen(pollId: pollId));
}

// User
@widgetbook.UseCase(name: 'User Widget', type: UserWidget)
Widget buildUserWidgetUseCase(BuildContext context) {
  final userId = context.knobs.string(
    label: 'User ID',
    initialValue: 'user_1',
  );

  return ZoePreview(child: UserWidget(userId: userId));
}

