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
    id: 'poll-3b',
    sheetId: 'sheet-2',
    parentId: 'sheet-2',
    orderIndex: 2,
    question: 'Morning or evening flights?',
    startDate: DateTime.now().subtract(const Duration(hours: 1)),
    options: [
      PollOption(
        id: 'option-3b-1',
        title: 'Morning flights - early start, more day time',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
        ],
      ),
      PollOption(
        id: 'option-3b-2',
        title: 'Evening flights - relaxed morning, arrive at night',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
        ],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_2',
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
  PollModel(
    id: 'poll-5',
    sheetId: 'sheet-4',
    parentId: 'sheet-4',
    orderIndex: 1,
    question: 'What\'s your biggest digital organization challenge?',
    startDate: DateTime.now().subtract(const Duration(minutes: 30)),
    options: [
      PollOption(
        id: 'option-5-1',
        title: 'Endless scrolling through chat history',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
        ],
      ),
      PollOption(
        id: 'option-5-2',
        title: 'Thousands of photos with no organization',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
        ],
      ),
      PollOption(
        id: 'option-5-3',
        title: 'Important details lost in the messages',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
        ],
      ),
      PollOption(
        id: 'option-5-4',
        title: 'Multiple apps and platforms to manage',
        votes: [
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
        ],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_2',
  ),
  PollModel(
    id: 'poll-6',
    sheetId: 'sheet-5',
    parentId: 'sheet-5',
    orderIndex: 1,
    question: 'What\'s your biggest community management challenge?',
    startDate: DateTime.now().subtract(const Duration(minutes: 15)),
    options: [
      PollOption(
        id: 'option-6-1',
        title: '100+ notifications drowning out important messages',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
        ],
      ),
      PollOption(
        id: 'option-6-2',
        title: 'Important clients lost in scattered tools',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
        ],
      ),
      PollOption(
        id: 'option-6-3',
        title: 'Tasks scattered across different apps',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
        ],
      ),
      PollOption(
        id: 'option-6-4',
        title: 'Missing meetings because of poor coordination',
        votes: [
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_7'),
        ],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_3',
  ),
  PollModel(
    id: 'poll-7',
    sheetId: 'sheet-6',
    parentId: 'sheet-6',
    orderIndex: 1,
    question: 'Let\'s do Friday meet? No, Sunday? Who\'s even coming?',
    startDate: DateTime.now().subtract(const Duration(minutes: 5)),
    options: [
      PollOption(
        id: 'option-7-1',
        title: 'Friday - End the week with friends',
        votes: [
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
        ],
      ),
      PollOption(
        id: 'option-7-2',
        title: 'Sunday - Relaxed weekend vibes',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-7-3',
        title: 'Saturday - Best of both worlds',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_4'),
        ],
      ),
      PollOption(
        id: 'option-7-4',
        title: 'I\'m not coming anyway 😂',
        votes: [
          Vote(userId: 'user_8'),
        ],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_1',
  ),
  PollModel(
    id: 'poll-8',
    sheetId: 'sheet-7',
    parentId: 'sheet-7',
    orderIndex: 1,
    question: 'What\'s your biggest exhibition planning challenge?',
    startDate: DateTime.now().subtract(const Duration(minutes: 10)),
    options: [
      PollOption(
        id: 'option-8-1',
        title: 'Too many scattered tools and apps',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
          Vote(userId: 'user_9'),
        ],
      ),
      PollOption(
        id: 'option-8-2',
        title: 'Food stall coordination chaos',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
        ],
      ),
      PollOption(
        id: 'option-8-3',
        title: 'Guest list management nightmare',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-8-4',
        title: 'Stage management confusion',
        votes: [
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
          Vote(userId: 'user_9'),
        ],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_2',
  ),
  PollModel(
    id: 'poll-9',
    sheetId: 'sheet-8',
    parentId: 'sheet-8',
    orderIndex: 1,
    question: 'What\'s your biggest school fundraiser challenge?',
    startDate: DateTime.now().subtract(const Duration(minutes: 5)),
    options: [
      PollOption(
        id: 'option-9-1',
        title: 'Cupcakes everywhere - no organization!',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
          Vote(userId: 'user_9'),
        ],
      ),
      PollOption(
        id: 'option-9-2',
        title: 'Ticket lists flying around - who has what?',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-9-3',
        title: 'Volunteer signups no one tracks',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
          Vote(userId: 'user_10'),
        ],
      ),
      PollOption(
        id: 'option-9-4',
        title: 'Calendar overflowing with meetings',
        votes: [
          Vote(userId: 'user_3'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
          Vote(userId: 'user_9'),
        ],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_3',
  ),
  PollModel(
    id: 'poll-10',
    sheetId: 'sheet-9',
    parentId: 'sheet-9',
    orderIndex: 1,
    question: 'What\'s your biggest BBQ planning challenge?',
    startDate: DateTime.now().subtract(const Duration(minutes: 2)),
    options: [
      PollOption(
        id: 'option-10-1',
        title: 'Endless group chat messages',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
          Vote(userId: 'user_9'),
        ],
      ),
      PollOption(
        id: 'option-10-2',
        title: 'Equipment coordination chaos',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
          Vote(userId: 'user_10'),
        ],
      ),
      PollOption(
        id: 'option-10-3',
        title: 'Dietary restrictions management',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
          Vote(userId: 'user_9'),
        ],
      ),
      PollOption(
        id: 'option-10-4',
        title: 'Timing and scheduling confusion',
        votes: [
          Vote(userId: 'user_3'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
          Vote(userId: 'user_10'),
        ],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_4',
  ),
  PollModel(
    id: 'poll-11',
    sheetId: 'sheet-10',
    parentId: 'sheet-10',
    orderIndex: 1,
    question: 'What\'s your biggest university hangout challenge?',
    startDate: DateTime.now().subtract(const Duration(minutes: 1)),
    options: [
      PollOption(
        id: 'option-11-1',
        title: 'Different timetables and schedules',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
        ],
      ),
      PollOption(
        id: 'option-11-2',
        title: 'Nobody replies to messages',
        votes: [
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-11-3',
        title: 'Finding the right place to meet',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
        ],
      ),
      PollOption(
        id: 'option-11-4',
        title: 'Tracking who\'s actually coming',
        votes: [
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
        ],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_5',
  ),
  PollModel(
    id: 'poll-12',
    sheetId: 'sheet-11',
    parentId: 'sheet-11',
    orderIndex: 1,
    question: 'What\'s your biggest book club planning challenge?',
    startDate: DateTime.now().subtract(const Duration(minutes: 30)),
    options: [
      PollOption(
        id: 'option-12-1',
        title: 'Juggling dates and scheduling',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
        ],
      ),
      PollOption(
        id: 'option-12-2',
        title: 'Deciding who\'s hosting each month',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-12-3',
        title: 'Choosing which book to read',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_6'),
        ],
      ),
      PollOption(
        id: 'option-12-4',
        title: 'Messy chat and communication chaos',
        votes: [
          Vote(userId: 'user_3'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_7'),
          Vote(userId: 'user_8'),
        ],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_6',
  ),
  PollModel(
    id: 'poll-13',
    sheetId: 'sheet-12',
    parentId: 'sheet-12',
    orderIndex: 1,
    question: 'What\'s your biggest softball club BBQ planning challenge?',
    startDate: DateTime.now().subtract(const Duration(minutes: 15)),
    options: [
      PollOption(
        id: 'option-13-1',
        title: 'Finding a date that works for everyone',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
          Vote(userId: 'user_9'),
        ],
      ),
      PollOption(
        id: 'option-13-2',
        title: 'Everyone talking but nobody deciding',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
          Vote(userId: 'user_10'),
        ],
      ),
      PollOption(
        id: 'option-13-3',
        title: 'Endless planning with no clarity',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_9'),
        ],
      ),
      PollOption(
        id: 'option-13-4',
        title: 'Everyone missing and plan gone wrong',
        votes: [
          Vote(userId: 'user_3'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_7'),
          Vote(userId: 'user_8'),
          Vote(userId: 'user_10'),
        ],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_7',
  ),
  PollModel(
    id: 'poll-14',
    sheetId: 'sheet-13',
    parentId: 'sheet-13',
    orderIndex: 1,
    question: 'What\'s your biggest bachelorette party planning challenge?',
    startDate: DateTime.now().subtract(const Duration(minutes: 10)),
    options: [
      PollOption(
        id: 'option-14-1',
        title: 'Non-stop group chat buzzing with questions',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
        ],
      ),
      PollOption(
        id: 'option-14-2',
        title: 'Juggling dates and availability conflicts',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
        ],
      ),
      PollOption(
        id: 'option-14-3',
        title: 'No fixed budget or date decisions',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
        ],
      ),
      PollOption(
        id: 'option-14-4',
        title: 'Empty checklist and coordination chaos',
        votes: [
          Vote(userId: 'user_3'),
          Vote(userId: 'user_4'),
        ],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_8',
  ),
  PollModel(
    id: 'poll-15',
    sheetId: 'sheet-14',
    parentId: 'sheet-14',
    orderIndex: 1,
    question: 'What\'s your biggest church summer fest planning challenge?',
    startDate: DateTime.now().subtract(const Duration(minutes: 5)),
    options: [
      PollOption(
        id: 'option-15-1',
        title: 'Food coordination chaos',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
        ],
      ),
      PollOption(
        id: 'option-15-2',
        title: 'Budget planning confusion',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-15-3',
        title: 'Date scheduling conflicts',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_6'),
        ],
      ),
      PollOption(
        id: 'option-15-4',
        title: 'Equipment and setup coordination',
        votes: [
          Vote(userId: 'user_3'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_7'),
          Vote(userId: 'user_8'),
        ],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_9',
  ),
  PollModel(
    id: 'poll-16',
    sheetId: 'sheet-15',
    parentId: 'sheet-15',
    orderIndex: 1,
    question: 'What\'s your biggest PTA bake sale planning challenge?',
    startDate: DateTime.now().subtract(const Duration(minutes: 3)),
    options: [
      PollOption(
        id: 'option-16-1',
        title: 'Baking assignments and coordination chaos',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
          Vote(userId: 'user_9'),
        ],
      ),
      PollOption(
        id: 'option-16-2',
        title: 'Dietary restrictions and special needs',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
          Vote(userId: 'user_10'),
        ],
      ),
      PollOption(
        id: 'option-16-3',
        title: 'Scheduling conflicts and availability',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_9'),
        ],
      ),
      PollOption(
        id: 'option-16-4',
        title: 'Budget and payment coordination',
        votes: [
          Vote(userId: 'user_3'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_7'),
          Vote(userId: 'user_8'),
          Vote(userId: 'user_10'),
        ],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_10',
  ),
  PollModel(
    id: 'poll-17',
    sheetId: 'sheet-16',
    parentId: 'sheet-16',
    orderIndex: 1,
    question: 'What\'s your biggest Halloween planning challenge?',
    startDate: DateTime.now().subtract(const Duration(minutes: 2)),
    options: [
      PollOption(
        id: 'option-17-1',
        title: 'Location confusion and wrong streets',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
          Vote(userId: 'user_9'),
        ],
      ),
      PollOption(
        id: 'option-17-2',
        title: 'Messy group chat and unclear communication',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
          Vote(userId: 'user_10'),
        ],
      ),
      PollOption(
        id: 'option-17-3',
        title: 'Scheduling conflicts and late arrivals',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_9'),
        ],
      ),
      PollOption(
        id: 'option-17-4',
        title: 'Nobody knows where to meet or which house',
        votes: [
          Vote(userId: 'user_3'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_7'),
          Vote(userId: 'user_8'),
          Vote(userId: 'user_10'),
        ],
      ),
    ],
    isMultipleChoice: true,
    createdBy: 'user_1',
  ),
];
