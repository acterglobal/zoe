// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quill_toolbar_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QuillToolbar)
const quillToolbarProvider = QuillToolbarProvider._();

final class QuillToolbarProvider
    extends $NotifierProvider<QuillToolbar, QuillToolbarState> {
  const QuillToolbarProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quillToolbarProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quillToolbarHash();

  @$internal
  @override
  QuillToolbar create() => QuillToolbar();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuillToolbarState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuillToolbarState>(value),
    );
  }
}

String _$quillToolbarHash() => r'fd396022a667968387bd26b5dace5ba1b0ac4856';

abstract class _$QuillToolbar extends $Notifier<QuillToolbarState> {
  QuillToolbarState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<QuillToolbarState, QuillToolbarState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<QuillToolbarState, QuillToolbarState>,
              QuillToolbarState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
