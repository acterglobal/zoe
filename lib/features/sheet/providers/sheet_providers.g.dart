// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sheet_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SheetList)
const sheetListProvider = SheetListProvider._();

final class SheetListProvider
    extends $NotifierProvider<SheetList, List<SheetModel>> {
  const SheetListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sheetListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sheetListHash();

  @$internal
  @override
  SheetList create() => SheetList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SheetModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SheetModel>>(value),
    );
  }
}

String _$sheetListHash() => r'c5abc9e268298aba533799daa40d75c6fe53802d';

abstract class _$SheetList extends $Notifier<List<SheetModel>> {
  List<SheetModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<SheetModel>, List<SheetModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<SheetModel>, List<SheetModel>>,
              List<SheetModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Filters by membership

@ProviderFor(sheetsList)
const sheetsListProvider = SheetsListProvider._();

/// Filters by membership

final class SheetsListProvider
    extends
        $FunctionalProvider<
          List<SheetModel>,
          List<SheetModel>,
          List<SheetModel>
        >
    with $Provider<List<SheetModel>> {
  /// Filters by membership
  const SheetsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sheetsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sheetsListHash();

  @$internal
  @override
  $ProviderElement<List<SheetModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<SheetModel> create(Ref ref) {
    return sheetsList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SheetModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SheetModel>>(value),
    );
  }
}

String _$sheetsListHash() => r'2aa2bfdc64b8a7ba7290046b39b0f2824d681828';

/// Search provider

@ProviderFor(sheetListSearch)
const sheetListSearchProvider = SheetListSearchProvider._();

/// Search provider

final class SheetListSearchProvider
    extends
        $FunctionalProvider<
          List<SheetModel>,
          List<SheetModel>,
          List<SheetModel>
        >
    with $Provider<List<SheetModel>> {
  /// Search provider
  const SheetListSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sheetListSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sheetListSearchHash();

  @$internal
  @override
  $ProviderElement<List<SheetModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<SheetModel> create(Ref ref) {
    return sheetListSearch(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SheetModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SheetModel>>(value),
    );
  }
}

String _$sheetListSearchHash() => r'819ef72f72cb682624888c237311c4dc3e651889';

/// Get Single Sheet

@ProviderFor(sheet)
const sheetProvider = SheetFamily._();

/// Get Single Sheet

final class SheetProvider
    extends $FunctionalProvider<SheetModel?, SheetModel?, SheetModel?>
    with $Provider<SheetModel?> {
  /// Get Single Sheet
  const SheetProvider._({
    required SheetFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sheetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sheetHash();

  @override
  String toString() {
    return r'sheetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<SheetModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SheetModel? create(Ref ref) {
    final argument = this.argument as String;
    return sheet(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SheetModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SheetModel?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SheetProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sheetHash() => r'643f3018c457e0265991a63b129a7d554cf53122';

/// Get Single Sheet

final class SheetFamily extends $Family
    with $FunctionalFamilyOverride<SheetModel?, String> {
  const SheetFamily._()
    : super(
        retry: null,
        name: r'sheetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get Single Sheet

  SheetProvider call(String sheetId) =>
      SheetProvider._(argument: sheetId, from: this);

  @override
  String toString() => r'sheetProvider';
}

/// Get Users of Sheet

@ProviderFor(listOfUsersBySheetId)
const listOfUsersBySheetIdProvider = ListOfUsersBySheetIdFamily._();

/// Get Users of Sheet

final class ListOfUsersBySheetIdProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  /// Get Users of Sheet
  const ListOfUsersBySheetIdProvider._({
    required ListOfUsersBySheetIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'listOfUsersBySheetIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$listOfUsersBySheetIdHash();

  @override
  String toString() {
    return r'listOfUsersBySheetIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    final argument = this.argument as String;
    return listOfUsersBySheetId(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ListOfUsersBySheetIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$listOfUsersBySheetIdHash() =>
    r'6795fc9de767d64d6806d624fad19fab81d3415f';

/// Get Users of Sheet

final class ListOfUsersBySheetIdFamily extends $Family
    with $FunctionalFamilyOverride<List<String>, String> {
  const ListOfUsersBySheetIdFamily._()
    : super(
        retry: null,
        name: r'listOfUsersBySheetIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get Users of Sheet

  ListOfUsersBySheetIdProvider call(String sheetId) =>
      ListOfUsersBySheetIdProvider._(argument: sheetId, from: this);

  @override
  String toString() => r'listOfUsersBySheetIdProvider';
}

/// Provider to check if a sheet exists

@ProviderFor(sheetExists)
const sheetExistsProvider = SheetExistsFamily._();

/// Provider to check if a sheet exists

final class SheetExistsProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provider to check if a sheet exists
  const SheetExistsProvider._({
    required SheetExistsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sheetExistsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sheetExistsHash();

  @override
  String toString() {
    return r'sheetExistsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as String;
    return sheetExists(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SheetExistsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sheetExistsHash() => r'1271be6e2dccad76c612a52e81aaeca23cb72ae0';

/// Provider to check if a sheet exists

final class SheetExistsFamily extends $Family
    with $FunctionalFamilyOverride<bool, String> {
  const SheetExistsFamily._()
    : super(
        retry: null,
        name: r'sheetExistsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider to check if a sheet exists

  SheetExistsProvider call(String sheetId) =>
      SheetExistsProvider._(argument: sheetId, from: this);

  @override
  String toString() => r'sheetExistsProvider';
}

/// Provider for sheets sorted by title (filtered by membership)

@ProviderFor(sortedSheets)
const sortedSheetsProvider = SortedSheetsProvider._();

/// Provider for sheets sorted by title (filtered by membership)

final class SortedSheetsProvider
    extends
        $FunctionalProvider<
          List<SheetModel>,
          List<SheetModel>,
          List<SheetModel>
        >
    with $Provider<List<SheetModel>> {
  /// Provider for sheets sorted by title (filtered by membership)
  const SortedSheetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sortedSheetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sortedSheetsHash();

  @$internal
  @override
  $ProviderElement<List<SheetModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<SheetModel> create(Ref ref) {
    return sortedSheets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SheetModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SheetModel>>(value),
    );
  }
}

String _$sortedSheetsHash() => r'e58c9902407d4adccfa510004bee3bcf2854e252';
