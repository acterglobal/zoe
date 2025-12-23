import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? bio;
  final String? avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    this.avatar,
  });

  factory UserModel.fromFirebaseUser(firebase_auth.User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      avatar: user.photoURL,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? bio,
    String? avatar = '',
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      avatar: avatar?.trim() == '' ? this.avatar : avatar,
    );
  }

  /// Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
      'avatar': avatar,
    };
  }

  /// Create from JSON from Firestore
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String? ?? '',
      bio: json['bio'] as String?,
      avatar: json['avatar'] as String?,
    );
  }
}
