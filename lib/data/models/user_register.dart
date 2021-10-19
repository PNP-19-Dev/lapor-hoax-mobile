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
    required this.id,
    required this.username,
    required this.email,
  });

  int id;
  String username;
  String email;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        username: json["username"],
        email: json["email"],
      );
}
