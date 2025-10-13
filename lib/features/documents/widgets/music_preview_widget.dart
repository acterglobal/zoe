import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/media_controller_widget.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/utils/document_media_utils.dart';
import 'package:zoe/features/documents/utils/media_controller_utils.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class MusicPreviewWidget extends ConsumerStatefulWidget {
  final DocumentModel document;

  const MusicPreviewWidget({super.key, required this.document});

  @override
  ConsumerState<MusicPreviewWidget> createState() => _MusicPreviewWidgetState();
}

class _MusicPreviewWidgetState extends ConsumerState<MusicPreviewWidget> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _audioPlayer.dispose();
    }
    super.dispose();
  }

  /// Audio Player Setup
  Future<void> _initializeAudioPlayer() async {
    final file = File(widget.document.filePath);
    if (!file.existsSync()) return;

    _audioPlayer = AudioPlayer();

    _audioPlayer.onPositionChanged.listen((pos) {
      if (mounted) setState(() => _position = pos);
    });

    _audioPlayer.onDurationChanged.listen((dur) {
      if (mounted) setState(() => _duration = dur);
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    await _audioPlayer.setSource(DeviceFileSource(widget.document.filePath));
    setState(() => _isInitialized = true);
  }

  /// Controls audio player
  Future<void> _togglePlayPause() async {
    if (!_isInitialized) return;

    await MediaControllerUtils.executeOperation(() async {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        if (DocumentMediaUtils.needsReset(_position, _duration)) {
          await _resetAndPlay();
        } else {
          await _audioPlayer.resume();
        }
      }
    });
  }

  Future<void> _resetAndPlay() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setSource(DeviceFileSource(widget.document.filePath));
      await _audioPlayer.resume();
      setState(() => _position = Duration.zero);
    } catch (_) {
      await _audioPlayer.resume();
    }
  }

  Future<void> _seekTo(Duration position) async {
    await MediaControllerUtils.executeOperation(() async {
      final validated = DocumentMediaUtils.validateSeekPosition(
        position,
        _duration,
      );
      await _audioPlayer.seek(validated);
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
    if (!_isInitialized) return _buildLoading(context);
    if (!File(widget.document.filePath).existsSync()) return _buildError(context);

    return _buildPlayer(context);
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
            Text(L10n.of(context).initializingAudioPlayer),
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

  Widget _buildPlayer(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.primary.withValues(alpha: 0.1),
                    theme.secondary.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Center(
                child: GlassyContainer(
                  width: 60,
                  height: 60,
                  borderRadius: BorderRadius.circular(40),
                  surfaceOpacity: 0.3,
                  borderOpacity: 0.2,
                  child: Icon(
                    Icons.music_note_rounded,
                    size: 40,
                    color: theme.primary,
                  ),
                ),
              ),
            ),
          ),
          MediaControllerWidget(
            isPlaying: _isPlaying,
            position: _position,
            duration: _duration,
            onPlayPause: _togglePlayPause,
            onSeekBackward: _seekBackward,
            onSeekForward: _seekForward,
            onSeekTo: _seekTo,
          ),
        ],
      ),
    );
  }
}
