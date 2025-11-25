import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/color_data.dart';

import '../../../../l10n/generated/l10n.dart';

class ColorSelectorWidget extends StatelessWidget {
  final ValueChanged<Color> onColorChanged;
  final Color selectedColor;

  const ColorSelectorWidget({
    super.key,
    required this.onColorChanged,
    required this.selectedColor,
  });

  static const colorPickerKey = 'color-picker';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10n.of(context).selectColor,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Wrap(children: _buildColorBoxes()),
      ],
    );
  }

  List<Widget> _buildColorBoxes() {
    return iconPickerColors
        .asMap()
        .entries
        .map((entry) => _buildColorBoxItem(entry.value, entry.key))
        .toList();
  }

  Widget _buildColorBoxItem(Color colorItem, int index) {
    final isSelected = colorItem == selectedColor;

    return InkWell(
      key: Key(colorPickerKey),
      borderRadius: BorderRadius.circular(100),
      onTap: () => onColorChanged(colorItem),
      child: Container(
        height: 40,
        width: 40,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: colorItem,
          border: isSelected ? Border.all(color: Colors.white, width: 1) : null,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
