import 'package:flutter/material.dart';

/// Edit/Save button widget for sheet detail app bar
class EditSaveButtonWidget extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onPressed;

  const EditSaveButtonWidget({
    super.key,
    required this.isEditing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: isEditing
              ? const Color(0xFF3B82F6)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          foregroundColor: isEditing
              ? Colors.white
              : Theme.of(context).colorScheme.onSurface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minimumSize: const Size(60, 36),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isEditing ? Icons.save_rounded : Icons.edit_rounded,
              size: 16,
              color: isEditing
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 6),
            Text(
              isEditing ? 'Save' : 'Edit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isEditing
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
