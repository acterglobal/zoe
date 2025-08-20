import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/media_controller_widget.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/utils/document_media_utils.dart';

class MusicPreviewWidget extends ConsumerStatefulWidget {
  final DocumentModel document;

  const MusicPreviewWidget({
    super.key,
    required this.document,
  });

  @override
  ConsumerState<MusicPreviewWidget> createState() => _MusicPreviewWidgetState();
}

class _MusicPreviewWidgetState extends ConsumerState<MusicPreviewWidget> {
  // Audio player state
  AudioPlayer? _audioPlayer;
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
    _audioPlayer?.dispose();
    super.dispose();
  }

  // MARK: - Audio Player Initialization
  Future<void> _initializeAudioPlayer() async {
    final file = File(widget.document.filePath);
    if (!file.existsSync()) return;

    _audioPlayer = AudioPlayer();
    
    // Setup listeners
    _audioPlayer!.onPositionChanged.listen((Duration position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _audioPlayer!.onDurationChanged.listen((Duration duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    _audioPlayer!.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer!.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    // Load the audio file
    await _audioPlayer!.setSource(DeviceFileSource(widget.document.filePath));
    
    setState(() {
      _isInitialized = true;
    });
  }

  // MARK: - Audio Controls
  void _togglePlayPause() async {
    if (_audioPlayer != null && _isInitialized) {
      if (_isPlaying) {
        await _audioPlayer!.pause();
      } else {
        await _audioPlayer!.resume();
      }
    } else {
      // Mock mode
      setState(() {
        _isPlaying = !_isPlaying;
      });
    }
  }

  void _seekTo(Duration position) async {
    if (_audioPlayer != null && _isInitialized) {
      final validatedPosition = DocumentMediaUtils.validateSeekPosition(position, _duration);
      await _audioPlayer!.seek(validatedPosition);
    } else {
      // Mock mode
      final validatedPosition = DocumentMediaUtils.validateSeekPosition(position, _duration);
      setState(() {
        _position = validatedPosition;
      });
    }
  }

  void _seekBackward() async {
    final newPosition = DocumentMediaUtils.calculateBackwardSeek(
      _position, 
      const Duration(seconds: 10)
    );
    _seekTo(newPosition);
  }

  void _seekForward() async {
    final newPosition = DocumentMediaUtils.calculateForwardSeek(
      _position, 
      const Duration(seconds: 10), 
      _duration
    );
    _seekTo(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      child: _buildMusicContainer(context, theme),
    );
  }

  Widget _buildMusicContainer(BuildContext context, ThemeData theme) {
    return GlassyContainer(
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _buildMusicContent(context, theme),
      ),
    );
  }

  Widget _buildMusicContent(BuildContext context, ThemeData theme) {
    if (!_isInitialized) {
      return GlassyContainer(
        height: 300,
        borderRadius: BorderRadius.circular(16),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing audio player...'),
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
              'Document not found',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      );
    }

    return GlassyContainer(
      height: 300,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          // Music visualization area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                    theme.colorScheme.secondary.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Music icon
                    GlassyContainer(
                      width: 60,
                      height: 60,
                      borderRadius: BorderRadius.circular(40),
                      surfaceOpacity: 0.3,
                      borderOpacity: 0.2,
                      child: Icon(
                        Icons.music_note_rounded,
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
          // Audio controls
          MediaControllerWidget(
            isPlaying: _isPlaying,
            position: _position,
            duration: _duration,
            onPlayPause: _togglePlayPause,
            onSeekBackward: _seekBackward,
            onSeekForward: _seekForward,
            onSeekTo: _seekTo,
            title: widget.document.title,
            showTitle: true,
          ),
        ],
      ),
    );
  }

  
}
