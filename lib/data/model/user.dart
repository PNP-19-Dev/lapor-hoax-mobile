class User {
  String name;
  String email;
  String phone;
  String password;
  String confirmPassword;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        password: json['password'],
        confirmPassword: json['confirm_password'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'confirm_password': confirmPassword,
      };
}
