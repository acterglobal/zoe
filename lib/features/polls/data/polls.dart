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
    question: 'Which city should we visit for our trip?',
    startDate: DateTime.now().subtract(const Duration(hours: 2)),
    endDate: DateTime.now().subtract(const Duration(hours: 1)), // This poll is ended
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
    id: 'poll-2b',
    sheetId: 'sheet-2',
    parentId: 'sheet-2',
    orderIndex: 2,
    question: 'What type of accommodation do you prefer?',
    startDate: DateTime.now().subtract(const Duration(hours: 1)),
    endDate: DateTime.now().subtract(const Duration(minutes: 30)), // This poll is ended
    options: [
      PollOption(
        id: 'option-2b-1',
        title: 'Hotel - Comfort and convenience',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
        ],
      ),
      PollOption(
        id: 'option-2b-2',
        title: 'Airbnb - Home-like experience',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
        ],
      ),
      PollOption(
        id: 'option-2b-3',
        title: 'Hostel - Budget-friendly and social',
        votes: [
          Vote(userId: 'user_7'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-2b-4',
        title: 'Resort - All-inclusive luxury',
        votes: [
          Vote(userId: 'user_9'),
          Vote(userId: 'user_10'),
        ],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_2',
  ),
  PollModel(
    id: 'poll-3b',
    sheetId: 'sheet-2',
    parentId: 'sheet-2',
    orderIndex: 3,
    question: 'What time should we book our flights?',
    startDate: DateTime.now().subtract(const Duration(hours: 1)),
    endDate: DateTime.now().subtract(const Duration(minutes: 15)), // This poll is ended
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
    question: 'Where should we celebrate Christmas this year?',
    startDate: DateTime.now().subtract(const Duration(hours: 1)),
    endDate: DateTime.now().subtract(const Duration(minutes: 10)), // This poll is ended
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
    id: 'poll-4b',
    sheetId: 'sheet-3',
    parentId: 'sheet-3',
    orderIndex: 2,
    question: 'What type of Christmas dinner do you prefer?',
    startDate: DateTime.now().subtract(const Duration(minutes: 30)),
    options: [
      PollOption(
        id: 'option-4b-1',
        title: 'Traditional roast dinner',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
        ],
      ),
      PollOption(
        id: 'option-4b-2',
        title: 'Buffet style with variety',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
        ],
      ),
      PollOption(
        id: 'option-4b-3',
        title: 'Potluck with family contributions',
        votes: [
          Vote(userId: 'user_7'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-4b-4',
        title: 'Ordered catering service',
        votes: [
          Vote(userId: 'user_9'),
          Vote(userId: 'user_10'),
        ],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_4',
  ),
  PollModel(
    id: 'poll-6',
    sheetId: 'sheet-4',
    parentId: 'sheet-4',
    orderIndex: 1,
    question: 'Which communication tool works best for your community?',
    startDate: DateTime.now().subtract(const Duration(minutes: 15)),
    options: [
      PollOption(
        id: 'option-6-1',
        title: 'WhatsApp - Quick and personal',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
        ],
      ),
      PollOption(
        id: 'option-6-2',
        title: 'Slack - Organized channels and threads',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
        ],
      ),
      PollOption(
        id: 'option-6-3',
        title: 'Discord - Voice and text combined',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
        ],
      ),
      PollOption(
        id: 'option-6-4',
        title: 'Email - Formal and professional',
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
    id: 'poll-6b',
    sheetId: 'sheet-4',
    parentId: 'sheet-4',
    orderIndex: 2,
    question: 'How often should community meetings be scheduled?',
    startDate: DateTime.now().subtract(const Duration(minutes: 10)),
    options: [
      PollOption(
        id: 'option-6b-1',
        title: 'Weekly - Regular and consistent',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
        ],
      ),
      PollOption(
        id: 'option-6b-2',
        title: 'Bi-weekly - Every two weeks',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
        ],
      ),
      PollOption(
        id: 'option-6b-3',
        title: 'Monthly - Less frequent but focused',
        votes: [
          Vote(userId: 'user_7'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-6b-4',
        title: 'As needed - Flexible scheduling',
        votes: [
          Vote(userId: 'user_9'),
          Vote(userId: 'user_10'),
        ],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_4',
  ),
  PollModel(
    id: 'poll-8',
    sheetId: 'sheet-5',
    parentId: 'sheet-5',
    orderIndex: 1,
    question: 'What type of exhibition setup do you prefer?',
    startDate: DateTime.now().subtract(const Duration(minutes: 10)),
    options: [
      PollOption(
        id: 'option-8-1',
        title: 'Indoor gallery with controlled lighting',
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
        title: 'Outdoor venue with natural lighting',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
        ],
      ),
      PollOption(
        id: 'option-8-3',
        title: 'Mixed indoor-outdoor hybrid space',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-8-4',
        title: 'Pop-up or temporary exhibition space',
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
    id: 'poll-8b',
    sheetId: 'sheet-5',
    parentId: 'sheet-5',
    orderIndex: 2,
    question: 'What type of exhibition theme do you prefer?',
    startDate: DateTime.now().subtract(const Duration(minutes: 5)),
    options: [
      PollOption(
        id: 'option-8b-1',
        title: 'Contemporary art and modern pieces',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
        ],
      ),
      PollOption(
        id: 'option-8b-2',
        title: 'Traditional and classical art',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
        ],
      ),
      PollOption(
        id: 'option-8b-3',
        title: 'Interactive and multimedia displays',
        votes: [
          Vote(userId: 'user_7'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-8b-4',
        title: 'Mixed media and diverse collection',
        votes: [
          Vote(userId: 'user_9'),
          Vote(userId: 'user_10'),
        ],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_3',
  ),
  PollModel(
    id: 'poll-9',
    sheetId: 'sheet-6',
    parentId: 'sheet-6',
    orderIndex: 1,
    question: 'What type of school fundraiser do you prefer?',
    startDate: DateTime.now().subtract(const Duration(minutes: 5)),
    options: [
      PollOption(
        id: 'option-9-1',
        title: 'Bake sale with homemade treats',
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
        title: 'Silent auction with donated items',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-9-3',
        title: 'Carnival or fun fair with games',
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
        title: 'Online crowdfunding campaign',
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
    sheetId: 'sheet-7',
    parentId: 'sheet-7',
    orderIndex: 1,
    question: 'What type of BBQ setup do you prefer?',
    startDate: DateTime.now().subtract(const Duration(minutes: 2)),
    options: [
      PollOption(
        id: 'option-10-1',
        title: 'Backyard grill setup',
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
        title: 'Park or beach BBQ',
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
        title: 'Indoor grill or kitchen cooking',
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
        title: 'Professional catering service',
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
    sheetId: 'sheet-8',
    parentId: 'sheet-8',
    orderIndex: 1,
    question: 'What type of university hangout do you prefer?',
    startDate: DateTime.now().subtract(const Duration(minutes: 1)),
    options: [
      PollOption(
        id: 'option-11-1',
        title: 'Campus coffee shop or café',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
        ],
      ),
      PollOption(
        id: 'option-11-2',
        title: 'Library study area or quiet space',
        votes: [
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-11-3',
        title: 'Student center or common area',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
        ],
      ),
      PollOption(
        id: 'option-11-4',
        title: 'Off-campus restaurant or bar',
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
    sheetId: 'sheet-9',
    parentId: 'sheet-9',
    orderIndex: 1,
    question: 'What type of book club meeting do you prefer?',
    startDate: DateTime.now().subtract(const Duration(minutes: 30)),
    options: [
      PollOption(
        id: 'option-12-1',
        title: 'In-person meetings at someone\'s home',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
        ],
      ),
      PollOption(
        id: 'option-12-2',
        title: 'Virtual meetings via video call',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-12-3',
        title: 'Café or library meetings',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_6'),
        ],
      ),
      PollOption(
        id: 'option-12-4',
        title: 'Hybrid meetings (in-person + virtual)',
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
    sheetId: 'sheet-10',
    parentId: 'sheet-10',
    orderIndex: 1,
    question: 'What type of softball club BBQ do you prefer?',
    startDate: DateTime.now().subtract(const Duration(minutes: 15)),
    options: [
      PollOption(
        id: 'option-13-1',
        title: 'Traditional BBQ with burgers and hot dogs',
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
        title: 'Grilled chicken and vegetable skewers',
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
        title: 'Potluck style with everyone bringing dishes',
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
        title: 'Catered BBQ with professional service',
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
    sheetId: 'sheet-11',
    parentId: 'sheet-11',
    orderIndex: 1,
    question: 'What type of bachelorette party do you prefer?',
    startDate: DateTime.now().subtract(const Duration(minutes: 10)),
    options: [
      PollOption(
        id: 'option-14-1',
        title: 'Weekend getaway to a destination city',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
        ],
      ),
      PollOption(
        id: 'option-14-2',
        title: 'Local night out with dinner and dancing',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
        ],
      ),
      PollOption(
        id: 'option-14-3',
        title: 'Spa day with relaxation and pampering',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
        ],
      ),
      PollOption(
        id: 'option-14-4',
        title: 'Home party with games and activities',
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
    sheetId: 'sheet-12',
    parentId: 'sheet-12',
    orderIndex: 1,
    question: 'What type of church summer fest do you prefer?',
    startDate: DateTime.now().subtract(const Duration(minutes: 5)),
    options: [
      PollOption(
        id: 'option-15-1',
        title: 'Traditional church festival with food stalls',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
        ],
      ),
      PollOption(
        id: 'option-15-2',
        title: 'Community picnic with games and activities',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-15-3',
        title: 'Charity fundraiser with raffle and auctions',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_6'),
        ],
      ),
      PollOption(
        id: 'option-15-4',
        title: 'Simple potluck with music and fellowship',
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
    sheetId: 'sheet-13',
    parentId: 'sheet-13',
    orderIndex: 1,
    question: 'What type of PTA bake sale do you prefer?',
    startDate: DateTime.now().subtract(const Duration(minutes: 3)),
    options: [
      PollOption(
        id: 'option-16-1',
        title: 'Traditional bake sale with homemade goods',
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
        title: 'Pre-packaged and store-bought items',
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
        title: 'Online bake sale with delivery',
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
        title: 'Combined bake sale and craft fair',
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
    sheetId: 'sheet-14',
    parentId: 'sheet-14',
    orderIndex: 1,
    question: 'What type of Halloween celebration do you prefer?',
    startDate: DateTime.now().subtract(const Duration(minutes: 2)),
    options: [
      PollOption(
        id: 'option-17-1',
        title: 'House party with friends',
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
        title: 'Trick-or-treating in neighborhood',
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
        title: 'Halloween movie night',
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
        title: 'Costume party at a venue',
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
  PollModel(
    id: 'poll-17b',
    sheetId: 'sheet-14',
    parentId: 'sheet-14',
    orderIndex: 2,
    question: 'What type of Halloween costume do you prefer?',
    startDate: DateTime.now().subtract(const Duration(minutes: 1)),
    options: [
      PollOption(
        id: 'option-17b-1',
        title: 'Scary and spooky costumes',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
        ],
      ),
      PollOption(
        id: 'option-17b-2',
        title: 'Funny and creative costumes',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
        ],
      ),
      PollOption(
        id: 'option-17b-3',
        title: 'Movie or TV character costumes',
        votes: [
          Vote(userId: 'user_7'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-17b-4',
        title: 'Simple and comfortable costumes',
        votes: [
          Vote(userId: 'user_9'),
          Vote(userId: 'user_10'),
        ],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_2',
  ),
  PollModel(
    id: 'poll-18',
    sheetId: 'sheet-15',
    parentId: 'sheet-15',
    orderIndex: 1,
    question: 'What type of summer camp do you prefer?',
    startDate: DateTime.now().subtract(const Duration(minutes: 1)),
    options: [
      PollOption(
        id: 'option-18-1',
        title: 'Day camp with daily activities',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
          Vote(userId: 'user_9'),
        ],
      ),
      PollOption(
        id: 'option-18-2',
        title: 'Overnight camp with full immersion',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
          Vote(userId: 'user_10'),
        ],
      ),
      PollOption(
        id: 'option-18-3',
        title: 'Weekend camp with short sessions',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_9'),
        ],
      ),
      PollOption(
        id: 'option-18-4',
        title: 'Virtual or online camp experience',
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
    createdBy: 'user_2',
  ),
  PollModel(
    id: 'poll-18b',
    sheetId: 'sheet-15',
    parentId: 'sheet-15',
    orderIndex: 2,
    question: 'What type of summer camp activities do you prefer?',
    startDate: DateTime.now().subtract(const Duration(minutes: 1)),
    options: [
      PollOption(
        id: 'option-18b-1',
        title: 'Outdoor adventure and sports',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
        ],
      ),
      PollOption(
        id: 'option-18b-2',
        title: 'Arts and crafts activities',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
        ],
      ),
      PollOption(
        id: 'option-18b-3',
        title: 'Educational and learning programs',
        votes: [
          Vote(userId: 'user_7'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-18b-4',
        title: 'Mixed activities and variety',
        votes: [
          Vote(userId: 'user_9'),
          Vote(userId: 'user_10'),
        ],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_3',
  ),
  PollModel(
    id: 'poll-19',
    sheetId: 'sheet-16',
    parentId: 'sheet-16',
    orderIndex: 1,
    question: 'What type of Thanksgiving dinner do you prefer?',
    startDate: DateTime.now().subtract(const Duration(minutes: 1)),
    options: [
      PollOption(
        id: 'option-19-1',
        title: 'Traditional home-cooked meal',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_7'),
          Vote(userId: 'user_9'),
        ],
      ),
      PollOption(
        id: 'option-19-2',
        title: 'Potluck style with everyone contributing',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_8'),
          Vote(userId: 'user_10'),
        ],
      ),
      PollOption(
        id: 'option-19-3',
        title: 'Restaurant or catering service',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_2'),
          Vote(userId: 'user_5'),
          Vote(userId: 'user_6'),
          Vote(userId: 'user_9'),
        ],
      ),
      PollOption(
        id: 'option-19-4',
        title: 'Simple and minimal celebration',
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
    createdBy: 'user_3',
  ),
  PollModel(
    id: 'poll-19b',
    sheetId: 'sheet-16',
    parentId: 'sheet-16',
    orderIndex: 2,
    question: 'What type of Thanksgiving dessert do you prefer?',
    startDate: DateTime.now().subtract(const Duration(minutes: 1)),
    options: [
      PollOption(
        id: 'option-19b-1',
        title: 'Traditional pumpkin pie',
        votes: [
          Vote(userId: 'user_1'),
          Vote(userId: 'user_3'),
          Vote(userId: 'user_5'),
        ],
      ),
      PollOption(
        id: 'option-19b-2',
        title: 'Apple pie with cinnamon',
        votes: [
          Vote(userId: 'user_2'),
          Vote(userId: 'user_4'),
          Vote(userId: 'user_6'),
        ],
      ),
      PollOption(
        id: 'option-19b-3',
        title: 'Chocolate-based desserts',
        votes: [
          Vote(userId: 'user_7'),
          Vote(userId: 'user_8'),
        ],
      ),
      PollOption(
        id: 'option-19b-4',
        title: 'Assorted dessert platter',
        votes: [
          Vote(userId: 'user_9'),
          Vote(userId: 'user_10'),
        ],
      ),
    ],
    isMultipleChoice: false,
    createdBy: 'user_4',
  ),
];
