class UserModel {
  final String id;
  final String name;

  UserModel({
    required this.id,
    required this.name,
  }); 

  UserModel copyWith({
    String? id,
    String? name,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
