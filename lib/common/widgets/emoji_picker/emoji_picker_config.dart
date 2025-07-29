// Emoji picker configuration builder
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class EmojiPickerConfigBuilder {
  static Config buildConfig(
    BuildContext context,
    TextEditingController searchController,
    Function(String emoji) onEmojiSelected,
  ) {
    return Config(
      height: 250.0,
      emojiTextStyle: _buildEmojiTextStyle(context),
      emojiViewConfig: _buildEmojiViewConfig(),
      categoryViewConfig: _buildCategoryViewConfig(context),
      bottomActionBarConfig: const BottomActionBarConfig(enabled: false),
    );
  }

  static TextStyle _buildEmojiTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 28.0,
      shadows: [
        Shadow(
          color:  Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
          offset: const Offset(0, 1),
          blurRadius: 2,
        ),
      ],
    );
  }

  static EmojiViewConfig _buildEmojiViewConfig() {
    return EmojiViewConfig(
      backgroundColor: Colors.transparent,
      columns: 8,
      emojiSizeMax: 44.0,
      verticalSpacing: 8.0,
      horizontalSpacing: 8.0,
      gridPadding: const EdgeInsets.all(16.0),
      buttonMode: ButtonMode.MATERIAL,
    );
  }

  static CategoryViewConfig _buildCategoryViewConfig(
    BuildContext context,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return CategoryViewConfig(
      backgroundColor: colorScheme.surface,
      indicatorColor: Colors.transparent,
      iconColor: colorScheme.onSurface.withValues(alpha: 0.6),
      iconColorSelected: colorScheme.primary,
      backspaceColor: colorScheme.onSurface.withValues(alpha: 0.6),
      dividerColor: Colors.transparent,
      tabBarHeight: 40.0,
    );
  }
}
