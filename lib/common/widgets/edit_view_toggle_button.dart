import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Zoe/common/widgets/quill_editor/actions/quill_actions.dart';
import 'package:Zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:Zoe/features/content/providers/content_menu_providers.dart';

class EditViewToggleButton extends ConsumerWidget {
  final String parentId;
  const EditViewToggleButton({super.key, required this.parentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditValueProvider(parentId));
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        // Close keyboard and clear quill toolbar state
        clearActiveEditorState(ref);
        ref.read(isEditValueProvider(parentId).notifier).state = !isEditing;
      },
      child: StyledIconContainer(
        icon: isEditing ? Icons.save_rounded : Icons.edit_rounded,
        size: 40,
        iconSize: 20,
        primaryColor: isEditing
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withValues(alpha: 0.6),
        secondaryColor: isEditing
            ? theme.colorScheme.secondary
            : theme.colorScheme.onSurface.withValues(alpha: 0.4),
        backgroundOpacity: isEditing ? 0.12 : 0.08,
        borderOpacity: isEditing ? 0.2 : 0.15,
        shadowOpacity: isEditing ? 0.15 : 0.1,
      ),
    );
  }
}
