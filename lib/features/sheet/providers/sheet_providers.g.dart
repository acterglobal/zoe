// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sheet_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Main sheet list provider with all sheet management functionality

@ProviderFor(SheetList)
const sheetListProvider = SheetListProvider._();

/// Main sheet list provider with all sheet management functionality
final class SheetListProvider
    extends $NotifierProvider<SheetList, List<SheetModel>> {
  /// Main sheet list provider with all sheet management functionality
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

String _$sheetListHash() => r'7e58ebc74c9335414fa2a424e8b3d25058215047';

/// Main sheet list provider with all sheet management functionality

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

/// Provider for sheets filtered by membership (current user must be a member)

@ProviderFor(memberSheets)
const memberSheetsProvider = MemberSheetsProvider._();

/// Provider for sheets filtered by membership (current user must be a member)

final class MemberSheetsProvider
    extends
        $FunctionalProvider<
          List<SheetModel>,
          List<SheetModel>,
          List<SheetModel>
        >
    with $Provider<List<SheetModel>> {
  /// Provider for sheets filtered by membership (current user must be a member)
  const MemberSheetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memberSheetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memberSheetsHash();

  @$internal
  @override
  $ProviderElement<List<SheetModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<SheetModel> create(Ref ref) {
    return memberSheets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SheetModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SheetModel>>(value),
    );
  }
}

String _$memberSheetsHash() => r'e9a6d9392eddcc85a6d08b5d4ae4735df0caa708';

/// Provider for searching sheets

@ProviderFor(sheetListSearch)
const sheetListSearchProvider = SheetListSearchProvider._();

/// Provider for searching sheets

final class SheetListSearchProvider
    extends
        $FunctionalProvider<
          List<SheetModel>,
          List<SheetModel>,
          List<SheetModel>
        >
    with $Provider<List<SheetModel>> {
  /// Provider for searching sheets
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

String _$sheetListSearchHash() => r'478be6cdb1287c4be6d3c1b9414ec3589ce33808';

/// Provider for a single sheet by ID

@ProviderFor(sheet)
const sheetProvider = SheetFamily._();

/// Provider for a single sheet by ID

final class SheetProvider
    extends $FunctionalProvider<SheetModel?, SheetModel?, SheetModel?>
    with $Provider<SheetModel?> {
  /// Provider for a single sheet by ID
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

String _$sheetHash() => r'23dbb2da469ce0110e0f6f82122873e908175561';

/// Provider for a single sheet by ID

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

  /// Provider for a single sheet by ID

  SheetProvider call(String sheetId) =>
      SheetProvider._(argument: sheetId, from: this);

  @override
  String toString() => r'sheetProvider';
}

/// Provider for list of users in a sheet

@ProviderFor(listOfUsersBySheetId)
const listOfUsersBySheetIdProvider = ListOfUsersBySheetIdFamily._();

/// Provider for list of users in a sheet

final class ListOfUsersBySheetIdProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  /// Provider for list of users in a sheet
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
    r'df6f970ce33d3935d21f30914f64679a492efc59';

/// Provider for list of users in a sheet

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

  /// Provider for list of users in a sheet

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

String _$sortedSheetsHash() => r'9905b55fb79aca05f96d8fd43f849b157d985a47';
