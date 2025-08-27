import 'package:flutter/material.dart';

class DocumentErrorWidget extends StatelessWidget {
  final String errorName;

  const DocumentErrorWidget({super.key, required this.errorName});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_rounded, size: 64, color: colorScheme.error),
          const SizedBox(height: 16),
          Text(
            errorName,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: colorScheme.error),
          ),
        ],
      ),
    );
  }
}
