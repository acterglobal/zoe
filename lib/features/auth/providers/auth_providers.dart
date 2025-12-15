import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/core/preference_service/preferences_service.dart';
import 'package:zoe/core/routing/app_router.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import '../../../common/providers/service_providers.dart';
import '../services/auth_service.dart';

part 'auth_providers.g.dart';

/// Main auth state provider with authentication management functionality
@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  final Logger _logger = Logger('AuthState');

  late final PreferencesService _prefsService = ref.read(
    preferencesServiceProvider,
  );

  late final AuthService _authService = ref.watch(authServiceProvider);

  @override
  Future<UserModel?> build() async {
    // Get the current auth state directly
    final firebaseUser = _authService.currentUser;

    // Update preferences based on current state
    if (firebaseUser != null) {
      await _prefsService.setLoginUserId(firebaseUser.uid);
      _logger.info('Stored user ID in preferences: ${firebaseUser.uid}');
    } else {
      await _prefsService.clearLoginUserId();
      _logger.info('Cleared user ID from preferences.');
    }

    // Listen for future auth state changes
    final subscription = _authService.authStateChanges.listen(
      (user) async {
        if (user != null) {
          await _prefsService.setLoginUserId(user.uid);
          _logger.info('Stored user ID in preferences: ${user.uid}');
        } else {
          await _prefsService.clearLoginUserId();
          _logger.info('Cleared user ID from preferences.');
        }

        // Check if provider is still mounted before updating state
        if (!ref.mounted) return;

        state = AsyncValue.data(
          user == null ? null : UserModel.fromFirebaseUser(user),
        );
      },
      onError: (e, s) {
        _logger.severe('Auth state stream error: $e');
        // Check if provider is still mounted before updating state
        if (!ref.mounted) return;
        state = AsyncValue.error(e, s);
      },
    );

    ref.onDispose(() => subscription.cancel());

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
    state = const AsyncValue.loading();
    try {
      await _authService.signUp(
        email: email,
        password: password,
        displayName: name.trim(),
      );

      final firebaseUser = _authService.currentUser;
      if (firebaseUser != null) {
        final newUser = UserModel.fromFirebaseUser(firebaseUser);
        await ref.read(userListProvider.notifier).addUser(newUser);
      }
    } catch (e, st) {
      _logger.severe('Sign up error: $e');
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      await _authService.signIn(email: email, password: password);
      // State will be updated by authStateChanges listener
    } catch (e, st) {
      _logger.severe('Sign in error: $e');
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      await _prefsService.clearLoginUserId();
      if (!ref.mounted) return;
      ref.read(routerProvider).go(AppRoutes.login.route);
    } catch (e) {
      _logger.severe('Sign out error: $e');
      rethrow;
    }
  }

  /// Delete account of the current user
  Future<void> deleteAccount() async {
    try {
      await _authService.deleteAccount();
      await _prefsService.clearLoginUserId();
      if (!ref.mounted) return;
      ref.read(routerProvider).go(AppRoutes.login.route);
    } catch (e) {
      _logger.severe('Delete account error: $e');
      rethrow;
    }
  }
}
