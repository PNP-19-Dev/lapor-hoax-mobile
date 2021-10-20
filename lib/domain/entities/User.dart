import 'package:equatable/equatable.dart';

class User extends Equatable {
  User({
    required this.id,
    required this.username,
    required this.email,
  });

  final int id;
  final String username;
  final String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
      };

  @override
  List<Object?> get props => [id, username, email];

  static User empty() => User(id: -1, username: '', email: '');
}
