import 'package:flutter/material.dart';

class AttributeFieldWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isEditing;
  final VoidCallback? onTapValue;
  final Widget valueWidget;

  const AttributeFieldWidget({
    super.key,
    required this.icon,
    required this.title,
    this.isEditing = false,
    this.onTapValue,
    required this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildLabel(context),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: isEditing ? onTapValue : null,
          child: valueWidget,
        ),
      ],
    );
  }

  Widget _buildLabel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4),
      constraints: BoxConstraints(maxWidth: 130),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
