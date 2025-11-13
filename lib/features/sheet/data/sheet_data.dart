import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/zoe_icons.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';

final sheetList = [
  SheetModel(
    id: 'sheet-1',
    title: 'Getting Started Guide',
    sheetAvatar: SheetAvatar(
      type: AvatarType.icon,
      data: ZoeIcon.book.name,
      color: const Color(0xFF6366F1), // Indigo
    ),
    coverImageUrl:
        'https://cdn.pixabay.com/photo/2015/10/29/14/38/web-1012467_1280.jpg',
    description: (
      plainText:
          'Your complete introduction to Zoe! This interactive guide walks you through all features, includes hands-on tasks to practice with, and provides tips for organizing your digital workspace effectively. Perfect for new users to get up and running quickly.',
      htmlText:
          '<p>Your complete introduction to <strong>Zoe</strong>! This interactive guide walks you through all features, includes hands-on tasks to practice with, and provides tips for organizing your digital workspace effectively. Perfect for new users to get up and running quickly.</p>',
    ),
    createdBy: 'user_1',
    users: ['user_1', 'user_3'],
  ),
  SheetModel(
    id: 'sheet-2',
    title: 'Planning a Trip',
    sheetAvatar: SheetAvatar(
      type: AvatarType.emoji,
      data: '✈️',
      color: const Color(0xFF10B981), // Emerald
    ),
    coverImageUrl:
        'https://static.vecteezy.com/system/resources/thumbnails/070/038/514/small/a-traveler-prepares-for-an-exciting-vacation-holding-a-passport-and-tickets-while-contemplating-their-next-adventure-a-bright-yellow-suitcase-stands-ready-for-the-journey-ahead-photo.jpg',
    description: (
      plainText:
          'Our epic trip planning workspace! From  choosing the perfect destination to coordinating all the fun details. Use polls to decide on destinations, tasks to track preparations, events to schedule activities, and share all the important links and resources.',
      htmlText:
          '<p>Our epic <strong>trip planning workspace</strong>! From choosing the perfect destination to coordinating all the fun details. Use polls to decide on destinations, tasks to track preparations, events to schedule activities, and share all the important links and resources.</p>',
    ),
    createdBy: 'user_1',
    users: ['user_1', 'user_3', 'user_4'],
  ),
  SheetModel(
    id: 'sheet-3',
    title: 'Christmas Time for Joy & Celebrations',
    sheetAvatar: SheetAvatar(
      type: AvatarType.image,
      data: 'https://cdn-icons-png.flaticon.com/512/9193/9193628.png',
      color: const Color(0xFFDC2626), // Red
    ),
    coverImageUrl:
        'https://img.freepik.com/free-vector/merry-christmas-happy-new-year-background-with-realistic-gifts-composition_1361-3582.jpg?semt=ais_hybrid&w=740&q=80',
    description: (
      plainText:
          'Our festive Christmas celebration workspace! From planning the perfect party to coordinating all the holiday fun. Use polls to decide on venues, tasks to track preparations, events to schedule activities, and share all the Christmas cheer and memes.',
      htmlText:
          '<p>Our festive <strong>Christmas celebration workspace</strong>! From planning the perfect party to coordinating all the holiday fun. Use polls to decide on venues, tasks to track preparations, events to schedule activities, and share all the Christmas cheer and memes.</p>',
    ),
    createdBy: 'user_3',
    users: ['user_1', 'user_3', 'user_4', 'user_5'],
  ),
  SheetModel(
    id: 'sheet-4',
    title: 'Community Organization Hub',
    sheetAvatar: SheetAvatar(
      type: AvatarType.emoji,
      data: '🏘️',
      color: const Color(0xFF059669), // Emerald
    ),
    description: (
      plainText:
          'Your one-stop solution for community management! This workspace helps you organize 100+ notifications, scattered tools, and important clients. From organizing chat groups to tracking important clients, event planning, and task management - bring everything together so you never miss what matters.',
      htmlText:
          '<p>Your <strong>one-stop solution for community management</strong>! This workspace helps you organize 100+ notifications, scattered tools, and important clients. From organizing chat groups to tracking important clients, event planning, and task management - bring everything together so you never miss what matters.</p>',
    ),
    createdBy: 'user_1',
    users: ['user_1', 'user_3', 'user_4', 'user_5', 'user_6', 'user_7'],
  ),
  SheetModel(
    id: 'sheet-5',
    title: 'Exhibition Planning Hub',
    sheetAvatar: SheetAvatar(
      type: AvatarType.icon,
      data: ZoeIcon.palette.name,
      color: const Color(0xFF1E40AF), // Blue
    ),
    description: (
      plainText:
          'Your organized workspace for exhibition planning! This hub helps you manage papers, notes, and multiple tools that were previously scattered. From food stalls to guest lists, stage management to vendor coordination - bring everything together in one organized place.',
      htmlText:
          '<p>Your <strong>organized workspace for exhibition planning</strong>! This hub helps you manage papers, notes, and multiple tools that were previously scattered. From food stalls to guest lists, stage management to vendor coordination - bring everything together in one organized place.</p>',
    ),
    createdBy: 'user_4',
    users: [
      'user_1',
      'user_3',
      'user_4',
      'user_5',
      'user_6',
      'user_7',
      'user_8',
      'user_9',
    ],
  ),
  SheetModel(
    id: 'sheet-6',
    title: 'School Fundraiser Success Hub',
    sheetAvatar: SheetAvatar(
      type: AvatarType.image,
      data: 'https://cdn-icons-png.flaticon.com/512/11800/11800900.png',
      color: const Color(0xFFDC2626), // Red
    ),
    description: (
      plainText:
          'Your organized workspace for school fundraiser success! This hub helps you manage cupcake coordination, ticket lists, volunteer signups, and calendar overflow. Transform what should be fun from mayhem into organized success with clear coordination and planning.',
      htmlText:
          '<p>Your <strong>organized workspace for school fundraiser success</strong>! This hub helps you manage cupcake coordination, ticket lists, volunteer signups, and calendar overflow. Transform what should be fun from mayhem into organized success with clear coordination and planning.</p>',
    ),
    createdBy: 'user_5',
    users: [
      'user_1',
      'user_2',
      'user_3',
      'user_4',
      'user_5',
      'user_6',
      'user_7',
      'user_8',
      'user_9',
      'user_10',
    ],
  ),
  SheetModel(
    id: 'sheet-7',
    title: 'BBQ Planning Paradise',
    sheetAvatar: SheetAvatar(
      type: AvatarType.icon,
      data: ZoeIcon.fire.name,
      color: const Color(0xFFEA580C), // Orange
    ),
    description: (
      plainText:
          'Your organized workspace for BBQ planning paradise! This hub helps you coordinate group chat messages, equipment planning, dietary restrictions, and meeting logistics. Transform BBQ planning from total confusion into organized fun with clear coordination.',
      htmlText:
          '<p>Your <strong>organized workspace for BBQ planning paradise</strong>! This hub helps you coordinate group chat messages, equipment planning, dietary restrictions, and meeting logistics. Transform BBQ planning from total confusion into organized fun with clear coordination.</p>',
    ),
    createdBy: 'user_6',
    users: [
      'user_1',
      'user_2',
      'user_3',
      'user_4',
      'user_5',
      'user_6',
      'user_7',
      'user_8',
      'user_9',
      'user_10',
    ],
  ),
  SheetModel(
    id: 'sheet-8',
    title: 'University Hangout Hub',
    sheetAvatar: SheetAvatar(
      type: AvatarType.emoji,
      data: '🎓',
      color: const Color(0xFF7C3AED), // Purple
    ),
    description: (
      plainText:
          'Your organized workspace for university hangout coordination! This hub helps you manage different timetables, meeting places, and attendance tracking. Transform hangout planning from total chaos into organized fun with calendar, checklist, poll, and attendance management.',
      htmlText:
          '<p>Your <strong>organized workspace for university hangout coordination</strong>! This hub helps you manage different timetables, meeting places, and attendance tracking. Transform hangout planning from total chaos into organized fun with calendar, checklist, poll, and attendance management.</p>',
    ),
    createdBy: 'user_7',
    users: ['user_1', 'user_5', 'user_6', 'user_7', 'user_8'],
  ),
  SheetModel(
    id: 'sheet-9',
    title: 'Book Club Paradise',
    sheetAvatar: SheetAvatar(
      type: AvatarType.image,
      data: 'https://cdn-icons-png.flaticon.com/512/5078/5078755.png',
      color: const Color(0xFF059669), // Green
    ),
    description: (
      plainText:
          'Your organized workspace for book club paradise! This hub helps you manage monthly meeting scheduling, hosting rotation, and book selection. Transform book club planning from stressful chaos into organized fun with one place for book, task, and calendar management.',
      htmlText:
          '<p>Your <strong>organized workspace for book club paradise</strong>! This hub helps you manage monthly meeting scheduling, hosting rotation, and book selection. Transform book club planning from stressful chaos into organized fun with one place for book, task, and calendar management.</p>',
    ),
    createdBy: 'user_8',
    users: [
      'user_1',
      'user_2',
      'user_3',
      'user_4',
      'user_5',
      'user_6',
      'user_7',
      'user_8',
    ],
  ),
  SheetModel(
    id: 'sheet-10',
    title: 'Softball Club BBQ Party Hub',
    sheetAvatar: SheetAvatar(
      type: AvatarType.icon,
      data: ZoeIcon.baseball.name,
      color: const Color(0xFFDC2626), // Red
    ),
    description: (
      plainText:
          'Your organized workspace for softball club BBQ party planning! This hub helps you coordinate date finding, decision making, and attendance tracking. Transform BBQ party planning from endless confusion into organized success with clear coordination and planning.',
      htmlText:
          '<p>Your <strong>organized workspace for softball club BBQ party planning</strong>! This hub helps you coordinate date finding, decision making, and attendance tracking. Transform BBQ party planning from endless confusion into organized success with clear coordination and planning.</p>',
    ),
    createdBy: 'user_1',
    users: [
      'user_1',
      'user_2',
      'user_3',
      'user_4',
      'user_5',
      'user_6',
      'user_7',
      'user_8',
      'user_9',
      'user_10',
    ],
  ),
  SheetModel(
    id: 'sheet-11',
    title: 'Bachelorette Party Paradise',
    sheetAvatar: SheetAvatar(
      type: AvatarType.emoji,
      data: '💃',
      color: const Color(0xFFEC4899), // Pink
    ),
    description: (
      plainText:
          'Your organized workspace for bachelorette party paradise! This hub helps you manage group chat coordination, date planning, budget decisions, and activity selection. Transform bachelorette party planning from stressful chaos into organized fun with clear coordination and planning.',
      htmlText:
          '<p>Your <strong>organized workspace for bachelorette party paradise</strong>! This hub helps you manage group chat coordination, date planning, budget decisions, and activity selection. Transform bachelorette party planning from stressful chaos into organized fun with clear coordination and planning.</p>',
    ),
    createdBy: 'user_2',
    users: ['user_1', 'user_2', 'user_3', 'user_4'],
  ),
  SheetModel(
    id: 'sheet-12',
    title: 'Church Summer Fest 2026 Hub',
    sheetAvatar: SheetAvatar(
      type: AvatarType.emoji,
      data: '⛪',
      color: const Color(0xFF059669), // Green
    ),
    description: (
      plainText:
          'Your organized workspace for Church Summer Fest 2026! This hub helps you coordinate food planning, budget management, date scheduling, and equipment coordination. Transform festival planning from total chaos into organized success with clear coordination and planning.',
      htmlText:
          '<p>Your <strong>organized workspace for Church Summer Fest 2026</strong>! This hub helps you coordinate food planning, budget management, date scheduling, and equipment coordination. Transform festival planning from total chaos into organized success with clear coordination and planning.</p>',
    ),
    createdBy: 'user_3',
    users: [
      'user_1',
      'user_2',
      'user_3',
      'user_4',
      'user_5',
      'user_6',
      'user_7',
      'user_8',
    ],
  ),
  SheetModel(
    id: 'sheet-13',
    title: 'PTA Bake Sale Success Hub',
    sheetAvatar: SheetAvatar(
      type: AvatarType.icon,
      data: ZoeIcon.bread.name,
      color: const Color(0xFFDC2626), // Red
    ),
    description: (
      plainText:
          'Your organized workspace for PTA bake sale success! This hub helps you coordinate baking assignments, dietary restrictions, scheduling, budget management, and volunteer coordination. Transform bake sale planning from total chaos into organized success with clear coordination and planning.',
      htmlText:
          '<p>Your <strong>organized workspace for PTA bake sale success</strong>! This hub helps you coordinate baking assignments, dietary restrictions, scheduling, budget management, and volunteer coordination. Transform bake sale planning from total chaos into organized success with clear coordination and planning.</p>',
    ),
    createdBy: 'user_4',
    users: [
      'user_1',
      'user_2',
      'user_3',
      'user_4',
      'user_5',
      'user_6',
      'user_7',
      'user_8',
      'user_9',
      'user_10',
    ],
  ),
  SheetModel(
    id: 'sheet-14',
    title: 'Halloween Planning Spectacular Hub',
    sheetAvatar: SheetAvatar(
      type: AvatarType.image,
      data: 'https://cdn-icons-png.flaticon.com/512/12420/12420664.png',
      color: const Color(0xFF7C2D12), // Dark orange/brown
    ),
    description: (
      plainText:
          'Your organized workspace for Halloween planning spectacular! This hub helps you coordinate meeting locations, group chat organization, and attendance tracking. Transform Halloween planning from location confusion into organized fun with clear coordination and planning.',
      htmlText:
          '<p>Your <strong>organized workspace for Halloween planning spectacular</strong>! This hub helps you coordinate meeting locations, group chat organization, and attendance tracking. Transform Halloween planning from location confusion into organized fun with clear coordination and planning.</p>',
    ),
    createdBy: 'user_5',
    users: [
      'user_1',
      'user_2',
      'user_3',
      'user_4',
      'user_5',
      'user_6',
      'user_7',
      'user_8',
      'user_9',
      'user_10',
    ],
  ),
  SheetModel(
    id: 'sheet-15',
    title: 'Summer Camp Sign-ups Success Hub',
    sheetAvatar: SheetAvatar(
      type: AvatarType.emoji,
      data: '🏕️',
      color: const Color(0xFF059669), // Green
    ),
    description: (
      plainText:
          'Your organized workspace for summer camp sign-ups success! This hub helps you coordinate form management, date scheduling, payment processing, and equipment planning. Transform camp sign-up planning from stress overload into organized success with clear coordination and planning.',
      htmlText:
          '<p>Your <strong>organized workspace for summer camp sign-ups success</strong>! This hub helps you coordinate form management, date scheduling, payment processing, and equipment planning. Transform camp sign-up planning from stress overload into organized success with clear coordination and planning.</p>',
    ),
    createdBy: 'user_6',
    users: [
      'user_1',
      'user_2',
      'user_3',
      'user_4',
      'user_5',
      'user_6',
      'user_7',
      'user_8',
      'user_9',
      'user_10',
    ],
  ),
  SheetModel(
    id: 'sheet-16',
    title: 'Thanksgiving Will Not Be Terrible',
    sheetAvatar: SheetAvatar(
      type: AvatarType.icon,
      data: ZoeIcon.forkKnife.name,
      color: const Color(0xFFEA580C), // Orange
    ),
    description: (
      plainText:
          'Your organized workspace for Thanksgiving success! This hub helps you coordinate cooking assignments, family group chat management, and meal planning. Transform Thanksgiving planning from endless stress into organized success with clear coordination and planning.',
      htmlText:
          '<p>Your <strong>organized workspace for Thanksgiving success</strong>! This hub helps you coordinate cooking assignments, family group chat management, and meal planning. Transform Thanksgiving planning from endless stress into organized success with clear coordination and planning.</p>',
    ),
    createdBy: 'user_7',
    users: [
      'user_1',
      'user_2',
      'user_3',
      'user_4',
      'user_5',
      'user_6',
      'user_7',
      'user_8',
      'user_9',
      'user_10',
    ],
  ),
];
