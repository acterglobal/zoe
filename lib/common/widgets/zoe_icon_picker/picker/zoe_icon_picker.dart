import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/keyboard_visbility_provider.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/color_data.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/zoe_icons.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class ZoeIconPicker extends ConsumerStatefulWidget {
  final Color? selectedColor;
  final ZoeIcon? selectedIcon;
  final Function(Color, ZoeIcon)? onIconSelection;

  const ZoeIconPicker({
    super.key,
    this.selectedColor,
    this.selectedIcon,
    this.onIconSelection,
  });

  static Future<void> show({
    required BuildContext context,
    final Color? selectedColor,
    final ZoeIcon? selectedIcon,
    final Function(Color, ZoeIcon)? onIconSelection,
  }) async => await showModalBottomSheet(
    showDragHandle: true,
    useSafeArea: true,
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    builder: (context) => ZoeIconPicker(
      selectedColor: selectedColor,
      selectedIcon: selectedIcon,
      onIconSelection: onIconSelection,
    ),
  );

  // Keys
  static const iconPreviewKey = 'icon-preview';
  static const colorPickerKey = 'color-picker';
  static const iconPickerKey = 'icon-picker';

  @override
  ConsumerState<ZoeIconPicker> createState() => _ZoeIconPickerState();
}

class _ZoeIconPickerState extends ConsumerState<ZoeIconPicker> {
  final searchController = TextEditingController();
  final ValueNotifier<Color> selectedColor = ValueNotifier(
    iconPickerColors.first,
  );
  final ValueNotifier<ZoeIcon> selectedIcon = ValueNotifier(ZoeIcon.file);
  final ValueNotifier<List<ZoeIcon>> zoeIconList = ValueNotifier(
    ZoeIcon.values,
  );

  void _setWidgetValues() {
    if (widget.selectedColor != null) {
      selectedColor.value = widget.selectedColor!;
    }
    if (widget.selectedIcon != null) {
      selectedIcon.value = widget.selectedIcon!;
    }
  }

  @override
  void initState() {
    super.initState();
    _setWidgetValues();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setWidgetValues();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildIconPreviewAndColorSelectorView(),
          Expanded(child: _buildIconSelector()),
          ZoePrimaryButton(
            onPressed: () {
              widget.onIconSelection?.call(
                selectedColor.value,
                selectedIcon.value,
              );
              Navigator.pop(context);
            },
            text: L10n.of(context).select,
          ),
        ],
      ),
    );
  }

  Widget _buildIconPreviewAndColorSelectorView() {
    final keyboardVisibility = ref.watch(keyboardVisibleProvider);

    return AnimatedSize(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
      child: keyboardVisibility.value ?? false
          ? const SizedBox.shrink()
          : Column(
              children: [
                _buildIconPreviewUI(),
                const SizedBox(height: 24),
                _buildColorSelector(),
                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _buildIconPreviewUI() {
    return ValueListenableBuilder<Color>(
      valueListenable: selectedColor,
      builder: (context, color, child) {
        return ValueListenableBuilder<ZoeIcon>(
          valueListenable: selectedIcon,
          builder: (context, zoeIcon, child) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Icon(
                  key: Key(ZoeIconPicker.iconPreviewKey),
                  zoeIcon.data,
                  size: 100,
                  color: color,
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildColorBoxes() {
    final iconColorWidgetsMap = iconPickerColors.asMap().map(
      (index, color) => MapEntry(index, _buildColorBoxItem(color, index)),
    );
    return iconColorWidgetsMap.values.toList();
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(L10n.of(context).selectColor),
        const SizedBox(height: 12),
        Wrap(children: _buildColorBoxes()),
      ],
    );
  }

  Widget _buildColorBoxItem(Color colorItem, int index) {
    return ValueListenableBuilder<Color>(
      valueListenable: selectedColor,
      builder: (context, color, child) {
        return InkWell(
          key: Key('${ZoeIconPicker.colorPickerKey}-$index'),
          borderRadius: BorderRadius.circular(100),
          onTap: () => selectedColor.value = colorItem,
          child: Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorItem,
              border: colorItem == color
                  ? Border.all(color: Colors.white, width: 1)
                  : null,
              borderRadius: const BorderRadius.all(Radius.circular(100)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchWidget() {
    return ZoeSearchBarWidget(
      controller: searchController,
      onChanged: (searchValue) =>
          zoeIconList.value = ZoeIcon.values.where((icon) {
            return icon.name.toLowerCase().contains(searchValue.toLowerCase());
          }).toList(),
      onClear: () => zoeIconList.value = ZoeIcon.values,
    );
  }

  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(L10n.of(context).selectIcon),
        const SizedBox(height: 5),
        _buildSearchWidget(),
        const SizedBox(height: 5),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: zoeIconList,
            builder: (context, iconList, child) {
              if (iconList.isEmpty) {
                return Center(child: Text(L10n.of(context).noIconsFound));
              }
              return _buildIconsBoxList(iconList);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIconsBoxList(List<ZoeIcon> iconList) {
    final iconBoxes = iconList
        .asMap()
        .map(
          (index, zoeIcon) =>
              MapEntry(index, _buildIconBoxItem(zoeIcon, index)),
        )
        .values
        .toList();
    return SingleChildScrollView(child: Wrap(children: iconBoxes));
  }

  Widget _buildIconBoxItem(ZoeIcon zoeIconItem, int index) {
    return ValueListenableBuilder<ZoeIcon>(
      valueListenable: selectedIcon,
      builder: (context, zoeIcon, child) {
        return InkWell(
          key: Key('${ZoeIconPicker.iconPickerKey}-$index'),
          borderRadius: BorderRadius.circular(100),
          onTap: () => selectedIcon.value = zoeIconItem,
          child: Container(
            height: 45,
            width: 45,
            alignment: Alignment.center,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white24,
              border: zoeIconItem == zoeIcon
                  ? Border.all(color: Colors.white, width: 1)
                  : null,
              borderRadius: const BorderRadius.all(Radius.circular(100)),
            ),
            child: Icon(zoeIconItem.data),
          ),
        );
      },
    );
  }
}
