class UserStatus {
  final isActive;
  final isStaff;
  final isAdmin;

  UserStatus({
    required this.isActive,
    required this.isStaff,
    required this.isAdmin,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) => UserStatus(
        isActive: json["is_active"],
        isStaff: json["is_staff"],
        isAdmin: json["is_admin"],
      );

  Map<String, dynamic> toJson() => {
        "is_active": isActive,
        "is_staff": isStaff,
        "is_admin": isAdmin,
      };
}
