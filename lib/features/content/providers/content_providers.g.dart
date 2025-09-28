// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Computed provider that combines data from individual module providers
/// Sorted by orderIndex within each parent, then by createdAt as fallback

@ProviderFor(contentList)
const contentListProvider = ContentListProvider._();

/// Computed provider that combines data from individual module providers
/// Sorted by orderIndex within each parent, then by createdAt as fallback

final class ContentListProvider
    extends
        $FunctionalProvider<
          List<ContentModel>,
          List<ContentModel>,
          List<ContentModel>
        >
    with $Provider<List<ContentModel>> {
  /// Computed provider that combines data from individual module providers
  /// Sorted by orderIndex within each parent, then by createdAt as fallback
  const ContentListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contentListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contentListHash();

  @$internal
  @override
  $ProviderElement<List<ContentModel>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<ContentModel> create(Ref ref) {
    return contentList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ContentModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ContentModel>>(value),
    );
  }
}

String _$contentListHash() => r'48a1b3d2010c2a0f901f78c9426912ce73643467';

/// Provider for content filtered by parent ID

@ProviderFor(contentListByParentId)
const contentListByParentIdProvider = ContentListByParentIdFamily._();

/// Provider for content filtered by parent ID

final class ContentListByParentIdProvider
    extends
        $FunctionalProvider<
          List<ContentModel>,
          List<ContentModel>,
          List<ContentModel>
        >
    with $Provider<List<ContentModel>> {
  /// Provider for content filtered by parent ID
  const ContentListByParentIdProvider._({
    required ContentListByParentIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'contentListByParentIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contentListByParentIdHash();

  @override
  String toString() {
    return r'contentListByParentIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<ContentModel>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<ContentModel> create(Ref ref) {
    final argument = this.argument as String;
    return contentListByParentId(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ContentModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ContentModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ContentListByParentIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contentListByParentIdHash() =>
    r'4f4519fe4aea281758acfb607f9d95519b9061e1';

/// Provider for content filtered by parent ID

final class ContentListByParentIdFamily extends $Family
    with $FunctionalFamilyOverride<List<ContentModel>, String> {
  const ContentListByParentIdFamily._()
    : super(
        retry: null,
        name: r'contentListByParentIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for content filtered by parent ID

  ContentListByParentIdProvider call(String parentId) =>
      ContentListByParentIdProvider._(argument: parentId, from: this);

  @override
  String toString() => r'contentListByParentIdProvider';
}

/// Provider for a single content by ID

@ProviderFor(content)
const contentProvider = ContentFamily._();

/// Provider for a single content by ID

final class ContentProvider
    extends $FunctionalProvider<ContentModel?, ContentModel?, ContentModel?>
    with $Provider<ContentModel?> {
  /// Provider for a single content by ID
  const ContentProvider._({
    required ContentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'contentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contentHash();

  @override
  String toString() {
    return r'contentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<ContentModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ContentModel? create(Ref ref) {
    final argument = this.argument as String;
    return content(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContentModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContentModel?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ContentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contentHash() => r'79da168fad69ee62d15514d335c29cb8867e2bf5';

/// Provider for a single content by ID

final class ContentFamily extends $Family
    with $FunctionalFamilyOverride<ContentModel?, String> {
  const ContentFamily._()
    : super(
        retry: null,
        name: r'contentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for a single content by ID

  ContentProvider call(String contentId) =>
      ContentProvider._(argument: contentId, from: this);

  @override
  String toString() => r'contentProvider';
}
