import 'package:mocktail/mocktail.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/polls/models/poll_model.dart';

class MockSheetModel extends Mock implements SheetModel {}
class MockEventModel extends Mock implements EventModel {}
class MockTaskModel extends Mock implements TaskModel {}
class MockLinkModel extends Mock implements LinkModel {}
class MockDocumentModel extends Mock implements DocumentModel {}
class MockPollModel extends Mock implements PollModel {}
