import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_magnifier_widget.dart';
import 'package:zoe/features/content/models/content_model.dart';

/// A widget that displays an empty state with an animated character and optional content sheet
class EmptyContentTypeWidget extends StatefulWidget {
  final String message;
  final Color color;
  final ContentType? contentType;
  final IconData? icon;
  final VoidCallback? onTap;

  const EmptyContentTypeWidget({
    super.key,
    required this.message,
    required this.color,
    this.contentType,
    this.icon,
    this.onTap,
  });

  @override
  State<EmptyContentTypeWidget> createState() => _EmptyContentTypeWidgetState();
}

class _EmptyContentTypeWidgetState extends State<EmptyContentTypeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _mouthAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _mouthAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox.expand(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAnimatedArea(context),
              const SizedBox(height: 24),
              _buildMessage(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedArea(BuildContext context) {
    return SizedBox(
      height: 220,
      width: 260,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            _buildSheet(context),
            EmptyStateMagnifierWidget(
              color: widget.color,
              mouthAnimation: _mouthAnimation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSheet(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 200,
      height: 220,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: widget.color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [_buildSheetHeader(context), ..._buildContentLines()],
      ),
    );
  }

  Widget _buildSheetHeader(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: widget.color.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(
          bottom: BorderSide(
            color: widget.color.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContentLines() {
    return List.generate(
      4,
      (index) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        child: Row(
          children: [
            _buildIcon(),
            const SizedBox(width: 12),
            _buildLine(),
          ],
        ),
      ),
    );
  }

  static const Map<ContentType, IconData> _iconMap = {
    ContentType.task: Icons.task_alt_outlined,
    ContentType.event: Icons.event_rounded,
    ContentType.document: Icons.insert_drive_file_rounded,
    ContentType.link: Icons.link_rounded,
    ContentType.poll: Icons.poll_rounded,
  };

  Widget _buildIcon() {
    final iconData =
        widget.icon ?? _iconMap[widget.contentType] ?? Icons.article_rounded;
    return Icon(
      iconData,
      size: 16,
      color: widget.color.withValues(alpha: 0.2),
    );
  }

  Widget _buildLine() {
    return Expanded(
      child: Container(
        height: 10,
        decoration: BoxDecoration(
          color: widget.color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Text(
      widget.message,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    );
  }
}
