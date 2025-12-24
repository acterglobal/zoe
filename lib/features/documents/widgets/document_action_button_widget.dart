import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';

class DocumentActionButtons extends ConsumerWidget {
  final VoidCallback? onDownload;
  final VoidCallback? onShare;

  const DocumentActionButtons({
    super.key,
    required this.onDownload,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        GestureDetector(
          onTap: () => onDownload?.call(),
          child: StyledIconContainer(
            icon: Icons.download,
            size: 40,
            iconSize: 20,
            primaryColor: primaryColor,
            secondaryColor: primaryColor,
            backgroundOpacity: 0.08,
            borderOpacity: 0.15,
            shadowOpacity: 0.1,
          ),
        ),
        // SizedBox(width: 10),
        // GestureDetector(
        //   onTap: () => onShare?.call(),
        //   child: StyledIconContainer(
        //     icon: Icons.share,
        //     size: 40,
        //     iconSize: 20,
        //     primaryColor: primaryColor,
        //     secondaryColor: primaryColor,
        //     backgroundOpacity: 0.08,
        //     borderOpacity: 0.15,
        //     shadowOpacity: 0.1,
        //   ),
        // ),
      ],
    );
  }
}
