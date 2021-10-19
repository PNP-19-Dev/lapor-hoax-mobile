class UserLogin {
  String name;
  String email;
  String password;

  UserLogin({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'username': name,
        'email': email,
        'password': password,
      };
}
