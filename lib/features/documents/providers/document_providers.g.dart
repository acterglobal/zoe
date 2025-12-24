// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Main document list provider with all document management functionality

@ProviderFor(DocumentList)
const documentListProvider = DocumentListProvider._();

/// Main document list provider with all document management functionality
final class DocumentListProvider
    extends $NotifierProvider<DocumentList, List<DocumentModel>> {
  /// Main document list provider with all document management functionality
  const DocumentListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentListHash();

  @$internal
  @override
  DocumentList create() => DocumentList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DocumentModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DocumentModel>>(value),
    );
  }
}

String _$documentListHash() => r'0dd896a3c1a5c86c41093691c2296cc9df55832f';

/// Main document list provider with all document management functionality

abstract class _$DocumentList extends $Notifier<List<DocumentModel>> {
  List<DocumentModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<DocumentModel>, List<DocumentModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<DocumentModel>, List<DocumentModel>>,
              List<DocumentModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for a single document by ID

@ProviderFor(document)
const documentProvider = DocumentFamily._();

/// Provider for a single document by ID

final class DocumentProvider
    extends $FunctionalProvider<DocumentModel?, DocumentModel?, DocumentModel?>
    with $Provider<DocumentModel?> {
  /// Provider for a single document by ID
  const DocumentProvider._({
    required DocumentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'documentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentHash();

  @override
  String toString() {
    return r'documentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<DocumentModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DocumentModel? create(Ref ref) {
    final argument = this.argument as String;
    return document(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentModel?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentHash() => r'6f1a65024b2c8bdb47747ad35a71218fabc0629a';

/// Provider for a single document by ID

final class DocumentFamily extends $Family
    with $FunctionalFamilyOverride<DocumentModel?, String> {
  const DocumentFamily._()
    : super(
        retry: null,
        name: r'documentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for a single document by ID

  DocumentProvider call(String documentId) =>
      DocumentProvider._(argument: documentId, from: this);

  @override
  String toString() => r'documentProvider';
}

/// Provider for documents filtered by parent ID

@ProviderFor(documentListByParent)
const documentListByParentProvider = DocumentListByParentFamily._();

/// Provider for documents filtered by parent ID

final class DocumentListByParentProvider
    extends
        $FunctionalProvider<
          List<DocumentModel>,
          List<DocumentModel>,
          List<DocumentModel>
        >
    with $Provider<List<DocumentModel>> {
  /// Provider for documents filtered by parent ID
  const DocumentListByParentProvider._({
    required DocumentListByParentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'documentListByParentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentListByParentHash();

  @override
  String toString() {
    return r'documentListByParentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<DocumentModel>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DocumentModel> create(Ref ref) {
    final argument = this.argument as String;
    return documentListByParent(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DocumentModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DocumentModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentListByParentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentListByParentHash() =>
    r'41cd2c7286a85a18270661eb1e322a99e6967528';

/// Provider for documents filtered by parent ID

final class DocumentListByParentFamily extends $Family
    with $FunctionalFamilyOverride<List<DocumentModel>, String> {
  const DocumentListByParentFamily._()
    : super(
        retry: null,
        name: r'documentListByParentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for documents filtered by parent ID

  DocumentListByParentProvider call(String parentId) =>
      DocumentListByParentProvider._(argument: parentId, from: this);

  @override
  String toString() => r'documentListByParentProvider';
}

/// Provider for searching documents

@ProviderFor(documentListSearch)
const documentListSearchProvider = DocumentListSearchProvider._();

/// Provider for searching documents

final class DocumentListSearchProvider
    extends
        $FunctionalProvider<
          List<DocumentModel>,
          List<DocumentModel>,
          List<DocumentModel>
        >
    with $Provider<List<DocumentModel>> {
  /// Provider for searching documents
  const DocumentListSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentListSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentListSearchHash();

  @$internal
  @override
  $ProviderElement<List<DocumentModel>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DocumentModel> create(Ref ref) {
    return documentListSearch(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DocumentModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DocumentModel>>(value),
    );
  }
}

String _$documentListSearchHash() =>
    r'd5cbe3d1b219b3fa739f3672f15e703aa7fdf4a3';
