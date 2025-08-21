import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/widgets/image_preview_widget.dart';
import 'package:zoe/features/documents/widgets/music_preview_widget.dart';
import 'package:zoe/features/documents/widgets/pdf_preview_widget.dart';
import 'package:zoe/features/documents/widgets/unsupported_preview_widget.dart';
import 'package:zoe/features/documents/widgets/video_preview_widget.dart';
import 'package:zoe/features/documents/actions/select_document_actions.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class DocumentPreviewScreen extends ConsumerStatefulWidget {
  final DocumentModel document;
  final bool isEditing;
  final bool isImage;
  final bool isVideo;
  final bool isMusic;
  final bool isPdf;

  const DocumentPreviewScreen({
    super.key,
    required this.document,
    this.isEditing = false,
    this.isImage = false,
    this.isVideo = false,
    this.isMusic = false,
    this.isPdf = false,
  });

  @override
  ConsumerState<DocumentPreviewScreen> createState() =>
      _DocumentPreviewScreenState();
}

class _DocumentPreviewScreenState extends ConsumerState<DocumentPreviewScreen>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      floatingActionButton:
          widget.isImage || widget.isVideo || widget.isMusic || widget.isPdf
          ? Stack(
              children: [
                Positioned(
                  bottom: 10,
                  right: 0,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                        if (_isExpanded) {
                          _animationController.forward();
                        } else {
                          _animationController.reverse();
                        }
                      });
                    },
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    child: AnimatedRotation(
                      turns: _isExpanded ? 0.125 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.menu_rounded,
                        color: AppColors.darkOnSurface,
                      ),
                    ),
                  ),
                ),
                _buildMenu(
                  context,
                  Icons.share_rounded,
                  80,
                  onTap: () => shareDocument(context, widget.document),
                ),
                _buildMenu(
                  context,
                  Icons.download_rounded,
                  140,
                  onTap: () {
                    CommonUtils.showSnackBar(
                      context,
                      L10n.of(context).downloadingWillBeAvailableSoon,
                    );
                  },
                ),
              ],
            )
          : null,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ZoeAppBar(title: widget.document.title),
      ),
      body: _buildBody(context, theme),
    );
  }

  Widget _buildMenu(
    BuildContext context,
    IconData icon,
    double offset, {
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return Positioned(
      bottom: 10,
      right: 0,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(-_slideAnimation.value * offset, 0),
            child: Opacity(
              opacity: _scaleAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: GestureDetector(
                  onTap: onTap,
                  child: StyledIconContainer(
                    icon: icon,
                    primaryColor: theme.colorScheme.secondary,
                    size: 50,
                    iconSize: 24,
                    backgroundOpacity: 0.1,
                    borderOpacity: 0.15,
                    shadowOpacity: 0.12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme) {
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

    if (widget.isImage) {
      return ImagePreviewWidget(document: widget.document);
    }

    if (widget.isVideo) {
      return VideoPreviewWidget(document: widget.document);
    }

    if (widget.isMusic) {
      return MusicPreviewWidget(document: widget.document);
    }

    if (widget.isPdf) {
      return PdfPreviewWidget(document: widget.document);
    }

    return UnsupportedPreviewWidget(document: widget.document);
  }
}
