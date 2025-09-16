class UserModel {
  final String id;
  final String name;
  final String? bio;
  final String? avatar;

  UserModel({
    required this.id,
    required this.name,
    this.bio,
    this.avatar,
  }); 

  UserModel copyWith({
    String? id,
    String? name,
    String? bio,
    String? avatar,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
    );
  }
}
