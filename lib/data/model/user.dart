class User {
  final String name;
  final String email;
  final String id;
  final String avatarUrl;

  const User(
      {required this.name,
      required this.email,
      required this.id,
      required this.avatarUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      id: json['id'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'id': id,
      'avatarUrl': avatarUrl,
    };
  }
}
