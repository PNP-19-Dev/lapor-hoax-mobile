import 'package:equatable/equatable.dart';

import '../../data/models/user_model.dart';

class UserResponse extends Equatable {
  const UserResponse({
    required this.user,
    required this.token,
  });

  final UserModel user;
  final String token;

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        user: UserModel.fromJson(json["user"]),
        token: json["token"],
      );

  @override
  List<Object?> get props => [user, token];
}

