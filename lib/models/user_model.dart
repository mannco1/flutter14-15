class User {
  final int id;
  final String name;
  final String email;
  User(
      {required this.id,
        required this.name,
        required this.email,
        });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['user_id'],
        name: json['username'],
        email: json['email'],
        );
  }
}