import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class User extends Equatable {
  User({
    required this.id,
    required this.username,
    required this.email,
  });

  int id;
  String username;
  String email;

  @override
  List<Object?> get props => [id, username, email];

  static User empty() => User(id: -1, username: '', email: '');
}
