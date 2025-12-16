// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PollList)
const pollListProvider = PollListProvider._();

final class PollListProvider
    extends $NotifierProvider<PollList, List<PollModel>> {
  const PollListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pollListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pollListHash();

  @$internal
  @override
  PollList create() => PollList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PollModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PollModel>>(value),
    );
  }
}

String _$pollListHash() => r'2dcbaaefee91922fc4e7f3f0c57c46eb6aef6868';

abstract class _$PollList extends $Notifier<List<PollModel>> {
  List<PollModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<PollModel>, List<PollModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<PollModel>, List<PollModel>>,
              List<PollModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(poll)
const pollProvider = PollFamily._();

final class PollProvider
    extends $FunctionalProvider<PollModel?, PollModel?, PollModel?>
    with $Provider<PollModel?> {
  const PollProvider._({
    required PollFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'pollProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pollHash();

  @override
  String toString() {
    return r'pollProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<PollModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PollModel? create(Ref ref) {
    final argument = this.argument as String;
    return poll(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PollModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PollModel?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PollProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pollHash() => r'7721018d9c0eafe3f2b57f6d544325690ee104b7';

final class PollFamily extends $Family
    with $FunctionalFamilyOverride<PollModel?, String> {
  const PollFamily._()
    : super(
        retry: null,
        name: r'pollProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PollProvider call(String pollId) =>
      PollProvider._(argument: pollId, from: this);

  @override
  String toString() => r'pollProvider';
}

@ProviderFor(notActivePollList)
const notActivePollListProvider = NotActivePollListProvider._();

final class NotActivePollListProvider
    extends
        $FunctionalProvider<List<PollModel>, List<PollModel>, List<PollModel>>
    with $Provider<List<PollModel>> {
  const NotActivePollListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notActivePollListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notActivePollListHash();

  @$internal
  @override
  $ProviderElement<List<PollModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<PollModel> create(Ref ref) {
    return notActivePollList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PollModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PollModel>>(value),
    );
  }
}

String _$notActivePollListHash() => r'e77ac147bf6d3def9e14943a784904c75e8554b6';

@ProviderFor(activePollList)
const activePollListProvider = ActivePollListProvider._();

final class ActivePollListProvider
    extends
        $FunctionalProvider<List<PollModel>, List<PollModel>, List<PollModel>>
    with $Provider<List<PollModel>> {
  const ActivePollListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activePollListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activePollListHash();

  @$internal
  @override
  $ProviderElement<List<PollModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<PollModel> create(Ref ref) {
    return activePollList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PollModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PollModel>>(value),
    );
  }
}

String _$activePollListHash() => r'29392dc2f0e61cc3d8c21566c32123dfe3709203';

@ProviderFor(completedPollList)
const completedPollListProvider = CompletedPollListProvider._();

final class CompletedPollListProvider
    extends
        $FunctionalProvider<List<PollModel>, List<PollModel>, List<PollModel>>
    with $Provider<List<PollModel>> {
  const CompletedPollListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completedPollListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completedPollListHash();

  @$internal
  @override
  $ProviderElement<List<PollModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<PollModel> create(Ref ref) {
    return completedPollList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PollModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PollModel>>(value),
    );
  }
}

String _$completedPollListHash() => r'824b380a253c3f5fcd72157e710deec54a091a2d';

@ProviderFor(pollListSearch)
const pollListSearchProvider = PollListSearchProvider._();

final class PollListSearchProvider
    extends
        $FunctionalProvider<List<PollModel>, List<PollModel>, List<PollModel>>
    with $Provider<List<PollModel>> {
  const PollListSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pollListSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pollListSearchHash();

  @$internal
  @override
  $ProviderElement<List<PollModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<PollModel> create(Ref ref) {
    return pollListSearch(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PollModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PollModel>>(value),
    );
  }
}

String _$pollListSearchHash() => r'afb2fa93e421cac1ed2b29c70c41f585c662f926';

@ProviderFor(pollListByParent)
const pollListByParentProvider = PollListByParentFamily._();

final class PollListByParentProvider
    extends
        $FunctionalProvider<List<PollModel>, List<PollModel>, List<PollModel>>
    with $Provider<List<PollModel>> {
  const PollListByParentProvider._({
    required PollListByParentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'pollListByParentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pollListByParentHash();

  @override
  String toString() {
    return r'pollListByParentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<PollModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<PollModel> create(Ref ref) {
    final argument = this.argument as String;
    return pollListByParent(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PollModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PollModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PollListByParentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pollListByParentHash() => r'acd48cb4ebb8027f233e0732a9334b393a3ac8c9';

final class PollListByParentFamily extends $Family
    with $FunctionalFamilyOverride<List<PollModel>, String> {
  const PollListByParentFamily._()
    : super(
        retry: null,
        name: r'pollListByParentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PollListByParentProvider call(String parentId) =>
      PollListByParentProvider._(argument: parentId, from: this);

  @override
  String toString() => r'pollListByParentProvider';
}

@ProviderFor(pollVotedMembers)
const pollVotedMembersProvider = PollVotedMembersFamily._();

final class PollVotedMembersProvider
    extends
        $FunctionalProvider<List<UserModel>, List<UserModel>, List<UserModel>>
    with $Provider<List<UserModel>> {
  const PollVotedMembersProvider._({
    required PollVotedMembersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'pollVotedMembersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pollVotedMembersHash();

  @override
  String toString() {
    return r'pollVotedMembersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<UserModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<UserModel> create(Ref ref) {
    final argument = this.argument as String;
    return pollVotedMembers(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<UserModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<UserModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PollVotedMembersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pollVotedMembersHash() => r'a2cbefaca0f2b09db4d859bb1a97f01e7e011434';

final class PollVotedMembersFamily extends $Family
    with $FunctionalFamilyOverride<List<UserModel>, String> {
  const PollVotedMembersFamily._()
    : super(
        retry: null,
        name: r'pollVotedMembersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PollVotedMembersProvider call(String pollId) =>
      PollVotedMembersProvider._(argument: pollId, from: this);

  @override
  String toString() => r'pollVotedMembersProvider';
}

@ProviderFor(ActivePollsWithPendingResponse)
const activePollsWithPendingResponseProvider =
    ActivePollsWithPendingResponseProvider._();

final class ActivePollsWithPendingResponseProvider
    extends $NotifierProvider<ActivePollsWithPendingResponse, List<PollModel>> {
  const ActivePollsWithPendingResponseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activePollsWithPendingResponseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activePollsWithPendingResponseHash();

  @$internal
  @override
  ActivePollsWithPendingResponse create() => ActivePollsWithPendingResponse();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PollModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PollModel>>(value),
    );
  }
}

String _$activePollsWithPendingResponseHash() =>
    r'84b7674ef646d8b27851c55e91a2f9988e7e8d8e';

abstract class _$ActivePollsWithPendingResponse
    extends $Notifier<List<PollModel>> {
  List<PollModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<PollModel>, List<PollModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<PollModel>, List<PollModel>>,
              List<PollModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
