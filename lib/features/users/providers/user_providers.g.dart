// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Main user list provider with all user management functionality

@ProviderFor(UserList)
const userListProvider = UserListProvider._();

/// Main user list provider with all user management functionality
final class UserListProvider
    extends $NotifierProvider<UserList, List<UserModel>> {
  /// Main user list provider with all user management functionality
  const UserListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userListHash();

  @$internal
  @override
  UserList create() => UserList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<UserModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<UserModel>>(value),
    );
  }
}

String _$userListHash() => r'6b081a550bb97e7f2592efc8b29686b6fc0e20bf';

/// Main user list provider with all user management functionality

abstract class _$UserList extends $Notifier<List<UserModel>> {
  List<UserModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<UserModel>, List<UserModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<UserModel>, List<UserModel>>,
              List<UserModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for the current user model

@ProviderFor(currentUser)
const currentUserProvider = CurrentUserProvider._();

/// Provider for the current user model

final class CurrentUserProvider
    extends $FunctionalProvider<UserModel?, UserModel?, UserModel?>
    with $Provider<UserModel?> {
  /// Provider for the current user model
  const CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $ProviderElement<UserModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserModel? create(Ref ref) {
    return currentUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserModel?>(value),
    );
  }
}

String _$currentUserHash() => r'06f30c9506a1d9172cad824cdeebfd56e7fb3e74';

/// Provider for users in a specific sheet

@ProviderFor(usersBySheetId)
const usersBySheetIdProvider = UsersBySheetIdFamily._();

/// Provider for users in a specific sheet

final class UsersBySheetIdProvider
    extends
        $FunctionalProvider<List<UserModel>, List<UserModel>, List<UserModel>>
    with $Provider<List<UserModel>> {
  /// Provider for users in a specific sheet
  const UsersBySheetIdProvider._({
    required UsersBySheetIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'usersBySheetIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$usersBySheetIdHash();

  @override
  String toString() {
    return r'usersBySheetIdProvider'
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
    return usersBySheetId(ref, argument);
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
    return other is UsersBySheetIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$usersBySheetIdHash() => r'80336ec66b38313231bd249ac17cfefc78afda52';

/// Provider for users in a specific sheet

final class UsersBySheetIdFamily extends $Family
    with $FunctionalFamilyOverride<List<UserModel>, String> {
  const UsersBySheetIdFamily._()
    : super(
        retry: null,
        name: r'usersBySheetIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for users in a specific sheet

  UsersBySheetIdProvider call(String sheetId) =>
      UsersBySheetIdProvider._(argument: sheetId, from: this);

  @override
  String toString() => r'usersBySheetIdProvider';
}

/// Provider for getting a user by ID

@ProviderFor(getUserById)
const getUserByIdProvider = GetUserByIdFamily._();

/// Provider for getting a user by ID

final class GetUserByIdProvider
    extends $FunctionalProvider<UserModel?, UserModel?, UserModel?>
    with $Provider<UserModel?> {
  /// Provider for getting a user by ID
  const GetUserByIdProvider._({
    required GetUserByIdFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'getUserByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getUserByIdHash();

  @override
  String toString() {
    return r'getUserByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<UserModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserModel? create(Ref ref) {
    final argument = this.argument as String?;
    return getUserById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserModel?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetUserByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getUserByIdHash() => r'badf980b7f4ce7b14a16ee0a81f5cda5c0df89b7';

/// Provider for getting a user by ID

final class GetUserByIdFamily extends $Family
    with $FunctionalFamilyOverride<UserModel?, String?> {
  const GetUserByIdFamily._()
    : super(
        retry: null,
        name: r'getUserByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for getting a user by ID

  GetUserByIdProvider call(String? userId) =>
      GetUserByIdProvider._(argument: userId, from: this);

  @override
  String toString() => r'getUserByIdProvider';
}

/// Provider for getting a user by name

@ProviderFor(getUserByIdFuture)
const getUserByIdFutureProvider = GetUserByIdFutureFamily._();

/// Provider for getting a user by name

final class GetUserByIdFutureProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserModel?>,
          UserModel?,
          FutureOr<UserModel?>
        >
    with $FutureModifier<UserModel?>, $FutureProvider<UserModel?> {
  /// Provider for getting a user by name
  const GetUserByIdFutureProvider._({
    required GetUserByIdFutureFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getUserByIdFutureProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getUserByIdFutureHash();

  @override
  String toString() {
    return r'getUserByIdFutureProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<UserModel?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserModel?> create(Ref ref) {
    final argument = this.argument as String;
    return getUserByIdFuture(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetUserByIdFutureProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getUserByIdFutureHash() => r'46101058435dfd385be80b95e70226a600aa3430';

/// Provider for getting a user by name

final class GetUserByIdFutureFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<UserModel?>, String> {
  const GetUserByIdFutureFamily._()
    : super(
        retry: null,
        name: r'getUserByIdFutureProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for getting a user by name

  GetUserByIdFutureProvider call(String userId) =>
      GetUserByIdFutureProvider._(argument: userId, from: this);

  @override
  String toString() => r'getUserByIdFutureProvider';
}

/// Provider for getting user IDs from a list of UserModel objects

@ProviderFor(userIdsFromUserModels)
const userIdsFromUserModelsProvider = UserIdsFromUserModelsFamily._();

/// Provider for getting user IDs from a list of UserModel objects

final class UserIdsFromUserModelsProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  /// Provider for getting user IDs from a list of UserModel objects
  const UserIdsFromUserModelsProvider._({
    required UserIdsFromUserModelsFamily super.from,
    required List<UserModel> super.argument,
  }) : super(
         retry: null,
         name: r'userIdsFromUserModelsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userIdsFromUserModelsHash();

  @override
  String toString() {
    return r'userIdsFromUserModelsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    final argument = this.argument as List<UserModel>;
    return userIdsFromUserModels(ref, argument);
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
    return other is UserIdsFromUserModelsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userIdsFromUserModelsHash() =>
    r'd54084c44ad5bf5cc0ffacb17ed983a91293c105';

/// Provider for getting user IDs from a list of UserModel objects

final class UserIdsFromUserModelsFamily extends $Family
    with $FunctionalFamilyOverride<List<String>, List<UserModel>> {
  const UserIdsFromUserModelsFamily._()
    : super(
        retry: null,
        name: r'userIdsFromUserModelsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for getting user IDs from a list of UserModel objects

  UserIdsFromUserModelsProvider call(List<UserModel> userModels) =>
      UserIdsFromUserModelsProvider._(argument: userModels, from: this);

  @override
  String toString() => r'userIdsFromUserModelsProvider';
}

/// Provider for getting user display name

@ProviderFor(userDisplayName)
const userDisplayNameProvider = UserDisplayNameFamily._();

/// Provider for getting user display name

final class UserDisplayNameProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Provider for getting user display name
  const UserDisplayNameProvider._({
    required UserDisplayNameFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userDisplayNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userDisplayNameHash();

  @override
  String toString() {
    return r'userDisplayNameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as String;
    return userDisplayName(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserDisplayNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userDisplayNameHash() => r'3c693d62cbda8f449d458caa289ecd7df53f1bf6';

/// Provider for getting user display name

final class UserDisplayNameFamily extends $Family
    with $FunctionalFamilyOverride<String, String> {
  const UserDisplayNameFamily._()
    : super(
        retry: null,
        name: r'userDisplayNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for getting user display name

  UserDisplayNameProvider call(String userId) =>
      UserDisplayNameProvider._(argument: userId, from: this);

  @override
  String toString() => r'userDisplayNameProvider';
}

/// Provider for searching users

@ProviderFor(userListSearch)
const userListSearchProvider = UserListSearchFamily._();

/// Provider for searching users

final class UserListSearchProvider
    extends
        $FunctionalProvider<List<UserModel>, List<UserModel>, List<UserModel>>
    with $Provider<List<UserModel>> {
  /// Provider for searching users
  const UserListSearchProvider._({
    required UserListSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userListSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userListSearchHash();

  @override
  String toString() {
    return r'userListSearchProvider'
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
    return userListSearch(ref, argument);
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
    return other is UserListSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userListSearchHash() => r'fadf44195398bab7bf8e11864d44f533d66f868c';

/// Provider for searching users

final class UserListSearchFamily extends $Family
    with $FunctionalFamilyOverride<List<UserModel>, String> {
  const UserListSearchFamily._()
    : super(
        retry: null,
        name: r'userListSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for searching users

  UserListSearchProvider call(String searchTerm) =>
      UserListSearchProvider._(argument: searchTerm, from: this);

  @override
  String toString() => r'userListSearchProvider';
}
