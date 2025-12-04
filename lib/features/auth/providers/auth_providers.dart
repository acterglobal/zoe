import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';
import '../models/auth_state_model.dart';
import '../services/auth_service.dart';

part 'auth_providers.g.dart';

/// Main auth state provider with authentication management functionality
@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  final Logger _logger = Logger('AuthState');

  @override
  AuthStateModel build() {
    // Listen to auth state changes from Firebase
    final authService = ref.watch(authServiceProvider);

    // Subscribe to auth state changes
    authService.authStateChanges.listen((firebaseUser) {
      if (firebaseUser != null) {
        _logger.info('User authenticated: ${firebaseUser.uid}');
        state = AuthStateAuthenticated(
          AuthUserModel.fromFirebaseUser(firebaseUser),
        );
      } else {
        _logger.info('User unauthenticated');
        state = const AuthStateUnauthenticated();
      }
    });

    // Return initial state based on current user
    final currentUser = authService.currentUser;
    if (currentUser != null) {
      return AuthStateAuthenticated(
        AuthUserModel.fromFirebaseUser(currentUser),
      );
    }
    return const AuthStateUnauthenticated();
  }

  /// Sign up with email and password
  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    state = const AuthStateLoading();
    try {
      final authService = ref.read(authServiceProvider);
      final displayName = '$firstName $lastName'.trim();
      await authService.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
      // State will be updated by authStateChanges listener
    } catch (e) {
      _logger.severe('Sign up error: $e');
      state = const AuthStateUnauthenticated();
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<void> signIn({required String email, required String password}) async {
    state = const AuthStateLoading();
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signIn(email: email, password: password);
      // State will be updated by authStateChanges listener
    } catch (e) {
      _logger.severe('Sign in error: $e');
      state = const AuthStateUnauthenticated();
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

/// Provider to check if user is authenticated
@riverpod
bool isAuthenticated(Ref ref) {
  final authState = ref.watch(authStateProvider);
  return authState is AuthStateAuthenticated;
}

/// Provider for the current authenticated user (null if not authenticated)
@riverpod
AuthUserModel? currentUser(Ref ref) {
  final authState = ref.watch(authStateProvider);
  if (authState is AuthStateAuthenticated) {
    return authState.user;
  }
  return null;
}
