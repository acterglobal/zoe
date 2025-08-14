import 'package:flutter/material.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class ZoeSearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String? hintText;
  final EdgeInsetsGeometry? margin;

  const ZoeSearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: margin,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildSearchIcon(context),
          const SizedBox(width: 12),
          _buildTextField(context),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) {
              if (value.text.isEmpty) return const SizedBox();
              return _buildClearButton(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchIcon(BuildContext context) {
    return Icon(
      Icons.search,
      size: 20,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
    );
  }

  Widget _buildClearButton(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.onSurface;
    return GestureDetector(
      onTap: () {
        controller.clear();
        onChanged('');
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.clear,
          size: 16,
          color: iconColor.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    return Expanded(
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText ?? L10n.of(context).search,
          hintStyle: TextStyle(
            color: textColor.withValues(alpha: 0.6),
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: TextStyle(color: textColor, fontSize: 16),
      ),
    );
  }
}
