import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/color_data.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/widgets/color_selector_widget.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

void showChooseColorBottomSheet({
  required BuildContext context,
  required String sheetId,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => ChooseColorBottomSheet(sheetId: sheetId),
  );
}

class ChooseColorBottomSheet extends ConsumerStatefulWidget {
  final String sheetId;

  const ChooseColorBottomSheet({super.key, required this.sheetId});

  @override
  ConsumerState<ChooseColorBottomSheet> createState() =>
      _ChooseColorBottomSheetState();
}

class _ChooseColorBottomSheetState
    extends ConsumerState<ChooseColorBottomSheet> {
  Color? selectedColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (selectedColor == null) {
      // Initialize with current sheet theme colors or defaults
      final sheet = ref.read(sheetProvider(widget.sheetId));
      selectedColor =
          sheet?.theme?.primary ?? Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return MaxWidthWidget(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 16,
        right: 16,
      ),
      isScrollable: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColorSelectorWidget(
            onColorChanged: (color) {
              setState(() {
                selectedColor = color;
              });
            },
            selectedColor: selectedColor!,
            colors: sheetThemeColors,
          ),
          const SizedBox(height: 24),

          // Save Button
          ZoePrimaryButton(
            onPressed: _saveSelectedColor,
            text: l10n.save,
            primaryColor: selectedColor,
            secondaryColor: selectedColor?.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _saveSelectedColor() {
    // Update the sheet's theme
    ref
        .read(sheetListProvider.notifier)
        .updateSheetTheme(
          sheetId: widget.sheetId,
          primary: selectedColor!,
          secondary: selectedColor!.withValues(alpha: 0.2),
        );

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
