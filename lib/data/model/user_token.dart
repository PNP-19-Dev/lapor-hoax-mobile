class UserToken {
  final token;

  UserToken({required this.token});

  factory UserToken.fromJson(Map<String, dynamic> json) => UserToken(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
