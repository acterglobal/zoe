import 'dart:async';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/core/preference_service/preferences_service.dart';
import '../models/auth_user_model.dart';
import '../services/auth_service.dart';

part 'auth_providers.g.dart';

/// Main auth state provider with authentication management functionality
@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  final Logger _logger = Logger('AuthState');

  @override
  Future<AuthUserModel?> build() async {
    final authService = ref.watch(authServiceProvider);
    final prefsService = PreferencesService();

    final completer = Completer<AuthUserModel?>();

    final subscription = authService.authStateChanges.listen(
      (firebaseUser) async {
        if (firebaseUser != null) {
          await prefsService.setLoginUserId(firebaseUser.uid);
          _logger.info('Stored user ID in preferences: ${firebaseUser.uid}');
        } else {
          await prefsService.clearLoginUserId();
          _logger.info('Cleared user ID from preferences.');
        }

        final userModel = firebaseUser == null
            ? null
            : AuthUserModel.fromFirebaseUser(firebaseUser);

        if (!completer.isCompleted) {
          completer.complete(userModel);
        } else {
          state = AsyncValue.data(userModel);
        }
      },
      onError: (e, s) {
        _logger.severe('Auth state stream error: $e');
        if (!completer.isCompleted) {
          completer.completeError(e, s);
        } else {
          state = AsyncValue.error(e, s);
        }
      },
    );

    ref.onDispose(() => subscription.cancel());

    return completer.future;
  }

  /// Sign up with email and password
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signUp(
        email: email,
        password: password,
        displayName: name.trim(),
      );
      // State will be updated by authStateChanges listener
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
      final authService = ref.read(authServiceProvider);
      await authService.signIn(email: email, password: password);
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
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
      // State will be updated by authStateChanges listener
    } catch (e) {
      _logger.severe('Sign out error: $e');
      rethrow;
    }
  }
}
