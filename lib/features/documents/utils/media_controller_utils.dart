class MediaControllerUtils {
  static bool _isProcessing = false;

  // Runs an operation, but only if nothing else is running
  static Future<T?> executeOperation<T>(Future<T> Function() operation) async {
    if (_isProcessing) return null;

    _isProcessing = true;
    try {
      return await operation();
    } finally {
      _isProcessing = false;
    }
  }
}
