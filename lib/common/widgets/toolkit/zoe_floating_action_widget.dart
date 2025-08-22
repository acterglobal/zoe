import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';

class ZoeFloatingAction extends StatefulWidget {
  final IconData icon;
  final double length;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final Color shadowColor;
  final Color menuBackgroundColor;
  final Color menuForegroundColor;
  final Color menuBorderColor;
  final Color menuShadowColor;
  final VoidCallback? onShare;
  final VoidCallback? onDownload;
  final double borderRadius;
  final double elevation;
  final double iconSize;

  const ZoeFloatingAction({
    super.key,
    required this.icon,
    required this.length,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.shadowColor,
    required this.menuBackgroundColor,
    required this.menuForegroundColor,
    required this.menuBorderColor,
    required this.menuShadowColor,
    this.onShare,
    this.onDownload,
    this.borderRadius = 12.0,
    this.elevation = 6.0,
    this.iconSize = 24.0,
  });

  @override
  State<ZoeFloatingAction> createState() => _ZoeFloatingActionState();
}

class _ZoeFloatingActionState extends State<ZoeFloatingAction>
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
    return Stack(
      children: [
        // Main floating action button
        Positioned(bottom: 10, right: 0, child: _buildMainButton()),
        // Share menu item
        _buildMenu(Icons.share_rounded, 80, onTap: widget.onShare),
        // Download menu item
        _buildMenu(Icons.download_rounded, 140, onTap: widget.onDownload),
      ],
    );
  }

  Widget _buildMainButton() {
    final theme = Theme.of(context).colorScheme;

    return FloatingActionButton(
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
        backgroundColor: theme.primary,
        foregroundColor: theme.onPrimary,
        child: AnimatedRotation(
          turns: _isExpanded ? 0.125 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Icon(Icons.menu_rounded, color: AppColors.darkOnSurface),
        ),
    );
  }

  Widget _buildMenu(IconData icon, double offset, {VoidCallback? onTap}) {
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
                    primaryColor: widget.menuBackgroundColor,
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
}
