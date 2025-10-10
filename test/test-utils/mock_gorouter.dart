import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockGoRouter extends Mock implements GoRouter {}

Future<MockGoRouter> mockAnyPushGoRouter() async {
  final mockGoRouter = MockGoRouter();
  when(() => mockGoRouter.push(any())).thenAnswer((_) async {
    return Future.value(true);
  });
  return mockGoRouter;
}
