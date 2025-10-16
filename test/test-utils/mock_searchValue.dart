import 'package:zoe/common/providers/common_providers.dart';

class MockSearchValue extends SearchValue {
  @override
  String build() => '';

  @override
  void update(String value) {
    state = value;
  }
}
