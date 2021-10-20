import 'package:equatable/equatable.dart';
import 'package:laporhoax/data/models/user_token.dart';
import 'package:laporhoax/domain/entities/user.dart';

class SessionData extends Equatable {
  final UserToken userToken;
  final User data;

  SessionData({
    required this.userToken,
    required this.data,
  });

  @override
  List<Object?> get props => [userToken, data];
}
