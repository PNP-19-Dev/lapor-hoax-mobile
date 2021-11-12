/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.43
 */

import 'package:equatable/equatable.dart';
import 'package:laporhoax/domain/entities/user.dart';

class RegisterData extends Equatable {
  RegisterData({
    required this.user,
    required this.token,
  });

  final User user;
  final String token;

  @override
  List<Object?> get props => [user, token];
}
