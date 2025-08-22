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

  /// Video Player Setup
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

    setState(() => _videoPlayerController = controller);
  }

  /// Controls video player
  Future<void> _togglePlayPause() async {
    final controller = _videoPlayerController;
    if (controller == null || !controller.value.isInitialized) return;

    await MediaControllerUtils.executeOperation(() async {
      if (_isPlaying) {
        controller.pause();
      } else {
        if (VideoUtils.needsReset(_position, _duration)) {
          await _resetAndPlay();
        } else {
          controller.play();
        }
      }
    });
  }

  Future<void> _resetAndPlay() async {
    final controller = _videoPlayerController;
    if (controller == null) return;

    try {
      await controller.seekTo(Duration.zero);
      controller.play();
      setState(() => _position = Duration.zero);
    } catch (e) {
      controller.play();
    }
  }

  Future<void> _seekTo(Duration position) async {
    final controller = _videoPlayerController;
    if (controller == null || !controller.value.isInitialized) return;

    await MediaControllerUtils.executeOperation(() async {
      final validated = DocumentMediaUtils.validateSeekPosition(position, _duration);
      await controller.seekTo(validated);
    });
  }

  void _seekBackward() {
    _seekTo(
      DocumentMediaUtils.calculateBackwardSeek(
        _position,
        const Duration(seconds: 10),
      ),
    );
  }

  void _seekForward() {
    _seekTo(
      DocumentMediaUtils.calculateForwardSeek(
        _position,
        const Duration(seconds: 10),
        _duration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: GlassyContainer(
        borderRadius: BorderRadius.circular(20),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final controller = _videoPlayerController;

    if (controller == null) return _buildLoading(context);
    if (!File(widget.document.filePath).existsSync()) return _buildError(context);

    return _buildPlayer(controller, context);
  }

  Widget _buildLoading(BuildContext context) {
    return GlassyContainer(
      height: 300,
      borderRadius: BorderRadius.circular(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(L10n.of(context).initializingVideoPlayer),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 64, color: theme.colorScheme.error),
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

  Widget _buildPlayer(VideoPlayerController controller, BuildContext context) {
   
    return GlassyContainer(
      width: double.infinity,
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
          Positioned(
            bottom: -10,
            left: 0,
            right: 0,
            child: MediaControllerWidget(
              isPlaying: _isPlaying,
              position: _position,
              duration: _duration,
              onPlayPause: _togglePlayPause,
              onSeekBackward: _seekBackward,
              onSeekForward: _seekForward,
              onSeekTo: _seekTo,
            ),
          ),
        ],
      ),
    );
  }
}
