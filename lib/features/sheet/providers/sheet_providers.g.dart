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

String _$sheetListHash() => r'071b717be5cbb57fd1d94e4d8ccdde74029c2cb9';

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

String _$sheetListSearchHash() => r'93398bf3848f81ca8d6d661712c3557cc0258db1';

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
