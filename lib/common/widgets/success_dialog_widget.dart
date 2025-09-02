import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/l10n/generated/l10n.dart';

/// Shows a modern success dialog with animations
Future<void> showSuccessDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? buttonText,
  VoidCallback? onButtonPressed,
  IconData? customIcon,
  bool useSafeArea = true,
  bool barrierDismissible = true,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    useSafeArea: useSafeArea,
    builder: (context) => SuccessDialogWidget(
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      customIcon: customIcon,
    ),
  );
}

class SuccessDialogWidget extends StatefulWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final IconData? customIcon;

  const SuccessDialogWidget({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
    this.customIcon,
  });

  @override
  State<SuccessDialogWidget> createState() => _SuccessDialogWidgetState();
}

class _SuccessDialogWidgetState extends State<SuccessDialogWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _iconController;
  late AnimationController _contentController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _iconAnimation;
  late Animation<double> _contentAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Dialog scale animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Icon animation
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _iconAnimation = CurvedAnimation(
      parent: _iconController,
      curve: Curves.bounceOut,
    );

    // Content animation
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _contentAnimation = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutQuart,
    );
  }

  void _startAnimations() {
    _scaleController.forward();

    // Delay icon animation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _iconController.forward();
    });

    // Delay content animation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _contentController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _iconController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: MaxWidthWidget(
          child: GlassyContainer(
            customGradientColors: [
              AppColors.getModernSurfaceWithAlpha(context, 0.96),
              AppColors.getModernSurfaceWithAlpha(context, 0.96),
              AppColors.getModernSurfaceWithAlpha(context, 0.96),
            ],
            borderRadius: BorderRadius.circular(24),
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnimatedIcon(),
                const SizedBox(height: 24),
                _buildAnimatedTitle(),
                const SizedBox(height: 12),
                _buildAnimatedMessage(),
                const SizedBox(height: 32),
                _buildAnimatedButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Animated success icon widget
  Widget _buildAnimatedIcon() {
    return ScaleTransition(
      scale: _iconAnimation,
      child: StyledIconContainer(
        icon: widget.customIcon ?? Icons.check_circle_rounded,
        backgroundOpacity: 0,
        size: 80,
        iconSize: 48,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  /// Animated title widget
  Widget _buildAnimatedTitle() {
    final theme = Theme.of(context);

    return _buildAnimatedTransition(
      child: Text(
        widget.title,
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Animated message widget
  Widget _buildAnimatedMessage() {
    final theme = Theme.of(context);

    return _buildAnimatedTransition(
      child: Text(
        widget.message,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Animated action button widget
  Widget _buildAnimatedButton() {
    final l10n = L10n.of(context);

    return _buildAnimatedTransition(
      child: ZoePrimaryButton(
        text: widget.buttonText ?? l10n.done,
        icon: Icons.done_rounded,
        onPressed: () {
          // Always close the dialog first
          context.pop();
          // Then execute custom callback if provided
          widget.onButtonPressed?.call();
        },
      ),
    );
  }

  /// Animated transition widget
  Widget _buildAnimatedTransition({required Widget child}) {
    return FadeTransition(
      opacity: _contentAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(_contentAnimation),
        child: child,
      ),
    );
  }
}
