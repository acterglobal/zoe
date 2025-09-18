// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji_search_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier for handling emoji search functionality

@ProviderFor(EmojiSearch)
const emojiSearchProvider = EmojiSearchProvider._();

/// Notifier for handling emoji search functionality
final class EmojiSearchProvider
    extends $NotifierProvider<EmojiSearch, EmojiSearchState> {
  /// Notifier for handling emoji search functionality
  const EmojiSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emojiSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emojiSearchHash();

  @$internal
  @override
  EmojiSearch create() => EmojiSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmojiSearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmojiSearchState>(value),
    );
  }
}

String _$emojiSearchHash() => r'cfb9e800d43a9f19677dff641def12f282fee59c';

/// Notifier for handling emoji search functionality

abstract class _$EmojiSearch extends $Notifier<EmojiSearchState> {
  EmojiSearchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<EmojiSearchState, EmojiSearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EmojiSearchState, EmojiSearchState>,
              EmojiSearchState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
