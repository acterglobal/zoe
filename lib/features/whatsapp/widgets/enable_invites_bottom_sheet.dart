import 'package:flutter/material.dart';
import 'package:zoe/features/whatsapp/utils/image_utils.dart';
import 'package:zoe/features/whatsapp/widgets/guide_step_widget.dart';
import 'package:zoe/features/whatsapp/widgets/important_note_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

void showEnableInvitesBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => EnableInvitesBottomSheet(),
  );
}

class EnableInvitesBottomSheet extends StatelessWidget {
  const EnableInvitesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.89,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              L10n.of(context).enableInvites,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            GuideStepWidget(
              stepNumber: 1,
              title: L10n.of(context).groupPermissions,
              description: L10n.of(
                context,
              ).navigateToGroupPermissionsDescription,
              imagePath: ImageUtils.getGroupPermissionImagePath(context),
            ),
            const SizedBox(height: 15),
            GuideStepWidget(
              stepNumber: 2,
              title: L10n.of(context).enableInviteViaOption,
              description: L10n.of(context).enableInviteViaOptionDescription,
              imagePath: ImageUtils.getInviteLinkImagePath(context),
            ),
            const SizedBox(height: 15),
            ImportantNoteWidget(
              title: L10n.of(context).importantNote,
              message: L10n.of(context).importantNoteDescription,
              icon: Icons.admin_panel_settings_outlined,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
