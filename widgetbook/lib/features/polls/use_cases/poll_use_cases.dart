import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/screens/poll_details_screen.dart';
import 'package:zoe/features/polls/screens/polls_list_screen.dart';
import 'package:zoe/features/polls/widgets/poll_list_widget.dart';
import 'package:zoe/features/polls/widgets/poll_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:widgetbook_workspace/features/polls/mock_poll_providers.dart';
import 'package:widgetbook_workspace/features/home/zoe_preview_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

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
    final status = context.knobs.object.dropdown(
      label: 'Poll \${index + 1} Status',
      options: ['Not Started', 'Active', 'Completed'],
      labelBuilder: (status) => status,
      initialOption: index == 0
          ? 'Active'
          : (index == 1 ? 'Not Started' : 'Completed'),
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
      label: 'Poll \${index + 1} Options',
      initialValue: 3,
      description: 'Number of options for poll \${index + 1}',
    );

    return PollModel(
      id: 'poll-$index',
      parentId: 'list-1',
      sheetId: 'mock-sheet-1',
      question: context.knobs.string(
        label: 'Poll \${index + 1} Question',
        initialValue: 'Question \${index + 1}?',
        description: 'The question for poll \${index + 1}',
      ),
      options: List.generate(optionCount, (optionIndex) {
        return PollOption(
          id: 'poll-$index-option-$optionIndex',
          title: context.knobs.string(
            label: 'Poll \${index + 1} Option \${optionIndex + 1}',
            initialValue: 'Option \${optionIndex + 1}',
            description: 'Text for option \${optionIndex + 1}',
          ),
          votes: List.generate(
            context.knobs.int.input(
              label: 'Poll \${index + 1} Option \${optionIndex + 1} Votes',
              initialValue: optionIndex == 0 ? 3 : 1,
              description: 'Number of votes for this option',
            ),
            (voteIndex) =>
                Vote(userId: 'user_$voteIndex', createdAt: DateTime.now()),
          ),
        );
      }),
      isMultipleChoice: context.knobs.boolean(
        label: 'Poll \${index + 1} Multiple Choice',
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
          pollListProvider.overrideWith(
            (ref) => MockPollNotifier(ref)..setPolls(polls),
          ),
          pollProvider.overrideWith((ref, id) {
            final pollList = ref.watch(pollListProvider);
            return pollList.where((p) => p.id == id).firstOrNull;
          }),
          // Mock user providers for votes view
          usersBySheetIdProvider.overrideWith(
            (ref, sheetId) => [
              UserModel(id: 'user_1', name: 'Test User 1'),
              UserModel(id: 'user_2', name: 'Test User 2'),
            ],
          ),
          pollVotedMembersProvider.overrideWith((ref, pollId) {
            final poll = ref.watch(pollProvider(pollId));
            if (poll == null) return [];
            final members = ref.watch(usersBySheetIdProvider(poll.sheetId));
            return members.where((member) {
              return poll.options.any(
                (option) =>
                    option.votes.any((vote) => vote.userId == member.id),
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
              shrinkWrap: false,
              maxItems: null,
            ),
          ),
        ),
      );
    },
  );
}

@widgetbook.UseCase(name: 'Poll Widget', type: PollWidget)
Widget buildPollWidgetUseCase(BuildContext context) {
  final pollId = context.knobs.string(label: 'Poll ID', initialValue: 'poll-1');

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
        label: 'Option \${index + 1}',
        initialValue: 'Option \${index + 1}',
      ),
      votes: List.generate(
        context.knobs.int.input(
          label: 'Votes for Option \${index + 1}',
          initialValue: index == 0 ? 2 : 1,
        ),
        (voteIndex) =>
            Vote(userId: 'user_$voteIndex', createdAt: DateTime.now()),
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
          pollListProvider.overrideWith(
            (ref) => MockPollNotifier(ref)..setPolls([poll]),
          ),
          pollProvider.overrideWith((ref, id) {
            final pollList = ref.watch(pollListProvider);
            return pollList.where((p) => p.id == id).firstOrNull;
          }),
          // Mock user providers for votes view
          usersBySheetIdProvider.overrideWith(
            (ref, sheetId) => [
              UserModel(id: 'user_1', name: 'Test User 1'),
              UserModel(id: 'user_2', name: 'Test User 2'),
            ],
          ),
          pollVotedMembersProvider.overrideWith((ref, pollId) {
            final poll = ref.watch(pollProvider(pollId));
            if (poll == null) return [];
            final members = ref.watch(usersBySheetIdProvider(poll.sheetId));
            return members.where((member) {
              return poll.options.any(
                (option) =>
                    option.votes.any((vote) => vote.userId == member.id),
              );
            }).toList();
          }),
        ],
        child: ZoePreview(child: PollWidget(pollId: pollId, isEditing: false)),
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
  final pollId = context.knobs.string(label: 'Poll ID', initialValue: 'poll-1');

  return ZoePreview(child: PollDetailsScreen(pollId: pollId));
}
