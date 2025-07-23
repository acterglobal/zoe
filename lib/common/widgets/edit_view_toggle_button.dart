import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';

class EditViewToggleButton extends ConsumerWidget {
  const EditViewToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditValueProvider);
    return ZoePrimaryButton(
      text: isEditing ? 'Save' : 'Edit',
      icon: isEditing ? Icons.save_rounded : Icons.edit_rounded,
      backgroundColor: isEditing
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onPressed: () {
        // Close keyboard when switching to view mode
        if (isEditing) {
           FocusManager.instance.primaryFocus?.unfocus();
        }
        ref.read(isEditValueProvider.notifier).state = !ref.read(
          isEditValueProvider,
        );
      },
    );
  }
}
