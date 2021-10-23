import 'package:equatable/equatable.dart';

class SessionData extends Equatable {
  String token;
  String expiry;
  int userid;
  String username;
  String email;

  SessionData(
      {required this.token,
      required this.expiry,
      required this.userid,
      required this.username,
      required this.email});

  Map<String, dynamic> toJson() => {
        "token": token,
        "expiry": expiry,
        "userId": userid,
        "username": username,
        "email": email,
      };

  factory SessionData.fromMap(Map<String, dynamic> map) => SessionData(
        token: map["token"],
        expiry: map["expiry"],
        userid: map["userid"],
        username: map["username"],
        email: map["email"],
      );

  @override
  List<Object?> get props => [token, expiry, userid, username, email];
}
