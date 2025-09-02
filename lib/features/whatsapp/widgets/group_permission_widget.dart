import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:zoe/common/widgets/step_indicator_widget.dart';
import 'package:zoe/common/widgets/success_dialog_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/common/widgets/toolkit/zoe_secondary_button.dart';
import 'package:zoe/features/whatsapp/providers/whatsapp_group_connect_provider.dart';
import 'package:zoe/features/whatsapp/utils/image_utils.dart';
import 'package:zoe/features/whatsapp/widgets/info_header_widget.dart';
import 'package:zoe/features/whatsapp/widgets/guide_step_widget.dart';
import 'package:zoe/features/whatsapp/widgets/important_note_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class GroupPermissionWidget extends ConsumerWidget {
  final String sheetId;
  const GroupPermissionWidget({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(whatsappGroupConnectProvider);

    return Column(
      children: [
        InfoHeaderWidget(
          title: L10n.of(context).enableInvites,
          subtitle: L10n.of(context).enableInvitesDescription,
          icon: OctIcons.shield,
        ),
        const SizedBox(height: 10),
        StepIndicatorWidget(
          currentStep: state.currentStep,
          totalSteps: state.totalSteps,
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
          GuideStepWidget(
            stepNumber: 1,
            title: L10n.of(context).groupPermissions,
            description: L10n.of(context).navigateToGroupPermissionsDescription,
            imagePath: ImageUtils.getGroupPermissionImagePath(context),
          ),
          const SizedBox(height: 24),
          GuideStepWidget(
            stepNumber: 2,
            title: L10n.of(context).enableInviteViaOption,
            description: L10n.of(context).enableInviteViaOptionDescription,
            imagePath: ImageUtils.getInviteLinkImagePath(context),
          ),
          const SizedBox(height: 24),
          ImportantNoteWidget(
            title: L10n.of(context).importantNote,
            message: L10n.of(context).importantNoteDescription,
            icon: Icons.admin_panel_settings_outlined,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
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
            onPressed: () =>
                state.isConnecting ? {} : _connectToGroup(context, ref),
          ),
        ),
      ],
    );
  }

  Future<void> _connectToGroup(BuildContext context, WidgetRef ref) async {
    final state = ref.read(whatsappGroupConnectProvider);
    final l10n = L10n.of(context);

    ref.read(whatsappGroupConnectProvider.notifier).setConnecting(true);
    try {
      // Simulate connection process
      await Future.delayed(const Duration(seconds: 1));

      if (!context.mounted) return;
      // First pop to close the current screen
      context.pop();
      
      ref.read(whatsappGroupConnectProvider.notifier).setConnecting(false);

      // Show success dialog with safer navigation handling
      await showSuccessDialog(
        context: context,
        title: l10n.successfullyConnected,
        message: l10n.whatsappGroupConnectedMessage,
        buttonText: l10n.done,
        customIcon: Icons.link_rounded,
        onButtonPressed: () {
          // Additional actions after success can be added here
          debugPrint(
            "WhatsApp group connected successfully - SheetId: $sheetId, GroupLink: ${state.groupLink}",
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      ref.read(whatsappGroupConnectProvider.notifier).setConnecting(false);
      debugPrint("Error connecting to group: $e");
    }
  }
}
