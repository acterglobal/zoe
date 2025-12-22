import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:mocktail/mocktail.dart';

/// Helper class to manage AppLinks stream without exposing StreamController
class MockAppLinks extends Mock implements AppLinks {
  final StreamController<Uri> _linkStreamController =
      StreamController<Uri>.broadcast();

  MockAppLinks() {
    when(() => getInitialLink()).thenAnswer((_) async => null);
    when(() => uriLinkStream).thenAnswer((_) => _linkStreamController.stream);
  }

  /// Emit a URI to simulate an incoming deep link
  void emitLink(Uri uri) => _linkStreamController.add(uri);

  /// Emit an error to simulate a stream error
  void emitError(Object error) => _linkStreamController.addError(error);

  /// Clean up resources
  void dispose() => _linkStreamController.close();
}
