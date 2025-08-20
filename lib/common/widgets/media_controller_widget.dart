import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';

class MediaControllerWidget extends StatelessWidget {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final VoidCallback onPlayPause;
  final VoidCallback onSeekBackward;
  final VoidCallback onSeekForward;
  final ValueChanged<Duration> onSeekTo;
  final String? title;
  final bool showTitle;

  const MediaControllerWidget({
    super.key,
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.onPlayPause,
    required this.onSeekBackward,
    required this.onSeekForward,
    required this.onSeekTo,
    this.title,
    this.showTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProgressSlider(context, theme),
          const SizedBox(height: 16),
          
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSeekButton(
                context,
                theme,
                icon: Icons.replay_10_rounded,
                onTap: onSeekBackward,
              ),
              _buildPlayPauseButton(context, theme),
              _buildSeekButton(
                context,
                theme,
                icon: Icons.forward_10_rounded,
                onTap: onSeekForward,
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Time display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeText(context, theme, position),
              _buildTimeText(context, theme, duration),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeekButton(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassyContainer(
        padding: const EdgeInsets.all(12),
        surfaceOpacity: 0.3,
        borderOpacity: 0.1,
        borderRadius: BorderRadius.circular(12),
        child: Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildPlayPauseButton(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: onPlayPause,
      child: GlassyContainer(
        padding: const EdgeInsets.all(12),
        surfaceOpacity: 0.4,
        borderOpacity: 0.15,
        borderRadius: BorderRadius.circular(12),
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: theme.colorScheme.primary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildTimeText(BuildContext context, ThemeData theme, Duration time) {
    return Text(
      _formatDuration(time),
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildProgressSlider(BuildContext context, ThemeData theme) {
    if (duration.inMilliseconds == 0) return const SizedBox.shrink();
    
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: theme.colorScheme.primary,
        inactiveTrackColor: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        thumbColor: theme.colorScheme.primary,
        overlayColor: theme.colorScheme.primary.withValues(alpha: 0.2),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      ),
      child: Slider(
        value: position.inMilliseconds.toDouble(),
        min: 0,
        max: duration.inMilliseconds.toDouble(),
        onChanged: (value) {
          onSeekTo(Duration(milliseconds: value.toInt()));
        },
        onChangeEnd: (value) {
          onSeekTo(Duration(milliseconds: value.toInt()));
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
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
