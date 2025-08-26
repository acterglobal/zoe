import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/common/widgets/toolkit/zoe_secondary_button.dart';
import 'package:zoe/features/whatsapp_connect/providers/whatsapp_group_connect_provider.dart';
import 'package:zoe/features/whatsapp_connect/widgets/info_header_widget.dart';
import 'package:zoe/features/whatsapp_connect/widgets/permission_step_widget.dart';
import 'package:zoe/features/whatsapp_connect/widgets/important_note_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class GroupPermissionWidget extends ConsumerWidget {
  const GroupPermissionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        InfoHeaderWidget(
          title: L10n.of(context).enableGroupPermission,
          subtitle: L10n.of(context).enableGroupPermissionDescription,
          icon: Icons.settings_outlined,
        ),
        Expanded(child: _buildPermissionContent(context)),
        _buildNavigationButtons(context, ref),
      ],
    );
  }

  Widget _buildPermissionContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          PermissionStepWidget(
            stepNumber: 1,
            title: L10n.of(context).navigateToGroupPermissions,
            description: L10n.of(context).navigateToGroupPermissionsDescription,
            imagePath: _getImagePath(context: context, isGroupPermission: true),
          ),
          const SizedBox(height: 24),
          PermissionStepWidget(
            stepNumber: 2,
            title: L10n.of(context).enableInviteViaOption,
            description: L10n.of(context).enableInviteViaOptionDescription,
            imagePath: _getImagePath(context: context, isInviteLink: true),
          ),
          const SizedBox(height: 24),
          ImportantNoteWidget(
            title: L10n.of(context).importantNote,
            message: L10n.of(context).importantNoteDescription,
            icon: Icons.admin_panel_settings_outlined,
            priorityIcon: Icons.priority_high,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _getImagePath({
    required BuildContext context,
    bool isGroupPermission = false,
    bool isInviteLink = false,
  }) {
    if (!isGroupPermission && !isInviteLink) return '';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isIOS = Platform.isIOS || Platform.isMacOS;
    final theme = isDarkMode ? 'dark' : 'light';
    final platform = isIOS ? 'ios' : 'android';
    final baseName = isGroupPermission ? 'permisson' : 'invite_link';
    return 'assets/images/whatsapp/${baseName}_${platform}_$theme.png';
  }

  Widget _buildNavigationButtons(BuildContext context, WidgetRef ref) {
    final state = ref.watch(whatsappGroupConnectProvider);

    return Row(
      children: [
        ZoeSecondaryButton(
          icon: Icons.arrow_back_rounded,
          text: L10n.of(context).previous,
          onPressed: () =>
              ref.read(whatsappGroupConnectProvider.notifier).previousStep(),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ZoePrimaryButton(
            icon: state.isConnecting ? null : Icons.link_rounded,
            text: state.isConnecting
                ? L10n.of(context).connecting
                : L10n.of(context).connectGroup,
            onPressed: () async {
              if (state.isConnecting) return;
              ref
                  .read(whatsappGroupConnectProvider.notifier)
                  .setConnecting(true);
              try {
                await Future.delayed(const Duration(seconds: 2));
                if (!context.mounted) return;
                context.pop();
                ref
                    .read(whatsappGroupConnectProvider.notifier)
                    .setConnecting(false);
              } catch (e) {
                debugPrint("Error connecting to group: $e");
              }
            },
          ),
        ),
      ],
    );
  }
}
