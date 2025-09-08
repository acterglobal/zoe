import 'package:zoe/features/polls/models/poll_model.dart';

final polls = [
  // Getting Started Guide Polls
  PollModel(
    id: 'poll-1',
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    orderIndex: 1,
    question: 'What feature would you like to explore first?',
    startDate: DateTime.now().subtract(const Duration(days: 1)),
    endDate: DateTime.now().subtract(
      const Duration(days: 1),
    ),
    options: [
      PollOption(
        id: 'option-1-1',
        title: 'Task management and to-do lists',
        votes: [
          Vote(
            userId: 'user_1',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
            updatedAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
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
      PollOption(id: 'option-1-3', title: 'Document organization'),
      PollOption(id: 'option-1-4', title: 'Link and resource sharing'),
    ],
    isMultipleChoice: false,
    createdBy: 'user_1',
  ),

  // Mobile App Development Polls
  PollModel(
    id: 'poll-app-1',
    sheetId: 'sheet-2',
    parentId: 'sheet-2',
    orderIndex: 1,
    question: 'Which UI framework should we use?',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 7)),
    options: [
      PollOption(
        id: 'option-app-1-1',
        title: 'Material Design 3',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
        ],
      ),
      PollOption(
        id: 'option-app-1-2',
        title: 'Custom Design System',
        votes: [
          Vote(userId: 'user_3'),
        ],
      ),
      PollOption(
        id: 'option-app-1-3',
        title: 'iOS Design',
        votes: [],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_1',
  ),
  PollModel(
    id: 'poll-app-2',
    sheetId: 'sheet-2',
    parentId: 'sheet-2',
    orderIndex: 2,
    question: 'Next Sprint Focus Areas',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 2)),
    options: [
      PollOption(
        id: 'option-app-2-1',
        title: 'Performance Optimization',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
        ],
      ),
      PollOption(
        id: 'option-app-2-2',
        title: 'New Features',
        votes: [
          Vote(userId: 'user_3'),
        ],
      ),
      PollOption(
        id: 'option-app-2-3',
        title: 'Bug Fixes',
        votes: [],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_2',
  ),

  // Community Garden Polls
  PollModel(
    id: 'poll-garden-1',
    sheetId: 'sheet-3',
    parentId: 'sheet-3',
    orderIndex: 1,
    question: 'What vegetables should we plant this season?',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 5)),
    options: [
      PollOption(
        id: 'option-garden-1-1',
        title: 'Tomatoes',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
        ],
      ),
      PollOption(
        id: 'option-garden-1-2',
        title: 'Peppers',
        votes: [
          Vote(userId: 'user_3'),
        ],
      ),
      PollOption(
        id: 'option-garden-1-3',
        title: 'Herbs',
        votes: [],
      ),
      PollOption(
        id: 'option-garden-1-4',
        title: 'Root Vegetables',
        votes: [],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_1',
  ),
  PollModel(
    id: 'poll-garden-2',
    sheetId: 'sheet-3',
    parentId: 'sheet-3',
    orderIndex: 2,
    question: 'Best time for community gardening days?',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 3)),
    options: [
      PollOption(
        id: 'option-garden-2-1',
        title: 'Saturday Mornings',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
        ],
      ),
      PollOption(
        id: 'option-garden-2-2',
        title: 'Sunday Afternoons',
        votes: [
          Vote(userId: 'user_3'),
        ],
      ),
      PollOption(
        id: 'option-garden-2-3',
        title: 'Weekday Evenings',
        votes: [],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_2',
  ),
  
  // Home Renovation Polls
  PollModel(
    id: 'poll-renovation-1',
    sheetId: 'sheet-6',
    parentId: 'sheet-6',
    orderIndex: 1,
    question: 'Which kitchen cabinet style do you prefer?',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 7)),
    options: [
      PollOption(
        id: 'option-renovation-1-1',
        title: 'Modern White Shaker',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
        ],
      ),
      PollOption(
        id: 'option-renovation-1-2',
        title: 'Classic Dark Wood',
        votes: [
          Vote(userId: 'user_3'),
        ],
      ),
      PollOption(
        id: 'option-renovation-1-3',
        title: 'Contemporary High Gloss',
        votes: [],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_1',
  ),
  PollModel(
    id: 'poll-renovation-2',
    sheetId: 'sheet-6',
    parentId: 'sheet-6',
    orderIndex: 2,
    question: 'Which appliance features are most important?',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 5)),
    options: [
      PollOption(
        id: 'option-renovation-2-1',
        title: 'Energy Efficiency',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
        ],
      ),
      PollOption(
        id: 'option-renovation-2-2',
        title: 'Smart Home Integration',
        votes: [
          Vote(userId: 'user_3'),
        ],
      ),
      PollOption(
        id: 'option-renovation-2-3',
        title: 'Quiet Operation',
        votes: [
          Vote(userId: 'user_1'),
        ],
      ),
      PollOption(
        id: 'option-renovation-2-4',
        title: 'Large Capacity',
        votes: [],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_2',
  ),

  // Wedding Planning Polls
  PollModel(
    id: 'poll-wedding-1',
    sheetId: 'sheet-4',
    parentId: 'sheet-4',
    orderIndex: 1,
    question: 'Which wedding venue do you prefer?',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 7)),
    options: [
      PollOption(
        id: 'option-wedding-1-1',
        title: 'Crystal Gardens - Indoor/Outdoor',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
        ],
      ),
      PollOption(
        id: 'option-wedding-1-2',
        title: 'Grand Hotel Ballroom',
        votes: [
          Vote(userId: 'user_3'),
        ],
      ),
      PollOption(
        id: 'option-wedding-1-3',
        title: 'Lakeside Manor',
        votes: [],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_1',
  ),
  PollModel(
    id: 'poll-wedding-2',
    sheetId: 'sheet-4',
    parentId: 'sheet-4',
    orderIndex: 2,
    question: 'Preferred dinner menu options?',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 14)),
    options: [
      PollOption(
        id: 'option-wedding-2-1',
        title: 'Chicken & Fish',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
        ],
      ),
      PollOption(
        id: 'option-wedding-2-2',
        title: 'Beef & Fish',
        votes: [
          Vote(userId: 'user_3'),
        ],
      ),
      PollOption(
        id: 'option-wedding-2-3',
        title: 'Vegetarian & Fish',
        votes: [],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_1',
  ),

  // Fitness Journey Polls
  PollModel(
    id: 'poll-fitness-1',
    sheetId: 'sheet-5',
    parentId: 'sheet-5',
    orderIndex: 1,
    question: 'Preferred workout time?',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 5)),
    options: [
      PollOption(
        id: 'option-fitness-1-1',
        title: 'Early Morning (6-8 AM)',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
        ],
      ),
      PollOption(
        id: 'option-fitness-1-2',
        title: 'Lunch Break (12-2 PM)',
        votes: [
          Vote(userId: 'user_3'),
        ],
      ),
      PollOption(
        id: 'option-fitness-1-3',
        title: 'Evening (5-7 PM)',
        votes: [],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_1',
  ),
  PollModel(
    id: 'poll-fitness-2',
    sheetId: 'sheet-5',
    parentId: 'sheet-5',
    orderIndex: 2,
    question: 'Which fitness classes interest you?',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 7)),
    options: [
      PollOption(
        id: 'option-fitness-2-1',
        title: 'HIIT Training',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
        ],
      ),
      PollOption(
        id: 'option-fitness-2-2',
        title: 'Yoga & Stretching',
        votes: [
          Vote(userId: 'user_3'),
        ],
      ),
      PollOption(
        id: 'option-fitness-2-3',
        title: 'Strength Training',
        votes: [
          Vote(userId: 'user_1'),
        ],
      ),
      PollOption(
        id: 'option-fitness-2-4',
        title: 'Cardio Classes',
        votes: [],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_2',
  ),
];
