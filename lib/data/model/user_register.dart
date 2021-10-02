class UserRegister {
  final response;
  final email;
  final name;
  final noHp;
  final isActive;
  final isStaff;
  final isAdmin;
  final token;

  UserRegister({
    required this.response,
    required this.email,
    required this.name,
    required this.noHp,
    required this.isActive,
    required this.isAdmin,
    required this.isStaff,
    required this.token,
  });

  factory UserRegister.fromJson(Map<String, dynamic> json) => UserRegister(
        response: json['response'],
        email: json['email'],
        name: json['name'],
        noHp: json['noHp'],
        isActive: json['is_active'],
        isStaff: json['is_staff'],
        isAdmin: json['is_admin'],
        token: json['token'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'nohp': noHp,
        'is_active': isActive,
        'is_staff': isStaff,
        'is_admin': isAdmin,
        'token': token,
      };
}
