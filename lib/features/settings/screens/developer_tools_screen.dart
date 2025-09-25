import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/settings/widgets/setting_card_widget.dart';
import 'package:zoe/features/settings/widgets/setting_item_widget.dart';
import 'package:zoe_native/zoe_native.dart';


class DeveloperToolsScreen extends ConsumerWidget {
  const DeveloperToolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Center(
          child: MaxWidthWidget(
            isScrollable: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildDeveloperToolsBody(context, ref),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const ZoeAppBar(title: 'Developer Tools'),
    );
  }

  Widget _buildDeveloperToolsBody(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // System Testing Section
        _buildSystemTestingSection(context),
        const SizedBox(height: 20),

        // Client Management Section
        _buildClientManagementSection(context, ref),
        const SizedBox(height: 20),

        // Future sections can be added here
        // _buildLoggingSection(context),
        // _buildNetworkSection(context),
      ],
    );
  }

  Widget _buildSystemTestingSection(BuildContext context) {
    return SettingCardWidget(
      title: 'System Testing',
      children: [
        SettingItemWidget(
          title: 'Systems Check',
          subtitle: 'Comprehensive system diagnostics and testing',
          icon: Icons.health_and_safety,
          iconColor: const Color(0xFF10B981), // Emerald
          onTap: () => context.push(AppRoutes.systemsTest.route),
        ),
      ],
    );
  }

  Widget _buildClientManagementSection(BuildContext context, WidgetRef ref) {
    return SettingCardWidget(
      title: 'Client Management',
      titleColor: const Color(0xFFEF4444), // Red warning color
      children: [
        SettingItemWidget(
          title: 'Reset Client',
          subtitle: 'Clear stored secrets and force client regeneration',
          icon: Icons.refresh,
          iconColor: const Color(0xFFEF4444), // Red
          onTap: () => _showResetClientDialog(context, ref),
        ),
      ],
    );
  }

  void _showResetClientDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Client'),
          content: const Text(
            'This will clear all stored client secrets and force the app to generate a new client identity. '
            'You may need to re-authenticate with services.\n\n'
            'Are you sure you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _performClientReset(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFEF4444),
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performClientReset(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Resetting client...'),
              ],
            ),
          );
        },
      );

      await resetClient();

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Client reset successfully'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reset client: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }
}

