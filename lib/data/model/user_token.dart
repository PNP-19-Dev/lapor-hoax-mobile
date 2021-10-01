class UserToken {
  final token;
  final expiry;

  UserToken({required this.token, required this.expiry});

  factory UserToken.fromJson(Map<String, dynamic> json) => UserToken(
        expiry: json["expiry"],
        token: json["token"],
      );
}
