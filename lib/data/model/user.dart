class User {
  String name;
  String email;
  String password;
  String confirmPassword;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        email: json['email'],
        password: json['password'],
        confirmPassword: json['confirm_password'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
      };
}
