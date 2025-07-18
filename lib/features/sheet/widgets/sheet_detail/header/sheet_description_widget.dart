import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';

/// Description widget for sheet header
class SheetDescriptionWidget extends ConsumerWidget {
  final String? sheetId;

  const SheetDescriptionWidget({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditingProvider(sheetId));
    return isEditing
        ? _buildDescriptionTextField(context, ref)
        : _buildDescriptionText(context, ref);
  }

  Widget _buildDescriptionTextField(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(descriptionControllerProvider(sheetId));
    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyLarge!,
      decoration: InputDecoration(hintText: 'Add a description...'),
      maxLines: null,
      onChanged: (value) => ref
          .read(sheetDetailProvider(sheetId).notifier)
          .updateDescription(value),
    );
  }

  Widget _buildDescriptionText(BuildContext context, WidgetRef ref) {
    final currentSheet = ref.watch(sheetProvider(sheetId));
    if (currentSheet.description.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        currentSheet.description,
        style: Theme.of(context).textTheme.bodyLarge!,
      ),
    );
  }
}
