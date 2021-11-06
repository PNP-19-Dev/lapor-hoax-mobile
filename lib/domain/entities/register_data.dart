import 'package:equatable/equatable.dart';
import 'package:laporhoax/domain/entities/user.dart';

class RegisterData extends Equatable {
  RegisterData({
    required this.user,
    required this.token,
  });

  final User user;
  final String token;

  @override
  List<Object?> get props => [user, token];
}
