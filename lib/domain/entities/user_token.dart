import 'package:equatable/equatable.dart';

class UserToken extends Equatable {
  final String? token;
  final String? expiry;

  UserToken({required this.token, required this.expiry});

  @override
  List<Object?> get props => [token, expiry];
}
