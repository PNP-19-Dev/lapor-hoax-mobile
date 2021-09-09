class User {
  String name;
  String email;
  String phone;

  User({required this.name, required this.email, required this.phone});

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
      );

  Map<String, dynamic> toJson() =>
      {'name': name, 'email': email, 'phone': phone};
}
