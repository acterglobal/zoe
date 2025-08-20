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


  static Duration createMockDuration({int minutes = 3, int seconds = 45}) {
    return Duration(minutes: minutes, seconds: seconds);
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
}
