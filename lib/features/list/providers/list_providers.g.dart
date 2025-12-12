// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Main list provider with all list management functionality

@ProviderFor(Lists)
const listsProvider = ListsProvider._();

/// Main list provider with all list management functionality
final class ListsProvider extends $NotifierProvider<Lists, List<ListModel>> {
  /// Main list provider with all list management functionality
  const ListsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listsHash();

  @$internal
  @override
  Lists create() => Lists();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ListModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ListModel>>(value),
    );
  }
}

String _$listsHash() => r'578fb3d7e7101f4fa417b73bb22d7c6a6d4ca6fc';

/// Main list provider with all list management functionality

abstract class _$Lists extends $Notifier<List<ListModel>> {
  List<ListModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<ListModel>, List<ListModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ListModel>, List<ListModel>>,
              List<ListModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for a single list item by ID

@ProviderFor(listItem)
const listItemProvider = ListItemFamily._();

/// Provider for a single list item by ID

final class ListItemProvider
    extends $FunctionalProvider<ListModel?, ListModel?, ListModel?>
    with $Provider<ListModel?> {
  /// Provider for a single list item by ID
  const ListItemProvider._({
    required ListItemFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'listItemProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$listItemHash();

  @override
  String toString() {
    return r'listItemProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<ListModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ListModel? create(Ref ref) {
    final argument = this.argument as String;
    return listItem(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListModel?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ListItemProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$listItemHash() => r'5ca0e8b92f6634b5c079486cbf6fb3ff5b376c1f';

/// Provider for a single list item by ID

final class ListItemFamily extends $Family
    with $FunctionalFamilyOverride<ListModel?, String> {
  const ListItemFamily._()
    : super(
        retry: null,
        name: r'listItemProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for a single list item by ID

  ListItemProvider call(String listId) =>
      ListItemProvider._(argument: listId, from: this);

  @override
  String toString() => r'listItemProvider';
}

/// Provider for lists filtered by parent ID

@ProviderFor(listByParent)
const listByParentProvider = ListByParentFamily._();

/// Provider for lists filtered by parent ID

final class ListByParentProvider
    extends
        $FunctionalProvider<List<ListModel>, List<ListModel>, List<ListModel>>
    with $Provider<List<ListModel>> {
  /// Provider for lists filtered by parent ID
  const ListByParentProvider._({
    required ListByParentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'listByParentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$listByParentHash();

  @override
  String toString() {
    return r'listByParentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<ListModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<ListModel> create(Ref ref) {
    final argument = this.argument as String;
    return listByParent(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ListModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ListModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ListByParentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$listByParentHash() => r'8423542525f86c9d92041bcd39888e7ee66db583';

/// Provider for lists filtered by parent ID

final class ListByParentFamily extends $Family
    with $FunctionalFamilyOverride<List<ListModel>, String> {
  const ListByParentFamily._()
    : super(
        retry: null,
        name: r'listByParentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for lists filtered by parent ID

  ListByParentProvider call(String parentId) =>
      ListByParentProvider._(argument: parentId, from: this);

  @override
  String toString() => r'listByParentProvider';
}

/// Provider for searching lists

@ProviderFor(listSearch)
const listSearchProvider = ListSearchFamily._();

/// Provider for searching lists

final class ListSearchProvider
    extends
        $FunctionalProvider<List<ListModel>, List<ListModel>, List<ListModel>>
    with $Provider<List<ListModel>> {
  /// Provider for searching lists
  const ListSearchProvider._({
    required ListSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'listSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$listSearchHash();

  @override
  String toString() {
    return r'listSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<ListModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<ListModel> create(Ref ref) {
    final argument = this.argument as String;
    return listSearch(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ListModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ListModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ListSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$listSearchHash() => r'6ebaa694206d3c3ad8bae66935a86fffc1d64cc3';

/// Provider for searching lists

final class ListSearchFamily extends $Family
    with $FunctionalFamilyOverride<List<ListModel>, String> {
  const ListSearchFamily._()
    : super(
        retry: null,
        name: r'listSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for searching lists

  ListSearchProvider call(String searchTerm) =>
      ListSearchProvider._(argument: searchTerm, from: this);

  @override
  String toString() => r'listSearchProvider';
}
