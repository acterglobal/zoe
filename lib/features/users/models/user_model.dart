class UserModel {
  final String id;
  final String name;
  final String? bio;

  UserModel({
    required this.id,
    required this.name,
    this.bio,
  }); 

  UserModel copyWith({
    String? id,
    String? name,
    String? bio,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
    );
  }
}
