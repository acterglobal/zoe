import 'package:flutter/material.dart';

/// Add block trigger widget
class AddBlockTrigger extends StatelessWidget {
  final bool showAddMenu;
  final VoidCallback onTap;

  const AddBlockTrigger({
    super.key,
    required this.showAddMenu,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Icon(showAddMenu ? Icons.close : Icons.add, size: 20),
            const SizedBox(width: 8),
            Text(showAddMenu ? 'Cancel' : 'Add a block'),
          ],
        ),
      ),
    );
  }
}
