import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../common/providers/service_providers.dart';
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
    final prefsService = ref.watch(preferencesServiceProvider);

    // Get the current auth state directly
    final firebaseUser = authService.currentUser;

    // Update preferences based on current state
    if (firebaseUser != null) {
      await prefsService.setLoginUserId(firebaseUser.uid);
      _logger.info('Stored user ID in preferences: ${firebaseUser.uid}');
    } else {
      await prefsService.clearLoginUserId();
      _logger.info('Cleared user ID from preferences.');
    }

    // Listen for future auth state changes
    final subscription = authService.authStateChanges.listen(
      (user) async {
        if (user != null) {
          await prefsService.setLoginUserId(user.uid);
          _logger.info('Stored user ID in preferences: ${user.uid}');
        } else {
          await prefsService.clearLoginUserId();
          _logger.info('Cleared user ID from preferences.');
        }

        // Check if provider is still mounted before updating state
        if (!ref.mounted) return;

        state = AsyncValue.data(
          user == null ? null : AuthUserModel.fromFirebaseUser(user),
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
        : AuthUserModel.fromFirebaseUser(firebaseUser);
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
