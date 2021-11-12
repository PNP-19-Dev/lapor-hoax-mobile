/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.48
 */

import 'package:equatable/equatable.dart';

class SessionData extends Equatable {
  final String token;
  final int userid;
  final String expiry;
  final String email;
  final String username;

  SessionData({
    required this.token,
    required this.userid,
    required this.expiry,
    required this.email,
    required this.username,
  });

  @override
  List<Object?> get props => [
    token,
    userid,
    expiry,
    email,
    username,
  ];
}
