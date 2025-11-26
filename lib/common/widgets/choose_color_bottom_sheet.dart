import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/selected_color_provider.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/color_data.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/widgets/color_selector_widget.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class ChooseColorBottomSheet extends ConsumerStatefulWidget {
  final String sheetId;

  const ChooseColorBottomSheet({super.key, required this.sheetId});

  static Future<void> show(
    BuildContext context, {
    required String sheetId,
  }) async {
    await showModalBottomSheet(
      showDragHandle: true,
      useSafeArea: true,
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) => ChooseColorBottomSheet(sheetId: sheetId),
    );
  }

  @override
  ConsumerState<ChooseColorBottomSheet> createState() =>
      _ChooseColorBottomSheetState();
}

class _ChooseColorBottomSheetState
    extends ConsumerState<ChooseColorBottomSheet> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    // Initialize with current sheet theme colors or defaults
    final sheet = ref.read(sheetProvider(widget.sheetId));
    selectedColor = sheet?.theme?.primary ?? iconPickerColors.first;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 16, left: 16),
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
              selectedColor: selectedColor,
            ),
            const SizedBox(height: 24),

            // Save Button
            ZoePrimaryButton(onPressed: _saveColors, text: l10n.save),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _saveColors() {
    // Update the sheet's theme
    ref
        .read(sheetListProvider.notifier)
        .updateSheetTheme(
          sheetId: widget.sheetId,
          primary: selectedColor,
          secondary: AppColors.primaryColor.withValues(alpha: 0.3),
        );

    // Also update the global selected color provider
    ref.read(selectedColorProvider.notifier).setColor(selectedColor);

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
