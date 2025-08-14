import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/widgets/animated_background_widget.dart';
import 'package:zoe/common/widgets/app_icon_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/welcome/data/feature_data.dart';
import 'package:zoe/features/welcome/widgets/feature_item.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackgroundWidget(
        child: SafeArea(
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.all(24),
              child: _buildWelcomeBodyUI(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBodyUI() {
    return Column(
      children: [
        const SizedBox(height: 32),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppIconWidget(),
                const SizedBox(height: 32),
                _buildAppTitle(),
                const SizedBox(height: 8),
                _buildAppDescription(),
                const SizedBox(height: 48),
                _buildFeaturesList(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        _buildGetStartedButton(),
      ],
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

  Widget _buildAppTitle() {
    return Text(
      L10n.of(context).welcomeToZoey,
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }

  Widget _buildAppDescription() {
    return Text(
      L10n.of(context).yourPersonalWorkspace,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildGetStartedButton() {
    return SizedBox(
      width: double.infinity,
      child: ZoePrimaryButton(
        text: L10n.of(context).getStarted,
        onPressed: () => context.go(AppRoutes.home.route),
      ),
    );
  }
}
