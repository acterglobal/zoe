import 'package:flutter/material.dart';

class DetailsAdditionalField extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isEditing;
  final VoidCallback? onChildTap;
  final Widget child;

  const DetailsAdditionalField({
    super.key,
    required this.icon,
    required this.title,
    this.isEditing = false,
    this.onChildTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTitle(context),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: isEditing ? onChildTap : null,
          child: child,
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 130),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
