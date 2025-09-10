import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/l10n/generated/l10n.dart';

void showProfileQrCodeBottomSheet(BuildContext context, UserModel user) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => ProfileQrCodeWidget(user: user),
  );
}

class ProfileQrCodeWidget extends StatelessWidget {
  final UserModel user;

  const ProfileQrCodeWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context).width * 0.8;
    final borderRadius = BorderRadius.circular(16);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner_rounded,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.scanToConnect,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GlassyContainer(
          padding: const EdgeInsets.all(16),
          width: size,
          height: size,
          borderRadius: borderRadius,
          child: PrettyQrView.data(
            data: user.name,
            decoration: PrettyQrDecoration(
              shape: PrettyQrSmoothSymbol(color: theme.colorScheme.onSurface),
              image: const PrettyQrDecorationImage(
                image: AssetImage('assets/icon/app_icon.png'),
                padding: EdgeInsets.all(24),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
