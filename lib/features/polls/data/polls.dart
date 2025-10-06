import 'package:zoe/features/polls/models/poll_model.dart';

final polls = [
  PollModel(
    id: 'poll-1',
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    orderIndex: 1,
    question: 'What feature would you like to explore first?',
    startDate: DateTime.now().subtract(const Duration(days: 1)),
    options: [
      PollOption(id: 'option-1-1', title: 'Task management and to-do lists'),
      PollOption(
        id: 'option-1-2',
        title: 'Event planning and scheduling',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_3'),
        ],
      ),
      PollOption(id: 'option-1-3', title: 'Document organization'),
      PollOption(id: 'option-1-4', title: 'Link and resource sharing'),
    ],
    isMultipleChoice: false,
    createdBy: 'user_2',
  ),
  PollModel(
    id: 'poll-2',
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    question: 'Which snacks should we bring for the next game?',
    startDate: DateTime.now().subtract(const Duration(days: 1)),
    endDate: DateTime.now().subtract(
      const Duration(days: 2),
    ), // This poll is ended
    orderIndex: 1,
    options: [
      PollOption(
        id: 'option-2-1',
        title: 'Orange slices',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_7'),
        ],
      ),
      PollOption(
        id: 'option-2-2',
        title: 'Granola bars',
        votes: [
          Vote(
            userId: 'user_8',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Vote(
            userId: 'user_9',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Vote(
            userId: 'user_7',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
      ),
      PollOption(
        id: 'option-2-3',
        title: 'Bananas',
        votes: [
          Vote(
            userId: 'user_1',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Vote(
            userId: 'user_2',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Vote(
            userId: 'user_3',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Vote(
            userId: 'user_4',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
      ),
      PollOption(
        id: 'option-2-4',
        title: 'Trail mix',
        votes: [
          Vote(userId: 'user_5'),
          Vote(userId: 'user_6'),
        ],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_1',
  ),
  PollModel(
    id: 'poll-3',
    sheetId: 'sheet-2',
    parentId: 'sheet-2',
    orderIndex: 1,
    question: 'Which city are we going finally?',
    startDate: DateTime.now().subtract(const Duration(hours: 2)),
    options: [
      PollOption(
        id: 'option-3-1',
        title: 'Mumbai, India',
        votes: [
          Vote(userId: 'user_3'),
        ],
      ),
      PollOption(
        id: 'option-3-2',
        title: 'Delhi, India',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
        ],
      ),
      PollOption(
        id: 'option-3-3',
        title: 'Goa, India',
        votes: [
          Vote(userId: 'user_1'),
        ],
      ),
      PollOption(
        id: 'option-3-4',
        title: 'Bangalore, India',
        votes: [
          Vote(userId: 'user_3'),
          Vote(userId: 'user_4'),
        ],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_1',
  ),
  PollModel(
    id: 'poll-4',
    sheetId: 'sheet-3',
    parentId: 'sheet-3',
    orderIndex: 1,
    question: 'Is venue home or hall?',
    startDate: DateTime.now().subtract(const Duration(hours: 1)),
    options: [
      PollOption(
        id: 'option-4-1',
        title: 'Home - Cozy and intimate',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
        ],
      ),
      PollOption(
        id: 'option-4-2',
        title: 'Hall - More space for everyone',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
        ],
      ),
      PollOption(
        id: 'option-4-3',
        title: 'Community Center',
      ),
      PollOption(
        id: 'option-4-4',
        title: 'Restaurant/Party Venue',
        votes: [
          Vote(userId: 'user_3'),
        ],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_1',
  ),
];
