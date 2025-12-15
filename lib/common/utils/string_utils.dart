extension ExceptionObjectExtension on Object {
  /// Strips 'Exception: ' prefix for user-friendly error display.
  String toErrorMessage() => toString().replaceAll('Exception: ', '');
}
