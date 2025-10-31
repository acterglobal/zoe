// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Main poll list provider with all poll management functionality

@ProviderFor(PollList)
const pollListProvider = PollListProvider._();

/// Main poll list provider with all poll management functionality
final class PollListProvider
    extends $NotifierProvider<PollList, List<PollModel>> {
  /// Main poll list provider with all poll management functionality
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

String _$pollListHash() => r'ecd26f25a9f2ded61448d1a50185948a87720ae2';

/// Main poll list provider with all poll management functionality

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

/// Provider for a single poll by ID

@ProviderFor(poll)
const pollProvider = PollFamily._();

/// Provider for a single poll by ID

final class PollProvider
    extends $FunctionalProvider<PollModel?, PollModel?, PollModel?>
    with $Provider<PollModel?> {
  /// Provider for a single poll by ID
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

/// Provider for a single poll by ID

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

  /// Provider for a single poll by ID

  PollProvider call(String pollId) =>
      PollProvider._(argument: pollId, from: this);

  @override
  String toString() => r'pollProvider';
}

/// Provider for polls filtered by membership (current user must be a member of the sheet)

@ProviderFor(pollsList)
const pollsListProvider = PollsListProvider._();

/// Provider for polls filtered by membership (current user must be a member of the sheet)

final class PollsListProvider
    extends
        $FunctionalProvider<List<PollModel>, List<PollModel>, List<PollModel>>
    with $Provider<List<PollModel>> {
  /// Provider for polls filtered by membership (current user must be a member of the sheet)
  const PollsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pollsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pollsListHash();

  @$internal
  @override
  $ProviderElement<List<PollModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<PollModel> create(Ref ref) {
    return pollsList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PollModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PollModel>>(value),
    );
  }
}

String _$pollsListHash() => r'ebba5677089fbf59070902756ac2fa07d98d245c';

/// Provider for not active polls (drafts) (filtered by membership)

@ProviderFor(notActivePollList)
const notActivePollListProvider = NotActivePollListProvider._();

/// Provider for not active polls (drafts) (filtered by membership)

final class NotActivePollListProvider
    extends
        $FunctionalProvider<List<PollModel>, List<PollModel>, List<PollModel>>
    with $Provider<List<PollModel>> {
  /// Provider for not active polls (drafts) (filtered by membership)
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

String _$notActivePollListHash() => r'59c2d4576751446af175d9e0d027517f2d6b7a4d';

/// Provider for active polls (filtered by membership)

@ProviderFor(activePollList)
const activePollListProvider = ActivePollListProvider._();

/// Provider for active polls (filtered by membership)

final class ActivePollListProvider
    extends
        $FunctionalProvider<List<PollModel>, List<PollModel>, List<PollModel>>
    with $Provider<List<PollModel>> {
  /// Provider for active polls (filtered by membership)
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

String _$activePollListHash() => r'4cff1602c3ecd9448809dac5b8c55d71e5d751f1';

/// Provider for completed polls (filtered by membership)

@ProviderFor(completedPollList)
const completedPollListProvider = CompletedPollListProvider._();

/// Provider for completed polls (filtered by membership)

final class CompletedPollListProvider
    extends
        $FunctionalProvider<List<PollModel>, List<PollModel>, List<PollModel>>
    with $Provider<List<PollModel>> {
  /// Provider for completed polls (filtered by membership)
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

String _$completedPollListHash() => r'c7fec916fdef2c70acd42e39873d56e9a3cf86c6';

/// Provider for searching polls

@ProviderFor(pollListSearch)
const pollListSearchProvider = PollListSearchProvider._();

/// Provider for searching polls

final class PollListSearchProvider
    extends
        $FunctionalProvider<List<PollModel>, List<PollModel>, List<PollModel>>
    with $Provider<List<PollModel>> {
  /// Provider for searching polls
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

String _$pollListSearchHash() => r'd19195d93c43fa62669d2701657e98f151d2aa72';

/// Provider for polls filtered by parent ID

@ProviderFor(pollListByParent)
const pollListByParentProvider = PollListByParentFamily._();

/// Provider for polls filtered by parent ID

final class PollListByParentProvider
    extends
        $FunctionalProvider<List<PollModel>, List<PollModel>, List<PollModel>>
    with $Provider<List<PollModel>> {
  /// Provider for polls filtered by parent ID
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

/// Provider for polls filtered by parent ID

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

  /// Provider for polls filtered by parent ID

  PollListByParentProvider call(String parentId) =>
      PollListByParentProvider._(argument: parentId, from: this);

  @override
  String toString() => r'pollListByParentProvider';
}

/// Provider for members who have voted

@ProviderFor(pollVotedMembers)
const pollVotedMembersProvider = PollVotedMembersFamily._();

/// Provider for members who have voted

final class PollVotedMembersProvider
    extends
        $FunctionalProvider<List<UserModel>, List<UserModel>, List<UserModel>>
    with $Provider<List<UserModel>> {
  /// Provider for members who have voted
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

/// Provider for members who have voted

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

  /// Provider for members who have voted

  PollVotedMembersProvider call(String pollId) =>
      PollVotedMembersProvider._(argument: pollId, from: this);

  @override
  String toString() => r'pollVotedMembersProvider';
}

/// Provider for active polls with pending response from current user (filtered by membership)

@ProviderFor(ActivePollsWithPendingResponse)
const activePollsWithPendingResponseProvider =
    ActivePollsWithPendingResponseProvider._();

/// Provider for active polls with pending response from current user (filtered by membership)
final class ActivePollsWithPendingResponseProvider
    extends $NotifierProvider<ActivePollsWithPendingResponse, List<PollModel>> {
  /// Provider for active polls with pending response from current user (filtered by membership)
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
    r'd5d9f5fd04ce4361771949b5905025f22d07dce3';

/// Provider for active polls with pending response from current user (filtered by membership)

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
