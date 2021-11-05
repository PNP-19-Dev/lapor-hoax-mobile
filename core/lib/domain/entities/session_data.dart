import 'package:equatable/equatable.dart';

class SessionData extends Equatable {
  final String token;
  final int userid;
  final String expiry;
  final String email;
  final String username;

  SessionData({
    required this.token,
    required this.userid,
    required this.expiry,
    required this.email,
    required this.username,
  });

  Map<String, dynamic> toJson() => {
        "token": token,
        "userId": userid,
        "expiry": expiry,
        "email": email,
        "username": username,
      };

  factory SessionData.fromMap(Map<String, dynamic> map) => SessionData(
        token: map["token"],
        userid: map["userid"],
        expiry: map["expiry"],
        email: map["email"],
        username: map["username"],
      );

  @override
  List<Object?> get props => [token, userid, expiry, email, username];
}
