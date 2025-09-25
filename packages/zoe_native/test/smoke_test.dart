import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:zoe_native/zoe_native.dart';

// Surely, you can use Mockito or whatever other mocking packages
class MockRustLibApi extends Mock implements RustLibApi {}

class MockClientBuilder extends Mock implements ClientBuilder {}

Future<void> main() async {
  // this ensures the dart types are fine and we ca  mock
  // the API without any issues
  final mockApi = MockRustLibApi();
  when(
    () => mockApi.zoeClientClientClientBuilder(),
  ).thenAnswer((_) async => MockClientBuilder());

  RustLib.initMock(api: mockApi);

  test('can mock Rust calls', () async {
    await Client.builder();
  });
}
