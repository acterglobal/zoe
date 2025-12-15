import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/core/preference_service/preferences_service.dart';
import 'package:zoe/core/routing/app_router.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/common/providers/service_providers.dart';
import 'package:zoe/features/auth/services/auth_service.dart';

part 'auth_providers.g.dart';

/// Main auth state provider with authentication management functionality
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  final Logger _logger = Logger('AuthState');

  late final PreferencesService _prefsService = ref.read(
    preferencesServiceProvider,
  );

  late final AuthService _authService = ref.watch(authServiceProvider);

  @override
  UserModel? build() {
    // Get the current auth state directly
    final firebaseUser = _authService.currentUser;

    // Return initial state
    return firebaseUser == null
        ? null
        : UserModel.fromFirebaseUser(firebaseUser);
  }

  /// Sign up with email and password
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _authService.signUp(
        email: email,
        password: password,
        displayName: name.trim(),
      );

      final firebaseUser = _authService.currentUser;
      if (firebaseUser == null) return;
      final user = UserModel.fromFirebaseUser(firebaseUser);
      await ref.read(userListProvider.notifier).addUser(user);
      await _prefsService.setLoginUserId(user.id);
      state = user;
      if (ref.mounted) ref.read(routerProvider).go(AppRoutes.home.route);
    } on FirebaseAuthException catch (e) {
      _logger.severe('Sign up error: $e');
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _authService.signIn(email: email, password: password);
      final firebaseUser = _authService.currentUser;
      if (firebaseUser == null) return;
      final user = UserModel.fromFirebaseUser(firebaseUser);
      await _prefsService.setLoginUserId(user.id);
      state = user;
      if (ref.mounted) ref.read(routerProvider).go(AppRoutes.home.route);
    } on FirebaseAuthException catch (e) {
      _logger.severe('Sign in error: $e');
      rethrow;
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      await _prefsService.clearLoginUserId();
      state = null;
      if (!ref.mounted) return;
      ref.read(routerProvider).go(AppRoutes.welcome.route);
    } catch (e) {
      _logger.severe('Sign out error: $e');
      rethrow;
    }
  }

  /// Delete account of the current user
  Future<void> deleteAccount() async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return;
      await ref.read(userListProvider.notifier).deleteUser(userId);
      await _authService.deleteAccount();
      await _prefsService.clearLoginUserId();
      state = null;
      if (!ref.mounted) return;
      ref.read(routerProvider).go(AppRoutes.welcome.route);
    } catch (e) {
      _logger.severe('Delete account error: $e');
      rethrow;
    }
  }
}
