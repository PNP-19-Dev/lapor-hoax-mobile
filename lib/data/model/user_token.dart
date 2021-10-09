class UserToken {
  String? token;
  String? expiry;

  UserToken({required this.token, required this.expiry});

  factory UserToken.fromJson(Map<String, dynamic> json) => UserToken(
        expiry: json["expiry"],
        token: json["token"],
      );

  static empty() {
    return UserToken(token: null, expiry: null);
  }
}
