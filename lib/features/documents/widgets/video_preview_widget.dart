import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/media_controller_widget.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/utils/document_media_utils.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class VideoPreviewWidget extends ConsumerStatefulWidget {
  final DocumentModel document;

  const VideoPreviewWidget({super.key, required this.document});

  @override
  ConsumerState<VideoPreviewWidget> createState() => _VideoPreviewWidgetState();
}

class _VideoPreviewWidgetState extends ConsumerState<VideoPreviewWidget> {
  VideoPlayerController? _videoPlayerController;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    final file = File(widget.document.filePath);
    if (!file.existsSync()) return;

    final controller = VideoPlayerController.file(file);
    await controller.initialize();

    controller.addListener(() {
      if (!mounted) return;
      final value = controller.value;
      setState(() {
        _position = value.position;
        _duration = value.duration;
        _isPlaying = value.isPlaying;
      });
    });

    setState(() {
      _videoPlayerController = controller;
    });
  }

  void _togglePlayPause() {
    final controller = _videoPlayerController;
    if (controller == null || !controller.value.isInitialized) return;

    if (_isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  void _seekTo(Duration position) {
    final controller = _videoPlayerController;
    if (controller == null || !controller.value.isInitialized) return;

    final validatedPosition = DocumentMediaUtils.validateSeekPosition(position, _duration);
    controller.seekTo(validatedPosition);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: _buildVideoContainer(context, theme),
    );
  }

  Widget _buildVideoContainer(BuildContext context, ThemeData theme) {
    return GlassyContainer(
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _buildVideoContent(context, theme),
      ),
    );
  }

  Widget _buildVideoContent(BuildContext context, ThemeData theme) {
    final controller = _videoPlayerController;

    if (controller == null) {
      return GlassyContainer(
        height: 300,
        borderRadius: BorderRadius.circular(16),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing video player...'),
            ],
          ),
        ),
      );
    }

    final file = File(widget.document.filePath);
    if (!file.existsSync()) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              L10n.of(context).documentNotFound,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      );
    }

    return GlassyContainer(
      height: 320,
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
          // Video controls overlay
          Positioned(
            bottom: -10,
            left: 0,
            right: 0,
            child: MediaControllerWidget(
              isPlaying: _isPlaying,
              position: _position,
              duration: _duration,
              onPlayPause: _togglePlayPause,
              onSeekBackward: () {
                final newPosition = DocumentMediaUtils.calculateBackwardSeek(
                  _position, 
                  const Duration(seconds: 10)
                );
                _seekTo(newPosition);
              },
              onSeekForward: () {
                final newPosition = DocumentMediaUtils.calculateForwardSeek(
                  _position, 
                  const Duration(seconds: 10), 
                  _duration
                );
                _seekTo(newPosition);
              },
              onSeekTo: _seekTo,
            ),
          ),
        ],
      ),
    );
  }
}
