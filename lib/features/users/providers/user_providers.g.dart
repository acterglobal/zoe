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

String _$userListHash() => r'83b7366d9a9c832bee8187d39eae85691db02970';

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

/// Provider for the logged-in user ID

@ProviderFor(loggedInUser)
const loggedInUserProvider = LoggedInUserProvider._();

/// Provider for the logged-in user ID

final class LoggedInUserProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Provider for the logged-in user ID
  const LoggedInUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loggedInUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loggedInUserHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return loggedInUser(ref);
  }
}

String _$loggedInUserHash() => r'b0250a555a99db0cc699cd1697343ee35e5d3a7f';

/// Provider for the current user model

@ProviderFor(currentUser)
const currentUserProvider = CurrentUserProvider._();

/// Provider for the current user model

final class CurrentUserProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserModel?>,
          UserModel?,
          FutureOr<UserModel?>
        >
    with $FutureModifier<UserModel?>, $FutureProvider<UserModel?> {
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
  $FutureProviderElement<UserModel?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserModel?> create(Ref ref) {
    return currentUser(ref);
  }
}

String _$currentUserHash() => r'7ec33880494c002ad1428c0c641e2287c754010f';

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
    required String super.argument,
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
    final argument = this.argument as String;
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

String _$getUserByIdHash() => r'5ebe570241acdf3c577893d0ea0ed295a0faf1b9';

/// Provider for getting a user by ID

final class GetUserByIdFamily extends $Family
    with $FunctionalFamilyOverride<UserModel?, String> {
  const GetUserByIdFamily._()
    : super(
        retry: null,
        name: r'getUserByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for getting a user by ID

  GetUserByIdProvider call(String userId) =>
      GetUserByIdProvider._(argument: userId, from: this);

  @override
  String toString() => r'getUserByIdProvider';
}

/// Provider for getting a user by name

@ProviderFor(getUserByName)
const getUserByNameProvider = GetUserByNameFamily._();

/// Provider for getting a user by name

final class GetUserByNameProvider
    extends $FunctionalProvider<UserModel?, UserModel?, UserModel?>
    with $Provider<UserModel?> {
  /// Provider for getting a user by name
  const GetUserByNameProvider._({
    required GetUserByNameFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getUserByNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getUserByNameHash();

  @override
  String toString() {
    return r'getUserByNameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<UserModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserModel? create(Ref ref) {
    final argument = this.argument as String;
    return getUserByName(ref, argument);
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
    return other is GetUserByNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getUserByNameHash() => r'a42232953aef9f0e0776e5458de73e21901df49c';

/// Provider for getting a user by name

final class GetUserByNameFamily extends $Family
    with $FunctionalFamilyOverride<UserModel?, String> {
  const GetUserByNameFamily._()
    : super(
        retry: null,
        name: r'getUserByNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for getting a user by name

  GetUserByNameProvider call(String name) =>
      GetUserByNameProvider._(argument: name, from: this);

  @override
  String toString() => r'getUserByNameProvider';
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

String _$userDisplayNameHash() => r'0ce98b87fab93a5d7397d21a85bebc07d687a91b';

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
