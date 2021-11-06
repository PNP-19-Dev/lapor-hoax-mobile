import 'package:equatable/equatable.dart';
import 'package:laporhoax/domain/entities/user.dart';

class UserModel extends Equatable {
  UserModel({
    required this.id,
    required this.username,
    required this.email,
  });

  final int id;
  final String username;
  final String email;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        email: json["email"],
      );

  User toEntity() => User(id: id, username: username, email: email);

  @override
  List<Object?> get props => [id, username, email];
}
