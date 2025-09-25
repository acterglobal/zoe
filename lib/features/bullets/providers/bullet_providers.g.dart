// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bullet_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Main bullet list notifier with all bullet management functionality

@ProviderFor(BulletList)
const bulletListProvider = BulletListProvider._();

/// Main bullet list notifier with all bullet management functionality
final class BulletListProvider
    extends $NotifierProvider<BulletList, List<BulletModel>> {
  /// Main bullet list notifier with all bullet management functionality
  const BulletListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bulletListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bulletListHash();

  @$internal
  @override
  BulletList create() => BulletList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<BulletModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<BulletModel>>(value),
    );
  }
}

String _$bulletListHash() => r'09ec450f9d9de372cbd06bdb4d576920734d3ee7';

/// Main bullet list notifier with all bullet management functionality

abstract class _$BulletList extends $Notifier<List<BulletModel>> {
  List<BulletModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<BulletModel>, List<BulletModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<BulletModel>, List<BulletModel>>,
              List<BulletModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for a single bullet by ID

@ProviderFor(bullet)
const bulletProvider = BulletFamily._();

/// Provider for a single bullet by ID

final class BulletProvider
    extends $FunctionalProvider<BulletModel?, BulletModel?, BulletModel?>
    with $Provider<BulletModel?> {
  /// Provider for a single bullet by ID
  const BulletProvider._({
    required BulletFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bulletProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bulletHash();

  @override
  String toString() {
    return r'bulletProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<BulletModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BulletModel? create(Ref ref) {
    final argument = this.argument as String;
    return bullet(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BulletModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BulletModel?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BulletProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bulletHash() => r'3d9fbbf674cc85a73d3c90fd3cdb8dbf59505123';

/// Provider for a single bullet by ID

final class BulletFamily extends $Family
    with $FunctionalFamilyOverride<BulletModel?, String> {
  const BulletFamily._()
    : super(
        retry: null,
        name: r'bulletProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for a single bullet by ID

  BulletProvider call(String bulletId) =>
      BulletProvider._(argument: bulletId, from: this);

  @override
  String toString() => r'bulletProvider';
}

/// Provider for bullets filtered by parent ID

@ProviderFor(bulletListByParent)
const bulletListByParentProvider = BulletListByParentFamily._();

/// Provider for bullets filtered by parent ID

final class BulletListByParentProvider
    extends
        $FunctionalProvider<
          List<BulletModel>,
          List<BulletModel>,
          List<BulletModel>
        >
    with $Provider<List<BulletModel>> {
  /// Provider for bullets filtered by parent ID
  const BulletListByParentProvider._({
    required BulletListByParentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bulletListByParentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bulletListByParentHash();

  @override
  String toString() {
    return r'bulletListByParentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<BulletModel>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<BulletModel> create(Ref ref) {
    final argument = this.argument as String;
    return bulletListByParent(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<BulletModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<BulletModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BulletListByParentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bulletListByParentHash() =>
    r'3237d7997592e240f3a7073684c29bc0373bf283';

/// Provider for bullets filtered by parent ID

final class BulletListByParentFamily extends $Family
    with $FunctionalFamilyOverride<List<BulletModel>, String> {
  const BulletListByParentFamily._()
    : super(
        retry: null,
        name: r'bulletListByParentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for bullets filtered by parent ID

  BulletListByParentProvider call(String parentId) =>
      BulletListByParentProvider._(argument: parentId, from: this);

  @override
  String toString() => r'bulletListByParentProvider';
}

/// Focus management for newly added bullets

@ProviderFor(BulletFocus)
const bulletFocusProvider = BulletFocusProvider._();

/// Focus management for newly added bullets
final class BulletFocusProvider
    extends $NotifierProvider<BulletFocus, String?> {
  /// Focus management for newly added bullets
  const BulletFocusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bulletFocusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bulletFocusHash();

  @$internal
  @override
  BulletFocus create() => BulletFocus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$bulletFocusHash() => r'4811dc4fc115aecc98f0d531cf3a7492cd7d5b28';

/// Focus management for newly added bullets

abstract class _$BulletFocus extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
