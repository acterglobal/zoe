import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// Represents an authenticated user
class AuthUserModel {
  final String uid;
  final String email;
  final String? displayName;

  const AuthUserModel({
    required this.uid,
    required this.email,
    this.displayName,
  });

  factory AuthUserModel.fromFirebaseUser(firebase_auth.User user) {
    return AuthUserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  AuthUserModel copyWith({String? uid, String? email, String? displayName}) {
    return AuthUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
    );
  }
}

/// Represents the current authentication state
sealed class AuthStateModel {
  const AuthStateModel();
}

class AuthStateAuthenticated extends AuthStateModel {
  final AuthUserModel user;
  const AuthStateAuthenticated(this.user);
}

class AuthStateUnauthenticated extends AuthStateModel {
  const AuthStateUnauthenticated();
}

class AuthStateLoading extends AuthStateModel {
  const AuthStateLoading();
}
