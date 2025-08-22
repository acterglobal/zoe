import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/features/documents/utils/document_media_utils.dart';

class MediaControllerWidget extends StatelessWidget {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final VoidCallback onPlayPause;
  final VoidCallback onSeekBackward;
  final VoidCallback onSeekForward;
  final ValueChanged<Duration> onSeekTo;

  const MediaControllerWidget({
    super.key,
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.onPlayPause,
    required this.onSeekBackward,
    required this.onSeekForward,
    required this.onSeekTo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProgressSlider(context),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeText(context, position),
              _buildTimeText(context, duration),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSeekButton(
                context,
                Icons.replay_10_rounded,
                onSeekBackward,
              ),
              _buildPlayPauseButton(context),
              _buildSeekButton(
                context,
                Icons.forward_10_rounded,
                onSeekForward,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeekButton(
    BuildContext context,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GlassyContainer(
      padding: const EdgeInsets.all(12),
      surfaceOpacity: 0.5,
      borderOpacity: 0.1,
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 24),
    );
  }

  Widget _buildPlayPauseButton(BuildContext context) {
    return GlassyContainer(
      padding: const EdgeInsets.all(12),
      surfaceOpacity: 0.5,
      borderOpacity: 0.15,
      borderRadius: BorderRadius.circular(12),
      onTap: onPlayPause,
      child: Icon(
        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        color: Theme.of(context).colorScheme.onSurface,
        size: 24,
      ),
    );
  }

  Widget _buildTimeText(BuildContext context, Duration time) {
    final theme = Theme.of(context);
    return Text(
      DocumentMediaUtils.formatDuration(time),
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildProgressSlider(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    if (duration.inMilliseconds == 0) return const SizedBox.shrink();

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: theme.primary,
        inactiveTrackColor: theme.onSurface.withValues(alpha: 0.3),
        thumbColor: theme.primary,
        overlayColor: theme.primary.withValues(alpha: 0.2),
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
}
