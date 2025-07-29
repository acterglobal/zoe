import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class CustomEmojiPickerWidget extends ConsumerWidget {
  final Function(String emoji) onEmojiSelected;

  const CustomEmojiPickerWidget({super.key, required this.onEmojiSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = TextEditingController();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;

    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildHeader(context, onSurface),
          const Divider(height: 1),
          ZoeSearchBarWidget(
            controller: searchController,
            onChanged: (value) {},
            hintText: L10n.of(context).searchEmojis,
          ),
          Expanded(
            child: _buildEmojiPicker(
              context,
              searchController,
              onSurface,
              colorScheme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker(
    BuildContext context,
    TextEditingController searchController,
    Color onSurface,
    ColorScheme colorScheme,
  ) {
    return EmojiPicker(
      onEmojiSelected: (_, emoji) {
        onEmojiSelected(emoji.emoji);
        Navigator.pop(context);
      },
      textEditingController: searchController,
      config: Config(
        height: 250,
        emojiTextStyle: TextStyle(
          fontSize: 28,
          shadows: [
            Shadow(
              color: onSurface.withValues(alpha: 0.1),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        emojiViewConfig: EmojiViewConfig(
          columns: 8,
          emojiSizeMax: 44,
          backgroundColor: Colors.transparent,
          verticalSpacing: 8,
          horizontalSpacing: 8,
          gridPadding: const EdgeInsets.all(16),
          buttonMode: ButtonMode.MATERIAL,
        ),
        categoryViewConfig: CategoryViewConfig(
          backgroundColor: colorScheme.surface,
          indicatorColor: Colors.transparent,
          iconColor: onSurface.withValues(alpha: 0.6),
          iconColorSelected: colorScheme.primary,
          backspaceColor: onSurface.withValues(alpha: 0.6),
          dividerColor: Colors.transparent,
          tabBarHeight: 40,
        ),
        bottomActionBarConfig: const BottomActionBarConfig(enabled: false),
      ),
    );
  }

  /// Header with title and close button
  Widget _buildHeader(BuildContext context, Color onSurface) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Text(
            L10n.of(context).chooseEmoji,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: onSurface,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.close,
                size: 20,
                color: onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper function to show the emoji picker modal
void showCustomEmojiPicker(
  BuildContext context,
  WidgetRef ref, {
  required Function(String emoji) onEmojiSelected,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => CustomEmojiPickerWidget(onEmojiSelected: onEmojiSelected),
  );
}
