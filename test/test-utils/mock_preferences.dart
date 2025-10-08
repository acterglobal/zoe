import 'package:mocktail/mocktail.dart';
import 'package:zoe/core/preference_service/preferences_service.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

Future<MockPreferencesService> mockGetLoginUserId() async {
  final mockPreferencesService = MockPreferencesService();
  when(
    () => mockPreferencesService.getLoginUserId(),
  ).thenAnswer((_) async => 'user_1');
  return mockPreferencesService;
}
