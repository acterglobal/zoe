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
    this.height = 60,
    this.margin = const EdgeInsets.symmetric(vertical: 4),
    this.borderRadius = 25,
    this.borderOpacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height ?? 60),
      child: Container(
        alignment: Alignment.center,
        margin: margin,
        child: GlassyContainer(
          borderRadius: BorderRadius.circular(borderRadius ?? 25),
          borderOpacity: borderOpacity ?? 0.1,
          child: SizedBox(
            height: height ?? 60,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: IntrinsicHeight(
                  child: Row(
                    children: tabTexts
                        .asMap()
                        .entries
                        .map(
                          (entry) => _buildCustomTab(
                            context: context,
                            text: entry.value,
                            isSelected: selectedIndex == entry.key,
                            onTap: () => onTabChanged(entry.key),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTab({
    required BuildContext context,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected
                ? AppColors.primaryColor
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
