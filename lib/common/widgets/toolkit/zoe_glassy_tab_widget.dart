import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';

class ZoeGlassyTabWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final List<String> tabTexts;
  final int selectedIndex;
  final Function(int) onTabChanged;
  final double? height;
  final EdgeInsets? margin;
  final double? borderRadius;
  final double? borderOpacity;

  @override
  Size get preferredSize => Size.fromHeight(height ?? 60);

  const ZoeGlassyTabWidget({
    super.key,
    required this.tabTexts,
    required this.selectedIndex,
    required this.onTabChanged,
    this.height,
    this.margin = const EdgeInsets.symmetric(vertical: 4),
    this.borderRadius,
    this.borderOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return GlassyContainer(
        borderRadius: BorderRadius.circular(borderRadius ?? 25),
        padding: EdgeInsets.symmetric(horizontal: 3,vertical: 3),
        borderOpacity: borderOpacity ?? 0.1,
        height: height ?? 60,
        margin: margin,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
          ),
          child: _buildTabList(context),
      ),
    );
  }

  Widget _buildTabList(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: tabTexts.length,
      itemBuilder: (context, index) => _buildTabItem(
        context: context,
        text: tabTexts[index],
        isSelected: selectedIndex == index,
        onTap: () => onTabChanged(index),
      ),
    );
  }
}

Widget _buildTabItem({
  required BuildContext context,
  required String text,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryColor.withValues(alpha: 0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? Border.all(color: AppColors.primaryColor, width: 1.5)
            : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected
              ? AppColors.primaryColor
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 12,
        ),
      ),
    ),
  );
}
