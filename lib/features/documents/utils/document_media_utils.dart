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

  static bool needsReset(Duration position, Duration duration) {
    return position >= duration - const Duration(milliseconds: 100) ||
        position == Duration.zero;
  }
}