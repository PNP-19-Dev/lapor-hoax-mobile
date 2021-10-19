import 'package:equatable/equatable.dart';
import 'package:laporhoax/data/models/user_data.dart';
import 'package:laporhoax/data/models/user_token.dart';

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
