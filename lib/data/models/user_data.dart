class User {
  int id;
  final username;
  final email;

  User({
    required this.id,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
      );

  static empty() {
    return User(id: -1, username: null, email: null);
  }
}
