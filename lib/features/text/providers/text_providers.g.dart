// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TextList)
const textListProvider = TextListProvider._();

final class TextListProvider
    extends $NotifierProvider<TextList, List<TextModel>> {
  const TextListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'textListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$textListHash();

  @$internal
  @override
  TextList create() => TextList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TextModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TextModel>>(value),
    );
  }
}

String _$textListHash() => r'adc87dd2d75189d652f9040b3e3290f54bd78631';

abstract class _$TextList extends $Notifier<List<TextModel>> {
  List<TextModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<TextModel>, List<TextModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<TextModel>, List<TextModel>>,
              List<TextModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for a single text by ID

@ProviderFor(text)
const textProvider = TextFamily._();

/// Provider for a single text by ID

final class TextProvider
    extends $FunctionalProvider<TextModel?, TextModel?, TextModel?>
    with $Provider<TextModel?> {
  /// Provider for a single text by ID
  const TextProvider._({
    required TextFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'textProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$textHash();

  @override
  String toString() {
    return r'textProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<TextModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TextModel? create(Ref ref) {
    final argument = this.argument as String;
    return text(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TextModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TextModel?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TextProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$textHash() => r'd2266cb64dd9f0d9ec4c79bf7ff803e1f07fb1e0';

/// Provider for a single text by ID

final class TextFamily extends $Family
    with $FunctionalFamilyOverride<TextModel?, String> {
  const TextFamily._()
    : super(
        retry: null,
        name: r'textProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for a single text by ID

  TextProvider call(String textId) =>
      TextProvider._(argument: textId, from: this);

  @override
  String toString() => r'textProvider';
}

/// Provider for texts filtered by parent ID

@ProviderFor(textByParent)
const textByParentProvider = TextByParentFamily._();

/// Provider for texts filtered by parent ID

final class TextByParentProvider
    extends
        $FunctionalProvider<List<TextModel>, List<TextModel>, List<TextModel>>
    with $Provider<List<TextModel>> {
  /// Provider for texts filtered by parent ID
  const TextByParentProvider._({
    required TextByParentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'textByParentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$textByParentHash();

  @override
  String toString() {
    return r'textByParentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<TextModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<TextModel> create(Ref ref) {
    final argument = this.argument as String;
    return textByParent(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TextModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TextModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TextByParentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$textByParentHash() => r'6f1ef37608eaf60e3b9323388eef20f60bc0e070';

/// Provider for texts filtered by parent ID

final class TextByParentFamily extends $Family
    with $FunctionalFamilyOverride<List<TextModel>, String> {
  const TextByParentFamily._()
    : super(
        retry: null,
        name: r'textByParentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for texts filtered by parent ID

  TextByParentProvider call(String parentId) =>
      TextByParentProvider._(argument: parentId, from: this);

  @override
  String toString() => r'textByParentProvider';
}

/// Provider for searching texts

@ProviderFor(textListSearch)
const textListSearchProvider = TextListSearchFamily._();

/// Provider for searching texts

final class TextListSearchProvider
    extends
        $FunctionalProvider<List<TextModel>, List<TextModel>, List<TextModel>>
    with $Provider<List<TextModel>> {
  /// Provider for searching texts
  const TextListSearchProvider._({
    required TextListSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'textListSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$textListSearchHash();

  @override
  String toString() {
    return r'textListSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<TextModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<TextModel> create(Ref ref) {
    final argument = this.argument as String;
    return textListSearch(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TextModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TextModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TextListSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$textListSearchHash() => r'6fb00ac2024720db64b313ed9feed5190cf022c9';

/// Provider for searching texts

final class TextListSearchFamily extends $Family
    with $FunctionalFamilyOverride<List<TextModel>, String> {
  const TextListSearchFamily._()
    : super(
        retry: null,
        name: r'textListSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for searching texts

  TextListSearchProvider call(String searchTerm) =>
      TextListSearchProvider._(argument: searchTerm, from: this);

  @override
  String toString() => r'textListSearchProvider';
}

/// Provider for sorted texts

@ProviderFor(sortedTexts)
const sortedTextsProvider = SortedTextsProvider._();

/// Provider for sorted texts

final class SortedTextsProvider
    extends
        $FunctionalProvider<List<TextModel>, List<TextModel>, List<TextModel>>
    with $Provider<List<TextModel>> {
  /// Provider for sorted texts
  const SortedTextsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sortedTextsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sortedTextsHash();

  @$internal
  @override
  $ProviderElement<List<TextModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<TextModel> create(Ref ref) {
    return sortedTexts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TextModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TextModel>>(value),
    );
  }
}

String _$sortedTextsHash() => r'603c03fe05030cea11a5aa1862e2d22742cf3ec8';
