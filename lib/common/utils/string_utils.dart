extension ExceptionObjectExtension on Object {
  /// Converts the object to a string representation.
  String convertToString() => toString().replaceAll('Exception: ', '');
}
