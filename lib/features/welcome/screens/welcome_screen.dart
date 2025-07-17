import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/features/sheet/providers/sheet_list_provider.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/welcome/data/feature_data.dart';
import 'package:zoey/features/welcome/widgets/feature_item.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildAppIcon(),
              const SizedBox(height: 32),
              _buildAppTitle(),
              const SizedBox(height: 8),
              _buildAppDescription(),
              const SizedBox(height: 48),
              _buildFeaturesList(),
              const Spacer(),
              _buildGetStartedButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    return Column(
      children: features
          .map(
            (feature) => FeatureItem(
              icon: feature.icon,
              title: feature.title,
              description: feature.description,
            ),
          )
          .toList(),
    );
  }

  Widget _buildAppIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.note_alt_rounded, size: 40, color: Colors.white),
    );
  }

  Widget _buildAppTitle() {
    return Text(
      'Welcome to Zoe',
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }

  Widget _buildAppDescription() {
    return Text(
      'Your personal workspace for organizing thoughts, tasks, and ideas with beautiful simplicity.',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        height: 1.5,
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final sheetListNotifier = ref.read(sheetListProvider.notifier);
          sheetListNotifier.initializeWithSampleData();
          context.go(AppRoutes.home.route);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            'Get Started',
            style: Theme.of(
              context,
            ).textTheme.labelLarge!.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
