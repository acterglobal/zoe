class MediaControllerUtils {
  static bool _isProcessing = false;

  static bool get isProcessing => _isProcessing;

  static Future<T?> executeOperation<T>(Future<T> Function() operation) async {
    if (_isProcessing) return null;

    _isProcessing = true;
    try {
      return await operation();
    } finally {
      _isProcessing = false;
    }
  }

  static void resetProcessing() {
    _isProcessing = false;
  }
}
