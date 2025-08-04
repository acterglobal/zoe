import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';
import 'package:zoey/features/users/providers/user_providers.dart';
import 'package:zoey/features/sheet/providers/sheet_providers.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';
import 'package:zoey/features/task/providers/task_providers.dart';
import 'dart:math' as math;

class DashboardHeaderWidget extends ConsumerStatefulWidget {
  const DashboardHeaderWidget({super.key});

  @override
  ConsumerState<DashboardHeaderWidget> createState() =>
      _DashboardHeaderWidgetState();
}

class _DashboardHeaderWidgetState extends ConsumerState<DashboardHeaderWidget>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late Animation<double> _floatAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Floating animation
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _floatAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Rotation animation
    _rotateController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _rotateController, curve: Curves.linear));

    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animations
    _floatController.repeat(reverse: true);
    _rotateController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final sheetList = ref.watch(sheetListProvider);
    final eventList = ref.watch(eventListProvider);
    final taskList = ref.watch(taskListProvider);

    return currentUserAsync.when(
      data: (user) {
        final userName = user?.name ?? 'Guest';
        final firstName = userName.split(' ').first;

        return Column(
          children: [
            // Welcome banner
            _buildWelcomeBanner(context, firstName),
            const SizedBox(height: 16),
            // Quick stats cards
            _buildQuickStatsGrid(
              context,
              sheetList.length,
              eventList.length,
              taskList.length,
            ),
          ],
        );
      },
      loading: () => _buildLoadingState(context),
      error: (error, stackTrace) => _buildErrorState(context),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context, String firstName) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryColor, AppColors.secondaryColor],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.25),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left side - Welcome text
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  firstName,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.today_rounded,
                        color: Colors.white.withValues(alpha: 0.9),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getFormattedDate(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Right side - Animated Zoe persona
          Expanded(flex: 2, child: _buildAnimatedZoePersona()),
        ],
      ),
    );
  }

  Widget _buildAnimatedZoePersona() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _floatAnimation,
        _rotateAnimation,
        _pulseAnimation,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background particles/effects
              ..._buildBackgroundParticles(),
              // Main Zoe persona
              Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.3),
                        Colors.white.withValues(alpha: 0.1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.rocket_launch_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              // Orbiting elements
              ..._buildOrbitingElements(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildBackgroundParticles() {
    return List.generate(6, (index) {
      final angle = (index * 60.0) * (math.pi / 180);
      final radius = 40.0 + (index * 8.0);

      return Transform.rotate(
        angle: _rotateAnimation.value + angle,
        child: Transform.translate(
          offset: Offset(
            radius * math.cos(_rotateAnimation.value + angle),
            radius * math.sin(_rotateAnimation.value + angle),
          ),
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.4),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.6),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildOrbitingElements() {
    final elements = [
      Icons.star_rounded,
      Icons.favorite_rounded,
      Icons.bolt_rounded,
    ];

    return List.generate(elements.length, (index) {
      final angle = (index * 120.0) * (math.pi / 180);
      final radius = 60.0;

      return Transform.rotate(
        angle: _rotateAnimation.value * 0.5,
        child: Transform.translate(
          offset: Offset(
            radius * math.cos(_rotateAnimation.value * 0.5 + angle),
            radius * math.sin(_rotateAnimation.value * 0.5 + angle),
          ),
          child: Transform.scale(
            scale: _pulseAnimation.value * 0.8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Icon(
                elements[index],
                size: 12,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildQuickStatsGrid(
    BuildContext context,
    int sheetCount,
    int eventCount,
    int taskCount,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.article_rounded,
            label: 'Sheets',
            value: sheetCount.toString(),
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.event_rounded,
            label: 'Events',
            value: eventCount.toString(),
            color: AppColors.secondaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.task_alt_rounded,
            label: 'Tasks',
            value: taskCount.toString(),
            color: AppColors.successColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface,
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface,
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, color: AppColors.errorColor),
            const SizedBox(width: 8),
            Text('Unable to load data', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final weekday = weekdays[now.weekday - 1];
    final month = months[now.month - 1];
    final day = now.day;

    return '$weekday, $month $day';
  }
}
