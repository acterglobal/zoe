import 'package:flutter/material.dart';

class AppIconWidget extends StatelessWidget {
  final double size;
  const AppIconWidget({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.note_alt_rounded, size: 40, color: Colors.white),
    );
  }
}
