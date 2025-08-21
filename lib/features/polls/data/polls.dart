import 'package:zoe/features/polls/models/poll_model.dart';

final polls = [
  // Getting Started Guide (sheet-1) polls
  PollModel(
    id: 'poll-1',
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    orderIndex: 1,
    question: 'What feature would you like to explore first?',
    startDate: DateTime.now().subtract(const Duration(days: 1)),
    endDate: DateTime.now().subtract(
      const Duration(days: 1),
    ), // This poll is ended
    options: [
      PollOption(
        id: 'option-1-1',
        title: 'Task management and to-do lists',
        votes: [
          Vote(userId: 'user_1', createdAt: DateTime.now().subtract(const Duration(days: 1)), updatedAt: DateTime.now().subtract(const Duration(days: 1))),
        ],
      ),
      PollOption(
        id: 'option-1-2',
        title: 'Event planning and scheduling',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_3'),
        ],
      ),
      PollOption(
        id: 'option-1-3',
        title: 'Document organization',
        votes: [
          Vote(userId: 'user_4'),
          Vote(userId: 'user_5'),
        ],
      ),
      PollOption(
        id: 'option-1-4',
        title: 'Link and resource sharing',
        votes: [
          Vote(userId: 'user_6'),
        ],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_1',
  ),

  // Community Organization (sheet-2) polls
  PollModel(
    id: 'poll-community-1',
    sheetId: 'sheet-2',
    parentId: 'sheet-2',
    question: 'Which snacks should we bring for the next game?',
    startDate: DateTime.now().subtract(const Duration(days: 1)),
    endDate: DateTime.now().subtract(
      const Duration(days: 2),
    ), // This poll is ended
    orderIndex: 1,
    options: [
      PollOption(
        id: 'option-community-1-1',
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
        id: 'option-community-1-2',
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
        id: 'option-community-1-3',
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
        id: 'option-community-1-4',
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
    id: 'poll-community-2',
    sheetId: 'sheet-2',
    parentId: 'sheet-2',
    question: 'What time works best for team practice?',
    startDate: DateTime.now().subtract(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 7)),
    orderIndex: 2,
    options: [
      PollOption(
        id: 'option-community-2-1',
        title: 'Monday 4:00 PM',
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
          Vote(userId: 'user_4'),
          Vote(userId: 'user_5'),
        ],
      ),
      PollOption(
        id: 'option-community-2-2',
        title: 'Tuesday 5:00 PM',
        votes: [
          Vote(
            userId: 'user_6',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Vote(
            userId: 'user_7',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Vote(
            userId: 'user_8',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Vote(userId: 'user_9'),
          Vote(userId: 'user_10'),
        ],
      ),
      PollOption(
        id: 'option-community-2-3',
        title: 'Wednesday 4:30 PM',
        votes: [
          Vote(
            userId: 'user_2',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_4'),
        ],
      ),
      PollOption(
        id: 'option-community-2-4',
        title: 'Saturday 9:00 AM',
        votes: [
          Vote(
            userId: 'user_1',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Vote(userId: 'user_2'),
          Vote(userId: 'user_3'),
        ],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_1',
  ),

  // Inclusive Communication (sheet-3) polls
  PollModel(
    id: 'poll-inclusive-1',
    sheetId: 'sheet-3',
    parentId: 'sheet-3',
    orderIndex: 1,
    question: 'How do you prefer to receive team updates?',
    startDate: DateTime.now().subtract(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 7)),
    options: [
      PollOption(
        id: 'option-inclusive-1-1',
        title: 'Text messages',
        votes: [
          Vote(
            userId: 'user_4',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Vote(
            userId: 'user_5',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Vote(
            userId: 'user_6',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
      ),
      PollOption(
        id: 'option-inclusive-1-2',
        title: 'Email',
        votes: [
          Vote(userId: 'user_4'),
          Vote(userId: 'user_5'),
        ],
      ),
      PollOption(
        id: 'option-inclusive-1-3',
        title: 'Group chat app',
        votes: [
          Vote(userId: 'user_4'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_6'),
        ],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_3',
  ),

  // Group Trip Planning (sheet-8) polls
  PollModel(
    id: 'poll-trip-1',
    sheetId: 'sheet-8',
    parentId: 'sheet-8',
    question: 'Which cities should we visit in Japan?',
    startDate: DateTime.now().subtract(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 7)),
    orderIndex: 1,
    options: [
      PollOption(
        id: 'option-trip-1-1',
        title: 'Tokyo',
        votes: [
          Vote(userId: 'user_9'),
          Vote(userId: 'user_10'),
        ],
      ),
      PollOption(
        id: 'option-trip-1-2',
        title: 'Kyoto',
        votes: [
          Vote(userId: 'user_9'),
          Vote(userId: 'user_10'),
        ],
      ),
      PollOption(
        id: 'option-trip-1-3',
        title: 'Osaka',
        votes: [
          Vote(userId: 'user_9'),
          Vote(userId: 'user_10'),
        ],
      ),
      PollOption(
        id: 'option-trip-1-4',
        title: 'Hiroshima',
        votes: [
          Vote(userId: 'user_9'),
        ],
      ),
      PollOption(
        id: 'option-trip-1-5',
        title: 'Nara',
        votes: [
          Vote(userId: 'user_10'),
        ],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_5',
  ),

  PollModel(
    id: 'poll-trip-2',
    sheetId: 'sheet-8',
    parentId: 'sheet-8',
    question: 'What type of accommodation do you prefer?',
    startDate: DateTime.now().subtract(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 7)),
    orderIndex: 2,
    options: [
      PollOption(
        id: 'option-trip-2-1',
        title: 'Traditional ryokan',
        votes: [
          Vote(userId: 'user_9'),
          Vote(userId: 'user_10'),
        ],
      ),
      PollOption(
        id: 'option-trip-2-2',
        title: 'Modern hotel',
        votes: [
          Vote(userId: 'user_9'),
          Vote(userId: 'user_10'),
        ],
      ),
      PollOption(
        id: 'option-trip-2-3',
        title: 'Vacation rental/Airbnb',
        votes: [
          Vote(userId: 'user_9'),
          Vote(userId: 'user_10'),
        ],
      ),
      PollOption(
        id: 'option-trip-2-4',
        title: 'Hostel',
        votes: [Vote(userId: 'user_10')],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_5',
  ),

  PollModel(
    id: 'poll-test-1',
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    question: 'What is your favorite color?',
    isMultipleChoice: true,
    createdBy: 'user_1',
    options: [
      PollOption(id: 'option-test-1-1', title: 'Red'),
      PollOption(id: 'option-test-1-2', title: 'Blue'),
      PollOption(id: 'option-test-1-3', title: 'Green'),
      PollOption(id: 'option-test-1-4', title: 'Yellow'),
      PollOption(id: 'option-test-1-5', title: 'Purple'),
    ],
  ),
];
