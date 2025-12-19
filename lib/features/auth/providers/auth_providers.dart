import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/services/snackbar_service.dart';
import 'package:zoe/common/utils/firebase_utils.dart';
import 'package:zoe/common/widgets/dialogs/loading_dialog_widget.dart';
import 'package:zoe/core/constants/firestore_constants.dart';
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

  late final SnackbarService _snackBarService = ref.read(snackbarServiceProvider);

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
      state = ref.read(getUserByIdProvider(user.id)) ?? user;
      if (ref.mounted) ref.read(routerProvider).go(AppRoutes.home.route);
    } on FirebaseAuthException catch (e) {
      _logger.severe('Sign up error: $e');
      _snackBarService.show(getFirebaseErrorMessage(e));
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
      state = ref.read(getUserByIdProvider(user.id)) ?? user;
      if (ref.mounted) ref.read(routerProvider).go(AppRoutes.home.route);
    } on FirebaseAuthException catch (e) {
      _logger.severe('Sign in error: $e');
      _snackBarService.show(getFirebaseErrorMessage(e));
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
    } on FirebaseAuthException catch (e) {
      _logger.severe('Sign out error: $e');
      _snackBarService.show(getFirebaseErrorMessage(e));
    } catch (e) {
      _logger.severe('Sign out error: $e');
      _snackBarService.show('Sign out failed.');
    }
  }

  /// Delete account of the current user
  Future<void> deleteAccount(BuildContext context, String password) async {
    try {
      final user = _authService.currentUser;
      if (user == null || user.email == null) return;

      // Show loading dialog
      LoadingDialogWidget.show(context);

      // Re-authenticate user with password
      final authCredentials = await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: user.email!, password: password),
      );
      if (authCredentials.user == null) return;

      final userId = authCredentials.user!.uid;
      // Delete all content created by the user
      final fieldName = FirestoreFieldConstants.createdBy;
      await Future.wait([
        // Delete all sheets documents
        runFirestoreDeleteContentOperation(
          ref: ref,
          collectionName: FirestoreCollections.sheets,
          fieldName: fieldName,
          isEqualTo: userId,
        ),
        // Delete all texts documents
        runFirestoreDeleteContentOperation(
          ref: ref,
          collectionName: FirestoreCollections.texts,
          fieldName: fieldName,
          isEqualTo: userId,
        ),
        // Delete all events documents
        runFirestoreDeleteContentOperation(
          ref: ref,
          collectionName: FirestoreCollections.events,
          fieldName: fieldName,
          isEqualTo: userId,
        ),
        // Delete all lists documents
        runFirestoreDeleteContentOperation(
          ref: ref,
          collectionName: FirestoreCollections.lists,
          fieldName: fieldName,
          isEqualTo: userId,
        ),
        // Delete all tasks documents
        runFirestoreDeleteContentOperation(
          ref: ref,
          collectionName: FirestoreCollections.tasks,
          fieldName: fieldName,
          isEqualTo: userId,
        ),
        // Delete all bullets documents
        runFirestoreDeleteContentOperation(
          ref: ref,
          collectionName: FirestoreCollections.bullets,
          fieldName: fieldName,
          isEqualTo: userId,
        ),
        // Delete all polls documents
        runFirestoreDeleteContentOperation(
          ref: ref,
          collectionName: FirestoreCollections.polls,
          fieldName: fieldName,
          isEqualTo: userId,
        ),
        // Remove user from getting started sheet
        runFirestoreOperation(
          ref,
          () => ref
              .read(firestoreProvider)
              .collection(FirestoreCollections.sheets)
              .doc(gettingStartedSheetId)
              .update({
                FirestoreFieldConstants.users: FieldValue.arrayRemove([userId]),
              }),
        ),
      ]);

      await ref.read(userListProvider.notifier).deleteUser(userId);
      await _authService.deleteAccount();
      await _prefsService.clearLoginUserId();
      state = null;
      if (!ref.mounted) return;
      ref.read(routerProvider).go(AppRoutes.welcome.route);
    } on FirebaseAuthException catch (e) {
      _logger.severe('Delete account error: $e');
      _snackBarService.show(getFirebaseErrorMessage(e));
    } catch (e) {
      _logger.severe('Delete account error: $e');
      _snackBarService.show('Delete account failed.');
    } finally {
      // Hide loading dialog
      if (context.mounted) LoadingDialogWidget.hide(context);
    }
  }
}
