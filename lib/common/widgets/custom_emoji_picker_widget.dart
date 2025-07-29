import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:emoji_picker_flutter/src/emoji_picker_internal_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/emoji_picker/emoji_picker_config.dart';
import 'package:zoey/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoey/l10n/generated/l10n.dart';

// Main emoji picker widget
class CustomEmojiPickerWidget extends ConsumerStatefulWidget {
  final Function(String emoji) onEmojiSelected;

  const CustomEmojiPickerWidget({super.key, required this.onEmojiSelected});

  @override
  ConsumerState<CustomEmojiPickerWidget> createState() =>
      _CustomEmojiPickerWidgetState();
}

class _CustomEmojiPickerWidgetState
    extends ConsumerState<CustomEmojiPickerWidget> {
  late TextEditingController _searchController;
  final EmojiPickerUtils _emojiUtils = EmojiPickerUtils();
  List<CategoryEmoji> _allEmojiCategories = [];
  EmojiSearchState _searchState = const EmojiSearchState();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadEmojiData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEmojiData() async {
    try {
      final emojiPickerInternalUtils = EmojiPickerInternalUtils();
      final filteredCategories = await emojiPickerInternalUtils
          .filterUnsupported(defaultEmojiSet);

      setState(() {
        _allEmojiCategories = filteredCategories;
      });
    } catch (e) {
      debugPrint('Error loading emoji data: $e');
    }
  }

  Future<void> _performEmojiSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchState = const EmojiSearchState();
      });
      return;
    }

    setState(() {
      _searchState = _searchState.copyWith(isSearching: true, query: query);
    });

    try {
      final results = await _emojiUtils.searchEmoji(query, _allEmojiCategories);
      setState(() {
        _searchState = _searchState.copyWith(
          searchResults: results,
          isSearching: false,
        );
      });
    } catch (e) {
      setState(() {
        _searchState = _searchState.copyWith(
          searchResults: [],
          isSearching: false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.0,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        children: [
          _buildEmojiPickerHeader(context),
          const Divider(height: 1),
          _buildSearchBar(),
          Expanded(child: _buildContent(context)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return ZoeSearchBarWidget(
      controller: _searchController,
      onChanged: _performEmojiSearch,
      hintText: L10n.of(context).searchEmojis,
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_searchState.query.isNotEmpty) {
      return _buildSearchResultsWidget(
        context,
        _searchState,
        widget.onEmojiSelected,
      );
    }

    return _buildEmojiPicker(context);
  }

  Widget _buildEmojiPicker(BuildContext context) {
    final config = EmojiPickerConfigBuilder.buildConfig(
      context,
      _searchController,
      widget.onEmojiSelected,
    );

    return EmojiPicker(
      onEmojiSelected: (_, emoji) {
        widget.onEmojiSelected(emoji.emoji);
        Navigator.pop(context);
      },
      textEditingController: _searchController,
      config: config,
    );
  }

  // Emoji picker header widget
  Widget _buildEmojiPickerHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Text(
            L10n.of(context).chooseEmoji,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          _buildCloseButton(context),
        ],
      ),
    );
  }

  // Close button widget
  Widget _buildCloseButton(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.onSurface;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Icon(
          Icons.close,
          size: 20.0,
          color: iconColor.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  // Search results widget
  Widget _buildSearchResultsWidget(
    BuildContext context,
    EmojiSearchState searchState,
    Function(String emoji) onEmojiSelected,
  ) {
    if (searchState.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchState.searchResults.isEmpty) {
      return _buildEmptySearchState(context);
    }

    return _buildSearchResultsGrid(context, searchState, onEmojiSelected);
  }

  Widget _buildEmptySearchState(BuildContext context) {
    return Center(
      child: Text(
        L10n.of(context).noEmojisFound,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSearchResultsGrid(
    BuildContext context,
    EmojiSearchState searchState,
    Function(String emoji) onEmojiSelected,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1,
      ),
      itemCount: searchState.searchResults.length,
      itemBuilder: (context, index) {
        final emoji = searchState.searchResults[index];
        return _buildEmojiItem(context, emoji, onEmojiSelected);
      },
    );
  }

  // Individual emoji item widget
  Widget _buildEmojiItem(
    BuildContext context,
    Emoji emoji,
    Function(String emoji) onEmojiSelected,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      onTap: () {
        onEmojiSelected(emoji.emoji);
        Navigator.pop(context);
      },
      child: Center(
        child: Text(emoji.emoji, style: const TextStyle(fontSize: 28.0)),
      ),
    );
  }
}

// Utility function to show emoji picker
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
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: CustomEmojiPickerWidget(onEmojiSelected: onEmojiSelected),
    ),
  );
}
