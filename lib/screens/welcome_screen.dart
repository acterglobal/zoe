import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../common/providers/app_state_provider.dart';
import '../common/theme/app_theme.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getBackground(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/Icon with animation
                    Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            size: 60,
                            color: Colors.white,
                          ),
                        )
                        .animate()
                        .scale(delay: 200.ms, duration: 600.ms)
                        .then()
                        .shimmer(delay: 400.ms, duration: 1000.ms),

                    const SizedBox(height: 48),

                    // Welcome text
                    Text('Welcome to Zoe', style: AppTheme.heading1(context))
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 16),

                    // Description
                    Text(
                          'Your personal workspace for organizing thoughts, tasks, and ideas with beautiful simplicity.',
                          textAlign: TextAlign.center,
                          style: AppTheme.bodyLarge(context).copyWith(
                            color: AppTheme.getTextSecondary(context),
                            height: 1.5,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 64),

                    // Feature cards
                    Row(
                          children: [
                            Expanded(
                              child: _FeatureCard(
                                icon: Icons.checklist_rounded,
                                title: 'Organize',
                                description:
                                    'Keep your tasks and ideas structured',
                                color: const Color(0xFF10B981),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _FeatureCard(
                                icon: Icons.event_note_rounded,
                                title: 'Plan',
                                description: 'Schedule and track your events',
                                color: const Color(0xFF8B5CF6),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _FeatureCard(
                                icon: Icons.lightbulb_rounded,
                                title: 'Create',
                                description: 'Capture and develop your ideas',
                                color: const Color(0xFFF59E0B),
                              ),
                            ),
                          ],
                        )
                        .animate()
                        .fadeIn(delay: 800.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),
                  ],
                ),
              ),

              // Get Started button
              SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _getStarted(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Let\'s get started',
                            style: AppTheme.labelLarge(
                              context,
                            ).copyWith(color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 1000.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  void _getStarted(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    appState.initializeWithSampleData();
    appState.completeFirstLaunch();

    // The Consumer in main.dart will automatically handle the navigation
    // when isFirstLaunch becomes false, so we don't need to navigate manually
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.getSurface(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.05,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: 12),
          Text(title, style: AppTheme.labelLarge(context)),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTheme.bodySmall(context).copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}
