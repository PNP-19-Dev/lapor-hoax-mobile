/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.43
 */

import 'package:equatable/equatable.dart';

class User extends Equatable {
  User({
    required this.id,
    required this.username,
    required this.email,
  });

  final int id;
  final String username;
  final String email;

  @override
  List<Object?> get props => [id, username, email];
}
