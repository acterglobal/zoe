/// Common utilities for media document handling (audio/video)
class DocumentMediaUtils {
  
  static Duration calculateBackwardSeek(
    Duration currentPosition,
    Duration seekAmount,
  ) {
    final newPosition = currentPosition - seekAmount;
    return newPosition.isNegative ? Duration.zero : newPosition;
  }

  static Duration calculateForwardSeek(
    Duration currentPosition,
    Duration seekAmount,
    Duration totalDuration,
  ) {
    final newPosition = currentPosition + seekAmount;
    if (newPosition <= totalDuration) {
      return newPosition;
    } else {
      return totalDuration;
    }
  }

  static Duration validateSeekPosition(
    Duration position,
    Duration totalDuration,
  ) {
    if (position.isNegative) return Duration.zero;
    if (position > totalDuration) return totalDuration;
    return position;
  }
  
  static double calculateProgressPercentage(
    Duration position,
    Duration totalDuration,
  ) {
    if (totalDuration.inMilliseconds == 0) return 0.0;
    return (position.inMilliseconds / totalDuration.inMilliseconds).clamp(
      0.0,
      1.0,
    );
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }
}

/// Media Control Utilities
class MediaControllerUtils {
  static bool _isProcessing = false;
  
  /// Check if a media operation is currently in progress
  static bool get isProcessing => _isProcessing;
  
  /// Execute a media operation with protection against duplicates
  static Future<T?> executeOperation<T>(Future<T> Function() operation) async {
    if (_isProcessing) return null;
    
    _isProcessing = true;
    try {
      return await operation();
    } finally {
      _isProcessing = false;
    }
  }
  
  /// Reset the processing state (useful for cleanup)
  static void resetProcessing() {
    _isProcessing = false;
  }
}

/// Audio-specific utilities
class AudioUtils {
  /// Check if audio is at the end and needs reset
  static bool needsReset(Duration position, Duration duration) {
    return position >= duration - const Duration(milliseconds: 100) || 
           position == Duration.zero;
  }
  
  /// Get safe seek position for audio (avoid end positions)
  static Duration getSafeSeekPosition(Duration position, Duration duration) {
    final safeEndPosition = duration - const Duration(milliseconds: 200);
    return position > safeEndPosition ? safeEndPosition : position;
  }
}

/// Video-specific utilities
class VideoUtils {
  /// Check if video is at the end and needs reset
  static bool needsReset(Duration position, Duration duration) {
    return position >= duration - const Duration(milliseconds: 100) || 
           position == Duration.zero;
  }
  
  /// Get safe seek position for video (avoid end positions)
  static Duration getSafeSeekPosition(Duration position, Duration duration) {
    final safeEndPosition = duration - const Duration(milliseconds: 200);
    return position > safeEndPosition ? safeEndPosition : position;
  }
}
