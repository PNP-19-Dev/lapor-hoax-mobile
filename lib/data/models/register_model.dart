/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.48
 */

import 'package:equatable/equatable.dart';
import 'package:laporhoax/data/models/register.dart';

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
