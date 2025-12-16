// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Main link list provider with all link management functionality

@ProviderFor(LinkList)
const linkListProvider = LinkListProvider._();

/// Main link list provider with all link management functionality
final class LinkListProvider
    extends $NotifierProvider<LinkList, List<LinkModel>> {
  /// Main link list provider with all link management functionality
  const LinkListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkListHash();

  @$internal
  @override
  LinkList create() => LinkList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<LinkModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<LinkModel>>(value),
    );
  }
}

String _$linkListHash() => r'b1408c52c0f9a4f71c38b6766f70888c7e4101fe';

/// Main link list provider with all link management functionality

abstract class _$LinkList extends $Notifier<List<LinkModel>> {
  List<LinkModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<LinkModel>, List<LinkModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<LinkModel>, List<LinkModel>>,
              List<LinkModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for a single link by ID

@ProviderFor(link)
const linkProvider = LinkFamily._();

/// Provider for a single link by ID

final class LinkProvider
    extends $FunctionalProvider<LinkModel?, LinkModel?, LinkModel?>
    with $Provider<LinkModel?> {
  /// Provider for a single link by ID
  const LinkProvider._({
    required LinkFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'linkProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$linkHash();

  @override
  String toString() {
    return r'linkProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<LinkModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LinkModel? create(Ref ref) {
    final argument = this.argument as String;
    return link(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LinkModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LinkModel?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LinkProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$linkHash() => r'1aa372fd9aebf6f2a04885f9b72bbfe396b0ef7f';

/// Provider for a single link by ID

final class LinkFamily extends $Family
    with $FunctionalFamilyOverride<LinkModel?, String> {
  const LinkFamily._()
    : super(
        retry: null,
        name: r'linkProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for a single link by ID

  LinkProvider call(String linkId) =>
      LinkProvider._(argument: linkId, from: this);

  @override
  String toString() => r'linkProvider';
}

/// Provider for links filtered by parent ID

@ProviderFor(linkByParent)
const linkByParentProvider = LinkByParentFamily._();

/// Provider for links filtered by parent ID

final class LinkByParentProvider
    extends
        $FunctionalProvider<List<LinkModel>, List<LinkModel>, List<LinkModel>>
    with $Provider<List<LinkModel>> {
  /// Provider for links filtered by parent ID
  const LinkByParentProvider._({
    required LinkByParentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'linkByParentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$linkByParentHash();

  @override
  String toString() {
    return r'linkByParentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<LinkModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<LinkModel> create(Ref ref) {
    final argument = this.argument as String;
    return linkByParent(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<LinkModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<LinkModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LinkByParentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$linkByParentHash() => r'2b524db25402d4c0474b6d5829473a35461e5ca6';

/// Provider for links filtered by parent ID

final class LinkByParentFamily extends $Family
    with $FunctionalFamilyOverride<List<LinkModel>, String> {
  const LinkByParentFamily._()
    : super(
        retry: null,
        name: r'linkByParentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for links filtered by parent ID

  LinkByParentProvider call(String parentId) =>
      LinkByParentProvider._(argument: parentId, from: this);

  @override
  String toString() => r'linkByParentProvider';
}

/// Provider for searching links

@ProviderFor(linkListSearch)
const linkListSearchProvider = LinkListSearchProvider._();

/// Provider for searching links

final class LinkListSearchProvider
    extends
        $FunctionalProvider<List<LinkModel>, List<LinkModel>, List<LinkModel>>
    with $Provider<List<LinkModel>> {
  /// Provider for searching links
  const LinkListSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkListSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkListSearchHash();

  @$internal
  @override
  $ProviderElement<List<LinkModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<LinkModel> create(Ref ref) {
    return linkListSearch(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<LinkModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<LinkModel>>(value),
    );
  }
}

String _$linkListSearchHash() => r'848fbc2e83ec533a0380f5f1f480085b4d20a4b4';
