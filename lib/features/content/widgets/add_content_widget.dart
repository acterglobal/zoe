import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/content/widgets/content_menu_options.dart';

class AddContentWidget extends ConsumerWidget {
  final bool isEditing;
  final VoidCallback onTapText;
  final VoidCallback onTapEvent;
  final VoidCallback onTapBulletedList;
  final VoidCallback onTapToDoList;

  const AddContentWidget({
    super.key,
    required this.isEditing,
    required this.onTapText,
    required this.onTapEvent,
    required this.onTapBulletedList,
    required this.onTapToDoList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If not editing, return empty widget
    if (!isEditing) return const SizedBox.shrink();

    final isShowMenu = ref.watch(contentMenuProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildToggleButton(context, ref, isShowMenu),
        if (isShowMenu)
          ContentMenuOptions(
            onTapText: () {
              _toggleMenu(ref);
              onTapText();
            },

            onTapEvent: () {
              _toggleMenu(ref);
              onTapEvent();
            },
            onTapBulletedList: () {
              _toggleMenu(ref);
              onTapBulletedList();
            },
            onTapToDoList: () {
              _toggleMenu(ref);
              onTapToDoList();
            },
          ),
      ],
    );
  }

  Widget _buildToggleButton(
    BuildContext context,
    WidgetRef ref,
    bool isShowMenu,
  ) {
    return GestureDetector(
      onTap: () => _toggleMenu(ref),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Icon(
              isShowMenu ? Icons.close : Icons.add,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              isShowMenu ? 'Cancel' : 'Add content',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleMenu(WidgetRef ref) {
    HapticFeedback.mediumImpact();
    ref.read(contentMenuProvider.notifier).state = !ref.read(
      contentMenuProvider,
    );
  }
}
