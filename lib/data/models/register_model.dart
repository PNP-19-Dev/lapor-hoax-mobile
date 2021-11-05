import 'package:equatable/equatable.dart';
import 'package:laporhoax/domain/entities/register.dart';

class RegisterModel extends Equatable {
  final String name;
  final String email;
  final String password;

  RegisterModel({
    required this.name,
    required this.email,
    required this.password,
  });

  factory RegisterModel.fromDTO(Register register) => RegisterModel(
      name: register.name,
      email: register.email,
      password: register.password,
  );

  Map<String, dynamic> toJson() => {
        'username': name,
        'email': email,
        'password': password,
      };

  @override
  List<Object?> get props => [name, email, password];
}
