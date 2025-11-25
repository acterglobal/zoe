import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/color_data.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/widgets/color_selector_widget.dart';
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
  late Color _tempPrimaryColor;
  late Color _tempSecondaryColor;

  @override
  void initState() {
    super.initState();
    // Initialize with current sheet theme colors or defaults
    final sheet = ref.read(sheetProvider(widget.sheetId));
    _tempPrimaryColor = sheet?.theme?.primary ?? iconPickerColors.first;
    _tempSecondaryColor = sheet?.theme?.secondary ?? iconPickerColors[1];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.selectColor,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // Preview Section
            _buildPreviewSection(theme, l10n),
            const SizedBox(height: 32),

            // Primary Color Selector
            ColorSelectorWidget(
              title: l10n.primaryColor,
              onColorChanged: (color) {
                setState(() {
                  _tempPrimaryColor = color;
                });
              },
              selectedColor: _tempPrimaryColor,
            ),
            const SizedBox(height: 24),

            // Secondary Color Selector
            ColorSelectorWidget(
              title: l10n.secondaryColor,
              onColorChanged: (color) {
                setState(() {
                  _tempSecondaryColor = color;
                });
              },
              selectedColor: _tempSecondaryColor,
            ),
            const SizedBox(height: 32),

            // Save Button
            ZoePrimaryButton(onPressed: _saveColors, text: l10n.save),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection(ThemeData theme, L10n l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.preview,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildColorPreview(
                  theme,
                  l10n.primaryColor,
                  _tempPrimaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildColorPreview(
                  theme,
                  l10n.secondaryColor,
                  _tempSecondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorPreview(ThemeData theme, String label, Color color) {
    return Column(
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _saveColors() {
    ref
        .read(sheetListProvider.notifier)
        .updateSheetTheme(
          sheetId: widget.sheetId,
          primary: _tempPrimaryColor,
          secondary: _tempSecondaryColor,
        );
    if (mounted) {
      Navigator.pop(context);
    }
  }
}
