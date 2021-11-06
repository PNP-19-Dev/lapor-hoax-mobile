import 'package:equatable/equatable.dart';
import 'package:laporhoax/data/models/user_model.dart';

class RegisterData extends Equatable {
  RegisterData({
    required this.user,
    required this.token,
  });

  final UserModel user;
  final String token;

  @override
  List<Object?> get props => [user, token];
}
