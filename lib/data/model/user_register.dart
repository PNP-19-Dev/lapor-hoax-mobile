class UserRegister {
  UserRegister({
    required this.user,
    required this.token,
  });

  UserData user;
  String token;

  factory UserRegister.fromJson(Map<String, dynamic> json) => UserRegister(
        user: UserData.fromJson(json["user"]),
        token: json["token"],
      );
}

class UserData {
  UserData({
    required this.username,
    required this.email,
  });

  String username;
  String email;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        username: json["username"],
        email: json["email"],
      );
}
